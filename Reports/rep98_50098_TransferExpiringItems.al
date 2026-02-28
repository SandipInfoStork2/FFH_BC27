report 50098 "Transfer Expiring Items"
{
    // 
    // TAL0.1 2018/12/05 VC correct duplicate entries

    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", Open, Positive, "Location Code", "Expiration Date");

                trigger OnAfterGetRecord();
                begin
                    if "Lot No." <> '' then begin
                        if not ItemBuffer.GET("Item No.", '', 0D) then begin
                            CLEAR(ItemBuffer);
                            ItemBuffer."Item No." := "Item No.";
                            ItemBuffer.INSERT;
                        end;
                        ItemBuffer.Quantity += "Remaining Quantity";
                        ItemBuffer.MODIFY;

                        if not Buffer.GET("Item No.", "Lot No.", "Expiration Date") then begin
                            CLEAR(Buffer);
                            Buffer."Item No." := "Item No.";
                            Buffer."Lot No." := "Lot No.";
                            Buffer."Expiration Date" := "Expiration Date";
                            Buffer.INSERT;
                        end;
                        Buffer.Quantity += "Remaining Quantity";
                        Buffer.MODIFY;
                    end;
                end;

                trigger OnPostDataItem();
                var
                    ReservationEntry: Record "Reservation Entry";
                    Item2: Record Item;
                    Qty2Transfer: Decimal;
                    TotalQty2Transfer: Decimal;
                begin
                    with ItemBuffer do begin
                        if ItemBuffer.FINDFIRST then
                            repeat
                                TotalQty2Transfer := 0;
                                Item2.GET("Item No.");
                                Item2.SETRANGE("Location Filter", TransferHeader."Transfer-from Code");
                                NextLineNo += 10000;
                                Counter += 1;
                                Window.UPDATE(2, Counter);
                                CLEAR(TransferLine);
                                TransferLine."Document No." := TransferHeader."No.";
                                TransferLine."Line No." := NextLineNo;
                                TransferLine.VALIDATE("Item No.", "Item No.");
                                TransferLine.INSERT(true);

                                Buffer.SETRANGE("Item No.", ItemBuffer."Item No.");
                                if Buffer.FINDFIRST then
                                    repeat
                                        Item2.SETRANGE("Lot No. Filter", Buffer."Lot No.");
                                        Item2.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                                        Qty2Transfer := Buffer.Quantity - Item2."Reserved Qty. on Inventory";
                                        if Qty2Transfer > Item2.Inventory then
                                            Qty2Transfer := Item2.Inventory;
                                        if Qty2Transfer > 0 then begin
                                            TotalQty2Transfer += Qty2Transfer;
                                            CLEAR(ReservationEntry);
                                            NextEntryNo += 1;
                                            ReservationEntry."Entry No." := NextEntryNo;
                                            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                            ReservationEntry."Item No." := TransferLine."Item No.";
                                            ReservationEntry."Lot No." := Buffer."Lot No.";
                                            //ReservationEntry."Expiration Date" := Buffer."Expiration Date";
                                            //ReservationEntry."New Lot No." := Buffer."Lot No.";
                                            //ReservationEntry."New Expiration Date" := Buffer."Expiration Date";
                                            ReservationEntry.VALIDATE("Quantity (Base)", -Buffer.Quantity);
                                            ReservationEntry."Location Code" := TransferHeader."Transfer-from Code";
                                            ReservationEntry."Creation Date" := WORKDATE;
                                            ReservationEntry."Source Type" := DATABASE::"Transfer Line";
                                            ReservationEntry."Source Subtype" := 0;
                                            ReservationEntry."Source ID" := TransferHeader."No.";
                                            ReservationEntry."Source Ref. No." := TransferLine."Line No.";
                                            ReservationEntry."Shipment Date" := TransferHeader."Shipment Date";
                                            ReservationEntry."Created By" := USERID;
                                            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                            ReservationEntry.INSERT;


                                            //14/11/2022 review logic issues when deleting lines
                                            //clear(ReservationEntry);
                                            /*
                                            ReservationEntry.Positive := true;
                                            ReservationEntry.VALIDATE("Quantity (Base)", Buffer.Quantity);
                                            ReservationEntry."Location Code" := TransferHeader."Transfer-to Code";
                                            ReservationEntry."Source Subtype" := 1;
                                            ReservationEntry."Shipment Date" := 0D;
                                            ReservationEntry."Expected Receipt Date" := TransferHeader."Shipment Date";
                                            ReservationEntry.INSERT;
                                            */
                                            CLEAR(ReservationEntry);
                                            ReservationEntry.INIT;
                                            ReservationEntry."Entry No." := 0;
                                            ReservationEntry."Item No." := "Item Ledger Entry"."Item No.";
                                            ReservationEntry."Location Code" := TransferHeader."Transfer-to Code";
                                            ReservationEntry.VALIDATE("Quantity (Base)", Buffer.Quantity);
                                            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                            ReservationEntry."Source Type" := 5741;
                                            ReservationEntry."Source ID" := TransferHeader."No.";
                                            ReservationEntry."Source Ref. No." := TransferLine."Line No.";
                                            ReservationEntry.Quantity := (Buffer.Quantity);
                                            ReservationEntry."Qty. to Handle (Base)" := (Buffer.Quantity);
                                            ReservationEntry."Qty. to Invoice (Base)" := (Buffer.Quantity);
                                            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                            ReservationEntry."Creation Date" := TODAY;
                                            ReservationEntry."Created By" := USERID;
                                            ReservationEntry."Source Subtype" := 1;
                                            ReservationEntry."Expected Receipt Date" := TransferHeader."Shipment Date";
                                            ReservationEntry.Positive := TRUE;
                                            ReservationEntry."Shipment Date" := 0D;
                                            ReservationEntry."Lot No." := "Item Ledger Entry"."Lot No.";
                                            ReservationEntry.INSERT(TRUE);
                                        end;
                                    until Buffer.NEXT = 0;
                                if TotalQty2Transfer > 0 then begin
                                    TransferLine.VALIDATE(Quantity, TotalQty2Transfer);
                                    TransferLine.MODIFY(true);
                                end else begin
                                    NextLineNo -= 10000;
                                    TransferLine.DELETE(true);
                                end;
                            until ItemBuffer.NEXT = 0;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE(Open, true);
                    SETRANGE(Positive, true);
                    SETRANGE("Location Code", TransferHeader."Transfer-from Code");
                    SETFILTER("Expiration Date", '<=%1&<>%2', ExpirationDate, 0D);
                    Buffer.DELETEALL;
                    ItemBuffer.DELETEALL;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                Window.UPDATE(1, "No.");
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
            end;

            trigger OnPreDataItem();
            var
                ReservationEntry: Record "Reservation Entry";
            begin
                Window.OPEN('Item No.: #1###############\Lines Added: #2############');
                if ReservationEntry.FINDLAST then
                    NextEntryNo := ReservationEntry."Entry No.";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    caption = 'Options';
                    field(ExpirationDate; ExpirationDate)
                    {
                        Caption = 'Expiration Date';
                        ShowMandatory = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Buffer: Record ExpirationCalculation temporary;
        ItemBuffer: Record ExpirationCalculation temporary;
        ExpirationDate: Date;
        NextLineNo: Integer;
        Window: Dialog;
        Counter: Integer;
        NextEntryNo: Integer;

    procedure SetHeader(FromHeader: Record "Transfer Header");
    begin
        NextLineNo := 0;
        TransferHeader.GET(FromHeader."No.");
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", FromHeader."No.");
        if TransferLine.FINDLAST then
            NextLineNo := TransferLine."Line No.";
    end;
}


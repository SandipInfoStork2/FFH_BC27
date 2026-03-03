report 50098 "Transfer Expiring Items"
{
    // 
    // TAL0.1 2018/12/05 VC correct duplicate entries

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.", Open, Positive, "Location Code", "Expiration Date");

                trigger OnAfterGetRecord();
                begin
                    if "Lot No." <> '' then begin
                        if not ItemBuffer.Get("Item No.", '', 0D) then begin
                            Clear(ItemBuffer);
                            ItemBuffer."Item No." := "Item No.";
                            ItemBuffer.Insert;
                        end;
                        ItemBuffer.Quantity += "Remaining Quantity";
                        ItemBuffer.Modify;

                        if not Buffer.Get("Item No.", "Lot No.", "Expiration Date") then begin
                            Clear(Buffer);
                            Buffer."Item No." := "Item No.";
                            Buffer."Lot No." := "Lot No.";
                            Buffer."Expiration Date" := "Expiration Date";
                            Buffer.Insert;
                        end;
                        Buffer.Quantity += "Remaining Quantity";
                        Buffer.Modify;
                    end;
                end;

                trigger OnPostDataItem();
                var
                    ReservationEntry: Record "Reservation Entry";
                    Item2: Record Item;
                    Qty2Transfer: Decimal;
                    TotalQty2Transfer: Decimal;
                begin
                    if ItemBuffer.FindFirst then
                        repeat
                            TotalQty2Transfer := 0;
                            Item2.Get(ItemBuffer."Item No.");
                            Item2.SetRange("Location Filter", TransferHeader."Transfer-from Code");
                            NextLineNo += 10000;
                            Counter += 1;
                            Window.Update(2, Counter);
                            Clear(TransferLine);
                            TransferLine."Document No." := TransferHeader."No.";
                            TransferLine."Line No." := NextLineNo;
                            TransferLine.Validate("Item No.", ItemBuffer."Item No.");
                            TransferLine.Insert(true);

                            Buffer.SetRange("Item No.", ItemBuffer."Item No.");
                            if Buffer.FindFirst then
                                repeat
                                    Item2.SetRange("Lot No. Filter", Buffer."Lot No.");
                                    Item2.CalcFields(Inventory, "Reserved Qty. on Inventory");
                                    Qty2Transfer := Buffer.Quantity - Item2."Reserved Qty. on Inventory";
                                    if Qty2Transfer > Item2.Inventory then
                                        Qty2Transfer := Item2.Inventory;
                                    if Qty2Transfer > 0 then begin
                                        TotalQty2Transfer += Qty2Transfer;
                                        Clear(ReservationEntry);
                                        NextEntryNo += 1;
                                        ReservationEntry."Entry No." := NextEntryNo;
                                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                        ReservationEntry."Item No." := TransferLine."Item No.";
                                        ReservationEntry."Lot No." := Buffer."Lot No.";
                                        //ReservationEntry."Expiration Date" := Buffer."Expiration Date";
                                        //ReservationEntry."New Lot No." := Buffer."Lot No.";
                                        //ReservationEntry."New Expiration Date" := Buffer."Expiration Date";
                                        ReservationEntry.Validate("Quantity (Base)", -Buffer.Quantity);
                                        ReservationEntry."Location Code" := TransferHeader."Transfer-from Code";
                                        ReservationEntry."Creation Date" := WorkDate;
                                        ReservationEntry."Source Type" := Database::"Transfer Line";
                                        ReservationEntry."Source Subtype" := 0;
                                        ReservationEntry."Source ID" := TransferHeader."No.";
                                        ReservationEntry."Source Ref. No." := TransferLine."Line No.";
                                        ReservationEntry."Shipment Date" := TransferHeader."Shipment Date";
                                        ReservationEntry."Created By" := UserId;
                                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                        ReservationEntry.Insert;


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
                                        Clear(ReservationEntry);
                                        ReservationEntry.Init;
                                        ReservationEntry."Entry No." := 0;
                                        ReservationEntry."Item No." := "Item Ledger Entry"."Item No.";
                                        ReservationEntry."Location Code" := TransferHeader."Transfer-to Code";
                                        ReservationEntry.Validate("Quantity (Base)", Buffer.Quantity);
                                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                        ReservationEntry."Source Type" := 5741;
                                        ReservationEntry."Source ID" := TransferHeader."No.";
                                        ReservationEntry."Source Ref. No." := TransferLine."Line No.";
                                        ReservationEntry.Quantity := (Buffer.Quantity);
                                        ReservationEntry."Qty. to Handle (Base)" := (Buffer.Quantity);
                                        ReservationEntry."Qty. to Invoice (Base)" := (Buffer.Quantity);
                                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                        ReservationEntry."Creation Date" := Today;
                                        ReservationEntry."Created By" := UserId;
                                        ReservationEntry."Source Subtype" := 1;
                                        ReservationEntry."Expected Receipt Date" := TransferHeader."Shipment Date";
                                        ReservationEntry.Positive := true;
                                        ReservationEntry."Shipment Date" := 0D;
                                        ReservationEntry."Lot No." := "Item Ledger Entry"."Lot No.";
                                        ReservationEntry.Insert(true);
                                    end;
                                until Buffer.Next = 0;
                            if TotalQty2Transfer > 0 then begin
                                TransferLine.Validate(Quantity, TotalQty2Transfer);
                                TransferLine.Modify(true);
                            end else begin
                                NextLineNo -= 10000;
                                TransferLine.Delete(true);
                            end;
                        until ItemBuffer.Next = 0;
                end;

                trigger OnPreDataItem();
                begin
                    SetRange(Open, true);
                    SetRange(Positive, true);
                    SetRange("Location Code", TransferHeader."Transfer-from Code");
                    SetFilter("Expiration Date", '<=%1&<>%2', ExpirationDate, 0D);
                    Buffer.DeleteAll;
                    ItemBuffer.DeleteAll;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                Window.Update(1, "No.");
            end;

            trigger OnPostDataItem();
            begin
                Window.Close;
            end;

            trigger OnPreDataItem();
            var
                ReservationEntry: Record "Reservation Entry";
            begin
                Window.Open('Item No.: #1###############\Lines Added: #2############');
                if ReservationEntry.FindLast then
                    NextEntryNo := ReservationEntry."Entry No.";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ExpirationDate; ExpirationDate)
                    {
                        Caption = 'Expiration Date';
                        ShowMandatory = true;
                        ToolTip = 'Specifies the value of the Expiration Date field.';
                        ApplicationArea = All;
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
        TransferHeader.Get(FromHeader."No.");
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", FromHeader."No.");
        if TransferLine.FindLast then
            NextLineNo := TransferLine."Line No.";
    end;
}


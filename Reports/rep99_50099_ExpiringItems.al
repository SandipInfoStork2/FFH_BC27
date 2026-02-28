report 50099 "Expiring Items"
{
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
                    //if not ItemBuffer.GET("Item No.", '', 0D) then begin
                    //    CLEAR(ItemBuffer);
                    //     ItemBuffer."Item No." := "Item No.";
                    //     ItemBuffer.INSERT;
                    // end;
                    //ItemBuffer.Quantity += "Remaining Quantity";
                    //ItemBuffer.MODIFY;
                    if ("Lot No." <> '') and ("Expiration Date" <> 0D) then begin
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
                begin
                    //Buffer.RESET;
                    // Buffer.SetFilter("Item No.", Item."No.");


                    with Buffer do begin
                        if Buffer.FINDFIRST then begin


                            //Message(format(Buffer.Count));
                            repeat
                                NextLineNo += 10000;
                                Counter += 1;
                                Window.UPDATE(2, Counter);
                                CLEAR(ItemJnlLine);
                                ItemJnlLine."Journal Template Name" := ItemJnlLine2."Journal Template Name";
                                ItemJnlLine."Journal Batch Name" := ItemJnlLine2."Journal Batch Name";
                                ItemJnlLine.SetUpNewLine(ItemJnlLine2);
                                ItemJnlLine."Line No." := NextLineNo;
                                ItemJnlLine.VALIDATE("Item No.", "Item No.");
                                ItemJnlLine.VALIDATE("Posting Date", WORKDATE);
                                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                                ItemJnlLine.VALIDATE("Location Code", FromLocationCode);
                                ItemJnlLine.VALIDATE(Quantity, Quantity);
                                ItemJnlLine.VALIDATE("New Location Code", ToLocationCode);
                                ItemJnlLine.INSERT(true);

                                Buffer.SETRANGE("Item No.", Buffer."Item No.");
                                if Buffer.FINDFIRST then
                                    repeat
                                        CLEAR(ReservationEntry);
                                        NextEntryNo += 1;
                                        ReservationEntry."Entry No." := NextEntryNo;
                                        ReservationEntry."Item No." := ItemJnlLine."Item No.";
                                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                        ReservationEntry."Lot No." := Buffer."Lot No.";
                                        ReservationEntry."Expiration Date" := Buffer."Expiration Date";
                                        ReservationEntry."New Lot No." := Buffer."Lot No.";
                                        ReservationEntry."New Expiration Date" := Buffer."Expiration Date";
                                        ReservationEntry.VALIDATE("Quantity (Base)", -Buffer.Quantity);
                                        ReservationEntry."Location Code" := FromLocationCode;
                                        ReservationEntry."Creation Date" := WORKDATE;
                                        ReservationEntry."Source Type" := DATABASE::"Item Journal Line";
                                        ReservationEntry."Source Subtype" := 4;
                                        ReservationEntry."Source ID" := ItemJnlLine."Journal Template Name";
                                        ReservationEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
                                        ReservationEntry."Source Ref. No." := ItemJnlLine."Line No.";
                                        ReservationEntry."Shipment Date" := WORKDATE;
                                        ReservationEntry."Created By" := USERID;
                                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                        ReservationEntry.INSERT;
                                    until Buffer.NEXT = 0;
                                ItemJnlLine2 := ItemJnlLine;
                            until Buffer.NEXT = 0;
                        end;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE(Open, true);
                    SETRANGE(Positive, true);
                    SETRANGE("Location Code", FromLocationCode);
                    SETFILTER("Expiration Date", '<=%1&<>%2', ExpirationDate, 0D);

                    Buffer.DELETEALL;
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
        SaveValues = true;

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
                    field(FromLocationCode; FromLocationCode)
                    {
                        Caption = 'From Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                    }

                    field(ToLocationCode; ToLocationCode)
                    {
                        Caption = 'To Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            myInt: Integer;
        begin
            ExpirationDate := WorkDate();
            //FromLocationCode := 'ARAD-1';
            //ToLocationCode := 'AR-WASTE';
        end;
    }

    labels
    {
    }

    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLine2: Record "Item Journal Line";
        Buffer: Record ExpirationCalculation temporary;
        //ItemBuffer: Record ExpirationCalculation temporary;
        ExpirationDate: Date;
        FromLocationCode: Code[10];
        ToLocationCode: Code[10];
        NextLineNo: Integer;
        Window: Dialog;
        Counter: Integer;
        NextEntryNo: Integer;

    procedure SetItemJnl(var ToItemJnlLIne: Record "Item Journal Line");
    begin
        ItemJnlLine2.COPY(ToItemJnlLIne);
        NextLineNo := 0;
        if ItemJnlLine2.FINDLAST then
            NextLineNo := ItemJnlLine2."Line No.";
    end;
}


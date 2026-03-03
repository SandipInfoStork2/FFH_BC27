report 50099 "Expiring Items"
{
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
                    //if not ItemBuffer.GET("Item No.", '', 0D) then begin
                    //    CLEAR(ItemBuffer);
                    //     ItemBuffer."Item No." := "Item No.";
                    //     ItemBuffer.INSERT;
                    // end;
                    //ItemBuffer.Quantity += "Remaining Quantity";
                    //ItemBuffer.MODIFY;
                    if ("Lot No." <> '') and ("Expiration Date" <> 0D) then begin
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
                begin
                    //Buffer.RESET;
                    // Buffer.SetFilter("Item No.", Item."No.");
                    if Buffer.FindFirst then begin


                        //Message(format(Buffer.Count));
                        repeat
                            NextLineNo += 10000;
                            Counter += 1;
                            Window.Update(2, Counter);
                            Clear(ItemJnlLine);
                            ItemJnlLine."Journal Template Name" := ItemJnlLine2."Journal Template Name";
                            ItemJnlLine."Journal Batch Name" := ItemJnlLine2."Journal Batch Name";
                            ItemJnlLine.SetUpNewLine(ItemJnlLine2);
                            ItemJnlLine."Line No." := NextLineNo;
                            ItemJnlLine.Validate("Item No.", Buffer."Item No.");
                            ItemJnlLine.Validate("Posting Date", WorkDate);
                            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
                            ItemJnlLine.Validate("Location Code", FromLocationCode);
                            ItemJnlLine.Validate(Quantity, Buffer.Quantity);
                            ItemJnlLine.Validate("New Location Code", ToLocationCode);
                            ItemJnlLine.Insert(true);

                            Buffer.SetRange("Item No.", Buffer."Item No.");
                            if Buffer.FindFirst then
                                repeat
                                    Clear(ReservationEntry);
                                    NextEntryNo += 1;
                                    ReservationEntry."Entry No." := NextEntryNo;
                                    ReservationEntry."Item No." := ItemJnlLine."Item No.";
                                    ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                    ReservationEntry."Lot No." := Buffer."Lot No.";
                                    ReservationEntry."Expiration Date" := Buffer."Expiration Date";
                                    ReservationEntry."New Lot No." := Buffer."Lot No.";
                                    ReservationEntry."New Expiration Date" := Buffer."Expiration Date";
                                    ReservationEntry.Validate("Quantity (Base)", -Buffer.Quantity);
                                    ReservationEntry."Location Code" := FromLocationCode;
                                    ReservationEntry."Creation Date" := WorkDate;
                                    ReservationEntry."Source Type" := Database::"Item Journal Line";
                                    ReservationEntry."Source Subtype" := 4;
                                    ReservationEntry."Source ID" := ItemJnlLine."Journal Template Name";
                                    ReservationEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
                                    ReservationEntry."Source Ref. No." := ItemJnlLine."Line No.";
                                    ReservationEntry."Shipment Date" := WorkDate;
                                    ReservationEntry."Created By" := UserId;
                                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                    ReservationEntry.Insert;
                                until Buffer.Next = 0;
                            ItemJnlLine2 := ItemJnlLine;
                        until Buffer.Next = 0;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SetRange(Open, true);
                    SetRange(Positive, true);
                    SetRange("Location Code", FromLocationCode);
                    SetFilter("Expiration Date", '<=%1&<>%2', ExpirationDate, 0D);

                    Buffer.DeleteAll;
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
        SaveValues = true;

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
                    field(FromLocationCode; FromLocationCode)
                    {
                        Caption = 'From Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                        ToolTip = 'Specifies the value of the From Location Code field.';
                        ApplicationArea = All;
                    }

                    field(ToLocationCode; ToLocationCode)
                    {
                        Caption = 'To Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                        ToolTip = 'Specifies the value of the To Location Code field.';
                        ApplicationArea = All;
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
        ItemJnlLine2.Copy(ToItemJnlLIne);
        NextLineNo := 0;
        if ItemJnlLine2.FindLast then
            NextLineNo := ItemJnlLine2."Line No.";
    end;
}


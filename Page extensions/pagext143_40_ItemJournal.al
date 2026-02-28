pageextension 50243 ItemJournalExt extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        //TAL 1.0.0.71 >>
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        moveafter("Applies-to Entry"; "Gen. Bus. Posting Group")
        //TAL 1.0.0.71 <<

        //+1.0.0.228
        modify("Unit Cost")
        {
            Editable = UnitCostEditable;
            Visible = UnitCostEditable;
        }
        //-1.0.0.228
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Get Standard Journals")
        {
            action("Correct Finished Production Order")
            {
                ApplicationArea = Suite;
                Caption = 'Correct Finished Production Order';
                Ellipsis = true;
                Image = GetStandardJournal;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Custom: Correct Finished Production Order';

                trigger OnAction()
                var
                    ProductionOrder: Record "Production Order";

                    ILE: Record "Item Ledger Entry";
                    rL_ItemJournalLine: Record "Item Journal Line";
                    vL_LineNo: Integer;
                    ReservationEntry: Record "Reservation Entry";

                    DocNo: Code[20];
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    ItemJournalBatch: Record "Item Journal Batch";
                begin
                    ItemJournalBatch.GET(Rec."Journal Template Name", rec."Journal Batch Name");

                    DocNo := '';
                    if ItemJournalBatch."No. Series" <> '' then begin
                        DocNo := NoSeriesMgt.GetNextNo(ItemJournalBatch."No. Series", WorkDate(), false);
                    end;

                    ProductionOrder.RESET;
                    ProductionOrder.SetRange(Status, ProductionOrder.Status::Finished);
                    if PAGE.RunModal(PAGE::"Finished Production Orders", ProductionOrder) = ACTION::LookupOK then begin

                        ILE.RESET;
                        ILE.SetRange("Order Type", ILE."Order Type"::Production);
                        ILE.SetFilter("Order No.", ProductionOrder."No.");
                        if ILE.FindSet() then begin
                            repeat
                                CLEAR(rL_ItemJournalLine);

                                vL_LineNo := 0;
                                rL_ItemJournalLine.RESET;
                                rL_ItemJournalLine.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                                rL_ItemJournalLine.SETFILTER("Journal Batch Name", Rec."Journal Batch Name");
                                IF rL_ItemJournalLine.FINDLAST THEN BEGIN
                                    vL_LineNo := rL_ItemJournalLine."Line No.";
                                END;
                                vL_LineNo += 10000;

                                CLEAR(rL_ItemJournalLine);
                                rL_ItemJournalLine.RESET;
                                rL_ItemJournalLine.VALIDATE("Journal Template Name", Rec."Journal Template Name");
                                rL_ItemJournalLine.VALIDATE("Journal Batch Name", Rec."Journal Batch Name");
                                rL_ItemJournalLine.VALIDATE("Line No.", vL_LineNo);
                                rL_ItemJournalLine.SetUpNewLine(rL_ItemJournalLine);

                                rL_ItemJournalLine.VALIDATE("Posting Date", ILE."Posting Date");

                                if ILE."Entry Type" = ILE."Entry Type"::Consumption then begin
                                    rL_ItemJournalLine.VALIDATE("Entry Type", rL_ItemJournalLine."Entry Type"::"Positive Adjmt.");
                                end;

                                if ILE."Entry Type" = ILE."Entry Type"::Output then begin
                                    rL_ItemJournalLine.VALIDATE("Entry Type", rL_ItemJournalLine."Entry Type"::"Negative Adjmt.");
                                end;

                                rL_ItemJournalLine.INSERT(TRUE);
                                if DocNo <> '' then begin

                                    rL_ItemJournalLine.VALIDATE("Document No.", DocNo);

                                end else begin
                                    rL_ItemJournalLine.VALIDATE("Document No.", ILE."Document No." + 'C');

                                end;

                                rL_ItemJournalLine.VALIDATE("External Document No.", ILE."Document No.");
                                rL_ItemJournalLine.VALIDATE("Item No.", ILE."Item No.");
                                rL_ItemJournalLine.VALIDATE("Location Code", ILE."Location Code");
                                rL_ItemJournalLine.VALIDATE("Unit of Measure Code", ILE."Unit of Measure Code");
                                rL_ItemJournalLine.VALIDATE(Quantity, ABS(ILE.Quantity));
                                rL_ItemJournalLine.MODIFY(TRUE);

                                if ILE."Lot No." = '' then begin
                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        rL_ItemJournalLine.VALIDATE("Applies-to Entry", ILE."Entry No.");
                                    end;

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Positive Adjmt." then begin
                                        rL_ItemJournalLine.VALIDATE("Applies-from Entry", ILE."Entry No.");
                                    end;

                                    rL_ItemJournalLine.MODIFY(TRUE);

                                end else begin
                                    CLEAR(ReservationEntry);
                                    ReservationEntry.INIT;
                                    ReservationEntry."Entry No." := 0;
                                    ReservationEntry.VALIDATE("Item No.", rL_ItemJournalLine."Item No.");
                                    ReservationEntry.VALIDATE("Location Code", rL_ItemJournalLine."Location Code");
                                    ReservationEntry.VALIDATE("Quantity (Base)", rL_ItemJournalLine.Quantity);
                                    ReservationEntry.VALIDATE(Positive, TRUE);
                                    ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);

                                    ReservationEntry.VALIDATE("Creation Date", TODAY);
                                    ReservationEntry.VALIDATE("Source Type", 83);

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        ReservationEntry.VALIDATE("Source Subtype", 3);
                                    end;

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Positive Adjmt." then begin
                                        ReservationEntry.VALIDATE("Source Subtype", 2);
                                    end;

                                    ReservationEntry.VALIDATE("Source ID", rL_ItemJournalLine."Journal Template Name");
                                    ReservationEntry.VALIDATE("Source Batch Name", rL_ItemJournalLine."Journal Batch Name");
                                    ReservationEntry.VALIDATE("Source Ref. No.", rL_ItemJournalLine."Line No.");

                                    ReservationEntry.VALIDATE("Created By", USERID);
                                    //ReservationEntry.VALIDATE("Expected Receipt Date", rL_WRLSearch."Starting Date");


                                    ReservationEntry.VALIDATE("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");

                                    ReservationEntry.VALIDATE("Lot No.", ILE."Lot No.");

                                    //Evaluate(TempDate, Colmn4_Valid);

                                    ReservationEntry.VALIDATE("Expiration Date", ILE."Expiration Date");
                                    //ReservationEntry.VALIDATE("Serial No.", Colmn5_Valid);

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        ReservationEntry.VALIDATE("Appl.-to Item Entry", ILE."Entry No.");
                                    end else begin
                                        ReservationEntry.VALIDATE("Appl.-from Item Entry", ILE."Entry No.");
                                    end;


                                    ReservationEntry.INSERT(TRUE);
                                end;
                            until ILE.Next() = 0;
                        end;

                    end
                end;
            }
        }
        //-1.0.0.124
    }

    //+1.0.0.228
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
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
                    NoSeriesMgt: Codeunit "No. Series";
                    ItemJournalBatch: Record "Item Journal Batch";
                begin
                    ItemJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");

                    DocNo := '';
                    if ItemJournalBatch."No. Series" <> '' then begin
                        DocNo := NoSeriesMgt.GetNextNo(ItemJournalBatch."No. Series", WorkDate(), false);
                    end;

                    ProductionOrder.Reset;
                    ProductionOrder.SetRange(Status, ProductionOrder.Status::Finished);
                    if Page.RunModal(Page::"Finished Production Orders", ProductionOrder) = Action::LookupOK then begin

                        ILE.Reset;
                        ILE.SetRange("Order Type", ILE."Order Type"::Production);
                        ILE.SetFilter("Order No.", ProductionOrder."No.");
                        if ILE.FindSet() then begin
                            repeat
                                Clear(rL_ItemJournalLine);

                                vL_LineNo := 0;
                                rL_ItemJournalLine.Reset;
                                rL_ItemJournalLine.SetFilter("Journal Template Name", Rec."Journal Template Name");
                                rL_ItemJournalLine.SetFilter("Journal Batch Name", Rec."Journal Batch Name");
                                if rL_ItemJournalLine.FindLast then begin
                                    vL_LineNo := rL_ItemJournalLine."Line No.";
                                end;
                                vL_LineNo += 10000;

                                Clear(rL_ItemJournalLine);
                                rL_ItemJournalLine.Reset;
                                rL_ItemJournalLine.Validate("Journal Template Name", Rec."Journal Template Name");
                                rL_ItemJournalLine.Validate("Journal Batch Name", Rec."Journal Batch Name");
                                rL_ItemJournalLine.Validate("Line No.", vL_LineNo);
                                rL_ItemJournalLine.SetUpNewLine(rL_ItemJournalLine);

                                rL_ItemJournalLine.Validate("Posting Date", ILE."Posting Date");

                                if ILE."Entry Type" = ILE."Entry Type"::Consumption then begin
                                    rL_ItemJournalLine.Validate("Entry Type", rL_ItemJournalLine."Entry Type"::"Positive Adjmt.");
                                end;

                                if ILE."Entry Type" = ILE."Entry Type"::Output then begin
                                    rL_ItemJournalLine.Validate("Entry Type", rL_ItemJournalLine."Entry Type"::"Negative Adjmt.");
                                end;

                                rL_ItemJournalLine.Insert(true);
                                if DocNo <> '' then begin

                                    rL_ItemJournalLine.Validate("Document No.", DocNo);

                                end else begin
                                    rL_ItemJournalLine.Validate("Document No.", ILE."Document No." + 'C');

                                end;

                                rL_ItemJournalLine.Validate("External Document No.", ILE."Document No.");
                                rL_ItemJournalLine.Validate("Item No.", ILE."Item No.");
                                rL_ItemJournalLine.Validate("Location Code", ILE."Location Code");
                                rL_ItemJournalLine.Validate("Unit of Measure Code", ILE."Unit of Measure Code");
                                rL_ItemJournalLine.Validate(Quantity, Abs(ILE.Quantity));
                                rL_ItemJournalLine.Modify(true);

                                if ILE."Lot No." = '' then begin
                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        rL_ItemJournalLine.Validate("Applies-to Entry", ILE."Entry No.");
                                    end;

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Positive Adjmt." then begin
                                        rL_ItemJournalLine.Validate("Applies-from Entry", ILE."Entry No.");
                                    end;

                                    rL_ItemJournalLine.Modify(true);

                                end else begin
                                    Clear(ReservationEntry);
                                    ReservationEntry.Init;
                                    ReservationEntry."Entry No." := 0;
                                    ReservationEntry.Validate("Item No.", rL_ItemJournalLine."Item No.");
                                    ReservationEntry.Validate("Location Code", rL_ItemJournalLine."Location Code");
                                    ReservationEntry.Validate("Quantity (Base)", rL_ItemJournalLine.Quantity);
                                    ReservationEntry.Validate(Positive, true);
                                    ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Surplus);

                                    ReservationEntry.Validate("Creation Date", Today);
                                    ReservationEntry.Validate("Source Type", 83);

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        ReservationEntry.Validate("Source Subtype", 3);
                                    end;

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Positive Adjmt." then begin
                                        ReservationEntry.Validate("Source Subtype", 2);
                                    end;

                                    ReservationEntry.Validate("Source ID", rL_ItemJournalLine."Journal Template Name");
                                    ReservationEntry.Validate("Source Batch Name", rL_ItemJournalLine."Journal Batch Name");
                                    ReservationEntry.Validate("Source Ref. No.", rL_ItemJournalLine."Line No.");

                                    ReservationEntry.Validate("Created By", UserId);
                                    //ReservationEntry.VALIDATE("Expected Receipt Date", rL_WRLSearch."Starting Date");


                                    ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");

                                    ReservationEntry.Validate("Lot No.", ILE."Lot No.");

                                    //Evaluate(TempDate, Colmn4_Valid);

                                    ReservationEntry.Validate("Expiration Date", ILE."Expiration Date");
                                    //ReservationEntry.VALIDATE("Serial No.", Colmn5_Valid);

                                    if rL_ItemJournalLine."Entry Type" = rL_ItemJournalLine."Entry Type"::"Negative Adjmt." then begin
                                        ReservationEntry.Validate("Appl.-to Item Entry", ILE."Entry No.");
                                    end else begin
                                        ReservationEntry.Validate("Appl.-from Item Entry", ILE."Entry No.");
                                    end;


                                    ReservationEntry.Insert(true);
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
        UserSetup.Get(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
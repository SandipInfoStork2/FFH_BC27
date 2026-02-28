/*
TAL0.1 2021/05/14 ANP Design Location Name
TAL0.2 2021/12/29 ANP Design Item Category Code

*/
pageextension 50159 PhysInventoryJournalExt extends "Phys. Inventory Journal"
{
    layout
    {
        // Add changes to page layout here

        addafter("Location Code")
        {
            field("Location Name"; "Location Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;//TAL 1.0.0.71
            }
        }

        modify("Reason Code")
        {
            Visible = true;
        }

        addafter("Reason Code")
        {
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.71 >>
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify("Applies-to Entry")
        {
            Visible = false;
        }
        // modify("Location Name")
        // {
        // Visible = false;
        // }
        moveafter("Posting Date"; "Location Code")
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Unit of Measure Code62477"; Rec."Unit of Measure Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item No.")
        {
            field("Variant Code97220"; Rec."Variant Code")
            {
                ApplicationArea = All;
                Width = 12;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Gen. Bus. Posting Group92798"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.71 <<

        //+1.0.0.228
        modify("Unit Cost")
        {
            Visible = UnitCostEditable;
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

        addafter(ShortcutDimCode8)
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Item Tracking Code"; "Item Tracking Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Tracking Lot No."; "Tracking Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Tracking Expiration Date"; "Tracking Expiration Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(CalculateCountingPeriod)
        {
            action("Zeroise Physical Inventory")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                begin
                    InventLines.RESET;
                    InventLines.SETRANGE(InventLines."Journal Template Name", "Journal Template Name");
                    InventLines.SETRANGE(InventLines."Journal Batch Name", "Journal Batch Name");
                    IF InventLines.FindSet() THEN BEGIN
                        REPEAT
                            InventLines.VALIDATE("Qty. (Phys. Inventory)", 0);
                            InventLines.MODIFY();
                        UNTIL InventLines.NEXT = 0;
                    END;
                end;
            }

            action("Update Bin")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                    Bin: Record Bin;
                    BinCode: Code[20];
                    Text50000: Label 'Please select Bin Code';
                    Text50001: Label 'Are you sure to update all lines with Bin Code %1?';
                begin
                    //select the bin

                    InventLines.RESET;
                    InventLines.SETRANGE("Journal Template Name", "Journal Template Name");
                    InventLines.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    if InventLines.FindFirst() then begin
                        InventLines.TestField("Location Code");

                        Bin.RESET;
                        Bin.SetFilter("Location Code", InventLines."Location Code");
                        if page.RunModal(page::"Bin List", Bin) = Action::LookupOK then begin
                            BinCode := Bin.Code;
                        end;
                    end;

                    if BinCode = '' then begin
                        Error(Text50000);
                    end;

                    if not Confirm(Text50001, false) then begin
                        exit;
                    end;


                    InventLines.RESET;
                    InventLines.SETRANGE(InventLines."Journal Template Name", "Journal Template Name");
                    InventLines.SETRANGE(InventLines."Journal Batch Name", "Journal Batch Name");
                    IF InventLines.FindSet() THEN BEGIN
                        REPEAT
                            InventLines.VALIDATE("Bin Code", BinCode);
                            InventLines.MODIFY();
                        UNTIL InventLines.NEXT = 0;
                    END;
                end;
            }
        }

        addafter(CalculateCountingPeriod)
        {
            action(UpdateCostCenterCode)
            {
                ApplicationArea = all;
                Caption = 'Update Cost Center Code';
                Image = UpdateDescription;
                ToolTip = 'Custom: Update Cost Center Code';
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                begin
                    InventLines.RESET;
                    InventLines.SETRANGE(InventLines."Journal Template Name", Rec."Journal Template Name");
                    InventLines.SETRANGE(InventLines."Journal Batch Name", Rec."Journal Batch Name");
                    if InventLines.FindSet() then begin
                        ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        if ItemJnlBatch."Profit Center" <> '' then begin
                            repeat
                                InventLines.ValidateShortcutDimCode(4, ItemJnlBatch."Profit Center");
                                InventLines.MODIFY();
                            until InventLines.NEXT = 0;
                        end;
                    end;
                end;
            }
        }
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
        if ItemJnlBatch."Profit Center" <> '' then begin
            Rec.ValidateShortcutDimCode(4, ItemJnlBatch."Profit Center");
        end;
    end;

    var
        UnitCostEditable: Boolean;
        ItemJnlBatch: Record "Item Journal Batch";
}
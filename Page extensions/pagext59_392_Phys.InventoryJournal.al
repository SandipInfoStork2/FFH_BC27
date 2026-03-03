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
            field("Location Name"; Rec."Location Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                //TAL 1.0.0.71                ToolTip = 'Specifies the value of the Location Name field.';

            }
        }

        modify("Reason Code")
        {
            Visible = true;
        }

        addafter("Reason Code")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
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
                ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
            }
        }
        addafter("Item No.")
        {
            field("Variant Code97220"; Rec."Variant Code")
            {
                ApplicationArea = All;
                Width = 12;
                ToolTip = 'Specifies the variant of the item on the line.';
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Gen. Bus. Posting Group92798"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
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
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the number of the journal line.';
            }
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Item Tracking Code field.';
            }
            field("Tracking Lot No."; Rec."Tracking Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Tracking Lot No. field.';
            }
            field("Tracking Expiration Date"; Rec."Tracking Expiration Date")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Tracking Expiration Date field.';
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
                ToolTip = 'Executes the Zeroise Physical Inventory action.';

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                begin
                    InventLines.Reset;
                    InventLines.SETRANGE(InventLines."Journal Template Name", Rec."Journal Template Name");
                    InventLines.SETRANGE(InventLines."Journal Batch Name", Rec."Journal Batch Name");
                    if InventLines.FindSet() then begin
                        repeat
                            InventLines.Validate("Qty. (Phys. Inventory)", 0);
                            InventLines.Modify();
                        until InventLines.Next = 0;
                    end;
                end;
            }

            action("Update Bin")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Update Bin action.';

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                    Bin: Record Bin;
                    BinCode: Code[20];
                    Text50000: Label 'Please select Bin Code';
                    Text50001: Label 'Are you sure to update all lines with Bin Code %1?';
                begin
                    //select the bin

                    InventLines.Reset;
                    InventLines.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    InventLines.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    if InventLines.FindFirst() then begin
                        InventLines.TestField("Location Code");

                        Bin.Reset;
                        Bin.SetFilter("Location Code", InventLines."Location Code");
                        if Page.RunModal(Page::"Bin List", Bin) = Action::LookupOK then begin
                            BinCode := Bin.Code;
                        end;
                    end;

                    if BinCode = '' then begin
                        Error(Text50000);
                    end;

                    if not Confirm(Text50001, false) then begin
                        exit;
                    end;


                    InventLines.Reset;
                    InventLines.SETRANGE(InventLines."Journal Template Name", Rec."Journal Template Name");
                    InventLines.SETRANGE(InventLines."Journal Batch Name", Rec."Journal Batch Name");
                    if InventLines.FindSet() then begin
                        repeat
                            InventLines.Validate("Bin Code", BinCode);
                            InventLines.Modify();
                        until InventLines.Next = 0;
                    end;
                end;
            }
        }

        addafter(CalculateCountingPeriod)
        {
            action(UpdateCostCenterCode)
            {
                ApplicationArea = All;
                Caption = 'Update Cost Center Code';
                Image = UpdateDescription;
                ToolTip = 'Custom: Update Cost Center Code';
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    InventLines: Record "Item Journal Line";
                begin
                    InventLines.Reset;
                    InventLines.SetRange(InventLines."Journal Template Name", Rec."Journal Template Name");
                    InventLines.SetRange(InventLines."Journal Batch Name", Rec."Journal Batch Name");
                    if InventLines.FindSet() then begin
                        ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        if ItemJnlBatch."Profit Center" <> '' then begin
                            repeat
                                InventLines.ValidateShortcutDimCode(4, ItemJnlBatch."Profit Center");
                                InventLines.Modify();
                            until InventLines.Next = 0;
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
        UserSetup.Get(UserId);
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
/*
18/06/17 TAL0.1 add field "Shelf No."
TAL0.2 24/12/2018 VC move Shelf No. 
TAL0.3 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.4 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50131 PostedSalesCrMemoSubformExt extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }
        }

        modify("Net Weight")
        {
            Visible = true;
        }
        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
            }
        }
        */

        addafter("Deferral Code")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 3;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }

            field("Qty. Requested"; Rec."Qty. Requested")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Requested field.';
            }
        }

        addafter("ShortcutDimCode[8]")
        {

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Req. Country field.';
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Custom: Country/Region of Origin Code';
            }

            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Product Class (Κατηγορία)';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Potatoes District Region';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;
                ToolTip = 'Executes the Item &Tracking Entries action.';

                trigger OnAction();
                begin
                    Rec.ShowItemTrackingLines;
                end;
            }


        }

        addafter(DocumentLineTracking)
        {
            action("Update Categories")
            {
                ApplicationArea = Suite;
                Caption = 'Update Categories';
                Image = Edit;
                ToolTip = 'Custom: Update Categories';

                trigger OnAction()
                var
                    PostedSalesCrMemoLineUpdate: Page "Posted Sales Line C- Update";
                begin
                    PostedSalesCrMemoLineUpdate.LookupMode := true;
                    PostedSalesCrMemoLineUpdate.SetRec(Rec);
                    PostedSalesCrMemoLineUpdate.RunModal;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
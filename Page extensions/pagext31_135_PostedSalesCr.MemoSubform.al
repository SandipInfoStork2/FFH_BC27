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
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = all;
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
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }

            field("Qty. Requested"; "Qty. Requested")
            {
                Visible = false;
                ApplicationArea = all;
            }
        }

        addafter("ShortcutDimCode[8]")
        {

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = all;
                Visible = true;
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Visible = true;
            }

            field("Product Class"; "Product Class")
            {
                ApplicationArea = all;
            }
            field("Category 9"; "Category 9")
            {
                ApplicationArea = all;
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
                ApplicationArea = all;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;

                trigger OnAction();
                begin
                    ShowItemTrackingLines;
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
/*
TAL0.1 2019/05/05 VC design Quantity Base, UOM Base  
TAL0.2 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.3 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50192 PurchaseReturnOrderSubformExt extends "Purchase Return Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bin Code")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = All;
            }
        }

        addafter("Reserved Quantity")
        {
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
            }
        }
        */

        //TAL 1.0.0.71 >>
         addafter("Line Discount %")
        {
            field("VAT Prod. Posting Group90627";Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.71 <<
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(ItemTrackingLines2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction();
                begin
                    OpenItemTrackingLines;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
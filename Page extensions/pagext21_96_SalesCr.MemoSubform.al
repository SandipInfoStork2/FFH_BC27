
/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50121 SalesCrMemoSubformExt extends "Sales Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
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

        modify("Variant Code")
        {
            Visible = true;
        }

        //+1.0.0.228
        modify("Unit Cost (LCY)")
        {
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

        addafter(ShortcutDimCode8)
        {


            field("Req. Country"; "Req. Country")
            {
                caption = 'Req. Country';
                ApplicationArea = all;
                Visible = false;//TAL 1.0.0.71
                ToolTip = 'Custom: Req. Country';
            }

            field("Country/Region of Origin Code"; "Country/Region of Origin Code")
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

        modify("Tax Group Code")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Line")
        {
            action(ItemTrackingLines2)
            {
                ApplicationArea = all;
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
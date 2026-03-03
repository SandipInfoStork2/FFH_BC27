
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


            field("Req. Country"; Rec."Req. Country")
            {
                Caption = 'Req. Country';
                ApplicationArea = All;
                Visible = false;//TAL 1.0.0.71
                ToolTip = 'Custom: Req. Country';
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Country/Region of Origin Code field.';
            }

            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Class (Κατηγορία) field.';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Potatoes District Region field.';
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
                ApplicationArea = All;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Executes the Item &Tracking Lines action.';

                trigger OnAction();
                begin
                    Rec.OpenItemTrackingLines;
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

    var
        UnitCostEditable: Boolean;
}
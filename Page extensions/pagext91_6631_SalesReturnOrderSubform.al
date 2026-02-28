/*
TAL0.2 24/12/2018 VC design Shelf No., Description 2, Packaging Group Description 
TAL0.3 2019/05/05 VC design Quantity Base, UOM Base  
TAL0.4 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.5 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50191 SalesReturnOrderSubformExt extends "Sales Return Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        moveafter(Type; ShortcutDimCode5)
        modify("Variant Code")
        {
            Visible = true;
        }

        moveafter("No."; "Variant Code")

        addafter("Variant Code")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = All;
            }


        }

        modify("Description 2")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        moveafter("Unit Price"; "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = All;
            }
        }

        addbefore(Quantity)
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

        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = All;
            }
        }

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
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
                ToolTip = 'Custom: Req. Req. Country';
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
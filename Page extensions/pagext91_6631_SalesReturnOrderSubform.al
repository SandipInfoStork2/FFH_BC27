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
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        moveafter("Unit Price"; "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }
        }

        addbefore(Quantity)
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
        }

        addafter("Reserved Quantity")
        {
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }
        }

        modify("Net Weight")
        {
            Visible = true;
        }

        addafter("Net Weight")
        {
            field("Total Net Weight"; Rec."Total Net Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Net Weight field.';
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

            field("Req. Country"; Rec."Req. Country")
            {
                Caption = 'Req. Country';
                ApplicationArea = All;
                Visible = false;//TAL 1.0.0.71
                ToolTip = 'Custom: Req. Req. Country';
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
/*
18/06/17 TAL0.1 add fields
                "Quantity (Base)"
                "Qty. per Unit of Measure"
                "Unit of Measure (Base)"
                "Shelf No."

2020/06/09 TAL0.2 VC Validate for new prices. items are shipped but sales price is set end of week. request to get the current price
TAL0.3 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.4 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50116 SalesInvoiceSubformExt extends "Sales Invoice Subform"
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

        addafter("Line No.")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an auto-filled number if you have included Sales Unit of Measure on the item card and a quantity in the Qty. per Unit of Measure field.';
            }
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }


        }

        //+1.0.0.228
        modify("Unit Cost (LCY)")
        {
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

        addafter(ShortcutDimCode8)
        {
            field("Shipping Temperature"; Rec."Shipping Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
            }
            field("Shipping Quality Control"; Rec."Shipping Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Quality Control field.';
            }

            //field("Country/Region of Origin Code"; "Country/Region of Origin Code")
            // {
            //     ApplicationArea = all;
            //     Visible = true;
            // }
        }

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
    }

    actions
    {
        // Add changes to page actions here
        modify(GetShipmentLines)
        {
            trigger OnAfterAction()
            var
                rL_SalesLine: Record "Sales Line";
                rL_SalesHeader: Record "Sales Header";
            begin
                //+TAL0.2

                rL_SalesLine.Reset;
                rL_SalesLine.SETRANGE("Document Type", Rec."Document Type");
                rL_SalesLine.SETFILTER("Document No.", Rec."Document No.");
                rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                if rL_SalesLine.FindSet then begin
                    rL_SalesHeader.GET(Rec."Document Type", Rec."Document No.");
                    rL_SalesHeader.TestField("Posting Date");
                    repeat
                        rL_SalesLine.Validate(Quantity);
                        rL_SalesLine.Modify;
                    until rL_SalesLine.Next = 0;
                end;

                //-TAL0.2
                RedistributeTotalsOnAfterValidate();
            end;
        }

        addafter("Related Information")
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
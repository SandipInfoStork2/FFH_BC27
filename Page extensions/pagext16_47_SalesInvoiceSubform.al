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

        addafter("Line No.")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = all;
            }
            field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
            {
                ApplicationArea = all;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
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
            field("Shipping Temperature"; "Shipping Temperature")
            {
                ApplicationArea = all;
            }
            field("Shipping Quality Control"; "Shipping Quality Control")
            {
                ApplicationArea = all;
            }

            //field("Country/Region of Origin Code"; "Country/Region of Origin Code")
            // {
            //     ApplicationArea = all;
            //     Visible = true;
            // }
        }

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

                rL_SalesLine.RESET;
                rL_SalesLine.SETRANGE("Document Type", "Document Type");
                rL_SalesLine.SETFILTER("Document No.", "Document No.");
                rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                if rL_SalesLine.FINDSET then begin
                    rL_SalesHeader.GET("Document Type", "Document No.");
                    rL_SalesHeader.TESTFIELD("Posting Date");
                    repeat
                        rL_SalesLine.VALIDATE(Quantity);
                        rL_SalesLine.MODIFY;
                    until rL_SalesLine.NEXT = 0;
                end;

                //-TAL0.2
                RedistributeTotalsOnAfterValidate();
            end;
        }

        addafter("Related Information")
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
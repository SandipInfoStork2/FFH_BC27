pageextension 50265 PostedSalesInvoiceLinesExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Line Discount %")
        {
            field("Req.Country"; Rec."Req. Country")
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

        addafter("Document No.")
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 50265 PostedSalesInvoiceLinesExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Line Discount %")
        {
            field("Req.Country"; Rec."Req. Country")
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

        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting date for the entry.';
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
pageextension 50267 PostedReturnReceiptLinesExt extends "Posted Return Receipt Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Quantity Invoiced")
        {
            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Req. Country field.';
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
    }

    var
        myInt: Integer;
}
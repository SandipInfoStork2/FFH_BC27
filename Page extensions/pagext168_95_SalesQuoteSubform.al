pageextension 50268 SalesQuoteSubformExt extends "Sales Quote Subform"
{
    layout
    {
        // Add changes to page layout here
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
    }

    var
        myInt: Integer;
}
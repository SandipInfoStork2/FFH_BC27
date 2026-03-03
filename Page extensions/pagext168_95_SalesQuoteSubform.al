pageextension 50268 SalesQuoteSubformExt extends "Sales Quote Subform"
{
    layout
    {
        // Add changes to page layout here
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
    }

    var
        myInt: Integer;
}
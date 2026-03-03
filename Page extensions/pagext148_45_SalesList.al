pageextension 50248 SalesListExt extends "Sales List"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; Rec."Week No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Week No. field.';
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
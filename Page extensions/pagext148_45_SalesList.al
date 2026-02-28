pageextension 50248 SalesListExt extends "Sales List"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; "Week No.")
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
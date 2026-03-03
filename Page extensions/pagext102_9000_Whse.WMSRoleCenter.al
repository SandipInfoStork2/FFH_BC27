pageextension 50202 WhseWMSRoleCenterExt extends "Whse. WMS Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        //item list added in bc versino

        // Add changes to page actions here
        addafter("Item &Tracing")
        {
            action("page Bin Creation Worksheet")
            {
                ApplicationArea = All;
                RunObject = page "Bin Creation Worksheet";
                ToolTip = 'Executes the page Bin Creation Worksheet action.';
            }
        }
    }

    var
        myInt: Integer;
}
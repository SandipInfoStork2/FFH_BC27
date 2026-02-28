pageextension 50221 ProductionOrderListExt extends "Production Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Search Description")
        {
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
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
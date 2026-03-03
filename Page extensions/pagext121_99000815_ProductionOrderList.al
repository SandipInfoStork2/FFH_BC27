pageextension 50221 ProductionOrderListExt extends "Production Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Search Description")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor No. field.';
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
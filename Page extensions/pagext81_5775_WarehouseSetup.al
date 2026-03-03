pageextension 50181 WarehouseSetupExt extends "Warehouse Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Registered Whse. Movement Nos.")
        {
            field("Delivery Nos."; Rec."Delivery Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Nos. field.';
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
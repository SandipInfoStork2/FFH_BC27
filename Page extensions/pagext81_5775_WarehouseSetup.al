pageextension 50181 WarehouseSetupExt extends "Warehouse Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Registered Whse. Movement Nos.")
        {
            field("Delivery Nos."; "Delivery Nos.")
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
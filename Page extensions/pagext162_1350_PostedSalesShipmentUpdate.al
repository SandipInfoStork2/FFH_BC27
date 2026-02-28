pageextension 50262 PostedSalesShipmentUpdateExt extends "Posted Sales Shipment - Update"
{
    layout
    {
        // Add changes to page layout here
        addafter("Package Tracking No.")
        {
            field("Shipping Temperature"; "Shipping Temperature")
            {
                ApplicationArea = all;
            }
            field("Shipping Quality Control"; "Shipping Quality Control")
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
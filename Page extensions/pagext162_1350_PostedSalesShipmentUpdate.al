pageextension 50262 PostedSalesShipmentUpdateExt extends "Posted Sales Shipment - Update"
{
    layout
    {
        // Add changes to page layout here
        addafter("Package Tracking No.")
        {
            field("Shipping Temperature"; Rec."Shipping Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
            }
            field("Shipping Quality Control"; Rec."Shipping Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Quality Control field.';
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
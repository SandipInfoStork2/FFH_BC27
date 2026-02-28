tableextension 50177 ReturnShipmentHeaderExt extends "Return Shipment Header"
{
    fields
    {
        // Add changes to table fields here
    }

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
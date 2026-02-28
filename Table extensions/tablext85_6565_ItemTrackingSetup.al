tableextension 50185 ItemTrackingSetupExt extends "Item Tracking Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "TAL-Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}
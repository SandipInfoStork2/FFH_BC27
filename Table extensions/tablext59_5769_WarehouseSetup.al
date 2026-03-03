tableextension 50159 WarehouseSetupExt extends "Warehouse Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Delivery Nos."; Code[20])
        {
            AccessByPermission = tabledata "Warehouse Receipt Header" = R;
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }


    }

    var
        myInt: Integer;
}

table 50000 ExpirationCalculation
{

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Lot No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Lot No.", "Expiration Date")
        {
        }
    }

    fieldgroups
    {
    }
}



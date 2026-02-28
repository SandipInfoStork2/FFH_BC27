table 50010 "Lidl Order Archive"
{
    DataClassification = ToBeClassified;

    fields
    {
        //Sales Order No.	
        //Order Date	
        //Order Time //order date + current time	
        //Customer No.	
        //Version No.	
        //Shelf No.	
        //Item No.
        //Qty Ordered	
        //UOM (Base)


        field(1; "Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(10; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;

        }

        field(20; "Order Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            CAption = 'Import DateTime';
        }

        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(40; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(41; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;

        }


        field(60; "Qty Ordered"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;

        }
        field(70; "UOM (Base)"; Code[10])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Sales Order No.", "Order Date", "Order Time", "Item No.", "Version No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
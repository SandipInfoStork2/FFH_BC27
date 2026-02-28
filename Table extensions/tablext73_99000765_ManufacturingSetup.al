tableextension 50173 ManufacturingSetupExt extends "Manufacturing Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Zero Date Component Formula"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Mandatory Output Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //+1.0.0.229
        field(50002; "Mandatory Packing Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //-1.0.0.229

        //+1.0.0.237
        field(50003; "skip MatrOrCapConsumpExists"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //-1.0.0.237

    }

    var
        myInt: Integer;
}
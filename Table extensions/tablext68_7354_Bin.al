tableextension 50168 BinExt extends Bin
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Hide MN"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "No. Activity Lines"; Integer)
        {
            CalcFormula = Count("Warehouse Activity Line" WHERE("Bin Code" = FIELD(Code), "Location Code" = FIELD("Location Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
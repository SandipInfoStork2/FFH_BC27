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
            CalcFormula = count("Warehouse Activity Line" where("Bin Code" = field(Code), "Location Code" = field("Location Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
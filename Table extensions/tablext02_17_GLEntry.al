//TAL0.1 ANP 2021/12/03 Create Cost Center Field to lookup on Dimension Set

tableextension 50102 GLEntryExt extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cost Center"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"), "Dimension Code" = CONST('COST CENTRE')));

        }
        field(50001; "Register No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
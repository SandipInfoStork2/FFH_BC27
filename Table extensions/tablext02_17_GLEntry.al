//TAL0.1 ANP 2021/12/03 Create Cost Center Field to lookup on Dimension Set

tableextension 50102 GLEntryExt extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cost Center"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('COST CENTRE')));

        }
        field(50001; "Register No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
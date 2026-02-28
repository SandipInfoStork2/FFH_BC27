/*
TAL0.1 2018/11/09 VC add field EDI Code

*/
tableextension 50131 ReasonCodeExt extends "Reason Code"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "EDI Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Mark Invoice Entries"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
tableextension 50116 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cheque Page Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Cheque Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name where(Type = filter(Payments));
        }
        field(50007; "E-Trade Export Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
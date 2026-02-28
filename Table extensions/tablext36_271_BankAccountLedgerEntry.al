tableextension 50136 BankAccountLedgerEntryExt extends "Bank Account Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Calculation; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
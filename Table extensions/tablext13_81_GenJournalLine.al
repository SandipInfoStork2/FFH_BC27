
/*
TAL0.1 2019/12/17 Add payee name and validate vendor name
TAL0.2 2020/04/14 VC add logic for payments
                      Exported to Payment File editable = true
*/
tableextension 50113 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Payee Name (GL Cheque)"; Text[50])
        {
            Caption = 'Payee Name';
            DataClassification = ToBeClassified;
        }
        field(50014; "Transaction ID"; Text[35])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}
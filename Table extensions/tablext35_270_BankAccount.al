tableextension 50135 BankAccountExt extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50016; "Bank Transfer Company Code"; Code[10])
        {
            Caption = 'Bank Transfer Company Code';
            DataClassification = ToBeClassified;
        }
        field(50017; "Bank Deposit Slip Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
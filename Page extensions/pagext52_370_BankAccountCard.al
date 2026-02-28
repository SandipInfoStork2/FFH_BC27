pageextension 50152 BankAccountCardExt extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here

        addafter("Positive Pay Export Code")
        {
            field("Bank Transfer Company Code"; "Bank Transfer Company Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
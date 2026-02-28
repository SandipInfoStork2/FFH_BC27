pageextension 50124 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payroll Transaction Import")
        {
            group(Other)
            {
                Caption = 'Other';
                field("Cheque Page Line No"; "Cheque Page Line No")
                {
                    ApplicationArea = all;
                }
                field("Cheque Template Name"; "Cheque Template Name")
                {
                    ApplicationArea = all;
                }
                field("E-Trade Export Path"; "E-Trade Export Path")
                {
                    ApplicationArea = all;
                }
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
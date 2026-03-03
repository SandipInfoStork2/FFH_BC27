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
                field("Cheque Page Line No"; Rec."Cheque Page Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cheque Page Line No field.';
                }
                field("Cheque Template Name"; Rec."Cheque Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cheque Template Name field.';
                }
                field("E-Trade Export Path"; Rec."E-Trade Export Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Trade Export Path field.';
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
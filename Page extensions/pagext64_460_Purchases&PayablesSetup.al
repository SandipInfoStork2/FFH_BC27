pageextension 50164 PurchasesPayablesSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here

        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Grower Nos."; Rec."Grower Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Nos. field.';
            }
            field("Grower Receipt Nos."; Rec."Grower Receipt Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Receipt Nos. field.';
            }
        }

        addafter("Document Default Line Type")
        {
            field("Mand. P.O. Expected Recpt Date"; Rec."Mand. P.O. Expected Recpt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mandatory P.O. Expected Receipt Date field.';
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
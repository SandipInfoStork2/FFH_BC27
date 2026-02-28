pageextension 50164 PurchasesPayablesSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here

        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Grower Nos."; "Grower Nos.")
            {
                ApplicationArea = All;
            }
            field("Grower Receipt Nos."; "Grower Receipt Nos.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Document Default Line Type")
        {
            field("Mand. P.O. Expected Recpt Date"; "Mand. P.O. Expected Recpt Date")
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
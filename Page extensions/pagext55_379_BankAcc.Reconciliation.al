pageextension 50155 BankAccReconciliationExt extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Card")
        {
            action("Ledger E&ntries")
            {
                ApplicationArea = All;
                Caption = 'Ledger E&ntries';
                Image = BankAccountLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Bank Account Ledger Entries";
                RunPageLink = "Bank Account No." = FIELD("Bank Account No.");
                RunPageView = SORTING("Bank Account No.")
                                  ORDER(Descending);
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }
        }
    }

    var
        myInt: Integer;
}
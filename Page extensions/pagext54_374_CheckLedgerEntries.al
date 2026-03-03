/*
TAL0.1 2017/12/07 VC design Ext. Doc. No

*/
pageextension 50154 CheckLedgerEntriesExt extends "Check Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Check No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
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
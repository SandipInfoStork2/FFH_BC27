/*
TAL0.1 2017/12/07 VC design Ext. Doc. No

*/
pageextension 50153 BankAccountLedgerEntriesExt extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
            }
        }

        addafter("Entry No.")
        {
            field("Statement No."; Rec."Statement No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bank account statement that the ledger entry has been applied to, if the Statement Status is Bank Account Ledger Applied.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Navigate")
        {
            action("Open Rec. Entry")
            {
                ApplicationArea = All;
                Image = Open;
                ToolTip = 'Executes the Open Rec. Entry action.';

                trigger OnAction();
                var
                    cu_BALEUpdate: Codeunit "Bank Account Ledger Entry-Edit";
                begin
                    //+TAL0.2
                    Clear(cu_BALEUpdate);
                    cu_BALEUpdate.OpenBankAccountLedgerEntry(Rec);
                    //-TAL0.2
                end;
            }
            action("Close Rec. Entry")
            {
                ApplicationArea = All;
                Image = Close;
                ToolTip = 'Executes the Close Rec. Entry action.';

                trigger OnAction();
                var
                    cu_BALEUpdate: Codeunit "Bank Account Ledger Entry-Edit";
                begin
                    //+TAL0.2
                    Clear(cu_BALEUpdate);
                    cu_BALEUpdate.CloseBankAccountLedgerEntry(Rec);


                    //-TAL0.2
                end;
            }
        }
    }

    var
        myInt: Integer;
}
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
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Entry No.")
        {
            field("Statement No."; "Statement No.")
            {
                ApplicationArea = All;
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

                trigger OnAction();
                var
                    cu_BALEUpdate: Codeunit "Bank Account Ledger Entry-Edit";
                begin
                    //+TAL0.2
                    CLEAR(cu_BALEUpdate);
                    cu_BALEUpdate.OpenBankAccountLedgerEntry(Rec);
                    //-TAL0.2
                end;
            }
            action("Close Rec. Entry")
            {
                ApplicationArea = All;
                Image = Close;

                trigger OnAction();
                var
                    cu_BALEUpdate: Codeunit "Bank Account Ledger Entry-Edit";
                begin
                    //+TAL0.2
                    CLEAR(cu_BALEUpdate);
                    cu_BALEUpdate.CloseBankAccountLedgerEntry(Rec);


                    //-TAL0.2
                end;
            }
        }
    }

    var
        myInt: Integer;
}
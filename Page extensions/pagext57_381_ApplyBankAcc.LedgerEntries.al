/*
TAL0.1 2018/06/06 VC add field Calculation for calculation

*/
pageextension 50157 ApplyBankAccLedgerEntriesExt extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("External Document No.")
        {
            Visible = true;
        }

        addafter(LineApplied)
        {
            field(Calculation; Calculation)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addfirst(processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction();
                var
                    rL_BankLedgerEntry: Record "Bank Account Ledger Entry";
                    vL_TotalAmount: Decimal;
                begin

                    CurrPage.SETSELECTIONFILTER(rL_BankLedgerEntry);
                    vL_TotalAmount := 0;
                    if FINDFIRST then begin
                        repeat
                            vL_TotalAmount += rL_BankLedgerEntry.Amount;
                        until rL_BankLedgerEntry.NEXT = 0;
                    end;
                    MESSAGE('Total Amount: ' + FORMAT(vL_TotalAmount));
                end;
            }
        }
    }

    var
        myInt: Integer;
}
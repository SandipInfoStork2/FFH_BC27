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
            field(Calculation; Rec.Calculation)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Calculation field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addfirst(Processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Image = Calculate;
                ToolTip = 'Executes the Calculate action.';

                trigger OnAction();
                var
                    rL_BankLedgerEntry: Record "Bank Account Ledger Entry";
                    vL_TotalAmount: Decimal;
                begin

                    CurrPage.SetSelectionFilter(rL_BankLedgerEntry);
                    vL_TotalAmount := 0;
                    if Rec.FINDFIRST then begin
                        repeat
                            vL_TotalAmount += rL_BankLedgerEntry.Amount;
                        until rL_BankLedgerEntry.Next = 0;
                    end;
                    Message('Total Amount: ' + Format(vL_TotalAmount));
                end;
            }
        }
    }

    var
        myInt: Integer;
}
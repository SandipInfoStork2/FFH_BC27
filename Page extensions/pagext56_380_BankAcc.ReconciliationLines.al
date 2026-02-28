/*
TAL0.1 2018/05/31 VC Add 4 actions
TAL0.2 2018/06/12 VC add action force remove
TAL0.3 2019/03/19 VC Add Modify 
*/
pageextension 50156 BankAccReconciliationLinesExt extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Value Date")
        {
            field(Found; Found)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ApplyEntries)
        {
            action("Check No Filter")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.RESET;
                    rL_BankAccLE.SETFILTER("Bank Account No.", "Bank Account No.");
                    rL_BankAccLE.SETFILTER("Document No.", '*' + "Check No." + '*');
                    PAGE.RUN(PAGE::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action("Addtonal Info Filter")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.RESET;
                    rL_BankAccLE.SETFILTER("Bank Account No.", "Bank Account No.");
                    rL_BankAccLE.SETFILTER("External Document No.", '*' + "Additional Transaction Info" + '*');
                    PAGE.RUN(PAGE::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action("Amount Filter")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.RESET;
                    rL_BankAccLE.SETFILTER("Bank Account No.", "Bank Account No.");
                    rL_BankAccLE.SETRANGE(Amount, "Statement Amount");
                    PAGE.RUN(PAGE::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action(Statistics)
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    rL_BankAccRL: Record "Bank Acc. Reconciliation Line";
                    rL_BankAccRL2: Record "Bank Acc. Reconciliation Line";
                begin

                    //+TAL0.1
                    rL_BankAccRL.RESET;
                    rL_BankAccRL.SETFILTER("Statement No.", "Statement No.");

                    rL_BankAccRL2.RESET;
                    rL_BankAccRL2.SETFILTER("Statement No.", "Statement No.");
                    rL_BankAccRL2.SETRANGE("Applied Entries", 0);

                    MESSAGE('Total Lines:' + FORMAT(rL_BankAccRL.COUNT) + ' Remaining:' + FORMAT(rL_BankAccRL2.COUNT));
                end;
            }
            action("Force Remove")
            {
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction();
                begin
                    //+TAL0.2
                    if ("Applied Amount" <> 0) and ("Applied Entries" > 0) then begin
                        if CONFIRM(Text50000, false, Description, FORMAT("Transaction Date")) then begin
                            "Applied Amount" := 0;
                            "Applied Entries" := 0;
                            Difference := 0;
                            MODIFY; //TAL0.3
                        end;
                    end;
                    //-TAL0.2
                end;
            }
        }
    }


    var
        Text50000: Label 'Are you sure to Remove the applied Details for %1 Transaction Date %2. Force Remove?';
}
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
            field(Found; Rec.Found)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Found field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        //addafter(ApplyEntries)
        addafter(ShowStatementLineDetails)
        {
            action("Check No Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Check No Filter action.';

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.Reset;
                    rL_BankAccLE.SETFILTER("Bank Account No.", Rec."Bank Account No.");
                    rL_BankAccLE.SETFILTER("Document No.", '*' + Rec."Check No." + '*');
                    Page.Run(Page::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action("Addtonal Info Filter")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Executes the Addtonal Info Filter action.';

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.Reset;
                    rL_BankAccLE.SETFILTER("Bank Account No.", Rec."Bank Account No.");
                    rL_BankAccLE.SETFILTER("External Document No.", '*' + Rec."Additional Transaction Info" + '*');
                    Page.Run(Page::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action("Amount Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Amount Filter action.';

                trigger OnAction();
                var
                    rL_BankAccLE: Record "Bank Account Ledger Entry";
                begin
                    //+TAL0.1
                    rL_BankAccLE.Reset;
                    rL_BankAccLE.SETFILTER("Bank Account No.", Rec."Bank Account No.");
                    rL_BankAccLE.SETRANGE(Amount, Rec."Statement Amount");
                    Page.Run(Page::"Bank Account Ledger Entries", rL_BankAccLE);
                    //-TAL0.1
                end;
            }
            action(Statistics)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Statistics action.';

                trigger OnAction();
                var
                    rL_BankAccRL: Record "Bank Acc. Reconciliation Line";
                    rL_BankAccRL2: Record "Bank Acc. Reconciliation Line";
                begin

                    //+TAL0.1
                    rL_BankAccRL.Reset;
                    rL_BankAccRL.SETFILTER("Statement No.", Rec."Statement No.");

                    rL_BankAccRL2.Reset;
                    rL_BankAccRL2.SETFILTER("Statement No.", Rec."Statement No.");
                    rL_BankAccRL2.SetRange("Applied Entries", 0);

                    Message('Total Lines:' + Format(rL_BankAccRL.Count) + ' Remaining:' + Format(rL_BankAccRL2.Count));
                end;
            }
            action("Force Remove")
            {
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Executes the Force Remove action.';

                trigger OnAction();
                begin
                    //+TAL0.2
                    if (Rec."Applied Amount" <> 0) and (Rec."Applied Entries" > 0) then begin
                        if CONFIRM(Text50000, false, Rec.Description, FORMAT(Rec."Transaction Date")) then begin
                            Rec."Applied Amount" := 0;
                            Rec."Applied Entries" := 0;
                            Rec.Difference := 0;
                            Rec.MODIFY; //TAL0.3
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

/*

TAL0.1 2018/10/20 VC add fields "Total Transaction Amount",
                                "Total Applied Amount",
                                "Total Difference"                    
TAL0.2 2019/05/16 VC rename captio

*/
pageextension 50158 BankAccReconciliationListExt extends "Bank Acc. Reconciliation List"
{
    layout
    {
        // Add changes to page layout here

        addafter(StatementEndingBalance)
        {
            field("Total Transaction Amount"; Rec."Total Transaction Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the sum of values in the Statement Amount field on all the lines in the Bank Acc. Reconciliation and Payment Reconciliation Journal windows.';
            }
            field("Total Applied Amount"; Rec."Total Applied Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Applied Amount field.';
            }
            field("Total Difference"; Rec."Total Difference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the sum of values in the Difference field on all lines in the Bank Acc. Reconciliation window that belong to the bank account reconciliation.';
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
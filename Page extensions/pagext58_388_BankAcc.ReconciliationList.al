
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
            field("Total Transaction Amount"; "Total Transaction Amount")
            {
                ApplicationArea = All;
            }
            field("Total Applied Amount"; "Total Applied Amount")
            {
                ApplicationArea = All;
            }
            field("Total Difference"; "Total Difference")
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
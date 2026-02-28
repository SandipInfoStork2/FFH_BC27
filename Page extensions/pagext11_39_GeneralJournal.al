
/*
TAL0.1 2018/08/30 VC add action 
      Import Transactions Payroll
      Import Dimensions Payroll
*/
pageextension 50111 GeneralJournalExt extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Amount (LCY)")
        {
            Editable = false;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ImportPayrollTransactions)
        {
            action("Import Transactions Payroll")
            {
                ApplicationArea = all;
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction();
                begin

                    XMLPORT.RUN(50000); //TAL0.1 will also refresh the journal
                end;
            }
            action("Import Dimensions Payroll")
            {
                ApplicationArea = all;
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = XMLport "Import Dimens Trans Payroll";
            }
        }
    }

    var
        myInt: Integer;
}
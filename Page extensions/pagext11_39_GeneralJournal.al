
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
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ToolTip = 'Executes the Import Transactions Payroll action.';

                trigger OnAction();
                begin

                    Xmlport.Run(50000); //TAL0.1 will also refresh the journal
                end;
            }
            action("Import Dimensions Payroll")
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = xmlport "Import Dimens Trans Payroll";
                ToolTip = 'Executes the Import Dimensions Payroll action.';
            }
        }
    }

    var
        myInt: Integer;
}
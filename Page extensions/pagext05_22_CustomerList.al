/*
TAL0.1 VC 2017/11/02 review customer statement link

*/

pageextension 50105 CustomerListExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here

        addafter("Payments (LCY)")
        {
            field("Mandatory CY Fields"; "Mandatory CY Fields")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Statement)
        {
            action("Statement (Report)")
            {
                Caption = 'Statement (Report)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction();
                var
                    rL_ReportSelections: Record "Report Selections";
                    rL_Customer: Record Customer;
                begin
                    //+TAL0.1
                    //Codeunit Customer Layout - Statement
                    /*
                    CLEAR(rpt_Statement);
                    rL_Customer.RESET;
                    rL_Customer.SETFILTER("No.", "No.");
                    if rL_Customer.FINDSET then;
                    rpt_Statement.SETTABLEVIEW(rL_Customer);
                    rpt_Statement.RUNMODAL;
                    */

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SETRANGE(Usage, rL_ReportSelections.Usage::"C.Statement");
                    rL_ReportSelections.FINDSET;
                    rL_ReportSelections.TESTFIELD("Report ID");

                    rL_Customer.GET("No.");
                    rL_Customer.SETRECFILTER;
                    REPORT.RUNMODAL(rL_ReportSelections."Report ID", true, false, rL_Customer);
                    //-TAL0.1
                end;
            }
        }

        addafter("Sent Emails")
        {
            action(Statement3)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Statement';
                Image = "Report";
                //RunObject = Report "Customer Statement";
                ToolTip = 'Custom: View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    rL_ReportSelections: Record "Report Selections";
                    rL_Customer: Record Customer;
                begin
                    //Codeunit Customer Layout - Statement
                    //+NOD0.4
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SETRANGE(Usage, rL_ReportSelections.Usage::"C.Statement");
                    rL_ReportSelections.FINDSET;
                    rL_ReportSelections.TESTFIELD("Report ID");

                    rL_Customer.GET("No.");
                    rL_Customer.SETRECFILTER;
                    REPORT.RUNMODAL(rL_ReportSelections."Report ID", true, false, rL_Customer);
                    //-NOD0.4
                end;
            }
        }
    }

    var
        myInt: Integer;
}
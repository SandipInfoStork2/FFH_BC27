/*
TAL0.1 2018/05/24 VC existing customisation with zero 0:0 format create conflict with new request
                     dynamic show posted sales Shipment and posted sales Invoice qty and shiped qty(Qty Base) with decimals or not  
                     add field Report Decimal Places
TAL0.2 2020/03/06 VC add field Ship-to Warehouse Code,Ship-to Warehouse Name 
TAL0.3 2020/03/06 VC add field Chain of Custody Tracking

*/

pageextension 50104 CustomerCardExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("Report Decimal Places"; Rec."Report Decimal Places")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Report Decimal Places field.';
            }
            field("Show Total Qty"; Rec."Show Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Show Total Qty field.';
            }

            field("Mandatory CY Fields"; Rec."Mandatory CY Fields")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mandatory CY Fields field.';
            }
        }

        addafter("VAT Registration No.")
        {
            field("T.I.C. Registration No."; Rec."T.I.C. Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the T.I.C. Registration No. field.';
            }
        }

        addafter(GLN)
        {
            field("GLN Delivery"; Rec."GLN Delivery")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GLN Delivery field.';
            }
            field("Show GlobalGab COC No."; Rec."Show GlobalGab COC No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Show GlobalGab COC No. field.';
            }
        }

        addafter("Customized Calendar")
        {
            field("Ship-to Warehouse Code"; Rec."Ship-to Warehouse Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Warehouse Code field.';
            }
            field("Ship-to Warehouse Name"; Rec."Ship-to Warehouse Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Warehouse Name field.';
            }
        }

        addafter("E-Mail")
        {
            field("E-Mail CC"; Rec."E-Mail CC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email CC field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Report Statement")
        {
            action("Report Statement2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Statement (Report)';
                Image = "Report";
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';

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

                    rL_ReportSelections.Reset;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"C.Statement");
                    rL_ReportSelections.FindSet;
                    rL_ReportSelections.TestField("Report ID");

                    rL_Customer.GET(Rec."No.");
                    rL_Customer.SetRecFilter;
                    Report.RunModal(rL_ReportSelections."Report ID", true, false, rL_Customer);
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
                    rL_ReportSelections.Reset;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"C.Statement");
                    rL_ReportSelections.FindSet;
                    rL_ReportSelections.TestField("Report ID");

                    rL_Customer.GET(Rec."No.");
                    rL_Customer.SetRecFilter;
                    Report.RunModal(rL_ReportSelections."Report ID", true, false, rL_Customer);
                    //-NOD0.4
                end;
            }
        }

    }

    var
        myInt: Integer;
}
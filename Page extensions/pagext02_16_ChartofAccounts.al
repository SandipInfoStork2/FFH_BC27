pageextension 50102 ChartofAccountsExt extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("Co&mments")
        {
            Promoted = true;
        }

        addlast(reporting)
        {
            action("Financial Analysis Report")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Financial Analysis Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Custom: Financial Analysis Report';

            }
            action("Balance Sheet")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Balance Sheet 1";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Custom: Balance Sheet';

            }
            action("Income Statement")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Income Statement 1";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Custom: Income Statement';

            }
            action("Trial Balance - Full Detail")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Trial Balance - Full Detail";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Custom: Trial Balance - Full Detail';

            }
            action("Trial Balance with O/B")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Trial Balance with O/B";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Custom: Trial Balance with O/B';

            }
            /*
            action("Detail Trial Balance Custom")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = report "Detail Trial Balances";
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                Tooltip = 'Custom: Detail Trial Balance';

            }*/

        }


    }

    var
        myInt: Integer;
}
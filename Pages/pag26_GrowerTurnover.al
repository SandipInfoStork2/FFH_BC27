page 50026 "Grower Turnover"
{
    // version NAVW110.0

    CaptionML = ELL = 'Grower Turnover',
                ENU = 'Grower Turnover';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = Grower;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate();
                    begin
                        if PeriodType = PeriodType::Period then
                            PeriodPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Year then
                            YearPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Quarter then
                            QuarterPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Month then
                            MonthPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Week then
                            WeekPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Day then
                            DayPeriodTypeOnValidate;
                    end;
                }
                field(AmountType; AmountType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate();
                    begin
                        if AmountType = AmountType::"Balance at Date" then
                            BalanceatDateAmountTypeOnValid;
                        if AmountType = AmountType::"Net Change" then
                            NetChangeAmountTypeOnValidate;
                    end;
                }
                field("Customer No. Filter"; vG_CustNoFilter)
                {
                    DrillDown = false;
                    DrillDownPageID = "Customer List";
                    Lookup = true;
                    LookupPageID = "Customer List";
                    TableRelation = Customer;

                    trigger OnValidate();
                    begin
                        UpdateSubForm;
                    end;
                }
            }
            part(GrowerTurnoverLines; "Grower Turnover Lines")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        UpdateSubForm;
    end;

    trigger OnOpenPage();
    begin

        PeriodType := PeriodType::Month;
    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        AmountType: Option "Net Change","Balance at Date";
        vG_CustNoFilter: Code[20];

    local procedure UpdateSubForm();
    begin
        CurrPage.GrowerTurnoverLines.PAGE.Set(Rec, PeriodType, AmountType, vG_CustNoFilter);
    end;

    local procedure DayPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure WeekPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure MonthPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure QuarterPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure YearPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure PeriodPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure NetChangeAmountTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure BalanceatDateAmountTypeOnPush();
    begin
        UpdateSubForm;
    end;

    local procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    local procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    local procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    local procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    local procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    local procedure PeriodPeriodTypeOnValidate();
    begin
        PeriodPeriodTypeOnPush;
    end;

    local procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    local procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;
}


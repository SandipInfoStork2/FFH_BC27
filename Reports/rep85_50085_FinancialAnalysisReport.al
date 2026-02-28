report 50085 "Financial Analysis Report"
{
    // //
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep85_50085_FinancialAnalysisReport.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Financial Analysis Report';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Budget Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY(), 0, 4))
            {
            }
            column(LongText; LongText)
            {
            }

            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(USERID; FORMAT(USERID()))
            {
            }
            column(ReportName; ReportName)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(G_L_Account__TABLENAME__________GLFilter; "G/L Account".TABLENAME + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(RoundFactorText; RoundFactorText)
            {
            }
            column(ColumnHeader_1_; ColumnHeader[1])
            {
            }
            column(ColumnHeader_2_; ColumnHeader[2])
            {
            }
            column(ColumnSubHeader_6_; ColumnSubHeader[6])
            {
            }
            column(ColumnSubHeader_5_; ColumnSubHeader[5])
            {
            }
            column(ColumnSubHeader_4_; ColumnSubHeader[4])
            {
            }
            column(ColumnSubHeader_3_; ColumnSubHeader[3])
            {
            }
            column(ColumnSubHeader_2_; ColumnSubHeader[2])
            {
            }
            column(ColumnSubHeader_1_; ColumnSubHeader[1])
            {
            }
            column(NoOfColumns; NoOfColumns)
            {
            }
            column(GroupNo; GroupNo)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(AccountName_Control1500031Caption; AccountName_Control1500031CaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            dataitem(BlankLineCounter; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(BlankLineCounter_BlankLineCounter_Number; Number)
                {
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, "G/L Account"."No. of Blank Lines");
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                MaxIteration = 1;
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(AccountName; AccountName)
                {
                }
                column(bShowTLine; bShowTLine)
                {
                }
                column(G_L_Account___Account_Type_; "G/L Account"."Account Type")
                {
                }
                column(G_L_Account___No___Control1500030; "G/L Account"."No.")
                {
                }
                column(AccountName_Control1500031; AccountName)
                {
                }
                column(ColumnAmountText_1_; ColumnAmountText[1])
                {
                }
                column(ColumnAmountText_2_; ColumnAmountText[2])
                {
                }
                column(ColumnAmountText_3_; ColumnAmountText[3])
                {
                }
                column(ColumnAmountText_6_; ColumnAmountText[6])
                {
                }
                column(ColumnAmountText_5_; ColumnAmountText[5])
                {
                }
                column(ColumnAmountText_4_; ColumnAmountText[4])
                {
                }
                column(G_L_Account___No___Control1500038; "G/L Account"."No.")
                {
                }
                column(AccountName_Control1500039; AccountName)
                {
                }
                column(ColumnAmountText_6__Control1500040; ColumnAmountText[6])
                {
                }
                column(ColumnAmountText_5__Control1500041; ColumnAmountText[5])
                {
                }
                column(ColumnAmountText_4__Control1500042; ColumnAmountText[4])
                {
                }
                column(ColumnAmountText_3__Control1500043; ColumnAmountText[3])
                {
                }
                column(ColumnAmountText_2__Control1500044; ColumnAmountText[2])
                {
                }
                column(ColumnAmountText_1__Control1500045; ColumnAmountText[1])
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    bShowTLine := ShowTotalLine("G/L Account");
                    IF (("G/L Account"."Account Type" = "G/L Account"."Account Type"::Heading) OR
                        ("G/L Account"."Account Type" = "G/L Account"."Account Type"::"Begin-Total") OR
                        ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting) OR
                        bShowTLine) AND "G/L Account"."New Page"
                    THEN
                        GroupNo := GroupNo + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF IndentAccountName THEN
                    AccountName := PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name
                ELSE
                    AccountName := "G/L Account".Name;

                CalculateAmount("G/L Account");

                RoundAmount;
                IF (ColumnAmount[1] = 0) AND (ColumnAmount[2] = 0) AND (ColumnAmount[3] = 0) AND
                   (ColumnAmount[4] = 0) AND (ColumnAmount[5] = 0) AND (ColumnAmount[6] = 0) AND
                   ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting)
                THEN
                    CurrReport.SKIP
                    ;
                ConvertAmountToText;
            end;

            trigger OnPreDataItem()
            begin
                IF ReportType = ReportType::" " THEN
                    ERROR(Text1450007);
                PopulateFormatString;
                PopulateColumnHeader;
                FilterGLAccount("G/L Account");

                GroupNo := 1;
                GLSetup.GET;
                IF AddCurr THEN
                    HeaderText := STRSUBSTNO(Text1450013, GLSetup."Additional Reporting Currency")
                ELSE BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    HeaderText := STRSUBSTNO(Text1450013, GLSetup."LCY Code");
                END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReportType; ReportType)
                    {
                        Caption = 'Report Type';
                        ApplicationArea = all;
                    }
                    field(IndentAccountName; IndentAccountName)
                    {
                        Caption = 'Indent Account Name';
                        ApplicationArea = all;
                    }
                    field(AmountsInWhole; RoundingFactor)
                    {
                        Caption = 'Amounts in whole';
                        ApplicationArea = all;
                    }
                    field(AddCurr; AddCurr)
                    {
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GETFILTERS;
        RoundFactorText := ReportMngmt.RoundDescription(RoundingFactor);
        CurrentPeriodStart := "G/L Account".GETRANGEMIN("Date Filter");
        CurrentPeriodEnd := "G/L Account".GETRANGEMAX("Date Filter");

        LastYearCurrentPeriodStart := CALCDATE('-1Y', NORMALDATE(CurrentPeriodStart) + 1) - 1;
        IF CurrentPeriodStart <> NORMALDATE(CurrentPeriodStart) THEN
            LastYearCurrentPeriodStart := CLOSINGDATE(LastYearCurrentPeriodStart);

        LastYearCurrentPeriodEnd := CALCDATE('-1Y', NORMALDATE(CurrentPeriodEnd) + 1) - 1;
        IF CurrentPeriodEnd <> NORMALDATE(CurrentPeriodEnd) THEN
            LastYearCurrentPeriodEnd := CLOSINGDATE(LastYearCurrentPeriodEnd);

        AccPeriod.RESET;
        AccPeriod.SETRANGE("New Fiscal Year", TRUE, TRUE);
        AccPeriod.SETFILTER("Starting Date", '..%1', CurrentPeriodEnd);
        AccPeriod.FINDLAST;
        CurrentYearStart := AccPeriod."Starting Date";

        AccPeriod.SETFILTER("Starting Date", '..%1', LastYearCurrentPeriodEnd);
        AccPeriod.FINDLAST;
        LastYearStart := AccPeriod."Starting Date";
    end;

    var
        AccPeriod: Record "Accounting Period";
        ReportMngmt: Codeunit "Report Management";
        GLFilter: Text[250];
        LongText: Text[250];
        RoundFactorText: Text[50];
        FormatString: array[6] of Text[50];
        CurrentPeriodEnd: Date;
        CurrentYearStart: Date;
        LastYearStart: Date;
        RoundingFactor: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions;
        ColumnHeader: array[2] of Text[30];
        ColumnSubHeader: array[6] of Text[30];
        ColumnAmount: array[6] of Decimal;
        ColumnAmountText: array[6] of Text[30];
        DoNotRoundAmount: array[6] of Boolean;
        ReportName: Text[250];
        AddCurr: Boolean;
        ReportType: Option " ",,"Net Change/Budget","Net Change (This Year/Last Year)","Balance (This Year/Last Year)";
        CurrentPeriodStart: Date;
        LastYearCurrentPeriodStart: Date;
        LastYearCurrentPeriodEnd: Date;
        HeaderText: Text[250];
        NoOfColumns: Integer;
        IndentAccountName: Boolean;
        AccountName: Text[250];
        Text1450000: Label 'Current Year';
        Text1450001: Label 'Last Year';
        Text1450002: Label 'Balance';
        Text1450003: Label 'Budget';
        Text1450004: Label 'Variance %';
        Text1450005: Label 'Statement of Financial Position';
        Text1450006: Label 'Period: %1..%2 versus %3..%4';
        Text1450007: Label 'You must choose a Report Type.';
        Text1450008: Label 'Statement of Financial Performance (Profit and Loss)';
        Text1450009: Label 'Current Period';
        Text1450010: Label 'Year To Date';
        Text1450011: Label 'Net Change';
        Text1450012: Label 'Net Change - Period';
        Text1450013: Label 'All amounts are in %1.';
        Text1450015: Label '$ Difference';
        Text1450016: Label '% Difference';
        Text1450017: Label 'Period: %1..%2 versus %3..%4 and %5..%6 versus %7..%8';
        GroupNo: Integer;
        bShowTLine: Boolean;
        GLSetup: Record "General Ledger Setup";
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        AccountName_Control1500031CaptionLbl: Label 'Name';
        No_CaptionLbl: Label 'No.';

    local procedure PopulateColumnHeader()
    var
        i: Integer;
    begin
        FOR i := 1 TO 6 DO
            ColumnSubHeader[i] := '';
        FOR i := 1 TO 2 DO
            ColumnHeader[i] := '';
        LongText := '';

        CASE ReportType OF
            1:
                BEGIN
                    NoOfColumns := 6;
                    ReportName := Text1450005;
                    ColumnHeader[1] := Text1450000;
                    ColumnHeader[2] := Text1450001;
                    ColumnSubHeader[1] := Text1450002;
                    ColumnSubHeader[2] := Text1450003;
                    ColumnSubHeader[3] := Text1450004;
                    ColumnSubHeader[4] := Text1450002;
                    ColumnSubHeader[5] := Text1450003;
                    ColumnSubHeader[6] := Text1450004;
                    LongText :=
                      STRSUBSTNO(
                        Text1450006,
                        CurrentYearStart, CurrentPeriodEnd, LastYearStart, LastYearCurrentPeriodEnd);
                END;
            ReportType::"Net Change/Budget":
                BEGIN
                    NoOfColumns := 6;
                    ReportName := Text1450008;
                    ColumnHeader[1] := Text1450009;
                    ColumnHeader[2] := Text1450010;
                    ColumnSubHeader[1] := Text1450011;
                    ColumnSubHeader[2] := Text1450003;
                    ColumnSubHeader[3] := Text1450004;
                    ColumnSubHeader[4] := Text1450011;
                    ColumnSubHeader[5] := Text1450003;
                    ColumnSubHeader[6] := Text1450004;
                    LongText :=
                      STRSUBSTNO(
                        Text1450006,
                        CurrentPeriodStart, CurrentPeriodEnd, CurrentYearStart, CurrentPeriodEnd);
                END;
            ReportType::"Net Change (This Year/Last Year)":
                BEGIN
                    NoOfColumns := 6;
                    ReportName := Text1450008;
                    ColumnHeader[1] := Text1450012;
                    ColumnHeader[2] := Text1450010;
                    ColumnSubHeader[1] := Text1450000;
                    ColumnSubHeader[2] := Text1450001;
                    ColumnSubHeader[3] := Text1450004;
                    ColumnSubHeader[4] := Text1450000;
                    ColumnSubHeader[5] := Text1450001;
                    ColumnSubHeader[6] := Text1450004;
                    LongText :=
                      STRSUBSTNO(
                        Text1450017,
                        CurrentPeriodStart, CurrentPeriodEnd,
                        LastYearCurrentPeriodStart, LastYearCurrentPeriodEnd,
                        CurrentYearStart, CurrentPeriodEnd,
                        LastYearStart, LastYearCurrentPeriodEnd);
                END;
            ReportType::"Balance (This Year/Last Year)":
                BEGIN
                    NoOfColumns := 4;
                    ReportName := Text1450005;
                    ColumnSubHeader[1] := Text1450000;
                    ColumnSubHeader[2] := Text1450001;
                    ColumnSubHeader[3] := Text1450015;
                    ColumnSubHeader[4] := Text1450016;
                    LongText :=
                      STRSUBSTNO(
                        Text1450006,
                        CurrentYearStart, CurrentPeriodEnd, LastYearStart, LastYearCurrentPeriodEnd);
                END;
        END;
    end;

    local procedure ConvertAmountToText()
    var
        i: Integer;
    begin
        FOR i := 1 TO 6 DO BEGIN
            IF i <= NoOfColumns THEN BEGIN
                IF FormatString[i] <> '' THEN
                    ColumnAmountText[i] := FORMAT(ColumnAmount[i], 0, FormatString[i])
                ELSE
                    ColumnAmountText[i] := FORMAT(ColumnAmount[i]);
            END ELSE
                ColumnAmountText[i] := '';
        END;
    end;

    local procedure PopulateFormatString()
    var
        i: Integer;
    begin
        FOR i := 1 TO 6 DO BEGIN
            IF RoundingFactor = RoundingFactor::" " THEN
                FormatString[i] := '<Precision,2:><Standard Format,0>'
            ELSE
                FormatString[i] := '<Precision,1:><Standard Format,0>';
        END;
        CASE ReportType OF
            1, ReportType::"Net Change/Budget", ReportType::"Net Change (This Year/Last Year)":
                BEGIN
                    FormatString[3] := '';
                    FormatString[6] := '';
                    DoNotRoundAmount[3] := TRUE;
                    DoNotRoundAmount[6] := TRUE;
                END;
            ReportType::"Balance (This Year/Last Year)":
                BEGIN
                    FormatString[4] := '';
                    DoNotRoundAmount[4] := TRUE;
                END;
        END;
    end;

    local procedure RoundAmount()
    var
        i: Integer;
    begin
        FOR i := 1 TO 6 DO BEGIN
            IF NOT DoNotRoundAmount[i] THEN
                ColumnAmount[i] := ReportMngmt.RoundAmount(ColumnAmount[i], RoundingFactor);
        END;
    end;

    local procedure FilterGLAccount(var GLAccount: Record "G/L Account")
    begin
        CASE ReportType OF
            1, ReportType::"Balance (This Year/Last Year)":
                GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Balance Sheet");
            ReportType::"Net Change/Budget", ReportType::"Net Change (This Year/Last Year)":
                GLAccount.SETRANGE("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
        END;
    end;

    local procedure CalculateAmount(var GLAccount: Record "G/L Account")
    var
        i: Integer;
    begin
        FOR i := 1 TO 6 DO
            ColumnAmount[i] := 0;
        CASE ReportType OF
            1:
                BEGIN
                    GLAccount.SETRANGE("Date Filter", CurrentYearStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Balance at Date", "Budget at Date");
                    ColumnAmount[1] := GLAccount."Balance at Date";
                    ColumnAmount[2] := GLAccount."Budget at Date";
                    IF ColumnAmount[2] <> 0 THEN
                        ColumnAmount[3] := ROUND((ColumnAmount[2] - ColumnAmount[1]) / ColumnAmount[2] * 100, 1);

                    GLAccount.SETRANGE("Date Filter", LastYearStart, LastYearCurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Balance at Date", "Budget at Date");
                    ColumnAmount[4] := GLAccount."Balance at Date";
                    ColumnAmount[5] := GLAccount."Budget at Date";
                    IF ColumnAmount[5] <> 0 THEN
                        ColumnAmount[6] := ROUND((ColumnAmount[5] - ColumnAmount[4]) / ColumnAmount[5] * 100, 1);
                END;
            ReportType::"Net Change/Budget":
                BEGIN
                    GLAccount.SETRANGE("Date Filter", CurrentPeriodStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Budgeted Amount");
                    ColumnAmount[1] := GLAccount."Net Change";
                    ColumnAmount[2] := GLAccount."Budgeted Amount";
                    IF ColumnAmount[2] <> 0 THEN
                        ColumnAmount[3] := ROUND((ColumnAmount[1] - ColumnAmount[2]) / ColumnAmount[2] * 100, 1);

                    GLAccount.SETRANGE("Date Filter", CurrentYearStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Budgeted Amount");
                    ColumnAmount[4] := GLAccount."Net Change";
                    ColumnAmount[5] := GLAccount."Budgeted Amount";
                    IF ColumnAmount[5] <> 0 THEN
                        ColumnAmount[6] := ROUND((ColumnAmount[4] - ColumnAmount[5]) / ColumnAmount[5] * 100, 1);
                END;
            ReportType::"Net Change (This Year/Last Year)":
                BEGIN
                    GLAccount.SETRANGE("Date Filter", CurrentPeriodStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Additional-Currency Net Change");
                    IF AddCurr THEN
                        ColumnAmount[1] := GLAccount."Additional-Currency Net Change"
                    ELSE
                        ColumnAmount[1] := GLAccount."Net Change";
                    GLAccount.SETRANGE("Date Filter", LastYearCurrentPeriodStart, LastYearCurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Additional-Currency Net Change");
                    IF AddCurr THEN
                        ColumnAmount[2] := GLAccount."Additional-Currency Net Change"
                    ELSE
                        ColumnAmount[2] := GLAccount."Net Change";
                    IF ColumnAmount[2] <> 0 THEN
                        ColumnAmount[3] := ROUND((ColumnAmount[1] - ColumnAmount[2]) / ColumnAmount[2] * 100, 1);

                    GLAccount.SETRANGE("Date Filter", CurrentYearStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Additional-Currency Net Change");
                    IF AddCurr THEN
                        ColumnAmount[4] := GLAccount."Additional-Currency Net Change"
                    ELSE
                        ColumnAmount[4] := GLAccount."Net Change";
                    GLAccount.SETRANGE("Date Filter", LastYearStart, LastYearCurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Net Change", "Additional-Currency Net Change");
                    IF AddCurr THEN
                        ColumnAmount[5] := GLAccount."Additional-Currency Net Change"
                    ELSE
                        ColumnAmount[5] := GLAccount."Net Change";
                    IF ColumnAmount[5] <> 0 THEN
                        ColumnAmount[6] := ROUND((ColumnAmount[4] - ColumnAmount[5]) / ColumnAmount[5] * 100, 1);
                END;
            ReportType::"Balance (This Year/Last Year)":
                BEGIN
                    GLAccount.SETRANGE("Date Filter", CurrentYearStart, CurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Balance at Date", "Add.-Currency Balance at Date");
                    IF AddCurr THEN
                        ColumnAmount[1] := GLAccount."Add.-Currency Balance at Date"
                    ELSE
                        ColumnAmount[1] := GLAccount."Balance at Date";

                    GLAccount.SETRANGE("Date Filter", LastYearStart, LastYearCurrentPeriodEnd);
                    GLAccount.CALCFIELDS("Balance at Date", "Add.-Currency Balance at Date");
                    IF AddCurr THEN
                        ColumnAmount[2] := GLAccount."Add.-Currency Balance at Date"
                    ELSE
                        ColumnAmount[2] := GLAccount."Balance at Date";
                    ColumnAmount[3] := ColumnAmount[1] - ColumnAmount[2];
                    IF ColumnAmount[2] <> 0 THEN
                        ColumnAmount[4] := ROUND(((ColumnAmount[1] - ColumnAmount[2]) / ColumnAmount[2]) * 100, 1);
                END;
        END;
    end;

    local procedure ShowTotalLine(var GLAccount: Record "G/L Account"): Boolean
    begin
        IF ((GLAccount."Account Type" = GLAccount."Account Type"::"End-Total") OR
            (GLAccount."Account Type" = GLAccount."Account Type"::Total))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;
}


report 50081 "Trial Balance with O/B"
{
    // 
    // //NOD0.1 2011/06/20 Calculation of Opening Balance on the Report
    // //Based on Report 6: Trial Balance
    // NOD0.2 2014/03/27 vasilis copy 2013 version and upgrade
    // NOD0.3 Add LCY code on header
    // NOD0.4 2015/07/07 vasilis review export to excel
    // NOD0.5 2015/07/16 vasilis Design 6 ACY columns
    // NOD0.6 2015/09/24 vasilis remove 6 ACY columns and add option print ACY
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep81_50081_TrialBalancewithOB.rdlc';

    Caption = 'Trial Balance with O/B';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(LCYCode; GeneralLedgerSetup."LCY Code")
            {
            }

            column(COMPANYNAME; CompanyName)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(OBBalanceCaption; OBBalanceCaptionLbl)
            {
            }
            column(OBDrCaption; OBDrCaptionLbl)
            {
            }
            column(OBCrCaption; OBCrCaptionLbl)
            {
            }
            column(ColumnCaption_1; ColumnCaption[1])
            {
            }
            column(ColumnCaption_2; ColumnCaption[2])
            {
            }
            column(ColumnCaption_3; ColumnCaption[3])
            {
            }
            column(ColumnCaption_4; ColumnCaption[4])
            {
            }
            column(ColumnCaption_5; ColumnCaption[5])
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change")
                {
                }
                column(DebitAmount; "G/L Account"."Debit Amount")
                {
                }
                column(CreditAmount; "G/L Account"."Credit Amount")
                {
                }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date")
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                column(G_L_Account___OBalanceDr; vG_OBDebit)
                {
                }
                column(G_L_Account___OBalanceCr; vG_OBCredit)
                {
                }
                column(G_L_Account___OBalanceDrACY; vG_OBDebitACY)
                {
                }
                column(G_L_Account___OBalanceCrACY; vG_OBCreditACY)
                {
                }
                column(DebitAmountACY; "G/L Account"."Add.-Currency Debit Amount")
                {
                }
                column(CreditAmountACY; "G/L Account"."Add.-Currency Credit Amount")
                {
                }
                column(G_L_Account___Balance_at_DateACY_; "G/L Account"."Add.-Currency Balance at Date")
                {
                }
                column(G_L_Account___Balance_at_DateACY__Control24; -"G/L Account"."Add.-Currency Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(Column_1; Column[1])
                {
                }
                column(Column_2; Column[2])
                {
                }
                column(Column_3; Column[3])
                {
                }
                column(Column_4; Column[4])
                {
                }
                column(Column_5; Column[5])
                {
                }
                column(Column_6; Column[6])
                {
                }
                dataitem(BlankLineRepeater; "Integer")
                {
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break;

                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //+NOD 0.1 Initialize Variables
                vG_OBDebit := 0;
                vG_OBCredit := 0;

                //+NOD0.5
                vG_OBDebitACY := 0;
                vG_OBCreditACY := 0;
                //-NOD0.5


                //PG 19/08/11 Add new variable for G/L account, copy filters, and calculate net change
                vG_GLAccount.Reset;
                vG_GLAccount.CopyFilters("G/L Account");
                vG_GLAccount.SetRange(vG_GLAccount."No.", "G/L Account"."No.");
                vG_GLAccount.SetRange("Date Filter", 0D, ClosingDate(vG_StartDate - 1));   //PG Using all filters

                if vG_GLAccount.FindFirst then begin
                    vG_GLAccount.CalcFields(vG_GLAccount."Net Change");

                    if vG_GLAccount."Net Change" > 0 then begin          //PG Check for Debit or Credit O/B
                        vG_OBDebit := Abs(vG_GLAccount."Net Change");
                    end else begin
                        vG_OBCredit := Abs(vG_GLAccount."Net Change");
                    end;

                    //+NOD0.5
                    vG_GLAccount.CalcFields(vG_GLAccount."Additional-Currency Net Change");

                    if vG_GLAccount."Additional-Currency Net Change" > 0 then begin          //PG Check for Debit or Credit O/B
                        vG_OBDebitACY := Abs(vG_GLAccount."Additional-Currency Net Change");
                    end else begin
                        vG_OBCreditACY := Abs(vG_GLAccount."Additional-Currency Net Change");
                    end;

                    //-NOD0.5

                end;
                //-NOD 0.1

                CalcFields("Net Change", "Balance at Date", "Debit Amount", "Credit Amount");

                //+NOD0.5
                CalcFields("Additional-Currency Net Change", "Add.-Currency Balance at Date", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");
                //-NOD0.5

                //+NOD0.3
                if ExcludeOpeningZeroNoMove then begin
                    if ((vG_GLAccount."Net Change" = 0) and ("Debit Amount" = 0) and ("Credit Amount" = 0)) then
                        CurrReport.Skip;
                end;
                //-NOD0.3

                if PrintToExcel then
                    MakeExcelDataBody;

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";



                Column[1] := 0;
                Column[2] := 0;
                Column[3] := 0;
                Column[4] := 0;
                Column[5] := 0;
                Column[6] := 0;

                if not AddCurr then begin

                    Column[1] := vG_OBDebit;
                    Column[2] := vG_OBCredit;
                    Column[3] := "G/L Account"."Debit Amount";
                    Column[4] := "G/L Account"."Credit Amount";
                    Column[5] := "G/L Account"."Balance at Date";
                    Column[6] := -"G/L Account"."Balance at Date";

                end else begin
                    Column[1] := vG_OBDebitACY;
                    Column[2] := vG_OBCreditACY;
                    Column[3] := "G/L Account"."Add.-Currency Debit Amount";
                    Column[4] := "G/L Account"."Add.-Currency Credit Amount";
                    Column[5] := "G/L Account"."Add.-Currency Balance at Date";
                    Column[6] := -"G/L Account"."Add.-Currency Balance at Date";

                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;

                //+NOD0.6
                GLSetup.Get;
                if AddCurr then
                    HeaderText := StrSubstNo(Text1450013, GLSetup."Additional Reporting Currency")
                else begin
                    GLSetup.TestField("LCY Code");
                    HeaderText := StrSubstNo(Text1450013, GLSetup."LCY Code");
                end;
                //-NOD0.6
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Print to Excel field.';
                    }
                    field("Exclude No Movement Accounts"; ExcludeOpeningZeroNoMove)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ExcludeOpeningZeroNoMove field.';
                    }
                    field(AddCurr; AddCurr)
                    {
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Show Amounts in Add. Reporting Currency field.';
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

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
        //NOD0.3
        GeneralLedgerSetup.Get;
        //NOD0.3

        //+NOD0.1
        vG_StartDate := "G/L Account".GetRangeMin("Date Filter");
        vG_EndDate := "G/L Account".GetRangeMax("Date Filter");
        //-NOD0.1


        if not AddCurr then begin

            ColumnCaption[1] := 'Opening Balance';
            ColumnCaption[2] := 'Net Change';
            ColumnCaption[3] := 'Balance';
            ColumnCaption[4] := 'Debit';
            ColumnCaption[5] := 'Credit';

        end else begin
            ColumnCaption[1] := 'Opening Balance (ACY)';
            ColumnCaption[2] := 'Net Change (ACY)';
            ColumnCaption[3] := 'Balance (ACY)';
            ColumnCaption[4] := 'Debit (ACY)';
            ColumnCaption[5] := 'Credit (ACY)';

        end;

        if PrintToExcel then
            MakeExcelInfo;
    end;

    var
        Text000: Label 'Period: %1';
        ExcelBuf: Record "Excel Buffer" temporary;
        GLFilter: Text;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: Label 'Trial Balance with O/B';
        Text002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        Trial_BalanceCaptionLbl: Label 'Trial Balance (with Opening Balance)';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Net_ChangeCaptionLbl: Label 'Net Change';
        BalanceCaptionLbl: Label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name';
        G_L_Account___Net_Change_CaptionLbl: Label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: Label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: Label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: Label 'Credit';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        vG_OBDebit: Decimal;
        vG_OBCredit: Decimal;
        vG_StartDate: Date;
        vG_EndDate: Date;
        vG_GLAccount: Record "G/L Account";
        OBBalanceCaptionLbl: Label 'Opening Balance';
        OBDrCaptionLbl: Label 'Debit';
        OBCrCaptionLbl: Label 'Credit';
        ExcludeOpeningZeroNoMove: Boolean;
        GeneralLedgerSetup: Record "General Ledger Setup";
        vG_OBDebitACY: Decimal;
        vG_OBCreditACY: Decimal;
        AddCurr: Boolean;
        Column: array[6] of Decimal;
        ColumnCaption: array[5] of Text;
        HeaderText: Text[250];
        GLSetup: Record "General Ledger Setup";
        Text1450013: Label 'All amounts are in %1.';

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text005), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyName, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text007), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Format(Text001), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text006), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Report::"Trial Balance", false, false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text008), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text009), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Today, false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text010), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GetFilter("No."), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text011), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GetFilter("Date Filter"), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn("G/L Account".FieldCaption("No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("G/L Account".FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

        if not AddCurr then begin
            //PG 19/08/11 + Add opening balance columns on excel export
            ExcelBuf.AddColumn((ColumnCaption[1] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn((ColumnCaption[1] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            //PG 19/08/11 -

            ExcelBuf.AddColumn(Format(ColumnCaption[2] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[2] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[3] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[3] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

        end else begin
            //+NOD0.5
            ExcelBuf.AddColumn((ColumnCaption[1] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn((ColumnCaption[1] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[2] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[2] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[3] + ' - ' + ColumnCaption[4]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Format(ColumnCaption[3] + ' - ' + ColumnCaption[5]), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            //-NOD0.5
        end;
    end;

    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        BlankFiller := PadStr(' ', MaxStrLen(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
          ExcelBuf."Cell Type"::Text);
        if "G/L Account".Indentation = 0 then
            ExcelBuf.AddColumn(
              "G/L Account".Name, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
              ExcelBuf."Cell Type"::Text)
        else
            ExcelBuf.AddColumn(
              CopyStr(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);


        if not AddCurr then begin
            //+NOD0.4
            if vG_OBDebit = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(vG_OBDebit, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if vG_OBCredit = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(vG_OBCredit, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Debit Amount" = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Debit Amount", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Credit Amount" = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Credit Amount", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Balance at Date" <= 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if -"G/L Account"."Balance at Date" <= 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(-"G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;
            //-NOD0.4

        end else begin
            //+NOD0.5
            if vG_OBDebitACY = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(vG_OBDebitACY, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if vG_OBCreditACY = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(vG_OBCreditACY, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Add.-Currency Debit Amount" = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Add.-Currency Debit Amount", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Add.-Currency Credit Amount" = 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Add.-Currency Credit Amount", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if "G/L Account"."Add.-Currency Balance at Date" <= 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn("G/L Account"."Add.-Currency Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;

            if -"G/L Account"."Add.-Currency Balance at Date" <= 0 then begin
                ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end else begin
                ExcelBuf.AddColumn(-"G/L Account"."Add.-Currency Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
            end;
            //-NOD0.5
        end;

        //+NOD0.4
        /*
        //PG 19/08/11 + Add opening balance columns on excel export
        CASE TRUE OF
        
            (vG_OBDebit - vG_OBCredit)  =0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          (vG_OBDebit - vG_OBCredit) > 0:
            BEGIN
              ExcelBuf.AddColumn(
                vG_OBDebit,FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          (vG_OBDebit - vG_OBCredit) < 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                vG_OBCredit,FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        //PG 19/08/11 -
        */

        //+NOD0.4
        /*
        CASE TRUE OF
          "G/L Account"."Net Change" = 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" > 0:
            BEGIN
              ExcelBuf.AddColumn(
                "G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" < 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        */

        //+NOD0.4
        /*
        CASE TRUE OF
          "G/L Account"."Balance at Date" = 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Balance at Date" > 0:
            BEGIN
              ExcelBuf.AddColumn(
                "G/L Account"."Balance at Date",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Balance at Date" < 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Balance at Date",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        */

    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text002, Text001, CompanyName, UserId);
        ExcelBuf.CreateNewBook(Text002);
        ExcelBuf.WriteSheet(Text001, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        Error('');
    end;
}


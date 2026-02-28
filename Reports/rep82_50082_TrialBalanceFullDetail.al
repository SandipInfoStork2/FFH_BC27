report 50082 "Trial Balance - Full Detail"
{
    // nodma :: 2014-11-25 :: New report for Trial balance including customer, vendors, FA and bank accounts
    // 
    // NOD0.1 2015/07/22 vasilis
    // For report 50025 - Trial Balance(CVB) to change the columns Period Movement only to show not the net effect, but the total Debits and Credits Amount.
    //                    add debit and credit amount in the zero movement logic
    // NOD0.2 2015/08/05 Paris Corrected Opening Balance Date to be Date Filter Start Date - 1
    // NOD0.3 2016/02/25 vasilis review calculation date from NOD0.2
    //                   review export to excel
    //                   CreateFigures G/L Account if total account or end total show debit and credits
    //TAL 0.1 VK 20/10/2019
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep82_50082_TrialBalanceFullDetail.rdlc';

    Caption = 'Trial Balance - Full Detail';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }

            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TABLECAPTION + ': ' + GLFilter)
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
            column(G_L_Account___No__Caption; FIELDCAPTION("No."))
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
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change")
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
                column(G_L_Account___Account_Type_; FORMAT("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                column(OpeningDC1; OpeningDC[1])
                {
                }
                column(OpeningDC2; OpeningDC[2])
                {
                }
                column(PeriodMoveDC1; PeriodMoveDC[1])
                {
                }
                column(PeriodMoveDC2; PeriodMoveDC[2])
                {
                }
                column(ClosingDC1; ClosingDC[1])
                {
                }
                column(ClosingDC2; ClosingDC[2])
                {
                }
                column(NODCategory; NewCategoryInt)
                {
                }
                column(ShowGroups; ShowGroups)
                {
                }
                column(IsParent; IsParent)
                {
                }
                dataitem(BlankLineRepeater; "Integer")
                {
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF BlankLineNo = 0 THEN
                            CurrReport.BREAK;

                        BlankLineNo -= 1;
                    end;
                }
                dataitem("Bank Account"; "Bank Account")
                {
                    column(BankNo; "Bank Account"."No.")
                    {
                    }
                    column(BankName; "Bank Account".Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //nodma
                        //IF CurrentGroup IN [3,4] THEN CurrReport.skip;
                        NewCategoryInt := GetCategoryType("G/L Account"."No.", "Bank Account"."Bank Acc. Posting Group", 2);//nodma
                        IF NewCategoryInt <> 2 THEN CurrReport.SKIP;
                        CreateBankFigures("Bank Account");
                        IF isZeroValues THEN CurrReport.SKIP;
                        ShowGroups += 1;
                    end;
                }
                dataitem(Customer; Customer)
                {
                    column(CustNo; Customer."No.")
                    {
                    }
                    column(CustName; Customer.Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        //nodma
                        //IF CurrentGroup IN [2,4] THEN CurrReport.BREAK;
                        NewCategoryInt := GetCategoryType("G/L Account"."No.", Customer."Customer Posting Group", 3);//nodma
                        IF NewCategoryInt <> 3 THEN CurrReport.SKIP;
                        CreateCustomerFigures(Customer);
                        IF isZeroValues THEN CurrReport.SKIP;
                        ShowGroups += 1;
                    end;
                }
                dataitem(Vendor; Vendor)
                {
                    column(VendNo; Vendor."No.")
                    {
                    }
                    column(VendName; Vendor.Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        //nodma
                        //IF CurrentGroup IN [2,3] THEN CurrReport.BREAK;
                        NewCategoryInt := GetCategoryType("G/L Account"."No.", Vendor."Vendor Posting Group", 4);
                        IF NewCategoryInt <> 4 THEN CurrReport.SKIP;
                        CreateVendorFigures(Vendor);
                        IF isZeroValues THEN CurrReport.SKIP;
                        ShowGroups += 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Net Change", "Balance at Date", "Debit Amount", "Credit Amount"); //NOD0.1

                IF ChangeGroupNo THEN BEGIN
                    PageGroupNo += 1;
                    ChangeGroupNo := FALSE;
                END;

                ChangeGroupNo := "New Page";
                //nodma +
                NewCategoryInt := 0;
                CreateFigures("G/L Account");
                ShowGroups := 0;
                IF IsParentFunc("G/L Account"."No.") THEN
                    IsParent := 1
                ELSE
                    IsParent := 0;

                //nodma-
                IF ExcludeZeroMove THEN BEGIN
                    IF (OpeningDC[1] = 0) AND (OpeningDC[2] = 0) AND (ClosingDC[1] = 0) AND (ClosingDC[2] = 0) AND ("G/L Account"."Net Change" = 0)
                    AND ("G/L Account"."Debit Amount" = 0) AND ("G/L Account"."Credit Amount" = 0) THEN //NOD0.1
                        CurrReport.SKIP;
                END;

                IF PrintToExcel THEN
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := FALSE;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        ApplicationArea = all;
                    }
                    field(ExcludeZeroMove; ExcludeZeroMove)
                    {
                        Caption = 'Exclude Zero Movement Accounts';
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

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GETFILTERS;
        PeriodText := "G/L Account".GETFILTER("Date Filter");
        IF PeriodText = '' THEN
            ERROR('Please Specify Date filter');//nodma
        IF PrintToExcel THEN
            MakeExcelInfo;

        //NODMA
        FromDate := "G/L Account".GETRANGEMIN("G/L Account"."Date Filter");
        ToDate := "G/L Account".GETRANGEMAX("G/L Account"."Date Filter");
        IF (FromDate = 0D) OR (ToDate = 0D) THEN ERROR('Please Specify From and To date');//nodma
    end;

    var
        Text000: Label 'Period: %1';
        ExcelBuf: Record "Excel Buffer" temporary;
        GLFilter: Text;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: Label 'Trial Balance';
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
        Trial_BalanceCaptionLbl: Label 'Trial Balance';
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
        NewCategoryInt: Integer;
        FromDate: Date;
        ToDate: Date;
        OpeningDC: array[2] of Decimal;
        PeriodMoveDC: array[2] of Decimal;
        ClosingDC: array[2] of Decimal;
        ShowGroups: Integer;
        IsParent: Integer;
        ExcludeZeroMove: Boolean;

    [Scope('OnPrem')]
    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text005), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text007), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text001), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text006), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Trial Balance", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text008), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text009), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text010), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("No."), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text011), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("Date Filter"), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn("G/L Account".FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("G/L Account".FIELDCAPTION(Name), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          FORMAT('Opening Balance - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT('Opening Balance - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Net Change") + ' - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Net Change") + ' - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Balance at Date") + ' - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '',
          ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Balance at Date") + ' - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '',
          ExcelBuf."Cell Type"::Text);
    end;

    [Scope('OnPrem')]
    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        BlankFiller := PADSTR(' ', MAXSTRLEN(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
          ExcelBuf."Cell Type"::Text);
        IF "G/L Account".Indentation = 0 THEN
            ExcelBuf.AddColumn(
              "G/L Account".Name, FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
              ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn(
              COPYSTR(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        /*
        CASE TRUE OF
          "G/L Account"."Net Change" = 0:
            BEGIN
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" > 0:
            BEGIN
              ExcelBuf.AddColumn("G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" < 0:
            BEGIN
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(-"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        
        CASE TRUE OF
          "G/L Account"."Balance at Date" = 0:
            BEGIN
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Balance at Date" > 0:
            BEGIN
              ExcelBuf.AddColumn("G/L Account"."Balance at Date",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Balance at Date" < 0:
            BEGIN
              ExcelBuf.AddColumn('',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(-"G/L Account"."Balance at Date",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        */

        IF OpeningDC[1] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(OpeningDC[1], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        IF OpeningDC[2] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(OpeningDC[2], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        IF PeriodMoveDC[1] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(PeriodMoveDC[1], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        IF PeriodMoveDC[2] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(PeriodMoveDC[2], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        IF ClosingDC[1] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(ClosingDC[1], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        IF ClosingDC[2] <> 0 THEN BEGIN
            ExcelBuf.AddColumn(ClosingDC[2], FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

    end;

    [Scope('OnPrem')]
    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', Text002, Text001, COMPANYNAME, USERID);
        ERROR('');
    end;

    [Scope('OnPrem')]
    procedure GetCategoryType(GLAcc: Code[20]; paramCode: Code[20]; pType: Integer): Integer
    var
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        FAPostingGroup: Record "FA Posting Group";
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        //GetCategoryType
        // ,FA,Bank,Customer,Vendor
        // 1. Fixed Assets
        // 2. Bank Accounts
        // 3. Customer
        // 4. Vendor
        CASE pType OF
            1:
                BEGIN
                    // *** Fixed Assets ***
                    FAPostingGroup.RESET;
                    FAPostingGroup.SETRANGE(Code, paramCode);
                    IF FAPostingGroup.FINDFIRST THEN
                        IF (FAPostingGroup."Acquisition Cost Account" = GLAcc) THEN
                            EXIT(0);//Set FA Status NOT ACTIVE set to 1 if active
                END;
            2:
                BEGIN
                    // *** Bank Accounts ***
                    BankAccountPostingGroup.RESET;
                    BankAccountPostingGroup.SETRANGE(Code, paramCode);
                    IF BankAccountPostingGroup.FINDFIRST THEN
                        //IF BankAccountPostingGroup."G/L Bank Account No." = GLAcc THEN
                        IF BankAccountPostingGroup."G/L Account No." = GLAcc THEN//TAL 0.1 VK
                            EXIT(2);//Set Bank Status
                END;
            3:
                BEGIN
                    // *** Customers ***
                    CustomerPostingGroup.RESET;
                    CustomerPostingGroup.SETRANGE(Code, paramCode);
                    IF CustomerPostingGroup.FINDFIRST THEN
                        IF CustomerPostingGroup."Receivables Account" = GLAcc THEN
                            EXIT(3);
                END;
            4:
                BEGIN
                    // *** Vendors ***
                    VendorPostingGroup.RESET;
                    VendorPostingGroup.SETRANGE(Code, paramCode);
                    IF VendorPostingGroup.FINDFIRST THEN
                        IF VendorPostingGroup."Payables Account" = GLAcc THEN
                            EXIT(4);
                END;
        END;

        EXIT(0);
    end;

    [Scope('OnPrem')]
    procedure CreateFigures(pGLacc: Record "G/L Account")
    begin
        //CreateFigures For GL Accounts
        CLEAR(OpeningDC);
        CLEAR(PeriodMoveDC);
        CLEAR(ClosingDC);

        pGLacc.RESET;
        pGLacc.SETFILTER("Date Filter", '..%1', CALCDATE('-1D', FromDate));//NOD0.2
        pGLacc.CALCFIELDS("Net Change", "Debit Amount", "Credit Amount");

        //+NOD0.3
        IF ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Total) OR ("G/L Account"."Account Type" = "G/L Account"."Account Type"::"End-Total") THEN BEGIN
            OpeningDC[1] := pGLacc."Debit Amount";
            OpeningDC[2] := pGLacc."Credit Amount";
        END ELSE BEGIN
            OpeningDC[1] := pGLacc."Net Change";
            OpeningDC[2] := -pGLacc."Net Change";
        END;
        //-NOD0.3


        //+NOD0.3
        pGLacc.RESET;
        pGLacc.SETFILTER("Date Filter", '..%1', ToDate);
        pGLacc.CALCFIELDS("Net Change", "Debit Amount", "Credit Amount");
        IF ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Total) OR ("G/L Account"."Account Type" = "G/L Account"."Account Type"::"End-Total") THEN BEGIN
            ClosingDC[1] := pGLacc."Debit Amount";
            ClosingDC[2] := pGLacc."Credit Amount";
        END ELSE BEGIN
            ClosingDC[1] := pGLacc."Net Change";
            ClosingDC[2] := -pGLacc."Net Change";
        END;
        //-NOD0.3

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pGLacc.RESET;
        pGLacc.SETFILTER("Date Filter", '%1..%2', FromDate, ToDate);
        pGLacc.CALCFIELDS("Debit Amount", "Credit Amount");
        PeriodMoveDC[1] := pGLacc."Debit Amount";
        PeriodMoveDC[2] := pGLacc."Credit Amount";
        //-NOD0.1
    end;

    [Scope('OnPrem')]
    procedure CreateBankFigures(pBank: Record "Bank Account")
    begin
        //CreateBankFigures
        CLEAR(OpeningDC);
        CLEAR(PeriodMoveDC);
        CLEAR(ClosingDC);

        pBank.RESET;
        pBank.SETFILTER("Date Filter", '..%1', CALCDATE('-1D', FromDate));//NOD0.2
        pBank.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := pBank."Net Change (LCY)"; //pBank."Debit Amount (LCY)";
        OpeningDC[2] := -pBank."Net Change (LCY)"; //pBank."Credit Amount (LCY)";

        pBank.RESET;
        pBank.SETFILTER("Date Filter", '..%1', ToDate);
        pBank.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := pBank."Net Change (LCY)"; //pBank."Debit Amount (LCY)"
        ClosingDC[2] := -pBank."Net Change (LCY)"; //pBank."Credit Amount (LCY)"

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pBank.RESET;
        pBank.SETFILTER("Date Filter", '%1..%2', FromDate, ToDate);
        pBank.CALCFIELDS("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pBank."Debit Amount (LCY)";
        PeriodMoveDC[2] := pBank."Credit Amount (LCY)";
        //-NOD0.1
    end;

    [Scope('OnPrem')]
    procedure CreateCustomerFigures(pCust: Record Customer)
    begin
        //CreateCustomerFigures
        CLEAR(OpeningDC);
        CLEAR(PeriodMoveDC);
        CLEAR(ClosingDC);

        pCust.RESET;
        pCust.SETFILTER("Date Filter", '..%1', CALCDATE('-1D', FromDate));//NOD0.2
        pCust.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := pCust."Net Change (LCY)";
        OpeningDC[2] := -pCust."Net Change (LCY)";

        pCust.RESET;
        pCust.SETFILTER("Date Filter", '..%1', ToDate);
        pCust.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := pCust."Net Change (LCY)";
        ClosingDC[2] := -pCust."Net Change (LCY)";

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pCust.RESET;
        pCust.SETFILTER("Date Filter", '%1..%2', FromDate, ToDate);
        pCust.CALCFIELDS("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pCust."Debit Amount (LCY)";
        PeriodMoveDC[2] := pCust."Credit Amount (LCY)";
        //-NOD0.1
    end;

    [Scope('OnPrem')]
    procedure CreateVendorFigures(pVend: Record Vendor)
    begin
        //CreateCustomerFigures
        CLEAR(OpeningDC);
        CLEAR(PeriodMoveDC);
        CLEAR(ClosingDC);

        pVend.RESET;
        pVend.SETFILTER("Date Filter", '..%1', CALCDATE('-1D', FromDate));//NOD0.2
        pVend.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := -pVend."Net Change (LCY)";
        OpeningDC[2] := pVend."Net Change (LCY)";

        pVend.RESET;
        pVend.SETFILTER("Date Filter", '..%1', ToDate);
        pVend.CALCFIELDS("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := -pVend."Net Change (LCY)";
        ClosingDC[2] := pVend."Net Change (LCY)";

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pVend.RESET;
        pVend.SETFILTER("Date Filter", '%1..%2', FromDate, ToDate);
        pVend.CALCFIELDS("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pVend."Debit Amount (LCY)";
        PeriodMoveDC[2] := pVend."Credit Amount (LCY)";
        //-NOD0.1
    end;

    [Scope('OnPrem')]
    procedure isZeroValues(): Boolean
    begin
        IF (OpeningDC[1] = 0) AND (OpeningDC[2] = 0) AND (PeriodMoveDC[1] = 0) AND (PeriodMoveDC[2] = 0) AND (ClosingDC[1] = 0) AND (ClosingDC[2] = 0) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('OnPrem')]
    procedure IsParentFunc(pGLAcc: Code[20]): Boolean
    var
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        Banks: Record "Bank Account";
        Customers: Record Customer;
        Vendors: Record Vendor;
    begin
        // *** Bank Accounts ***
        BankAccountPostingGroup.RESET;
        //BankAccountPostingGroup.SETRANGE("G/L Bank Account No.", pGLAcc);
        BankAccountPostingGroup.SETRANGE("G/L Account No.", pGLAcc);//TAL 0.1 VK
        IF BankAccountPostingGroup.FINDFIRST THEN BEGIN
            Banks.RESET;
            Banks.SETCURRENTKEY("Bank Acc. Posting Group");
            Banks.SETRANGE("Bank Acc. Posting Group", BankAccountPostingGroup.Code);
            IF Banks.FINDSET THEN
                REPEAT
                    Banks.CALCFIELDS(Balance);
                    IF Banks.Balance <> 0 THEN
                        EXIT(TRUE);
                UNTIL Banks.NEXT = 0;
        END;
        // *** Customers ***
        CustomerPostingGroup.RESET;
        CustomerPostingGroup.SETRANGE("Receivables Account", pGLAcc);
        IF CustomerPostingGroup.FINDFIRST THEN BEGIN
            Customers.RESET;
            Customers.SETCURRENTKEY("Customer Posting Group");
            Customers.SETRANGE("Customer Posting Group", CustomerPostingGroup.Code);
            IF Customers.FINDSET THEN
                REPEAT
                    Customers.CALCFIELDS(Balance);
                    IF Customers.Balance <> 0 THEN
                        EXIT(TRUE);
                UNTIL Customers.NEXT = 0;
        END;
        // *** Vendors ***
        VendorPostingGroup.RESET;
        VendorPostingGroup.SETRANGE("Payables Account", pGLAcc);
        IF VendorPostingGroup.FINDFIRST THEN BEGIN
            Vendors.RESET;
            Vendors.SETCURRENTKEY("Vendor Posting Group");
            Vendors.SETRANGE("Vendor Posting Group", VendorPostingGroup.Code);
            IF Vendors.FINDSET THEN
                REPEAT
                    Vendors.CALCFIELDS(Balance);
                    IF Vendors.Balance <> 0 THEN
                        EXIT(TRUE);
                UNTIL Vendors.NEXT = 0;
        END;
        EXIT(FALSE);
    end;
}


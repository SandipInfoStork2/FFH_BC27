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
                        if BlankLineNo = 0 then
                            CurrReport.Break;

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
                        if NewCategoryInt <> 2 then CurrReport.Skip;
                        CreateBankFigures("Bank Account");
                        if isZeroValues then CurrReport.Skip;
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
                        if NewCategoryInt <> 3 then CurrReport.Skip;
                        CreateCustomerFigures(Customer);
                        if isZeroValues then CurrReport.Skip;
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
                        if NewCategoryInt <> 4 then CurrReport.Skip;
                        CreateVendorFigures(Vendor);
                        if isZeroValues then CurrReport.Skip;
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
                CalcFields("Net Change", "Balance at Date", "Debit Amount", "Credit Amount"); //NOD0.1

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";
                //nodma +
                NewCategoryInt := 0;
                CreateFigures("G/L Account");
                ShowGroups := 0;
                if IsParentFunc("G/L Account"."No.") then
                    IsParent := 1
                else
                    IsParent := 0;

                //nodma-
                if ExcludeZeroMove then begin
                    if (OpeningDC[1] = 0) and (OpeningDC[2] = 0) and (ClosingDC[1] = 0) and (ClosingDC[2] = 0) and ("G/L Account"."Net Change" = 0)
                    and ("G/L Account"."Debit Amount" = 0) and ("G/L Account"."Credit Amount" = 0) then //NOD0.1
                        CurrReport.Skip;
                end;

                if PrintToExcel then
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;
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
                    field(ExcludeZeroMove; ExcludeZeroMove)
                    {
                        Caption = 'Exclude Zero Movement Accounts';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Exclude Zero Movement Accounts field.';
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
        if PeriodText = '' then
            Error('Please Specify Date filter');//nodma
        if PrintToExcel then
            MakeExcelInfo;

        //NODMA
        FromDate := "G/L Account".GetRangeMin("G/L Account"."Date Filter");
        ToDate := "G/L Account".GetRangeMax("G/L Account"."Date Filter");
        if (FromDate = 0D) or (ToDate = 0D) then Error('Please Specify From and To date');//nodma
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

        ExcelBuf.AddColumn(
          Format('Opening Balance - ' + Text003), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          Format('Opening Balance - ' + Text004), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text003), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text004), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text003), false, '', true, false, true, '',
          ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text004), false, '', true, false, true, '',
          ExcelBuf."Cell Type"::Text);
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

        if OpeningDC[1] <> 0 then begin
            ExcelBuf.AddColumn(OpeningDC[1], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        if OpeningDC[2] <> 0 then begin
            ExcelBuf.AddColumn(OpeningDC[2], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        if PeriodMoveDC[1] <> 0 then begin
            ExcelBuf.AddColumn(PeriodMoveDC[1], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        if PeriodMoveDC[2] <> 0 then begin
            ExcelBuf.AddColumn(PeriodMoveDC[2], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        if ClosingDC[1] <> 0 then begin
            ExcelBuf.AddColumn(ClosingDC[1], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

        if ClosingDC[2] <> 0 then begin
            ExcelBuf.AddColumn(ClosingDC[2], false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        end else begin
            ExcelBuf.AddColumn('', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."Cell Type"::Text);
        end;

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
        case pType of
            1:
                begin
                    // *** Fixed Assets ***
                    FAPostingGroup.Reset;
                    FAPostingGroup.SetRange(Code, paramCode);
                    if FAPostingGroup.FindFirst then
                        if (FAPostingGroup."Acquisition Cost Account" = GLAcc) then
                            exit(0);//Set FA Status NOT ACTIVE set to 1 if active
                end;
            2:
                begin
                    // *** Bank Accounts ***
                    BankAccountPostingGroup.Reset;
                    BankAccountPostingGroup.SetRange(Code, paramCode);
                    if BankAccountPostingGroup.FindFirst then
                        //IF BankAccountPostingGroup."G/L Bank Account No." = GLAcc THEN
                        if BankAccountPostingGroup."G/L Account No." = GLAcc then//TAL 0.1 VK
                            exit(2);//Set Bank Status
                end;
            3:
                begin
                    // *** Customers ***
                    CustomerPostingGroup.Reset;
                    CustomerPostingGroup.SetRange(Code, paramCode);
                    if CustomerPostingGroup.FindFirst then
                        if CustomerPostingGroup."Receivables Account" = GLAcc then
                            exit(3);
                end;
            4:
                begin
                    // *** Vendors ***
                    VendorPostingGroup.Reset;
                    VendorPostingGroup.SetRange(Code, paramCode);
                    if VendorPostingGroup.FindFirst then
                        if VendorPostingGroup."Payables Account" = GLAcc then
                            exit(4);
                end;
        end;

        exit(0);
    end;


    procedure CreateFigures(pGLacc: Record "G/L Account")
    begin
        //CreateFigures For GL Accounts
        Clear(OpeningDC);
        Clear(PeriodMoveDC);
        Clear(ClosingDC);

        pGLacc.Reset;
        pGLacc.SetFilter("Date Filter", '..%1', CalcDate('-1D', FromDate));//NOD0.2
        pGLacc.CalcFields("Net Change", "Debit Amount", "Credit Amount");

        //+NOD0.3
        if ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Total) or ("G/L Account"."Account Type" = "G/L Account"."Account Type"::"End-Total") then begin
            OpeningDC[1] := pGLacc."Debit Amount";
            OpeningDC[2] := pGLacc."Credit Amount";
        end else begin
            OpeningDC[1] := pGLacc."Net Change";
            OpeningDC[2] := -pGLacc."Net Change";
        end;
        //-NOD0.3


        //+NOD0.3
        pGLacc.Reset;
        pGLacc.SetFilter("Date Filter", '..%1', ToDate);
        pGLacc.CalcFields("Net Change", "Debit Amount", "Credit Amount");
        if ("G/L Account"."Account Type" = "G/L Account"."Account Type"::Total) or ("G/L Account"."Account Type" = "G/L Account"."Account Type"::"End-Total") then begin
            ClosingDC[1] := pGLacc."Debit Amount";
            ClosingDC[2] := pGLacc."Credit Amount";
        end else begin
            ClosingDC[1] := pGLacc."Net Change";
            ClosingDC[2] := -pGLacc."Net Change";
        end;
        //-NOD0.3

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pGLacc.Reset;
        pGLacc.SetFilter("Date Filter", '%1..%2', FromDate, ToDate);
        pGLacc.CalcFields("Debit Amount", "Credit Amount");
        PeriodMoveDC[1] := pGLacc."Debit Amount";
        PeriodMoveDC[2] := pGLacc."Credit Amount";
        //-NOD0.1
    end;


    procedure CreateBankFigures(pBank: Record "Bank Account")
    begin
        //CreateBankFigures
        Clear(OpeningDC);
        Clear(PeriodMoveDC);
        Clear(ClosingDC);

        pBank.Reset;
        pBank.SetFilter("Date Filter", '..%1', CalcDate('-1D', FromDate));//NOD0.2
        pBank.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := pBank."Net Change (LCY)"; //pBank."Debit Amount (LCY)";
        OpeningDC[2] := -pBank."Net Change (LCY)"; //pBank."Credit Amount (LCY)";

        pBank.Reset;
        pBank.SetFilter("Date Filter", '..%1', ToDate);
        pBank.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := pBank."Net Change (LCY)"; //pBank."Debit Amount (LCY)"
        ClosingDC[2] := -pBank."Net Change (LCY)"; //pBank."Credit Amount (LCY)"

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pBank.Reset;
        pBank.SetFilter("Date Filter", '%1..%2', FromDate, ToDate);
        pBank.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pBank."Debit Amount (LCY)";
        PeriodMoveDC[2] := pBank."Credit Amount (LCY)";
        //-NOD0.1
    end;


    procedure CreateCustomerFigures(pCust: Record Customer)
    begin
        //CreateCustomerFigures
        Clear(OpeningDC);
        Clear(PeriodMoveDC);
        Clear(ClosingDC);

        pCust.Reset;
        pCust.SetFilter("Date Filter", '..%1', CalcDate('-1D', FromDate));//NOD0.2
        pCust.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := pCust."Net Change (LCY)";
        OpeningDC[2] := -pCust."Net Change (LCY)";

        pCust.Reset;
        pCust.SetFilter("Date Filter", '..%1', ToDate);
        pCust.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := pCust."Net Change (LCY)";
        ClosingDC[2] := -pCust."Net Change (LCY)";

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pCust.Reset;
        pCust.SetFilter("Date Filter", '%1..%2', FromDate, ToDate);
        pCust.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pCust."Debit Amount (LCY)";
        PeriodMoveDC[2] := pCust."Credit Amount (LCY)";
        //-NOD0.1
    end;


    procedure CreateVendorFigures(pVend: Record Vendor)
    begin
        //CreateCustomerFigures
        Clear(OpeningDC);
        Clear(PeriodMoveDC);
        Clear(ClosingDC);

        pVend.Reset;
        pVend.SetFilter("Date Filter", '..%1', CalcDate('-1D', FromDate));//NOD0.2
        pVend.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        OpeningDC[1] := -pVend."Net Change (LCY)";
        OpeningDC[2] := pVend."Net Change (LCY)";

        pVend.Reset;
        pVend.SetFilter("Date Filter", '..%1', ToDate);
        pVend.CalcFields("Net Change (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        ClosingDC[1] := -pVend."Net Change (LCY)";
        ClosingDC[2] := pVend."Net Change (LCY)";

        //+NOD0.1
        //PeriodMoveDC[1] := ClosingDC[1] - OpeningDC[1];
        //PeriodMoveDC[2] := ClosingDC[2] - OpeningDC[2];
        pVend.Reset;
        pVend.SetFilter("Date Filter", '%1..%2', FromDate, ToDate);
        pVend.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        PeriodMoveDC[1] := pVend."Debit Amount (LCY)";
        PeriodMoveDC[2] := pVend."Credit Amount (LCY)";
        //-NOD0.1
    end;


    procedure isZeroValues(): Boolean
    begin
        if (OpeningDC[1] = 0) and (OpeningDC[2] = 0) and (PeriodMoveDC[1] = 0) and (PeriodMoveDC[2] = 0) and (ClosingDC[1] = 0) and (ClosingDC[2] = 0) then
            exit(true)
        else
            exit(false);
    end;


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
        BankAccountPostingGroup.Reset;
        //BankAccountPostingGroup.SETRANGE("G/L Bank Account No.", pGLAcc);
        BankAccountPostingGroup.SetRange("G/L Account No.", pGLAcc);//TAL 0.1 VK
        if BankAccountPostingGroup.FindFirst then begin
            Banks.Reset;
            Banks.SetCurrentKey("Bank Acc. Posting Group");
            Banks.SetRange("Bank Acc. Posting Group", BankAccountPostingGroup.Code);
            if Banks.FindSet then
                repeat
                    Banks.CalcFields(Balance);
                    if Banks.Balance <> 0 then
                        exit(true);
                until Banks.Next = 0;
        end;
        // *** Customers ***
        CustomerPostingGroup.Reset;
        CustomerPostingGroup.SetRange("Receivables Account", pGLAcc);
        if CustomerPostingGroup.FindFirst then begin
            Customers.Reset;
            Customers.SetCurrentKey("Customer Posting Group");
            Customers.SetRange("Customer Posting Group", CustomerPostingGroup.Code);
            if Customers.FindSet then
                repeat
                    Customers.CalcFields(Balance);
                    if Customers.Balance <> 0 then
                        exit(true);
                until Customers.Next = 0;
        end;
        // *** Vendors ***
        VendorPostingGroup.Reset;
        VendorPostingGroup.SetRange("Payables Account", pGLAcc);
        if VendorPostingGroup.FindFirst then begin
            Vendors.Reset;
            Vendors.SetCurrentKey("Vendor Posting Group");
            Vendors.SetRange("Vendor Posting Group", VendorPostingGroup.Code);
            if Vendors.FindSet then
                repeat
                    Vendors.CalcFields(Balance);
                    if Vendors.Balance <> 0 then
                        exit(true);
                until Vendors.Next = 0;
        end;
        exit(false);
    end;
}


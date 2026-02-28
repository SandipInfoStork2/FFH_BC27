report 50016 "Vendor Statement"
{
    // version NAVW17.00,TAL.3.0
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep16_50016_VendorStatement.rdlc';
    Caption = 'Vendor Statement';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Print Statements", "Date Filter", "Currency Filter";
            column(No_Vend; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo3.Picture)
                {
                }
                column(VendAddr1; VendAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(VendAddr2; VendAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(VendAddr3; VendAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(VendAddr4; VendAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(VendAddr5; VendAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                {
                }
                column(VendAddr6; VendAddr[6])
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
                {
                }
                column(BankName_CompanyInfo; CompanyInfo."Bank Name")
                {
                }
                column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
                {
                }
                column(No1_Vend; Vendor."No.")
                {
                }
                column(TodayFormatted; FORMAT(TODAY, 0, 4))
                {
                }
                column(StartDate; FORMAT(StartDate))
                {
                }
                column(EndDate; FORMAT(EndDate))
                {
                }
                column(LastStatmntNo_Vend; FORMAT(Vendor."Last Statement No."))
                {
                    //DecimalPlaces = 0 : 0;
                }
                column(VendAddr7; VendAddr[7])
                {
                }
                column(VendAddr8; VendAddr[8])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(StatementCaption; StatementCaptionLbl)
                {
                }
                column(PhoneNo_CompanyInfoCaption; PhoneNo_CompanyInfoCaptionLbl)
                {
                }
                column(VATRegNo_CompanyInfoCaption; VATRegNo_CompanyInfoCaptionLbl)
                {
                }
                column(GiroNo_CompanyInfoCaption; GiroNo_CompanyInfoCaptionLbl)
                {
                }
                column(BankName_CompanyInfoCaption; BankName_CompanyInfoCaptionLbl)
                {
                }
                column(BankAccNo_CompanyInfoCaption; BankAccNo_CompanyInfoCaptionLbl)
                {
                }
                column(No1_VendCaption; No1_VendCaptionLbl)
                {
                }
                column(StartDateCaption; StartDateCaptionLbl)
                {
                }
                column(EndDateCaption; EndDateCaptionLbl)
                {
                }
                column(LastStatmntNo_VendCaption; LastStatmntNo_VendCaptionLbl)
                {
                }
                column(PostDate_DtldVendLedgEntriesCaption; PostDate_DtldVendLedgEntriesCaptionLbl)
                {
                }
                column(DocNo_DtldVendLedgEntriesCaption; DtldVendLedgEntries.FIELDCAPTION("Document No."))
                {
                }
                column(Desc_VendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION(Description))
                {
                }
                column(DueDate_VendLedgEntry2Caption; DueDate_VendLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtVendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION("Remaining Amount"))
                {
                }
                column(VendBalanceCaption; VendBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_VendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION("Original Amount"))
                {
                }
                column(CompanyInfoHomepageCaption; CompanyInfoHomepageCaptionLbl)
                {
                }
                column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                {
                }
                column(DocDateCaption; DocDateCaptionLbl)
                {
                }
                column(CompanyInfoSwift; CompanyInfo."SWIFT Code")
                {
                }
                column(CompanyInfoIBAN; CompanyInfo.IBAN)
                {
                }
                column(CompanyInfoFax; CompanyInfo."Fax No.")
                {
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    PrintOnlyIfDetail = true;
                    dataitem(VendLedgEntryHdr; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(Currency2Code_VendLedgEntryHdr; STRSUBSTNO(Text001, Currency2.Code))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(VendBalance_VendLedgEntryHdr; VendBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldVendLedgEntryType; FORMAT(DtldVendLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        dataitem(DtldVendLedgEntries; "Detailed Vendor Ledg. Entry")
                        {
                            DataItemTableView = SORTING("Vendor No.", "Posting Date", "Entry Type", "Currency Code");
                            column(PostDate_DtldVendLedgEntries; FORMAT("Posting Date"))
                            {
                            }
                            column(DocNo_DtldVendLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldVendLedgEntries; FORMAT("Due Date"))
                            {
                            }
                            column(CurrCode_DtldVendLedgEntries; "Currency Code")
                            {
                            }
                            column(Amt_DtldVendLedgEntries; Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldVendLedgEntries; "Remaining Amount")
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(VendBalance; VendBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code; Currency2.Code)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                if SkipReversedUnapplied(DtldVendLedgEntries) or (Amount = 0) then
                                    CurrReport.SKIP;
                                "Remaining Amount" := 0;
                                PrintLine := true;
                                case "Entry Type" of
                                    "Entry Type"::"Initial Entry":
                                        begin
                                            "Vendor Ledger Entry".GET("Vendor Ledger Entry No.");
                                            Description := "Vendor Ledger Entry".Description;
                                            "Due Date" := "Vendor Ledger Entry"."Due Date";
                                            "Vendor Ledger Entry".SETRANGE("Date Filter", 0D, EndDate);
                                            "Vendor Ledger Entry".CALCFIELDS("Remaining Amount");
                                            "Remaining Amount" := "Vendor Ledger Entry"."Remaining Amount";
                                            "Vendor Ledger Entry".SETRANGE("Date Filter");
                                        end;
                                    "Entry Type"::Application:
                                        begin
                                            DtldVendLedgEntries2.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                                            DtldVendLedgEntries2.SETRANGE("Vendor No.", "Vendor No.");
                                            DtldVendLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                            DtldVendLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                            DtldVendLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                            DtldVendLedgEntries2.SETFILTER("Currency Code", '<>%1', "Currency Code");
                                            if DtldVendLedgEntries2.FINDFIRST then begin
                                                Description := Text005;
                                                "Due Date" := 0D;
                                            end else
                                                PrintLine := false;
                                        end;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                        begin
                                            Description := Text006;
                                            "Due Date" := 0D;
                                        end;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                        begin
                                            Description := Text014;
                                            "Due Date" := 0D;
                                        end;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                        begin
                                            Description := Text007;
                                            "Due Date" := 0D;
                                        end;
                                end;

                                if PrintLine then
                                    VendBalance := VendBalance + Amount;
                            end;

                            trigger OnPreDataItem();
                            begin
                                SETRANGE("Vendor No.", Vendor."No.");
                                SETRANGE("Posting Date", StartDate, EndDate);
                                SETRANGE("Currency Code", Currency2.Code);

                                if Currency2.Code = '' then begin
                                    GLSetup.TESTFIELD("LCY Code");
                                    CurrencyCode3 := GLSetup."LCY Code"
                                end else
                                    CurrencyCode3 := Currency2.Code;
                            end;
                        }
                    }
                    dataitem(VendLedgEntryFooter; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(CurrencyCode3_VendLedgEntryFooter; CurrencyCode3)
                        {
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(VendBalance_VendLedgEntryHdrFooter; VendBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(EntriesExistsl_VendLedgEntryFooterCaption; EntriesExists)
                        {
                        }
                    }
                    dataitem(VendLedgEntry2; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Vendor No." = FIELD("No.");
                        DataItemLinkReference = Vendor;
                        DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date");
                        column(OverDueEntries; STRSUBSTNO(Text002, Currency2.Code))
                        {
                        }
                        column(RemainAmt_VendLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDate_VendLedgEntry2; FORMAT("Posting Date"))
                        {
                        }
                        column(DocNo_VendLedgEntry2; "Document No.")
                        {
                        }
                        column(Desc_VendLedgEntry2; Description)
                        {
                        }
                        column(DueDate_VendLedgEntry2; FORMAT("Due Date"))
                        {
                        }
                        column(OriginalAmt_VendLedgEntry2; "Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCode_VendLedgEntry2; "Currency Code")
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2Code_VendLedgEntry2; Currency2.Code)
                        {
                        }
                        column(CurrencyCode3_VendLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(VendNo_VendLedgEntry2; "Vendor No.")
                        {
                        }

                        trigger OnAfterGetRecord();
                        var
                            VendLedgEntry: Record "Vendor Ledger Entry";
                        begin
                            if IncludeAgingBand then
                                if ("Posting Date" > EndDate) and ("Due Date" >= EndDate) then
                                    CurrReport.SKIP;
                            VendLedgEntry := VendLedgEntry2;
                            VendLedgEntry.SETRANGE("Date Filter", 0D, EndDate);
                            VendLedgEntry.CALCFIELDS("Remaining Amount");
                            "Remaining Amount" := VendLedgEntry."Remaining Amount";
                            if VendLedgEntry."Remaining Amount" = 0 then
                                CurrReport.SKIP;

                            if IncludeAgingBand and ("Posting Date" <= EndDate) then
                                UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            if "Due Date" >= EndDate then
                                CurrReport.SKIP;
                        end;

                        trigger OnPreDataItem();
                        begin
                            CurrReport.CREATETOTALS("Remaining Amount");
                            if not IncludeAgingBand then
                                SETRANGE("Due Date", 0D, EndDate - 1);
                            SETRANGE("Currency Code", Currency2.Code);
                            if (not PrintEntriesDue) and (not IncludeAgingBand) then
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then
                            Currency2.FIND('-')
                        else
                            if Currency2.NEXT = 0 then
                                CurrReport.BREAK;

                        Vend2 := Vendor;
                        Vend2.SETRANGE("Date Filter", 0D, StartDate - 1);
                        Vend2.SETRANGE("Currency Filter", Currency2.Code);
                        Vend2.CALCFIELDS("Net Change");
                        //TJE Changed sign (-1*)
                        StartBalance := -1 * Vend2."Net Change";
                        VendBalance := -1 * Vend2."Net Change";
                        "Vendor Ledger Entry".SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code");
                        "Vendor Ledger Entry".SETRANGE("Vendor No.", Vendor."No.");
                        "Vendor Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);
                        "Vendor Ledger Entry".SETRANGE("Currency Code", Currency2.Code);
                        EntriesExists := "Vendor Ledger Entry".FINDFIRST;
                        if not EntriesExists then
                            CurrReport.SKIP;
                    end;

                    trigger OnPreDataItem();
                    begin
                        Vendor.COPYFILTER("Currency Filter", Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(AgingDate1; FORMAT(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; FORMAT(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; FORMAT(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; FORMAT(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; FORMAT(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; FORMAT(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; STRSUBSTNO(Text011, AgingBandEndingDate, PeriodLength, SELECTSTR(DateChoice + 1, Text013)))
                    {
                    }
                    column(AgingDate41; FORMAT(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; FORMAT(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; AgingBandBuf."Column 1 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; AgingBandBuf."Column 2 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; AgingBandBuf."Column 3 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; AgingBandBuf."Column 4 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; AgingBandBuf."Column 5 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption; beforeCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then begin
                            if not AgingBandBuf.FIND('-') then
                                CurrReport.BREAK;
                        end else
                            if AgingBandBuf.NEXT = 0 then
                                CurrReport.BREAK;
                        AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                        if AgingBandCurrencyCode = '' then
                            AgingBandCurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not IncludeAgingBand then
                            CurrReport.BREAK;
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                AgingBandBuf.DELETEALL;
                CurrReport.LANGUAGE := LanguageMgt.GetLanguageIdOrDefault("Language Code");
                PrintLine := false;
                Vend2 := Vendor;
                COPYFILTER("Currency Filter", Currency2.Code);
                if PrintAllHavingBal then begin
                    if Currency2.FIND('-') then
                        repeat
                            Vend2.SETRANGE("Date Filter", 0D, EndDate);
                            Vend2.SETRANGE("Currency Filter", Currency2.Code);
                            Vend2.CALCFIELDS("Net Change");
                            PrintLine := Vend2."Net Change" <> 0;
                        until (Currency2.NEXT = 0) or PrintLine;
                end;
                if (not PrintLine) and PrintAllHavingEntry then begin
                    "Vendor Ledger Entry".RESET;
                    "Vendor Ledger Entry".SETCURRENTKEY("Vendor No.", "Posting Date");
                    "Vendor Ledger Entry".SETRANGE("Vendor No.", "No.");
                    "Vendor Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);
                    COPYFILTER("Currency Filter", "Vendor Ledger Entry"."Currency Code");
                    PrintLine := "Vendor Ledger Entry".FINDFIRST;
                end;
                if not PrintLine then
                    CurrReport.SKIP;

                FormatAddr.Vendor(VendAddr, Vendor);
                CurrReport.PAGENO := 1;

                if not CurrReport.PREVIEW then begin
                    LOCKTABLE;
                    FIND;
                    "Last Statement No." := "Last Statement No." + 1;
                    MODIFY;
                    COMMIT;
                end else
                    "Last Statement No." := "Last Statement No." + 1;

                if LogInteraction then
                    if not CurrReport.PREVIEW then
                        SegManagement.LogDocument(
                          7, FORMAT("Last Statement No."), 0, 0, DATABASE::Vendor, "No.", "Salesperson Code", '',
                          Text003 + FORMAT("Last Statement No."), '');
            end;

            trigger OnPreDataItem();
            begin
                StartDate := GETRANGEMIN("Date Filter");
                EndDate := GETRANGEMAX("Date Filter");

                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Currency2.Code := '';
                Currency2.INSERT;
                COPYFILTER("Currency Filter", Currency.Code);
                if Currency.FIND('-') then
                    repeat
                        Currency2 := Currency;
                        Currency2.INSERT;
                    until Currency.NEXT = 0;
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
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Overdue Entries';
                    }
                    field(IncludeAllVendorswithLE; PrintAllHavingEntry)
                    {
                        ApplicationArea = All;
                        Caption = 'Include All Vendors with Ledger Entries';
                        MultiLine = true;

                        trigger OnValidate();
                        begin
                            if not PrintAllHavingEntry then
                                PrintAllHavingBal := true;
                        end;
                    }
                    field(IncludeAllVendorswithBalance; PrintAllHavingBal)
                    {
                        ApplicationArea = All;
                        Caption = 'Include All Vendors with a Balance';
                        MultiLine = true;

                        trigger OnValidate();
                        begin
                            if not PrintAllHavingBal then
                                PrintAllHavingEntry := true;
                        end;
                    }
                    field(IncludeReversedEntries; PrintReversedEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Reversed Entries';
                    }
                    field(IncludeUnappliedEntries; PrintUnappliedEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Unapplied Entries';
                    }
                    field(IncludeAgingBand; IncludeAgingBand)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Aging Band';
                    }
                    field(AgingBandPeriodLengt; PeriodLength)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Band Period Length';
                    }
                    field(AgingBandby; DateChoice)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Band by';
                        OptionCaption = 'Due Date,Posting Date';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            InitRequestPageDataInternal;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                end;
        end;

        LogInteractionEnable := true;
    end;

    trigger OnPreReport();
    begin
        InitRequestPageDataInternal;
    end;

    var
        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label '"Statement "';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Vend2: Record Vendor;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        LanguageMgt: Codeunit Language;
        "Vendor Ledger Entry": Record "Vendor Ledger Entry";
        DtldVendLedgEntries2: Record "Detailed Vendor Ledg. Entry";
        AgingBandBuf: Record "Aging Band Buffer" temporary;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        "Due Date": Date;
        VendAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        Description: Text[100];
        StartBalance: Decimal;
        VendBalance: Decimal;
        "Remaining Amount": Decimal;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CurrencyCode3: Code[10];
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        Text008: Label 'You must specify the Aging Band Period Length.';
        AgingBandEndingDate: Date;
        Text010: Label 'You must specify Aging Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        IncludeAgingBand: Boolean;
        Text012: Label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[10];
        Text013: Label 'Due Date,Posting Date';
        Text014: Label 'Application Writeoffs';
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text036: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        StatementCaptionLbl: Label 'Statement';
        PhoneNo_CompanyInfoCaptionLbl: Label 'Phone No.';
        VATRegNo_CompanyInfoCaptionLbl: Label 'VAT Registration No.';
        GiroNo_CompanyInfoCaptionLbl: Label 'Giro No.';
        BankName_CompanyInfoCaptionLbl: Label 'Bank';
        BankAccNo_CompanyInfoCaptionLbl: Label 'Account No.';
        No1_VendCaptionLbl: Label 'Vendor No.';
        StartDateCaptionLbl: Label 'Starting Date';
        EndDateCaptionLbl: Label 'Ending Date';
        LastStatmntNo_VendCaptionLbl: Label 'Statement No.';
        PostDate_DtldVendLedgEntriesCaptionLbl: Label 'Posting Date';
        DueDate_VendLedgEntry2CaptionLbl: Label 'Due Date';
        VendBalanceCaptionLbl: Label 'Balance';
        beforeCaptionLbl: Label '..before';
        isInitialized: Boolean;
        CompanyInfoHomepageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'E-Mail';
        DocDateCaptionLbl: Label 'Document Date';
        Total_CaptionLbl: Label 'Total';

    local procedure GetDate(PostingDate: Date; DueDate: Date): Date;
    begin
        if DateChoice = DateChoice::"Posting Date" then
            exit(PostingDate);

        exit(DueDate);
    end;

    local procedure CalcAgingBandDates();
    begin
        if not IncludeAgingBand then
            exit;
        if AgingBandEndingDate = 0D then
            ERROR(Text010);
        if FORMAT(PeriodLength) = '' then
            ERROR(Text008);
        EVALUATE(PeriodLength2, STRSUBSTNO(Text036, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
            ERROR(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal);
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        if not AgingBandBuf.FIND then
            AgingBandBuf.INSERT;
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
            if Date <= AgingDate[I] then
                if I = 1 then begin
                    AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 2 then begin
                    AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 3 then begin
                    AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 4 then begin
                    AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 5 then begin
                    AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := false;
                end;
            I := I + 1;
        end;
        AgingBandBuf.MODIFY;
    end;

    procedure SkipReversedUnapplied(var DtldVendLedgEntries: Record "Detailed Vendor Ledg. Entry"): Boolean;
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries then
            exit(false);
        if not PrintUnappliedEntries then
            if DtldVendLedgEntries.Unapplied then
                exit(true);
        if not PrintReversedEntries then begin
            VendLedgEntry.GET(DtldVendLedgEntries."Vendor Ledger Entry No.");
            if VendLedgEntry.Reversed then
                exit(true);
        end;
        exit(false);
    end;

    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean);
    begin
        InitRequestPageDataInternal;

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        EVALUATE(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
    end;

    procedure InitRequestPageDataInternal();
    begin
        if isInitialized then
            exit;

        isInitialized := true;

        if (not PrintAllHavingEntry) and (not PrintAllHavingBal) then
            PrintAllHavingBal := true;

        //LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode(7) <> '';
        LogInteractionEnable := LogInteraction;

        if FORMAT(PeriodLength) = '' then
            EVALUATE(PeriodLength, '<1M+CM>');
    end;
}


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
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Print Statements", "Date Filter", "Currency Filter";
            column(No_Vend; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
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
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(StartDate; Format(StartDate))
                {
                }
                column(EndDate; Format(EndDate))
                {
                }
                column(LastStatmntNo_Vend; Format(Vendor."Last Statement No."))
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
                column(DocNo_DtldVendLedgEntriesCaption; DtldVendLedgEntries.FieldCaption("Document No."))
                {
                }
                column(Desc_VendLedgEntry2Caption; VendLedgEntry2.FieldCaption(Description))
                {
                }
                column(DueDate_VendLedgEntry2Caption; DueDate_VendLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtVendLedgEntry2Caption; VendLedgEntry2.FieldCaption("Remaining Amount"))
                {
                }
                column(VendBalanceCaption; VendBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_VendLedgEntry2Caption; VendLedgEntry2.FieldCaption("Original Amount"))
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
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    PrintOnlyIfDetail = true;
                    dataitem(VendLedgEntryHdr; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(Currency2Code_VendLedgEntryHdr; StrSubstNo(Text001, Currency2.Code))
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
                        column(DtldVendLedgEntryType; Format(DtldVendLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        dataitem(DtldVendLedgEntries; "Detailed Vendor Ledg. Entry")
                        {
                            DataItemTableView = sorting("Vendor No.", "Posting Date", "Entry Type", "Currency Code");
                            column(PostDate_DtldVendLedgEntries; Format("Posting Date"))
                            {
                            }
                            column(DocNo_DtldVendLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldVendLedgEntries; Format("Due Date"))
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
                                    CurrReport.Skip;
                                "Remaining Amount" := 0;
                                PrintLine := true;
                                case "Entry Type" of
                                    "Entry Type"::"Initial Entry":
                                        begin
                                            "Vendor Ledger Entry".Get("Vendor Ledger Entry No.");
                                            Description := "Vendor Ledger Entry".Description;
                                            "Due Date" := "Vendor Ledger Entry"."Due Date";
                                            "Vendor Ledger Entry".SetRange("Date Filter", 0D, EndDate);
                                            "Vendor Ledger Entry".CalcFields("Remaining Amount");
                                            "Remaining Amount" := "Vendor Ledger Entry"."Remaining Amount";
                                            "Vendor Ledger Entry".SetRange("Date Filter");
                                        end;
                                    "Entry Type"::Application:
                                        begin
                                            DtldVendLedgEntries2.SetCurrentKey("Vendor No.", "Posting Date", "Entry Type");
                                            DtldVendLedgEntries2.SetRange("Vendor No.", "Vendor No.");
                                            DtldVendLedgEntries2.SetRange("Posting Date", "Posting Date");
                                            DtldVendLedgEntries2.SetRange("Entry Type", "Entry Type"::Application);
                                            DtldVendLedgEntries2.SetRange("Transaction No.", "Transaction No.");
                                            DtldVendLedgEntries2.SetFilter("Currency Code", '<>%1', "Currency Code");
                                            if DtldVendLedgEntries2.FindFirst then begin
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
                                SetRange("Vendor No.", Vendor."No.");
                                SetRange("Posting Date", StartDate, EndDate);
                                SetRange("Currency Code", Currency2.Code);

                                if Currency2.Code = '' then begin
                                    GLSetup.TestField("LCY Code");
                                    CurrencyCode3 := GLSetup."LCY Code"
                                end else
                                    CurrencyCode3 := Currency2.Code;
                            end;
                        }
                    }
                    dataitem(VendLedgEntryFooter; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
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
                        DataItemLink = "Vendor No." = field("No.");
                        DataItemLinkReference = Vendor;
                        DataItemTableView = sorting("Vendor No.", Open, Positive, "Due Date");
                        column(OverDueEntries; StrSubstNo(Text002, Currency2.Code))
                        {
                        }
                        column(RemainAmt_VendLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDate_VendLedgEntry2; Format("Posting Date"))
                        {
                        }
                        column(DocNo_VendLedgEntry2; "Document No.")
                        {
                        }
                        column(Desc_VendLedgEntry2; Description)
                        {
                        }
                        column(DueDate_VendLedgEntry2; Format("Due Date"))
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
                                    CurrReport.Skip;
                            VendLedgEntry := VendLedgEntry2;
                            VendLedgEntry.SetRange("Date Filter", 0D, EndDate);
                            VendLedgEntry.CalcFields("Remaining Amount");
                            "Remaining Amount" := VendLedgEntry."Remaining Amount";
                            if VendLedgEntry."Remaining Amount" = 0 then
                                CurrReport.Skip;

                            if IncludeAgingBand and ("Posting Date" <= EndDate) then
                                UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            if "Due Date" >= EndDate then
                                CurrReport.Skip;
                        end;

                        trigger OnPreDataItem();
                        begin
                            CurrReport.CreateTotals("Remaining Amount");
                            if not IncludeAgingBand then
                                SetRange("Due Date", 0D, EndDate - 1);
                            SetRange("Currency Code", Currency2.Code);
                            if (not PrintEntriesDue) and (not IncludeAgingBand) then
                                CurrReport.Break;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then
                            Currency2.Find('-')
                        else
                            if Currency2.Next = 0 then
                                CurrReport.Break;

                        Vend2 := Vendor;
                        Vend2.SetRange("Date Filter", 0D, StartDate - 1);
                        Vend2.SetRange("Currency Filter", Currency2.Code);
                        Vend2.CalcFields("Net Change");
                        //TJE Changed sign (-1*)
                        StartBalance := -1 * Vend2."Net Change";
                        VendBalance := -1 * Vend2."Net Change";
                        "Vendor Ledger Entry".SetCurrentKey("Vendor No.", "Posting Date", "Currency Code");
                        "Vendor Ledger Entry".SetRange("Vendor No.", Vendor."No.");
                        "Vendor Ledger Entry".SetRange("Posting Date", StartDate, EndDate);
                        "Vendor Ledger Entry".SetRange("Currency Code", Currency2.Code);
                        EntriesExists := "Vendor Ledger Entry".FindFirst;
                        if not EntriesExists then
                            CurrReport.Skip;
                    end;

                    trigger OnPreDataItem();
                    begin
                        Vendor.CopyFilter("Currency Filter", Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(AgingDate1; Format(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; Format(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; Format(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; Format(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; Format(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; Format(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; StrSubstNo(Text011, AgingBandEndingDate, PeriodLength, SelectStr(DateChoice + 1, Text013)))
                    {
                    }
                    column(AgingDate41; Format(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; Format(AgingDate[5]))
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
                            if not AgingBandBuf.Find('-') then
                                CurrReport.Break;
                        end else
                            if AgingBandBuf.Next = 0 then
                                CurrReport.Break;
                        AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                        if AgingBandCurrencyCode = '' then
                            AgingBandCurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not IncludeAgingBand then
                            CurrReport.Break;
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                AgingBandBuf.DeleteAll;
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault("Language Code");
                PrintLine := false;
                Vend2 := Vendor;
                CopyFilter("Currency Filter", Currency2.Code);
                if PrintAllHavingBal then begin
                    if Currency2.Find('-') then
                        repeat
                            Vend2.SetRange("Date Filter", 0D, EndDate);
                            Vend2.SetRange("Currency Filter", Currency2.Code);
                            Vend2.CalcFields("Net Change");
                            PrintLine := Vend2."Net Change" <> 0;
                        until (Currency2.Next = 0) or PrintLine;
                end;
                if (not PrintLine) and PrintAllHavingEntry then begin
                    "Vendor Ledger Entry".Reset;
                    "Vendor Ledger Entry".SetCurrentKey("Vendor No.", "Posting Date");
                    "Vendor Ledger Entry".SetRange("Vendor No.", "No.");
                    "Vendor Ledger Entry".SetRange("Posting Date", StartDate, EndDate);
                    CopyFilter("Currency Filter", "Vendor Ledger Entry"."Currency Code");
                    PrintLine := "Vendor Ledger Entry".FindFirst;
                end;
                if not PrintLine then
                    CurrReport.Skip;

                FormatAddr.Vendor(VendAddr, Vendor);
                CurrReport.PageNo := 1;

                if not CurrReport.Preview then begin
                    LockTable;
                    Find;
                    "Last Statement No." := "Last Statement No." + 1;
                    Modify;
                    Commit;
                end else
                    "Last Statement No." := "Last Statement No." + 1;

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          7, Format("Last Statement No."), 0, 0, Database::Vendor, "No.", "Salesperson Code", '',
                          Text003 + Format("Last Statement No."), '');
            end;

            trigger OnPreDataItem();
            begin
                StartDate := GetRangeMin("Date Filter");
                EndDate := GetRangeMax("Date Filter");

                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Currency2.Code := '';
                Currency2.Insert;
                CopyFilter("Currency Filter", Currency.Code);
                if Currency.Find('-') then
                    repeat
                        Currency2 := Currency;
                        Currency2.Insert;
                    until Currency.Next = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies the value of the Show Overdue Entries field.';
                    }
                    field(IncludeAllVendorswithLE; PrintAllHavingEntry)
                    {
                        ApplicationArea = All;
                        Caption = 'Include All Vendors with Ledger Entries';
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the Include All Vendors with Ledger Entries field.';

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
                        ToolTip = 'Specifies the value of the Include All Vendors with a Balance field.';

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
                        ToolTip = 'Specifies the value of the Include Reversed Entries field.';
                    }
                    field(IncludeUnappliedEntries; PrintUnappliedEntries)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Unapplied Entries';
                        ToolTip = 'Specifies the value of the Include Unapplied Entries field.';
                    }
                    field(IncludeAgingBand; IncludeAgingBand)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Aging Band';
                        ToolTip = 'Specifies the value of the Include Aging Band field.';
                    }
                    field(AgingBandPeriodLengt; PeriodLength)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Band Period Length';
                        ToolTip = 'Specifies the value of the Aging Band Period Length field.';
                    }
                    field(AgingBandby; DateChoice)
                    {
                        ApplicationArea = All;
                        Caption = 'Aging Band by';
                        OptionCaption = 'Due Date,Posting Date';
                        ToolTip = 'Specifies the value of the Aging Band by field.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies the value of the Log Interaction field.';
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
        GLSetup.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
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
            Error(Text010);
        if Format(PeriodLength) = '' then
            Error(Text008);
        Evaluate(PeriodLength2, StrSubstNo(Text036, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CalcDate(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CalcDate(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CalcDate(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CalcDate(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
            Error(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal);
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.Init;
        AgingBandBuf."Currency Code" := CurrencyCode;
        if not AgingBandBuf.Find then
            AgingBandBuf.Insert;
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
        AgingBandBuf.Modify;
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
            VendLedgEntry.Get(DtldVendLedgEntries."Vendor Ledger Entry No.");
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
        Evaluate(PeriodLength, NewPeriodLength);
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

        if Format(PeriodLength) = '' then
            Evaluate(PeriodLength, '<1M+CM>');
    end;
}


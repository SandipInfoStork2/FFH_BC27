report 50004 "Summary Boxes Report Group"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep04_50004_SummaryBoxesReportGroup.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            column(Vendor_No; Vendor."No.")
            {
            }
            column(Vendor_PhoneNo; Vendor."Phone No.")
            {
            }
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
            column(postedfilters; postedfilters)
            {
            }
            dataitem("Purchase Line Addon Posted"; "Purchase Line Addon Posted")
            {
                DataItemLink = "Buy-from Vendor No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                column(LineNo_PurchaseLineAddon; "Purchase Line Addon Posted"."Line No.")
                {
                }
                column(Type_PurchaseLineAddon; "Purchase Line Addon Posted".Type)
                {
                }
                column(No_PurchaseLineAddon; "Purchase Line Addon Posted"."No.")
                {
                }
                column(LocationCode_PurchaseLineAddon; "Purchase Line Addon Posted"."Location Code")
                {
                }
                column(Description_PurchaseLineAddon; "Purchase Line Addon Posted".Description)
                {
                }
                column(UnitofMeasure_PurchaseLineAddon; "Purchase Line Addon Posted"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLineAddon; "Purchase Line Addon Posted".Quantity)
                {
                }
                column(VariantCode_PurchaseLineAddon; "Purchase Line Addon Posted"."Variant Code")
                {
                }
                dataitem("Purchase Header Addon Posted"; "Purchase Header Addon Posted")
                {
                    DataItemLink = "No." = field("Document No.");
                    DataItemTableView = sorting("Buy-from Vendor No.") order(ascending);
                    RequestFilterFields = "No.", "Posting Date";
                    column(BuyfromVendorNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor No.")
                    {
                    }
                    column(No_PurchaseHeaderAddon; "Purchase Header Addon Posted"."No.")
                    {
                    }
                    column(PaytoVendorNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Vendor No.")
                    {
                    }
                    column(PaytoName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Name")
                    {
                    }
                    column(PaytoName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Name 2")
                    {
                    }
                    column(PaytoAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Address")
                    {
                    }
                    column(PaytoAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Address 2")
                    {
                    }
                    column(PaytoCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to City")
                    {
                    }
                    column(PaytoContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Contact")
                    {
                    }
                    column(YourReference_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Your Reference")
                    {
                    }
                    column(ShiptoCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Code")
                    {
                    }
                    column(ShiptoName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Name")
                    {
                    }
                    column(ShiptoName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Name 2")
                    {
                    }
                    column(ShiptoAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to City")
                    {
                    }
                    column(ShiptoContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Contact")
                    {
                    }
                    column(OrderDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Order Date")
                    {
                    }
                    column(PostingDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting Date")
                    {
                    }
                    column(ExpectedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Expected Receipt Date")
                    {
                    }
                    column(PostingDescription_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting Description")
                    {
                    }
                    column(PaymentTermsCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Payment Terms Code")
                    {
                    }
                    column(DueDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Due Date")
                    {
                    }
                    column(ShipmentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shipment Method Code")
                    {
                    }
                    column(LocationCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Location Code")
                    {
                    }
                    column(ShortcutDimension1Code_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shortcut Dimension 1 Code")
                    {
                    }
                    column(ShortcutDimension2Code_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shortcut Dimension 2 Code")
                    {
                    }
                    column(VendorPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Vendor Posting Group")
                    {
                    }
                    column(PurchaserCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Purchaser Code")
                    {
                    }
                    column(OrderClass_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Order Class")
                    {
                    }
                    column(Comment_PurchaseHeaderAddon; "Purchase Header Addon Posted".Comment)
                    {
                    }
                    column(NoPrinted_PurchaseHeaderAddon; "Purchase Header Addon Posted"."No. Printed")
                    {
                    }
                    column(OnHold_PurchaseHeaderAddon; "Purchase Header Addon Posted"."On Hold")
                    {
                    }
                    column(SelltoCustomerNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Sell-to Customer No.")
                    {
                    }
                    column(ReasonCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Reason Code")
                    {
                    }
                    column(GenBusPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Gen. Bus. Posting Group")
                    {
                    }
                    column(BuyfromVendorName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor Name")
                    {
                    }
                    column(BuyfromVendorName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor Name 2")
                    {
                    }
                    column(BuyfromAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Address")
                    {
                    }
                    column(BuyfromAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Address 2")
                    {
                    }
                    column(BuyfromCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from City")
                    {
                    }
                    column(BuyfromContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Contact")
                    {
                    }
                    column(PaytoPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Post Code")
                    {
                    }
                    column(PaytoCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to County")
                    {
                    }
                    column(PaytoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Country/Region Code")
                    {
                    }
                    column(BuyfromPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Post Code")
                    {
                    }
                    column(BuyfromCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from County")
                    {
                    }
                    column(BuyfromCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Country/Region Code")
                    {
                    }
                    column(ShiptoPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Post Code")
                    {
                    }
                    column(ShiptoCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to County")
                    {
                    }
                    column(ShiptoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Country/Region Code")
                    {
                    }
                    column(BalAccountType_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Bal. Account Type")
                    {
                    }
                    column(DocumentDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Document Date")
                    {
                    }
                    column(Area_PurchaseHeaderAddon; "Purchase Header Addon Posted".Area)
                    {
                    }
                    column(TransactionSpecification_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Transaction Specification")
                    {
                    }
                    column(PaymentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Payment Method Code")
                    {
                    }
                    column(PaytoContactNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Contact No.")
                    {
                    }
                    column(ResponsibilityCenter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Responsibility Center")
                    {
                    }
                    column(PostingfromWhseRef_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting from Whse. Ref.")
                    {
                    }
                    column(LocationFilter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Location Filter")
                    {
                    }
                    column(RequestedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Requested Receipt Date")
                    {
                    }
                    column(PromisedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Promised Receipt Date")
                    {
                    }
                    column(DateFilter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Date Filter")
                    {
                    }
                    column(VendorAuthorizationNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Vendor Authorization No.")
                    {
                    }
                    column(Ship_PurchaseHeaderAddon; "Purchase Header Addon Posted".Ship)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord();
            begin
                Vend2 := Vendor;
                FormatAddr.Vendor(VendAddr, Vendor);
            end;

            trigger OnPreDataItem();
            begin
                //StartDate := GETRANGEMIN("Purchase Header Addon Posted"."Posting Date");
                //EndDate := GETRANGEMAX("Purchase Header Addon Posted"."Posting Date");

                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
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
        "Purchase Header Addon Posted"."Posting Date" := 0D;
    end;

    trigger OnPreReport();
    begin
        postedfilters := "Purchase Header Addon Posted".GetFilters;
    end;

    var
        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label '"Statement "';
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        Text008: Label 'You must specify the Aging Band Period Length.';
        Text010: Label 'You must specify Aging Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        Text012: Label 'Period Length is out of range.';
        Text013: Label 'Due Date,Posting Date';
        Text014: Label 'Application Writeoffs';
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
        CompanyInfoHomepageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'E-Mail';
        DocDateCaptionLbl: Label 'Document Date';
        Total_CaptionLbl: Label 'Total';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Vend2: Record Vendor;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        LanguageMgt: Record Language;
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
        Description: Text[50];
        StartBalance: Decimal;
        VendBalance: Decimal;
        "Remaining Amount": Decimal;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CurrencyCode3: Code[10];
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        AgingBandEndingDate: Date;
        IncludeAgingBand: Boolean;
        AgingBandCurrencyCode: Code[10];
        [InDataSet]
        LogInteractionEnable: Boolean;
        isInitialized: Boolean;
        postedfilters: Text[250];
}


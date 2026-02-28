report 50044 "Sales - Return Receipt HORECA"
{
    // version NAVW110.0

    // TAL0.1 2019/09/16 VC Logo output performance
    // TAL0.2 2019/09/16 VC design 3 columns for Lidl
    // TAL0.2 2018/05/24 VC existing customisation with zero 0:0 format create conflict with new request
    //                      dynamic show posted sales Shipment and posted sales Invoice qty and shiped qty(Qty Base) with decimals or not
    //                      removed Format from RDLC for the qty and shiped qty fields
    // TAL0.3 2019/12/13 VC Design Customer Group dimension 5
    // TAL0.4 2019/12/19 VC add type item logic
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep44_50044_SalesReturnReceiptHORECA.rdlc';

    CaptionML = ELL = 'Sales - Return Receipt HORECA',
                ENU = 'Sales - Return Receipt HORECA';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Return Receipt Header"; "Return Receipt Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            //ReqFilterHeading = 'Posted Return Receipt';
            column(No_ReturnRcptHeader; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(SalesReturnRcptCopyText; STRSUBSTNO(Text002, CopyText))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(SellCustNo_ReturnRcptHdr; "Return Receipt Header"."Sell-to Customer No.")
                    {
                    }
                    column(SellCustNo_ReturnRcptHdrCaption; "Return Receipt Header".FIELDCAPTION("Sell-to Customer No."))
                    {
                    }
                    column(DocDate_ReturnRcptHeader; FORMAT("Return Receipt Header"."Document Date", 0, 4))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_ReturnRcptHeader; "Return Receipt Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_ReturnRcptHeader; "Return Receipt Header"."Your Reference")
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(ShptDt_ReturnRcptHeader; FORMAT("Return Receipt Header"."Shipment Date"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; STRSUBSTNO(Text003, ''))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn; CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn; CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn; CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(ReturnReceiptHeaderNoCptn; ReturnReceiptHeaderNoCptnLbl)
                    {
                    }
                    column(ReturnRcptHdrShptDtCptn; ReturnRcptHdrShptDtCptnLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }

                    column(CompanyInfoGlobalGabCOCNo; CompanyInfo."GlobalGab COC No.")
                    {
                    }
                    column(CompanyInfoBIOCertificationBody; CompanyInfo."BIO Certification Body")
                    {

                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Return Receipt Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Number; Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FINDSET then
                                    CurrReport.BREAK;
                            end else
                                if not Continue then
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := STRSUBSTNO('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if STRLEN(DimText) > MAXSTRLEN(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Return Receipt Line"; "Return Receipt Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Return Receipt Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(TypeInt; TypeInt)
                        {
                        }
                        column(Desc_ReturnReceiptLine; Description)
                        {
                        }
                        column(UOM_ReturnReceiptLine; "Unit of Measure")
                        {
                        }
                        column(Qty_ReturnReceiptLine; Quantity)
                        {
                        }
                        column(No_ReturnReceiptLine; "No.")
                        {
                        }
                        column(UOM_ReturnReceiptLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(Qty_ReturnReceiptLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(Desc_ReturnReceiptLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(No_ReturnReceiptLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(LineNo_ReturnReceiptLine; "Line No.")
                        {
                        }
                        column(QtyBase_ReturnReceiptLine; "Quantity (Base)")
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(UOMBase_ReturnReceiptLine; "Unit of Measure (Base)")
                        {
                        }
                        column(ShelfNo_ReturnReceiptLine; vG_shelfno)
                        {
                        }
                        column(Salesline_CustomerGroupDim; vG_ShortcutDimCode[5])
                        {
                        }
                        column(Salesline_CustomerGroupDimName; rG_DimensionValue.Name)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(DimensionLoop2Number; Number)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FINDSET then
                                        CurrReport.BREAK;
                                end else
                                    if not Continue then
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := STRSUBSTNO('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if STRLEN(DimText) > MAXSTRLEN(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem();
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.BREAK;
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if (not ShowCorrectionLines) and Correction then
                                CurrReport.SKIP;

                            DimSetEntry2.SETRANGE("Dimension Set ID", "Dimension Set ID");
                            TypeInt := Type;


                            CALCFIELDS("Unit of Measure (Base)");

                            vG_shelfno := '';
                            if "Return Receipt Line".Type = "Return Receipt Line".Type::Item then begin
                                if rG_item.GET("Return Receipt Line"."No.") then begin
                                    vG_shelfno := rG_item."Shelf No.";
                                end;
                            end;

                            //+TAL0.1
                            if LogoOutput then begin
                                CLEAR(CompanyInfo.Picture);
                                CLEAR(CompanyInfo1.Picture);
                                CLEAR(CompanyInfo2.Picture);
                                CLEAR(CompanyInfo3.Picture);
                            end else begin
                                LogoOutput := true;
                            end;
                            //-TAL0.1

                            //+TAL0.2
                            if rG_Customer."Report Decimal Places" then begin
                                EVALUATE(Quantity, FORMAT(Quantity, 0, '<Precision,0:1><Standard Format,0>'));
                                EVALUATE("Quantity (Base)", FORMAT("Quantity (Base)", 0, '<Precision,0:1><Standard Format,0>'));

                            end else begin
                                EVALUATE(Quantity, FORMAT(Quantity, 0, '<Precision,0:0><Standard Format,0>'));
                                EVALUATE("Quantity (Base)", FORMAT("Quantity (Base)", 0, '<Precision,0:0><Standard Format,0>'));
                            end;
                            //-TAL0.2

                            //+TAL0.3
                            CLEAR(vG_ShortcutDimCode); //TAL0.4
                            CLEAR(rG_DimensionValue);  //TAL0.4
                            if "Return Receipt Line".Type = "Return Receipt Line".Type::Item then begin   //TAL0.4
                                DimMgt.GetShortcutDimensions("Return Receipt Line"."Dimension Set ID", vG_ShortcutDimCode);

                                rG_DimensionValue.RESET;
                                rG_DimensionValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                                rG_DimensionValue.SETFILTER(Code, vG_ShortcutDimCode[5]);
                                if rG_DimensionValue.FINDSET then begin

                                end;
                            end;
                            //-TAL0.3
                        end;

                        trigger OnPreDataItem();
                        begin
                            MoreLines := FIND('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := NEXT(-1) <> 0;
                            if not MoreLines then
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(BilltoCustNo_ReturnRcptHdr; "Return Receipt Header"."Bill-to Customer No.")
                        {
                        }
                        column(CustAddr1; CustAddr[1])
                        {
                        }
                        column(CustAddr2; CustAddr[2])
                        {
                        }
                        column(CustAddr3; CustAddr[3])
                        {
                        }
                        column(CustAddr4; CustAddr[4])
                        {
                        }
                        column(CustAddr5; CustAddr[5])
                        {
                        }
                        column(CustAddr6; CustAddr[6])
                        {
                        }
                        column(CustAddr7; CustAddr[7])
                        {
                        }
                        column(CustAddr8; CustAddr[8])
                        {
                        }
                        column(BilltoAddressCaption; BilltoAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            if not ShowCustAddr then
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                    CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem();
                begin
                    if not CurrReport.PREVIEW then
                        CODEUNIT.RUN(CODEUNIT::"Return Receipt - Printed", "Return Receipt Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := 1 + ABS(NoOfCopies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                Language: Codeunit Language;
            begin
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Return Receipt Header");
                FormatDocumentFields("Return Receipt Header");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                if LogInteraction then
                    if not CurrReport.PREVIEW then
                        SegManagement.LogDocument(
                          20, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');

                rG_Customer.GET("Sell-to Customer No."); //TAL0.2
                if not rG_Customer."Show GlobalGab COC No." then begin
                    CompanyInfo."GlobalGab COC No." := '';
                end;
            end;

            trigger OnPreDataItem();
            begin
                //+TAL0.9
                if vG_HideGlobalGapCOC then begin
                    CompanyInfo."GlobalGab COC No." := '';
                    CompanyInfo."BIO Certification Body" := '';
                end;
                //-TAL0.9
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(ShowCorrectionLines; ShowCorrectionLines)
                    {
                        Caption = 'Show Correction Lines';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }

                    field("Hide GlobalGAP COC"; vG_HideGlobalGapCOC)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        GLSetup.GET;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    end;

    trigger OnPreReport();
    begin
        if not CurrReport.USEREQUESTPAGE then
            InitLogInteraction;

        LogoOutput := false; //TAL0.1
    end;

    var
        Text002: TextConst Comment = '%1 = Document No.', ENU = 'Sales - Return Receipt %1';
        Text003: Label 'Page %1';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        MoreLines: Boolean;
        ShowCustAddr: Boolean;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        ShowCorrectionLines: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        TypeInt: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        ReturnReceiptHeaderNoCptnLbl: Label 'Receipt No.';
        ReturnRcptHdrShptDtCptnLbl: Label 'Shipment Date';
        DocumentDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'Email';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        BilltoAddressCaptionLbl: Label 'Bill-to Address';
        rG_item: Record Item;
        vG_shelfno: Code[20];
        LogoOutput: Boolean;
        rG_Customer: Record Customer;
        vG_ShortcutDimCode: array[8] of Code[20];
        rG_DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        GLSetup: Record "General Ledger Setup";

        vG_HideGlobalGapCOC: Boolean;

    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(20) <> '';
    end;

    local procedure FormatAddressFields(ReturnReceiptHeader: Record "Return Receipt Header");
    begin
        FormatAddr.GetCompanyAddr(ReturnReceiptHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesRcptShipTo(ShipToAddr, ReturnReceiptHeader);
        ShowCustAddr := FormatAddr.SalesRcptBillTo(CustAddr, ShipToAddr, ReturnReceiptHeader);
    end;

    local procedure FormatDocumentFields(ReturnReceiptHeader: Record "Return Receipt Header");
    begin
        with ReturnReceiptHeader do begin
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);

            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
        end;
    end;
}


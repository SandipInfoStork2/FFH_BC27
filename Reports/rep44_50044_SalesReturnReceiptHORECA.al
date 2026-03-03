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
    ApplicationArea = All;

    dataset
    {
        dataitem("Return Receipt Header"; "Return Receipt Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            //ReqFilterHeading = 'Posted Return Receipt';
            column(No_ReturnRcptHeader; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(SalesReturnRcptCopyText; StrSubstNo(Text002, CopyText))
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
                    column(SellCustNo_ReturnRcptHdrCaption; "Return Receipt Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(DocDate_ReturnRcptHeader; Format("Return Receipt Header"."Document Date", 0, 4))
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
                    column(ShptDt_ReturnRcptHeader; Format("Return Receipt Header"."Shipment Date"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; StrSubstNo(Text003, ''))
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
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
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
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Return Receipt Line"; "Return Receipt Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Return Receipt Header";
                        DataItemTableView = sorting("Document No.", "Line No.");
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
                        column(UOM_ReturnReceiptLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Qty_ReturnReceiptLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(Desc_ReturnReceiptLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_ReturnReceiptLineCaption; FieldCaption("No."))
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
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
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
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem();
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if (not ShowCorrectionLines) and Correction then
                                CurrReport.Skip;

                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                            TypeInt := Type;


                            CalcFields("Unit of Measure (Base)");

                            vG_shelfno := '';
                            if "Return Receipt Line".Type = "Return Receipt Line".Type::Item then begin
                                if rG_item.Get("Return Receipt Line"."No.") then begin
                                    vG_shelfno := rG_item."Shelf No.";
                                end;
                            end;

                            //+TAL0.1
                            if LogoOutput then begin
                                Clear(CompanyInfo.Picture);
                                Clear(CompanyInfo1.Picture);
                                Clear(CompanyInfo2.Picture);
                                Clear(CompanyInfo3.Picture);
                            end else begin
                                LogoOutput := true;
                            end;
                            //-TAL0.1

                            //+TAL0.2
                            if rG_Customer."Report Decimal Places" then begin
                                Evaluate(Quantity, Format(Quantity, 0, '<Precision,0:1><Standard Format,0>'));
                                Evaluate("Quantity (Base)", Format("Quantity (Base)", 0, '<Precision,0:1><Standard Format,0>'));

                            end else begin
                                Evaluate(Quantity, Format(Quantity, 0, '<Precision,0:0><Standard Format,0>'));
                                Evaluate("Quantity (Base)", Format("Quantity (Base)", 0, '<Precision,0:0><Standard Format,0>'));
                            end;
                            //-TAL0.2

                            //+TAL0.3
                            Clear(vG_ShortcutDimCode); //TAL0.4
                            Clear(rG_DimensionValue);  //TAL0.4
                            if "Return Receipt Line".Type = "Return Receipt Line".Type::Item then begin   //TAL0.4
                                DimMgt.GetShortcutDimensions("Return Receipt Line"."Dimension Set ID", vG_ShortcutDimCode);

                                rG_DimensionValue.Reset;
                                rG_DimensionValue.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                                rG_DimensionValue.SetFilter(Code, vG_ShortcutDimCode[5]);
                                if rG_DimensionValue.FindSet then begin

                                end;
                            end;
                            //-TAL0.3
                        end;

                        trigger OnPreDataItem();
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
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
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem();
                begin
                    if not CurrReport.Preview then
                        Codeunit.Run(Codeunit::"Return Receipt - Printed", "Return Receipt Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                Language: Codeunit Language;
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Return Receipt Header");
                FormatDocumentFields("Return Receipt Header");

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          20, "No.", 0, 0, Database::Customer, "Bill-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');

                rG_Customer.Get("Sell-to Customer No."); //TAL0.2
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
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                        ApplicationArea = All;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies the value of the Show Internal Information field.';
                        ApplicationArea = All;
                    }
                    field(ShowCorrectionLines; ShowCorrectionLines)
                    {
                        Caption = 'Show Correction Lines';
                        ToolTip = 'Specifies the value of the Show Correction Lines field.';
                        ApplicationArea = All;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies the value of the Log Interaction field.';
                        ApplicationArea = All;
                    }

                    field("Hide GlobalGAP COC"; vG_HideGlobalGapCOC)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the vG_HideGlobalGapCOC field.';
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
        CompanyInfo.Get;
        SalesSetup.Get;
        GLSetup.Get;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    end;

    trigger OnPreReport();
    begin
        if not CurrReport.UseRequestPage then
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
        // LogInteraction := SegManagement.FindInteractTmplCode(20) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode(20) <> '';
    end;

    local procedure FormatAddressFields(ReturnReceiptHeader: Record "Return Receipt Header");
    begin
        FormatAddr.GetCompanyAddr(ReturnReceiptHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesRcptShipTo(ShipToAddr, ReturnReceiptHeader);
        ShowCustAddr := FormatAddr.SalesRcptBillTo(CustAddr, ShipToAddr, ReturnReceiptHeader);
    end;

    local procedure FormatDocumentFields(ReturnReceiptHeader: Record "Return Receipt Header");
    begin
        FormatDocument.SetSalesPerson(SalesPurchPerson, ReturnReceiptHeader."Salesperson Code", SalesPersonText);

        ReferenceText := FormatDocument.SetText(ReturnReceiptHeader."Your Reference" <> '', ReturnReceiptHeader.FieldCaption("Your Reference"));
    end;
}


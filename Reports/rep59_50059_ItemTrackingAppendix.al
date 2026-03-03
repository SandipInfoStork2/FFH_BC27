report 50059 "Item Tracking Appendix FFH"
{
    // version NAVW110.0

    // TAL0.1 2021/03/30 add option Purch. Post Receipt
    // TAL0.2 2021/04/08 add Grower Name in the Grouping section
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep59_50059_ItemTrackingAppendix.rdlc';

    Caption = 'Item Tracking Appendix FFH';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(MainRecord; "Integer")
        {
            DataItemTableView = sorting(Number);
            PrintOnlyIfDetail = false;
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(Addr1; Addr[1])
                {
                }
                column(Addr2; Addr[2])
                {
                }
                column(SourceCaption; SourceCaption)
                {
                }
                column(Addr3; Addr[3])
                {
                }
                column(Addr4; Addr[4])
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Addr5; Addr[5])
                {
                }
                column(Addr6; Addr[6])
                {
                }
                column(DocumentDate; Format(DocumentDate))
                {
                }
                column(Addr7; Addr[7])
                {
                }
                column(Addr8; Addr[8])
                {
                }
                column(Addr2Caption; Addr2Caption)
                {
                }
                column(Addr21; Addr2[1])
                {
                }
                column(Addr22; Addr2[2])
                {
                }
                column(Addr23; Addr2[3])
                {
                }
                column(Addr24; Addr2[4])
                {
                }
                column(Addr25; Addr2[5])
                {
                }
                column(Addr26; Addr2[6])
                {
                }
                column(Addr27; Addr2[7])
                {
                }
                column(Addr28; Addr2[8])
                {
                }
                column(ShowAddr2; ShowAddr2)
                {
                }
                column(ItemTrackingAppendixCaption; ItemTrackingAppendixCaptionLbl)
                {
                }
                column(DocumentDateCaption; DocumentDateCaptionLbl)
                {
                }
                column(PageCaption; PageCaptionLbl)
                {
                }
                dataitem(ItemTrackingLine; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    PrintOnlyIfDetail = false;
                    column(SerialNo_ItemTrackingLine; TrackingSpecBuffer."Serial No.")
                    {
                    }
                    column(No_ItemTrackingLine; TrackingSpecBuffer."Item No.")
                    {
                    }
                    column(Desc_ItemTrackingLine; TrackingSpecBuffer.Description)
                    {
                    }
                    column(Qty_ItemTrackingLine; TrackingSpecBuffer."Quantity (Base)")
                    {
                        DecimalPlaces = 0 : 2;
                    }
                    column(LotNo; TrackingSpecBuffer."Lot No.")
                    {
                    }
                    column(ShowGroup; ShowGroup)
                    {
                    }
                    column(NoCaption; NoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(QuantityCaption; QuantityCaptionLbl)
                    {
                    }
                    column(LotNoCaption; LotNoCaptionLbl)
                    {
                    }
                    column(SerialNoCaption; SerialNoCaptionLbl)
                    {
                    }
                    column(GrowerName_ItemTrackingLine; TrackingSpecBuffer."Grower Name")
                    {
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(TotalQuantity; TotalQty)
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(ShowTotal; ShowTotal)
                        {
                        }
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then
                            TrackingSpecBuffer.FindSet
                        else
                            TrackingSpecBuffer.Next;

                        if TrackingSpecBuffer.Correction then
                            TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";

                        ShowTotal := false;
                        if IsStartNewGroup(TrackingSpecBuffer) then
                            ShowTotal := true;

                        ShowGroup := false;
                        if (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) or
                           (TrackingSpecBuffer."Item No." <> OldNo)
                        then begin
                            OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                            OldNo := TrackingSpecBuffer."Item No.";
                            TotalQty := 0;
                        end else
                            ShowGroup := true;
                        TotalQty += TrackingSpecBuffer."Quantity (Base)";

                        TrackingSpecBuffer.CalcFields("Lot Grower No.", "Grower Name");
                    end;

                    trigger OnPostDataItem();
                    begin
                        //CurrReport.PAGENO(0);
                    end;

                    trigger OnPreDataItem();
                    begin
                        if TrackingSpecCount = 0 then
                            CurrReport.Break;
                        SetRange(Number, 1, TrackingSpecCount);
                        TrackingSpecBuffer.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
                          "Source Prod. Order Line", "Source Ref. No.");
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    // exclude documents without Item Tracking
                    if TrackingSpecCount = 0 then begin
                        //CurrReport.PAGENO(0);
                        CurrReport.Break;
                    end;
                    OldRefNo := 0;
                    ShowGroup := false;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                HandleRec(Number);
            end;

            trigger OnPreDataItem();
            begin
                if MainRecCount = 0 then
                    CurrReport.Break;
                SetRange(Number, 1, MainRecCount);
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
                    field(Document; DocType)
                    {
                        ApplicationArea = All;
                        Caption = 'Document';
                        Lookup = false;
                        OptionCaption = 'Sales Quote,Sales Order,Sales Invoice,Sales Credit Memo,Sales Return Order,Sales Post. Shipment,Sales Post. Invoice,Purch. Quote,Purch. Order,Purch. Invoice,Purch. Credit Memo,Purch. Return Order,Purch. Post Receipt';
                        ToolTip = 'Specifies the value of the Document field.';
                    }
                    field(DocumentNo; DocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the value of the Document No. field.';
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

    trigger OnPreReport();
    begin
        SetRecordFilter;
    end;

    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        SalesShipmentHdr: Record "Sales Shipment Header";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        FormatAddr: Codeunit "Format Address";
        DocNo: Code[20];
        DocType: Option "Sales Quote","Sales Order","Sales Invoice","Sales Credit Memo","Sales Return Order","Sales Post. Shipment","Sales Post. Invoice","Purch. Quote","Purch. Order","Purch. Invoice","Purch. Credit Memo","Purch. Return Order","Purch. Post Receipt";
        Addr: array[8] of Text[50];
        Addr2: array[8] of Text[50];
        SourceCaption: Text;
        Addr2Caption: Text;
        ShowAddr2: Boolean;
        ShowGroup: Boolean;
        ShowTotal: Boolean;
        DocumentDate: Date;
        MainRecCount: Integer;
        Text002: Label 'Pay-to Address';
        Text003: Label 'Bill-to Address';
        TrackingSpecCount: Integer;
        Text004: Label 'Sales - Shipment';
        OldRefNo: Integer;
        OldNo: Code[20];
        TotalQty: Decimal;
        Text005: Label 'Sales - Invoice';
        Text006: Label 'Sales';
        Text007: Label 'Purchase';
        ItemTrackingAppendixCaptionLbl: Label 'Item Tracking - Appendix';
        DocumentDateCaptionLbl: Label 'Document Date';
        PageCaptionLbl: Label 'Page';
        NoCaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        LotNoCaptionLbl: Label 'Lot No.';
        SerialNoCaptionLbl: Label 'Serial No.';
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        Text50002: Label 'Buy from Address';
        Text50005: TextConst ELL = 'Purchase Receipt', ENU = 'Purchase Receipt';

    local procedure SetRecordFilter();
    begin
        case DocType of
            DocType::"Sales Quote", DocType::"Sales Order", DocType::"Sales Invoice",
          DocType::"Sales Credit Memo", DocType::"Sales Return Order":
                FilterSalesHdr;
            DocType::"Purch. Quote", DocType::"Purch. Order", DocType::"Purch. Invoice",
          DocType::"Purch. Credit Memo", DocType::"Purch. Return Order":
                FilterPurchHdr;
            DocType::"Sales Post. Shipment":
                FilterSalesShip;
            DocType::"Sales Post. Invoice":
                FilterSalesInv;
            //+TAL0.1
            DocType::"Purch. Post Receipt":
                FilterPurchReceipt;
        //-TAL0.1
        end;
    end;

    local procedure HandleRec(Nr: Integer);
    begin
        case DocType of
            DocType::"Sales Quote", DocType::"Sales Order", DocType::"Sales Invoice",
            DocType::"Sales Credit Memo", DocType::"Sales Return Order":
                begin
                    if Nr = 1 then
                        SalesHeader.FindSet
                    else
                        SalesHeader.Next;
                    HandleSales;
                end;
            DocType::"Purch. Quote", DocType::"Purch. Order", DocType::"Purch. Invoice",
            DocType::"Purch. Credit Memo", DocType::"Purch. Return Order":
                begin
                    if Nr = 1 then
                        PurchaseHeader.FindSet
                    else
                        PurchaseHeader.Next;
                    HandlePurchase;
                end;
            DocType::"Sales Post. Shipment":
                begin
                    if Nr = 1 then
                        SalesShipmentHdr.FindSet
                    else
                        SalesShipmentHdr.Next;
                    HandleShipment;
                end;
            DocType::"Sales Post. Invoice":
                begin
                    if Nr = 1 then
                        SalesInvoiceHdr.FindSet
                    else
                        SalesInvoiceHdr.Next;
                    HandleInvoice;
                end;

            //+TAL0.1
            DocType::"Purch. Post Receipt":
                begin
                    if Nr = 1 then
                        PurchReceiptHeader.FindSet
                    else
                        PurchReceiptHeader.Next;
                    HandlePurchReceipt;
                end;
        //-TAL0.1
        end;
    end;

    local procedure HandleSales();
    begin
        AddressSalesHdr(SalesHeader);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, SalesHeader."No.",
            Database::"Sales Header", SalesHeader."Document Type");
    end;

    local procedure HandlePurchase();
    begin
        AddressPurchaseHdr(PurchaseHeader);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, PurchaseHeader."No.",
            Database::"Purchase Header", PurchaseHeader."Document Type");
    end;

    local procedure HandleShipment();
    begin
        AddressShipmentHdr(SalesShipmentHdr);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, SalesShipmentHdr."No.",
            Database::"Sales Shipment Header", 0);
    end;

    local procedure HandleInvoice();
    begin
        AddressInvoiceHdr(SalesInvoiceHdr);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, SalesInvoiceHdr."No.",
            Database::"Sales Invoice Header", 0);
    end;

    local procedure AddressSalesHdr(SalesHdr: Record "Sales Header");
    begin
        ShowAddr2 := false;
        case SalesHdr."Document Type" of
            SalesHdr."Document Type"::Invoice, SalesHdr."Document Type"::"Credit Memo":
                begin
                    FormatAddr.SalesHeaderSellTo(Addr, SalesHdr);
                    if SalesHdr."Bill-to Customer No." <> SalesHdr."Sell-to Customer No." then begin
                        FormatAddr.SalesHeaderBillTo(Addr2, SalesHdr);
                        ShowAddr2 := true;
                    end;
                end
            else
                FormatAddr.SalesHeaderBillTo(Addr, SalesHdr);
        end;
        DocumentDate := SalesHdr."Document Date";
        SourceCaption := StrSubstNo('%1 %2 %3', Text006, SalesHdr."Document Type", SalesHdr."No.");
        Addr2Caption := Text003;
    end;

    local procedure AddressPurchaseHdr(PurchaseHdr: Record "Purchase Header");
    begin
        ShowAddr2 := false;
        case PurchaseHdr."Document Type" of
            PurchaseHdr."Document Type"::Quote, PurchaseHdr."Document Type"::"Blanket Order":
                FormatAddr.PurchHeaderPayTo(Addr, PurchaseHdr);
            PurchaseHdr."Document Type"::Order, PurchaseHdr."Document Type"::"Return Order":
                begin
                    FormatAddr.PurchHeaderBuyFrom(Addr, PurchaseHdr);
                    if PurchaseHdr."Buy-from Vendor No." <> PurchaseHdr."Pay-to Vendor No." then begin
                        FormatAddr.PurchHeaderPayTo(Addr2, PurchaseHdr);
                        ShowAddr2 := true;
                    end;
                end;
            PurchaseHdr."Document Type"::Invoice, PurchaseHdr."Document Type"::"Credit Memo":
                begin
                    FormatAddr.PurchHeaderPayTo(Addr, PurchaseHdr);
                    if not (PurchaseHdr."Pay-to Vendor No." in ['', PurchaseHdr."Buy-from Vendor No."]) then begin
                        FormatAddr.PurchHeaderBuyFrom(Addr2, PurchaseHdr);
                        ShowAddr2 := true;
                    end;
                end;
        end;
        DocumentDate := PurchaseHdr."Document Date";
        SourceCaption := StrSubstNo('%1 %2 %3', Text007, PurchaseHdr."Document Type", PurchaseHdr."No.");
        Addr2Caption := Text002;
    end;

    local procedure AddressShipmentHdr(SalesShipHdr: Record "Sales Shipment Header");
    begin
        ShowAddr2 := false;
        FormatAddr.SalesShptShipTo(Addr, SalesShipHdr);
        if SalesShipHdr."Bill-to Customer No." <> SalesShipHdr."Sell-to Customer No." then begin
            FormatAddr.SalesShptBillTo(Addr2, Addr2, SalesShipHdr);
            ShowAddr2 := true;
        end;
        DocumentDate := SalesShipHdr."Document Date";
        SourceCaption := StrSubstNo('%1 %2', Text004, SalesShipHdr."No.");
        Addr2Caption := Text003;
    end;

    local procedure AddressInvoiceHdr(SalesInvHdr: Record "Sales Invoice Header");
    begin
        ShowAddr2 := false;
        FormatAddr.SalesInvBillTo(Addr, SalesInvHdr);
        DocumentDate := SalesInvHdr."Document Date";
        SourceCaption := StrSubstNo('%1 %2', Text005, SalesInvHdr."No.");
        Addr2Caption := Text002;
    end;

    procedure IsStartNewGroup(var TrackingSpecBuffer: Record "Tracking Specification" temporary): Boolean;
    var
        TrackingSpecBuffer2: Record "Tracking Specification" temporary;
        SourceRef: Integer;
    begin
        TrackingSpecBuffer2 := TrackingSpecBuffer;
        SourceRef := TrackingSpecBuffer2."Source Ref. No.";
        if TrackingSpecBuffer.Next = 0 then begin
            TrackingSpecBuffer := TrackingSpecBuffer2;
            exit(true);
        end;
        if SourceRef <> TrackingSpecBuffer."Source Ref. No." then begin
            TrackingSpecBuffer := TrackingSpecBuffer2;
            exit(true);
        end;
        TrackingSpecBuffer := TrackingSpecBuffer2;
        exit(false);
    end;

    local procedure FilterSalesHdr();
    begin
        case DocType of
            DocType::"Sales Quote":
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
            DocType::"Sales Order":
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            DocType::"Sales Invoice":
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
            DocType::"Sales Credit Memo":
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
            DocType::"Sales Return Order":
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
        end;
        if DocNo <> '' then
            SalesHeader.SetFilter("No.", DocNo);
        MainRecCount := SalesHeader.Count;
    end;

    local procedure FilterSalesShip();
    begin
        if DocNo <> '' then
            SalesShipmentHdr.SetRange("No.", DocNo);
        MainRecCount := SalesShipmentHdr.Count;
    end;

    local procedure FilterSalesInv();
    begin
        if DocNo <> '' then
            SalesInvoiceHdr.SetRange("No.", DocNo);
        MainRecCount := SalesInvoiceHdr.Count;
    end;

    local procedure FilterPurchHdr();
    begin
        case DocType of
            DocType::"Purch. Quote":
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
            DocType::"Purch. Order":
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            DocType::"Purch. Invoice":
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
            DocType::"Purch. Credit Memo":
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Credit Memo");
            DocType::"Purch. Return Order":
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Return Order");
        end;
        if DocNo <> '' then
            PurchaseHeader.SetFilter("No.", DocNo);
        MainRecCount := PurchaseHeader.Count;
    end;

    procedure SetPurchPostReceipt(pDocNo: Code[20]);
    begin

        DocType := DocType::"Purch. Post Receipt";
        DocNo := pDocNo;
    end;

    local procedure FilterPurchReceipt();
    begin
        if DocNo <> '' then
            PurchReceiptHeader.SetRange("No.", DocNo);
        MainRecCount := PurchReceiptHeader.Count;
    end;

    local procedure HandlePurchReceipt();
    begin
        AddressPostedPurchReceiptHdr(PurchReceiptHeader);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, PurchReceiptHeader."No.",
            Database::"Purch. Rcpt. Header", 0);
    end;

    local procedure AddressPostedPurchReceiptHdr(PurchaseReceiptHdr: Record "Purch. Rcpt. Header");
    begin
        ShowAddr2 := true;
        FormatAddr.PurchRcptBuyFrom(Addr, PurchaseReceiptHdr);
        DocumentDate := PurchaseReceiptHdr."Document Date";
        SourceCaption := StrSubstNo('%1 %2', Text50005, PurchaseReceiptHdr."No.");
        Addr2Caption := Text50002;
    end;

    procedure SetSalesShipment(pDocNo: Code[20]);
    begin

        DocType := DocType::"Sales Post. Shipment";
        DocNo := pDocNo;
    end;

    procedure SetSalesOrder(pDocNo: Code[20]);
    begin

        DocType := DocType::"Sales Order";
        DocNo := pDocNo;
    end;

    procedure SetPurchaseOrder(pDocNo: Code[20]);
    begin

        DocType := DocType::"Purch. Order";
        DocNo := pDocNo;
    end;
}


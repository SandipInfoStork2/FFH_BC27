table 50006 "Purchase Header Addon"
{
    // version NAVW17.00

    Caption = 'Purchase Header Addon';
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    LookupPageID = "Purchase List Addon";

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") and
                   (xRec."Buy-from Vendor No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := CONFIRM(Text004, false, FIELDCAPTION("Buy-from Vendor No."));
                    if Confirmed then begin
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");
                        if "Buy-from Vendor No." = '' then begin
                            if not PurchLine.ISEMPTY then
                                ERROR(
                                  Text005,
                                  FIELDCAPTION("Buy-from Vendor No."));
                            INIT;
                            PurchSetup.GET;
                            "No. Series" := xRec."No. Series";
                            InitRecord;
                            if xRec."Receiving No." <> '' then begin
                                "Receiving No. Series" := xRec."Receiving No. Series";
                                "Receiving No." := xRec."Receiving No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Shipment No." <> '' then begin
                                "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                                "Return Shipment No." := xRec."Return Shipment No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                        if "Document Type" = "Document Type"::Order then
                            PurchLine.SETFILTER("Quantity Received", '<>0')
                        else
                            if "Document Type" = "Document Type"::Invoice then begin
                                PurchLine.SETRANGE("Buy-from Vendor No.", xRec."Buy-from Vendor No.");
                                PurchLine.SETFILTER("Receipt No.", '<>%1', '');
                            end;
                        if PurchLine.FINDFIRST then
                            if "Document Type" = "Document Type"::Order then
                                PurchLine.TESTFIELD("Quantity Received", 0)
                            else
                                PurchLine.TESTFIELD("Receipt No.", '');

                        PurchLine.SETRANGE("Receipt No.");
                        PurchLine.SETRANGE("Quantity Received");
                        PurchLine.SETRANGE("Buy-from Vendor No.");

                        if "Document Type" = "Document Type"::Order then begin
                            PurchLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
                            if PurchLine.FIND('-') then
                                PurchLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                            PurchLine.SETRANGE("Prepmt. Amt. Inv.");
                        end;

                        if "Document Type" = "Document Type"::"Return Order" then
                            PurchLine.SETFILTER("Return Qty. Shipped", '<>0')
                        else
                            if "Document Type" = "Document Type"::"Credit Memo" then begin
                                PurchLine.SETRANGE("Buy-from Vendor No.", xRec."Buy-from Vendor No.");
                                PurchLine.SETFILTER("Return Shipment No.", '<>%1', '');
                            end;
                        if PurchLine.FINDFIRST then
                            if "Document Type" = "Document Type"::"Return Order" then
                                PurchLine.TESTFIELD("Return Qty. Shipped", 0)
                            else
                                PurchLine.TESTFIELD("Return Shipment No.", '');

                        PurchLine.RESET;
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                GetVend("Buy-from Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, false);
                Vend.TESTFIELD("Gen. Bus. Posting Group");
                "Buy-from Vendor Name" := Vend.Name;
                "Buy-from Vendor Name 2" := Vend."Name 2";
                "Buy-from Address" := Vend.Address;
                "Buy-from Address 2" := Vend."Address 2";
                "Buy-from City" := Vend.City;
                "Buy-from Post Code" := Vend."Post Code";
                "Buy-from County" := Vend.County;
                "Buy-from Country/Region Code" := Vend."Country/Region Code";
                if not SkipBuyFromContact then
                    "Buy-from Contact" := Vend.Contact;
                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                "Tax Area Code" := Vend."Tax Area Code";
                "Tax Liable" := Vend."Tax Liable";
                "VAT Country/Region Code" := Vend."Country/Region Code";
                "VAT Registration No." := Vend."VAT Registration No.";
                VALIDATE("Lead Time Calculation", Vend."Lead Time Calculation");
                "Responsibility Center" := UserSetupMgt.GetRespCenter(1, Vend."Responsibility Center");
                VALIDATE("Sell-to Customer No.", '');
                VALIDATE("Location Code", UserSetupMgt.GetLocation(1, Vend."Location Code", "Responsibility Center"));

                if "Buy-from Vendor No." = xRec."Pay-to Vendor No." then begin
                    if ReceivedPurchLinesExist or ReturnShipmentExist then begin
                        TESTFIELD("VAT Bus. Posting Group", xRec."VAT Bus. Posting Group");
                        TESTFIELD("Gen. Bus. Posting Group", xRec."Gen. Bus. Posting Group");
                    end;
                end;

                "Buy-from IC Partner Code" := Vend."IC Partner Code";
                "Send IC Document" := ("Buy-from IC Partner Code" <> '') and ("IC Direction" = "IC Direction"::Outgoing);

                if Vend."Pay-to Vendor No." <> '' then
                    VALIDATE("Pay-to Vendor No.", Vend."Pay-to Vendor No.")
                else begin
                    if "Buy-from Vendor No." = "Pay-to Vendor No." then
                        SkipPayToContact := true;
                    VALIDATE("Pay-to Vendor No.", "Buy-from Vendor No.");
                    SkipPayToContact := false;
                end;
                "Order Address Code" := '';

                VALIDATE("Order Address Code");


                if (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") or
                   (xRec."Currency Code" <> "Currency Code") or
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreatePurchLines(FIELDCAPTION("Buy-from Vendor No."));


                if not SkipBuyFromContact then
                    UpdateBuyFromCont("Buy-from Vendor No.");
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.GET;
                    NoSeries.TestManual(GetNoSeriesCode());
                    //NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") and
                   (xRec."Pay-to Vendor No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := CONFIRM(Text004, false, FIELDCAPTION("Pay-to Vendor No."));
                    if Confirmed then begin
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");

                        if "Document Type" = "Document Type"::Order then
                            PurchLine.SETFILTER("Quantity Received", '<>0');
                        if "Document Type" = "Document Type"::Invoice then
                            PurchLine.SETFILTER("Receipt No.", '<>%1', '');
                        if PurchLine.FINDFIRST then
                            if "Document Type" = "Document Type"::Order then
                                PurchLine.TESTFIELD("Quantity Received", 0)
                            else
                                PurchLine.TESTFIELD("Receipt No.", '');

                        PurchLine.SETRANGE("Receipt No.");
                        PurchLine.SETRANGE("Quantity Received");

                        if "Document Type" = "Document Type"::Order then begin
                            PurchLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
                            if PurchLine.FIND('-') then
                                PurchLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                            PurchLine.SETRANGE("Prepmt. Amt. Inv.");
                        end;

                        if "Document Type" = "Document Type"::"Return Order" then
                            PurchLine.SETFILTER("Return Qty. Shipped", '<>0');
                        if "Document Type" = "Document Type"::"Credit Memo" then
                            PurchLine.SETFILTER("Return Shipment No.", '<>%1', '');
                        if PurchLine.FINDFIRST then
                            if "Document Type" = "Document Type"::"Return Order" then
                                PurchLine.TESTFIELD("Return Qty. Shipped", 0)
                            else
                                PurchLine.TESTFIELD("Return Shipment No.", '');

                        PurchLine.RESET;
                    end else
                        "Pay-to Vendor No." := xRec."Pay-to Vendor No.";
                end;

                GetVend("Pay-to Vendor No.");
                Vend.CheckBlockedVendOnDocs(Vend, false);
                Vend.TESTFIELD("Vendor Posting Group");

                "Pay-to Name" := Vend.Name;
                "Pay-to Name 2" := Vend."Name 2";
                "Pay-to Address" := Vend.Address;
                "Pay-to Address 2" := Vend."Address 2";
                "Pay-to City" := Vend.City;
                "Pay-to Post Code" := Vend."Post Code";
                "Pay-to County" := Vend.County;
                "Pay-to Country/Region Code" := Vend."Country/Region Code";
                if not SkipPayToContact then
                    "Pay-to Contact" := Vend.Contact;
                "Payment Terms Code" := Vend."Payment Terms Code";
                "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";

                if "Document Type" = "Document Type"::"Credit Memo" then begin
                    "Payment Method Code" := '';
                    if PaymentTerms.GET("Payment Terms Code") then
                        if PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
                            "Payment Method Code" := Vend."Payment Method Code"
                end else
                    "Payment Method Code" := Vend."Payment Method Code";

                "Shipment Method Code" := Vend."Shipment Method Code";
                "Vendor Posting Group" := Vend."Vendor Posting Group";
                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                GLSetup.GET;
                if GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." then begin
                    "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                    "VAT Country/Region Code" := Vend."Country/Region Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                end;
                "Prices Including VAT" := Vend."Prices Including VAT";
                "Currency Code" := Vend."Currency Code";
                "Invoice Disc. Code" := Vend."Invoice Disc. Code";
                "Language Code" := Vend."Language Code";
                "Purchaser Code" := Vend."Purchaser Code";
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
                VALIDATE("Payment Method Code");
                VALIDATE("Currency Code");

                if "Document Type" = "Document Type"::Order then
                    VALIDATE("Prepayment %", Vend."Prepayment %");

                if "Pay-to Vendor No." = xRec."Pay-to Vendor No." then begin
                    if ReceivedPurchLinesExist then
                        TESTFIELD("Currency Code", xRec."Currency Code");
                end;

                // CreateDim(
                //   DATABASE::Vendor, "Pay-to Vendor No.",
                //   DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                //   DATABASE::Campaign, "Campaign No.",
                //   DATABASE::"Responsibility Center", "Responsibility Center");
                CreateDimFromDefaultDim(Rec.FieldNo("Pay-to Vendor No."));

                if (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") and
                   (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.")
                then
                    RecreatePurchLines(FIELDCAPTION("Pay-to Vendor No."));

                if not SkipPayToContact then
                    UpdatePayToCont("Pay-to Vendor No.");

                "Pay-to IC Partner Code" := Vend."IC Partner Code";
            end;
        }
        field(5; "Pay-to Name"; Text[50])
        {
            Caption = 'Pay-to Name';
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7; "Pay-to Address"; Text[50])
        {
            Caption = 'Pay-to Address';
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(9; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = IF ("Pay-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidateCity(
                  "Pay-to City", "Pay-to Post Code", "Pay-to County", "Pay-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(10; "Pay-to Contact"; Text[50])
        {
            Caption = 'Pay-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate();
            begin
                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then begin
                    PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE("Document No.", "No.");
                    PurchLine.SETFILTER("Sales Order Line No.", '<>0');
                    if not PurchLine.ISEMPTY then
                        ERROR(
                          Text006,
                          FIELDCAPTION("Ship-to Code"));
                end;

                if "Ship-to Code" <> '' then begin
                    ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
                    "Ship-to Name" := ShipToAddr.Name;
                    "Ship-to Name 2" := ShipToAddr."Name 2";
                    "Ship-to Address" := ShipToAddr.Address;
                    "Ship-to Address 2" := ShipToAddr."Address 2";
                    "Ship-to City" := ShipToAddr.City;
                    "Ship-to Post Code" := ShipToAddr."Post Code";
                    "Ship-to County" := ShipToAddr.County;
                    "Ship-to Country/Region Code" := ShipToAddr."Country/Region Code";
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                    if ShipToAddr."Location Code" <> '' then
                        VALIDATE("Location Code", ShipToAddr."Location Code");
                end else begin
                    TESTFIELD("Sell-to Customer No.");
                    Cust.GET("Sell-to Customer No.");
                    "Ship-to Name" := Cust.Name;
                    "Ship-to Name 2" := Cust."Name 2";
                    "Ship-to Address" := Cust.Address;
                    "Ship-to Address 2" := Cust."Address 2";
                    "Ship-to City" := Cust.City;
                    "Ship-to Post Code" := Cust."Post Code";
                    "Ship-to County" := Cust.County;
                    "Ship-to Country/Region Code" := Cust."Country/Region Code";
                    "Ship-to Contact" := Cust.Contact;
                    "Shipment Method Code" := Cust."Shipment Method Code";
                    if Cust."Location Code" <> '' then
                        VALIDATE("Location Code", Cust."Location Code");
                end;
            end;
        }
        field(13; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and
                   not ("Order Date" = xRec."Order Date")
                then
                    PriceMessageIfPurchLinesExist(FIELDCAPTION("Order Date"));
            end;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            //InitValue = 20170803D;

            trigger OnValidate();
            begin
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FIELDCAPTION("Posting No."), FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.", "Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."), FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.", "Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."), FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

                VALIDATE("Document Date", "Posting Date");

                if ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) and
                   not ("Posting Date" = xRec."Posting Date")
                then
                    PriceMessageIfPurchLinesExist(FIELDCAPTION("Posting Date"));

                if "Currency Code" <> '' then begin
                    UpdateCurrencyFactor;
                    if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                end;
                if PurchLinesExist then
                    JobUpdatePurchLines;
            end;
        }
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION("Expected Receipt Date"));
            end;
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate();
            begin
                if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.GET("Payment Terms Code");
                    if (("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) and
                        not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        VALIDATE("Due Date", "Document Date");
                        VALIDATE("Pmt. Discount Date", 0D);
                        VALIDATE("Payment Discount %", 0);
                    end else begin
                        "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
                        "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", "Document Date");
                        if not UpdateDocumentDate then
                            VALIDATE("Payment Discount %", PaymentTerms."Discount %")
                    end;
                end else begin
                    VALIDATE("Due Date", "Document Date");
                    if not UpdateDocumentDate then begin
                        VALIDATE("Pmt. Discount Date", 0D);
                        VALIDATE("Payment Discount %", 0);
                    end;
                end;
                if xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" then
                    VALIDATE("Prepmt. Payment Terms Code", "Payment Terms Code");
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                if not (CurrFieldNo in [0, FIELDNO("Posting Date"), FIELDNO("Document Date")]) then
                    TESTFIELD(Status, Status::Open);
                GLSetup.GET;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if ("Location Code" <> xRec."Location Code") and
                   (xRec."Buy-from Vendor No." = "Buy-from Vendor No.")
                then
                    MessageIfPurchLinesExist(FIELDCAPTION("Location Code"));

                UpdateShipToAddress;

                if "Location Code" = '' then begin
                    if InvtSetup.GET then
                        "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                end else begin
                    if Location.GET("Location Code") then;
                    "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                end;
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(31; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                if not (CurrFieldNo in [0, FIELDNO("Posting Date")]) or ("Currency Code" <> xRec."Currency Code") then
                    TESTFIELD(Status, Status::Open);
                if (CurrFieldNo <> FIELDNO("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdatePurchLines(FIELDCAPTION("Currency Factor"));
            end;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate();
            var
                PurchLine: Record "Purchase Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                TESTFIELD(Status, Status::Open);

                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    PurchLine.SETRANGE("Document Type", "Document Type");
                    PurchLine.SETRANGE("Document No.", "No.");
                    PurchLine.SETFILTER("Direct Unit Cost", '<>%1', 0);
                    PurchLine.SETFILTER("VAT %", '<>%1', 0);
                    if PurchLine.FIND('-') then begin
                        RecalculatePrice :=
                          CONFIRM(
                            STRSUBSTNO(
                              Text025 +
                              Text027,
                              FIELDCAPTION("Prices Including VAT"), PurchLine.FIELDCAPTION("Direct Unit Cost")),
                            true);
                        //    PurchLine.SetPurchHeader(Rec);

                        if "Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.GET("Currency Code");

                        repeat
                            PurchLine.TESTFIELD("Quantity Invoiced", 0);
                            PurchLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                            if not RecalculatePrice then begin
                                PurchLine."VAT Difference" := 0;
                                PurchLine.InitOutstandingAmount;
                            end else
                                if "Prices Including VAT" then begin
                                    PurchLine."Direct Unit Cost" :=
                                      ROUND(
                                        PurchLine."Direct Unit Cost" * (1 + PurchLine."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision");
                                    if PurchLine.Quantity <> 0 then begin
                                        PurchLine."Line Discount Amount" :=
                                          ROUND(
                                            PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        PurchLine.VALIDATE("Inv. Discount Amount",
                                          ROUND(
                                            PurchLine."Inv. Discount Amount" * (1 + PurchLine."VAT %" / 100),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end else begin
                                    PurchLine."Direct Unit Cost" :=
                                      ROUND(
                                        PurchLine."Direct Unit Cost" / (1 + PurchLine."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision");
                                    if PurchLine.Quantity <> 0 then begin
                                        PurchLine."Line Discount Amount" :=
                                          ROUND(
                                            PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        PurchLine.VALIDATE("Inv. Discount Amount",
                                          ROUND(
                                            PurchLine."Inv. Discount Amount" / (1 + PurchLine."VAT %" / 100),
                                            Currency."Amount Rounding Precision"));
                                    end;
                                end;
                            PurchLine.MODIFY;
                        until PurchLine.NEXT = 0;
                    end;
                end;
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Invoice Disc. Code"));
            end;
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate();
            begin
                MessageIfPurchLinesExist(FIELDCAPTION("Language Code"));
            end;
        }
        field(43; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            var
                ApprovalEntry: Record "Approval Entry";
            begin
                ApprovalEntry.SETRANGE("Table ID", DATABASE::"Purchase Header");
                ApprovalEntry.SETRANGE("Document Type", "Document Type");
                ApprovalEntry.SETRANGE("Document No.", "No.");
                ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
                if not ApprovalEntry.ISEMPTY then
                    ERROR(Text042, FIELDCAPTION("Purchaser Code"));

                // CreateDim(
                //   DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                //   DATABASE::Vendor, "Pay-to Vendor No.",
                //   DATABASE::Campaign, "Campaign No.",
                //   DATABASE::"Responsibility Center", "Responsibility Center");
                CreateDimFromDefaultDim(Rec.FieldNo("Purchaser Code"));
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            Caption = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                             "No." = FIELD("No."),
                                                             "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup();
            begin
                TESTFIELD("Bal. Account No.", '');
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
                VendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
                VendLedgEntry.SETRANGE(Open, true);
                if "Applies-to Doc. No." <> '' then begin
                    VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                    VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                    if VendLedgEntry.FINDFIRST then;
                    VendLedgEntry.SETRANGE("Document Type");
                    VendLedgEntry.SETRANGE("Document No.");
                end else
                    if "Applies-to Doc. Type" <> 0 then begin
                        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
                        if VendLedgEntry.FINDFIRST then;
                        VendLedgEntry.SETRANGE("Document Type");
                    end else
                        if Amount <> 0 then begin
                            VendLedgEntry.SETRANGE(Positive, Amount < 0);
                            if VendLedgEntry.FINDFIRST then;
                            VendLedgEntry.SETRANGE(Positive);
                        end;
                //ApplyVendEntries.SetPurch(Rec,VendLedgEntry,PurchHeader.FIELDNO("Applies-to Doc. No."));
                ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                ApplyVendEntries.SETRECORD(VendLedgEntry);
                ApplyVendEntries.LOOKUPMODE(true);
                if ApplyVendEntries.RUNMODAL = ACTION::LookupOK then begin
                    ApplyVendEntries.GetVendLedgEntry(VendLedgEntry);
                    GenJnlApply.CheckAgainstApplnCurrency(
                      "Currency Code", VendLedgEntry."Currency Code", GenJnILine."Account Type"::Vendor, true);
                    "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    "Applies-to Doc. No." := VendLedgEntry."Document No.";
                end;
                CLEAR(ApplyVendEntries);
            end;

            trigger OnValidate();
            begin
                if "Applies-to Doc. No." <> '' then
                    TESTFIELD("Bal. Account No.", '');

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Buy-from Vendor No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Buy-from Vendor No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Buy-from Vendor No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Buy-from Vendor No.");
            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";

            trigger OnValidate();
            begin
                if "Bal. Account No." <> '' then
                    case "Bal. Account Type" of
                        "Bal. Account Type"::"G/L Account":
                            begin
                                GLAcc.GET("Bal. Account No.");
                                GLAcc.CheckGLAcc;
                                GLAcc.TESTFIELD("Direct Posting", true);
                            end;
                        "Bal. Account Type"::"Bank Account":
                            begin
                                BankAcc.GET("Bal. Account No.");
                                BankAcc.TESTFIELD(Blocked, false);
                                BankAcc.TESTFIELD("Currency Code", "Currency Code");
                            end;
                    end;
            end;
        }
        field(57; Receive; Boolean)
        {
            Caption = 'Receive';
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(59; "Print Posted Documents"; Boolean)
        {
            Caption = 'Print Posted Documents';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Receiving No."; Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64; "Last Receiving No."; Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
        field(66; "Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(67; "Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(68; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(69; "Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate();
            begin
                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                then begin
                    PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE("Document No.", "No.");
                    PurchLine.SETFILTER("Sales Order Line No.", '<>0');
                    if not PurchLine.ISEMPTY then
                        ERROR(
                          Text006,
                          FIELDCAPTION("Sell-to Customer No."));
                end;

                if "Sell-to Customer No." = '' then
                    VALIDATE("Location Code", UserSetupMgt.GetLocation(1, '', "Responsibility Center"))
                else
                    VALIDATE("Ship-to Code", '');
            end;
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") and
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group")
                then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        RecreatePurchLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                    end;
            end;
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Type"));
            end;
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION("Transport Method"));
            end;
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81; "Buy-from Address"; Text[50])
        {
            Caption = 'Buy-from Address';
        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidateCity(
                  "Buy-from City", "Buy-from Post Code", "Buy-from County", "Buy-from Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(84; "Buy-from Contact"; Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = IF ("Pay-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(
                  "Pay-to City", "Pay-to Post Code", "Pay-to County", "Pay-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(86; "Pay-to County"; Text[30])
        {
            Caption = 'Pay-to County';
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                ModifyPayToVendorAddress();
            end;
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(
                  "Buy-from City", "Buy-from Post Code", "Buy-from County", "Buy-from Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(89; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from County';
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                UpdatePayToAddressFromBuyFromAddress(FieldNo("Pay-to Country/Region Code"));
                ModifyVendorAddress();
            end;
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(92; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";


        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnValidate();
            begin
                if "Order Address Code" <> '' then begin
                    OrderAddr.GET("Buy-from Vendor No.", "Order Address Code");
                    "Buy-from Vendor Name" := OrderAddr.Name;
                    "Buy-from Vendor Name 2" := OrderAddr."Name 2";
                    "Buy-from Address" := OrderAddr.Address;
                    "Buy-from Address 2" := OrderAddr."Address 2";
                    "Buy-from City" := OrderAddr.City;
                    "Buy-from Contact" := OrderAddr.Contact;
                    "Buy-from Post Code" := OrderAddr."Post Code";
                    "Buy-from County" := OrderAddr.County;
                    "Buy-from Country/Region Code" := OrderAddr."Country/Region Code";

                    if ("Document Type" = "Document Type"::"Return Order") or
                       ("Document Type" = "Document Type"::"Credit Memo")
                    then begin
                        "Ship-to Name" := OrderAddr.Name;
                        "Ship-to Name 2" := OrderAddr."Name 2";
                        "Ship-to Address" := OrderAddr.Address;
                        "Ship-to Address 2" := OrderAddr."Address 2";
                        "Ship-to City" := OrderAddr.City;
                        "Ship-to Post Code" := OrderAddr."Post Code";
                        "Ship-to County" := OrderAddr.County;
                        "Ship-to Country/Region Code" := OrderAddr."Country/Region Code";
                        "Ship-to Contact" := OrderAddr.Contact;
                    end
                end else begin
                    GetVend("Buy-from Vendor No.");
                    "Buy-from Vendor Name" := Vend.Name;
                    "Buy-from Vendor Name 2" := Vend."Name 2";
                    "Buy-from Address" := Vend.Address;
                    "Buy-from Address 2" := Vend."Address 2";
                    "Buy-from City" := Vend.City;
                    "Buy-from Contact" := Vend.Contact;
                    "Buy-from Post Code" := Vend."Post Code";
                    "Buy-from County" := Vend.County;
                    "Buy-from Country/Region Code" := Vend."Country/Region Code";

                    if ("Document Type" = "Document Type"::"Return Order") or
                       ("Document Type" = "Document Type"::"Credit Memo")
                    then begin
                        "Ship-to Name" := Vend.Name;
                        "Ship-to Name 2" := Vend."Name 2";
                        "Ship-to Address" := Vend.Address;
                        "Ship-to Address 2" := Vend."Address 2";
                        "Ship-to City" := Vend.City;
                        "Ship-to Post Code" := Vend."Post Code";
                        "Ship-to County" := Vend.County;
                        "Ship-to Country/Region Code" := Vend."Country/Region Code";
                        "Ship-to Contact" := Vend.Contact;
                        "Shipment Method Code" := Vend."Shipment Method Code";
                        if Vend."Location Code" <> '' then
                            VALIDATE("Location Code", Vend."Location Code");
                    end
                end;
            end;
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION("Entry Point"));
            end;
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate();
            begin
                if xRec."Document Date" <> "Document Date" then
                    UpdateDocumentDate := true;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
            end;
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION(Area));
            end;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate();
            begin
                UpdatePurchLines(FIELDCAPTION("Transaction Specification"));
            end;
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate();
            begin
                PaymentMethod.INIT;
                if "Payment Method Code" <> '' then
                    PaymentMethod.GET("Payment Method Code");
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";
                if "Bal. Account No." <> '' then begin
                    TESTFIELD("Applies-to Doc. No.", '');
                    TESTFIELD("Applies-to ID", '');
                end;
            end;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                with PurchHeader do begin
                    //  PurchHeader := Rec;
                    PurchSetup.GET;
                    TestNoSeries;
                    //if NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") then
                    if NoSeries.LookupRelatedNoSeries(GetPostingNoSeriesCode(), PurchHeader."Posting No. Series") then
                        VALIDATE("Posting No. Series");
                    //  Rec := PurchHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                    PurchSetup.GET;
                    TestNoSeries;
                    //NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                    NoSeries.TestAreRelated(GetPostingNoSeriesCode(), "Posting No. Series");
                end;
                TESTFIELD("Posting No.", '');
            end;
        }
        field(109; "Receiving No. Series"; Code[10])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                with PurchHeader do begin
                    //  PurchHeader := Rec;
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Receipt Nos.");
                    //if NoSeriesMgt.LookupSeries(PurchSetup."Posted Receipt Nos.", "Receiving No. Series") then
                    if NoSeries.LookupRelatedNoSeries(PurchSetup."Posted Receipt Nos.", PurchHeader."Receiving No. Series") then
                        VALIDATE("Receiving No. Series");
                    //  Rec := PurchHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Receiving No. Series" <> '' then begin
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Receipt Nos.");
                    //NoSeriesMgt.TestSeries(PurchSetup."Posted Receipt Nos.", "Receiving No. Series");
                    NoSeries.TestAreRelated(PurchSetup."Posted Receipt Nos.", "Receiving No. Series");
                end;
                TESTFIELD("Receiving No.", '');
            end;
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Area Code"));
            end;
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                MessageIfPurchLinesExist(FIELDCAPTION("Tax Liable"));
            end;
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") and
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreatePurchLines(FIELDCAPTION("VAT Bus. Posting Group"));
            end;
        }
        field(118; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate();
            var
                TempVendLedgEntry: Record "Vendor Ledger Entry";
            begin
                if "Applies-to ID" <> '' then
                    TESTFIELD("Bal. Account No.", '');
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                    VendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
                    VendLedgEntry.SETRANGE(Open, true);
                    VendLedgEntry.SETRANGE("Applies-to ID", xRec."Applies-to ID");
                    if VendLedgEntry.FINDFIRST then
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    VendLedgEntry.RESET;
                end;
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                GLSetup.GET;
                if "VAT Base Discount %" > GLSetup."VAT Tolerance %" then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed :=
                          CONFIRM(
                            Text007 +
                            Text008, false,
                            FIELDCAPTION("VAT Base Discount %"),
                            GLSetup.FIELDCAPTION("VAT Tolerance %"),
                            GLSetup.TABLECAPTION);
                    if not Confirmed then
                        "VAT Base Discount %" := xRec."VAT Base Discount %";
                end;

                if ("VAT Base Discount %" = xRec."VAT Base Discount %") and
                   (CurrFieldNo <> 0)
                then
                    exit;

                PurchLine.SETRANGE("Document Type", "Document Type");
                PurchLine.SETRANGE("Document No.", "No.");
                PurchLine.SETFILTER(Type, '<>%1', PurchLine.Type::" ");
                PurchLine.SETFILTER(Quantity, '<>0');
                PurchLine.LOCKTABLE;
                if PurchLine.FINDSET then begin
                    MODIFY;
                    repeat
                        PurchLine.UpdateAmounts;
                        PurchLine.MODIFY;
                    until PurchLine.NEXT = 0;
                end;
                PurchLine.RESET;
            end;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';

            trigger OnValidate();
            begin
                if "Send IC Document" then begin
                    TESTFIELD("Buy-from IC Partner Code");
                    TESTFIELD("IC Direction", "IC Direction"::Outgoing);
                end;
            end;
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Buy-from IC Partner Code"; Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Pay-to IC Partner Code"; Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;

            trigger OnValidate();
            begin
                if "IC Direction" = "IC Direction"::Incoming then
                    "Send IC Document" := false;
            end;
        }
        field(130; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(131; "Last Prepayment No."; Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Purch. Inv. Header";
        }
        field(132; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(133; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(134; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                if CurrFieldNo <> 0 then
                    UpdatePurchLines(FIELDCAPTION("Prepayment %"));
            end;
        }
        field(135; "Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                with PurchHeader do begin
                    //  PurchHeader := Rec;
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                    //if NoSeriesMgt.LookupSeries(PurchSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series") then
                    if NoSeries.LookupRelatedNoSeries(PurchSetup."Posted Prepmt. Inv. Nos.", PurchHeader."Prepayment No. Series") then
                        VALIDATE("Prepayment No. Series");
                    //  Rec := PurchHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Prepayment No. Series" <> '' then begin
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                    //NoSeriesMgt.TestSeries(PurchSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series");
                    NoSeries.TestAreRelated(PurchSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series");
                end;
                TESTFIELD("Prepayment No. Series", '');
            end;
        }
        field(136; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(137; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(138; "Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                with PurchHeader do begin
                    //  PurchHeader := Rec;
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                    //if NoSeriesMgt.LookupSeries(PurchSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No. Series") then
                    if NoSeries.LookupRelatedNoSeries(PurchSetup."Posted Prepmt. Cr. Memo Nos.", PurchHeader."Prepmt. Cr. Memo No. Series") then
                        VALIDATE("Prepmt. Cr. Memo No. Series");
                    //  Rec := PurchHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Prepmt. Cr. Memo No. Series" <> '' then begin
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                    //NoSeriesMgt.TestSeries(PurchSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No. Series");
                    NoSeries.TestAreRelated(PurchSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No. Series");
                end;
                TESTFIELD("Prepmt. Cr. Memo No. Series", '');
            end;
        }
        field(139; "Prepmt. Posting Description"; Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(142; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(143; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate();
            var
                PaymentTerms: Record "Payment Terms";
            begin
                if ("Prepmt. Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.GET("Prepmt. Payment Terms Code");
                    if (("Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) and
                        not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        VALIDATE("Prepayment Due Date", "Document Date");
                        VALIDATE("Prepmt. Pmt. Discount Date", 0D);
                        VALIDATE("Prepmt. Payment Discount %", 0);
                    end else begin
                        "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
                        "Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", "Document Date");
                        if not UpdateDocumentDate then
                            VALIDATE("Prepmt. Payment Discount %", PaymentTerms."Discount %")
                    end;
                end else begin
                    VALIDATE("Prepayment Due Date", "Document Date");
                    if not UpdateDocumentDate then begin
                        VALIDATE("Prepmt. Pmt. Discount Date", 0D);
                        VALIDATE("Prepmt. Payment Discount %", 0);
                    end;
                end;
            end;
        }
        field(144; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                if not (CurrFieldNo in [0, FIELDNO("Posting Date"), FIELDNO("Document Date")]) then
                    TESTFIELD(Status, Status::Open);
                GLSetup.GET;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                VALIDATE("VAT Base Discount %");
            end;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(160; "Job Queue Status"; Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = '" ,Scheduled for Posting,Error,Posting"';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup();
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
                if "Job Queue Status" = "Job Queue Status"::" " then
                    exit;
                JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
            end;
        }
        field(161; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDocDim;
            end;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = Max("Purchase Header Archive"."Version No." WHERE("Document Type" = FIELD("Document Type"),
                                                                             "No." = FIELD("No."),
                                                                             "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate();
            begin
                // CreateDim(
                //   DATABASE::Campaign, "Campaign No.",
                //   DATABASE::Vendor, "Pay-to Vendor No.",
                //   DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                //   DATABASE::"Responsibility Center", "Responsibility Center");
                CreateDimFromDefaultDim(Rec.FieldNo("Campaign No."));
            end;
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Buy-from Vendor No." <> '' then begin
                    if Cont.GET("Buy-from Contact No.") then
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.RESET;
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
                        ContBusinessRelation.SETRANGE("No.", "Buy-from Vendor No.");
                        if ContBusinessRelation.FINDFIRST then
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SETRANGE("No.", '');
                    end;
                end;

                if "Buy-from Contact No." <> '' then
                    if Cont.GET("Buy-from Contact No.") then;
                if PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    VALIDATE("Buy-from Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                TESTFIELD(Status, Status::Open);

                if ("Buy-from Contact No." <> xRec."Buy-from Contact No.") and
                   (xRec."Buy-from Contact No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := CONFIRM(Text004, false, FIELDCAPTION("Buy-from Contact No."));
                    if Confirmed then begin
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");
                        if ("Buy-from Contact No." = '') and ("Buy-from Vendor No." = '') then begin
                            if not PurchLine.ISEMPTY then
                                ERROR(
                                  Text005,
                                  FIELDCAPTION("Buy-from Contact No."));
                            INIT;
                            PurchSetup.GET;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Receiving No." <> '' then begin
                                "Receiving No. Series" := xRec."Receiving No. Series";
                                "Receiving No." := xRec."Receiving No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Shipment No." <> '' then begin
                                "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                                "Return Shipment No." := xRec."Return Shipment No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Buy-from Vendor No." <> '') and ("Buy-from Contact No." <> '') then begin
                    Cont.GET("Buy-from Contact No.");
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
                    ContBusinessRelation.SETRANGE("No.", "Buy-from Vendor No.");
                    if ContBusinessRelation.FINDFIRST then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            ERROR(Text038, Cont."No.", Cont.Name, "Buy-from Vendor No.");
                end;

                UpdateBuyFromVend("Buy-from Contact No.");
            end;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Pay-to Vendor No." <> '' then begin
                    if Cont.GET("Pay-to Contact No.") then
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.RESET;
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
                        ContBusinessRelation.SETRANGE("No.", "Pay-to Vendor No.");
                        if ContBusinessRelation.FINDFIRST then
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SETRANGE("No.", '');
                    end;
                end;

                if "Pay-to Contact No." <> '' then
                    if Cont.GET("Pay-to Contact No.") then;
                if PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    VALIDATE("Pay-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                TESTFIELD(Status, Status::Open);

                if ("Pay-to Contact No." <> xRec."Pay-to Contact No.") and
                   (xRec."Pay-to Contact No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := CONFIRM(Text004, false, FIELDCAPTION("Pay-to Contact No."));
                    if Confirmed then begin
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");
                        if ("Pay-to Contact No." = '') and ("Pay-to Vendor No." = '') then begin
                            if not PurchLine.ISEMPTY then
                                ERROR(
                                  Text005,
                                  FIELDCAPTION("Pay-to Contact No."));
                            INIT;
                            PurchSetup.GET;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Receiving No." <> '' then begin
                                "Receiving No. Series" := xRec."Receiving No. Series";
                                "Receiving No." := xRec."Receiving No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Shipment No." <> '' then begin
                                "Return Shipment No. Series" := xRec."Return Shipment No. Series";
                                "Return Shipment No." := xRec."Return Shipment No.";
                            end;
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            exit;
                        end;
                    end else begin
                        "Pay-to Contact No." := xRec."Pay-to Contact No.";
                        exit;
                    end;
                end;

                if ("Pay-to Vendor No." <> '') and ("Pay-to Contact No." <> '') then begin
                    Cont.GET("Pay-to Contact No.");
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
                    ContBusinessRelation.SETRANGE("No.", "Pay-to Vendor No.");
                    if ContBusinessRelation.FINDFIRST then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            ERROR(Text038, Cont."No.", Cont.Name, "Pay-to Vendor No.");
                end;

                UpdatePayToVend("Pay-to Contact No.");
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if not UserSetupMgt.CheckRespCenter(1, "Responsibility Center") then
                    ERROR(
                      Text028,
                      RespCenter.TABLECAPTION, UserSetupMgt.GetPurchasesFilter);

                "Location Code" := UserSetupMgt.GetLocation(1, '', "Responsibility Center");
                if "Location Code" = '' then begin
                    if InvtSetup.GET then
                        "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                end else begin
                    if Location.GET("Location Code") then;
                    "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                end;

                UpdateShipToAddress;

                // CreateDim(
                //   DATABASE::"Responsibility Center", "Responsibility Center",
                //   DATABASE::Vendor, "Pay-to Vendor No.",
                //   DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                //   DATABASE::Campaign, "Campaign No.");
                CreateDimFromDefaultDim(Rec.FieldNo("Responsibility Center"));

                if xRec."Responsibility Center" <> "Responsibility Center" then begin
                    RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                    "Assigned User ID" := '';
                end;
            end;
        }
        field(5752; "Completely Received"; Boolean)
        {
            CalcFormula = Min("Purchase Line"."Completely Received" WHERE("Document Type" = FIELD("Document Type"),
                                                                           "Document No." = FIELD("No."),
                                                                           Type = FILTER(<> " "),
                                                                           "Location Code" = FIELD("Location Filter")));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Promised Receipt Date" <> 0D then
                    ERROR(
                      Text034,
                      FIELDCAPTION("Requested Receipt Date"),
                      FIELDCAPTION("Promised Receipt Date"));

                if "Requested Receipt Date" <> xRec."Requested Receipt Date" then
                    UpdatePurchLines(FIELDCAPTION("Requested Receipt Date"));
            end;
        }
        field(5791; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Promised Receipt Date" <> xRec."Promised Receipt Date" then
                    UpdatePurchLines(FIELDCAPTION("Promised Receipt Date"));
            end;
        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Lead Time Calculation" <> xRec."Lead Time Calculation" then
                    UpdatePurchLines(FIELDCAPTION("Lead Time Calculation"));
            end;
        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                if "Inbound Whse. Handling Time" <> xRec."Inbound Whse. Handling Time" then
                    UpdatePurchLines(FIELDCAPTION("Inbound Whse. Handling Time"));
            end;
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800; "Vendor Authorization No."; Code[35])
        {
            Caption = 'Vendor Authorization No.';
        }
        field(5801; "Return Shipment No."; Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802; "Return Shipment No. Series"; Code[10])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                with PurchHeader do begin
                    //  PurchHeader := Rec;
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                    //if NoSeriesMgt.LookupSeries(PurchSetup."Posted Return Shpt. Nos.", "Return Shipment No. Series") then
                    if NoSeries.LookupRelatedNoSeries(PurchSetup."Posted Return Shpt. Nos.", PurchHeader."Return Shipment No. Series") then
                        VALIDATE("Return Shipment No. Series");
                    //  Rec := PurchHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Return Shipment No. Series" <> '' then begin
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                    //NoSeriesMgt.TestSeries(PurchSetup."Posted Return Shpt. Nos.", "Return Shipment No. Series");
                    NoSeries.TestAreRelated(PurchSetup."Posted Return Shpt. Nos.", "Return Shipment No. Series");
                end;
                TESTFIELD("Return Shipment No.", '');
            end;
        }
        field(5803; Ship; Boolean)
        {
            Caption = 'Ship';
        }
        field(5804; "Last Return Shipment No."; Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate();
            begin
                if not UserSetupMgt.CheckRespCenter(1, "Responsibility Center", "Assigned User ID") then
                    ERROR(
                      Text049, "Assigned User ID",
                      RespCenter.TABLECAPTION, UserSetupMgt.GetPurchasesFilter("Assigned User ID"));
            end;
        }
        field(50000; bPosted; Boolean)
        {
        }
        field(50001; bEnabled; Boolean)
        {
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "No.", "Document Type")
        {
        }
        key(Key3; "Document Type", "Buy-from Vendor No.")
        {
        }
        key(Key4; "Document Type", "Pay-to Vendor No.")
        {
        }
        key(Key5; "Buy-from Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        POLines.SETRANGE("Document No.", "No.");
        if POLines.FIND('-') then
            repeat
                POLines.DELETE;
            until POLines.NEXT = 0;
    end;

    trigger OnInsert();
    var
        PurchaseHeader2: Record "Purchase Header";
        NoSeriesCode: Code[20];
    begin
        if "No." = '' then begin
            TestNoSeries;
            //NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
            NoSeriesCode := GetNoSeriesCode();
            "No. Series" := NoSeriesCode;
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
            PurchaseHeader2.SetLoadFields("No.");
            while PurchaseHeader2.Get("Document Type", "No.") do
                "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
        end;

        InitRecord;

        if GETFILTER("Buy-from Vendor No.") <> '' then
            if GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") then
                VALIDATE("Buy-from Vendor No.", GETRANGEMIN("Buy-from Vendor No."));

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header", "Document Type", "No.");

        "Posting Date" := TODAY;
    end;

    trigger OnModify();
    begin
        //IF bPosted THEN
        //BEGIN
        //MESSAGE('You cannot modify posted record');
        //Rec:=xRec;
        //END;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    var
        Text000: Label 'Do you want to print receipt %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more sales orders.';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label '"Deleting this document will cause a gap in the number series for receipts. "';
        Text010: Label 'An empty receipt %1 will be created to fill this gap in the number series.\\';
        Text011: Label 'Do you want to continue?';
        Text012: Label '"Deleting this document will cause a gap in the number series for posted invoices. "';
        Text013: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text014: Label '"Deleting this document will cause a gap in the number series for posted credit memos. "';
        Text015: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text016: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        Text019: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
        Text020: Label 'You must update the existing purchase lines manually.';
        Text021: Label 'The change may affect the exchange rate used on the price calculation of the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: Label 'Do you want to print return shipment %1?';
        Text025: Label '"You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. "';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label '"Deleting this document will cause a gap in the number series for return shipments. "';
        Text030: Label 'An empty return shipment %1 will be created to fill this gap in the number series.\\';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        PurchLine: Record "Purchase Line Addon";
        xPurchLine: Record "Purchase Line Addon";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchHeader: Record "Purchase Header Addon";
        PurchCommentLine: Record "Purch. Comment Line";
        ShipToAddr: Record "Ship-to Address";
        Cust: Record Customer;
        CompanyInfo: Record "Company Information";
        PostCode: Record "Post Code";
        OrderAddr: Record "Order Address";
        BankAcc: Record "Bank Account";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeaderPrepmt: Record "Purch. Inv. Header";
        PurchCrMemoHeaderPrepmt: Record "Purch. Cr. Memo Hdr.";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenJnILine: Record "Gen. Journal Line";
        RespCenter: Record "Responsibility Center";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        InvtSetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        UserSetupMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ApplyVendEntries: Page "Apply Vendor Entries";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        SkipBuyFromContact: Boolean;
        SkipPayToContact: Boolean;
        Text040: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text041: Label 'The purchase %1 %2 has item tracking. Do you want to delete it anyway?';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text043: Label 'Do you want to print prepayment invoice %1?';
        Text044: Label 'Do you want to print prepayment credit memo %1?';
        Text045: Label '"Deleting this document will cause a gap in the number series for prepayment invoices. "';
        Text046: Label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        Text047: Label '"Deleting this document will cause a gap in the number series for prepayment credit memos. "';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
        NameAddressDetails: Text[512];
        NameAddressDetails2: Text[512];
        UpdateDocumentDate: Boolean;
        Text053: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text054: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        POLines: Record "Purchase Line Addon";

        ModifyVendorAddressNotificationLbl: Label 'Update the address';
        ModifyVendorAddressNotificationMsg: Label 'The address you entered for %1 is different from the Vendor''s existing address.', Comment = '%1=Vendor name';
        DontShowAgainActionLbl: Label 'Don''t show again';

    procedure InitPostingNoSeries()
    var
        PostingNoSeries: Code[20];
    begin
        GLSetup.GetRecordOnce();
        if IsCreditDocType() then
            PostingNoSeries := PurchSetup."Posted Credit Memo Nos."
        else
            PostingNoSeries := PurchSetup."Posted Invoice Nos.";

        case "Document Type" of
            "Document Type"::Quote, "Document Type"::Order:
                begin
                    if NoSeries.IsAutomatic(PostingNoSeries) then
                        "Posting No. Series" := PostingNoSeries;
                    if NoSeries.IsAutomatic(PurchSetup."Posted Receipt Nos.") then
                        "Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                    if "Document Type" = "Document Type"::Order then begin
                        if NoSeries.IsAutomatic(PurchSetup."Posted Prepmt. Inv. Nos.") then
                            "Prepayment No. Series" := PurchSetup."Posted Prepmt. Inv. Nos.";
                        if NoSeries.IsAutomatic(PurchSetup."Posted Prepmt. Cr. Memo Nos.") then
                            "Prepmt. Cr. Memo No. Series" := PurchSetup."Posted Prepmt. Cr. Memo Nos.";
                    end;
                end;
            "Document Type"::Invoice:
                begin
                    if ("No. Series" <> '') and (PurchSetup."Invoice Nos." = PostingNoSeries) then
                        "Posting No. Series" := "No. Series"
                    else
                        if NoSeries.IsAutomatic(PostingNoSeries) then
                            "Posting No. Series" := PostingNoSeries;
                    if PurchSetup."Receipt on Invoice" then
                        if NoSeries.IsAutomatic(PurchSetup."Posted Receipt Nos.") then
                            "Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                end;
            "Document Type"::"Return Order":
                begin
                    if NoSeries.IsAutomatic(PostingNoSeries) then
                        "Posting No. Series" := PostingNoSeries;
                    if NoSeries.IsAutomatic(PurchSetup."Posted Return Shpt. Nos.") then
                        "Return Shipment No. Series" := PurchSetup."Posted Return Shpt. Nos.";
                end;
            "Document Type"::"Credit Memo":
                begin
                    if ("No. Series" <> '') and (PurchSetup."Credit Memo Nos." = PostingNoSeries) then
                        "Posting No. Series" := "No. Series"
                    else
                        if NoSeries.IsAutomatic(PostingNoSeries) then
                            "Posting No. Series" := PostingNoSeries;
                    if PurchSetup."Return Shipment on Credit Memo" then
                        if NoSeries.IsAutomatic(PurchSetup."Posted Return Shpt. Nos.") then
                            "Return Shipment No. Series" := PurchSetup."Posted Return Shpt. Nos.";
                end;
        end;
    end;

    procedure InitRecord();
    begin
        PurchSetup.GET;

        // case "Document Type" of
        //     "Document Type"::Quote, "Document Type"::Order:
        //         begin
        //             NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchSetup."Posted Invoice Nos.");
        //             NoSeriesMgt.SetDefaultSeries("Receiving No. Series", PurchSetup."Posted Receipt Nos.");
        //             if "Document Type" = "Document Type"::Order then begin
        //                 NoSeriesMgt.SetDefaultSeries("Prepayment No. Series", PurchSetup."Posted Prepmt. Inv. Nos.");
        //                 NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series", PurchSetup."Posted Prepmt. Cr. Memo Nos.");
        //             end;
        //         end;
        //     "Document Type"::Invoice:
        //         begin
        //             if ("No. Series" <> '') and
        //                (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.")
        //             then
        //                 "Posting No. Series" := "No. Series"
        //             else
        //                 NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchSetup."Posted Invoice Nos.");
        //             if PurchSetup."Receipt on Invoice" then
        //                 NoSeriesMgt.SetDefaultSeries("Receiving No. Series", PurchSetup."Posted Receipt Nos.");
        //         end;
        //     "Document Type"::"Return Order":
        //         begin
        //             NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchSetup."Posted Credit Memo Nos.");
        //             NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series", PurchSetup."Posted Return Shpt. Nos.");
        //         end;
        //     "Document Type"::"Credit Memo":
        //         begin
        //             if ("No. Series" <> '') and
        //                (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.")
        //             then
        //                 "Posting No. Series" := "No. Series"
        //             else
        //                 NoSeriesMgt.SetDefaultSeries("Posting No. Series", PurchSetup."Posted Credit Memo Nos.");
        //             if PurchSetup."Return Shipment on Credit Memo" then
        //                 NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series", PurchSetup."Posted Return Shpt. Nos.");
        //         end;
        // end;

        InitPostingNoSeries;

        if "Document Type" in ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Return Order"] then
            "Order Date" := WORKDATE;

        if "Document Type" = "Document Type"::Invoice then
            "Expected Receipt Date" := WORKDATE;

        if not ("Document Type" in ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
           ("Posting Date" = 0D)
        then
            "Posting Date" := WORKDATE;

        if PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" then
            "Posting Date" := 0D;

        "Document Date" := WORKDATE;

        VALIDATE("Sell-to Customer No.", '');

        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
            GLSetup.GET;
            Correction := GLSetup."Mark Cr. Memos as Corrections";
        end;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        if InvtSetup.GET then
            "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";

        "Responsibility Center" := UserSetupMgt.GetRespCenter(1, "Responsibility Center");
    end;

    procedure AssistEdit(OldPurchHeader: Record "Purchase Header"): Boolean;
    begin
        PurchSetup.GET;
        TestNoSeries;
        // if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldPurchHeader."No. Series", "No. Series") then begin
        //     PurchSetup.GET;
        //     TestNoSeries;
        //     NoSeriesMgt.SetSeries("No.");
        //     exit(true);
        // end;
        if NoSeries.LookupRelatedNoSeries(GetNoSeriesCode(), OldPurchHeader."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    local procedure TestNoSeries(): Boolean;
    begin
        PurchSetup.GET;
        case "Document Type" of
            "Document Type"::Quote:
                PurchSetup.TESTFIELD("Quote Nos.");
            "Document Type"::Order:
                PurchSetup.TESTFIELD("Order Nos.");
            "Document Type"::Invoice:
                begin
                    PurchSetup.TESTFIELD("Invoice Nos.");
                    PurchSetup.TESTFIELD("Posted Invoice Nos.");
                end;
            "Document Type"::"Return Order":
                PurchSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Memo":
                begin
                    PurchSetup.TESTFIELD("Credit Memo Nos.");
                    PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
                end;
            "Document Type"::"Blanket Order":
                PurchSetup.TESTFIELD("Blanket Order Nos.");
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10];
    begin
        case "Document Type" of
            "Document Type"::Quote:
                exit(PurchSetup."Quote Nos.");
            "Document Type"::Order:
                exit(PurchSetup."Order Nos.");
            "Document Type"::Invoice:
                exit(PurchSetup."Invoice Nos.");
            "Document Type"::"Return Order":
                exit(PurchSetup."Return Order Nos.");
            "Document Type"::"Credit Memo":
                exit(PurchSetup."Credit Memo Nos.");
            "Document Type"::"Blanket Order":
                exit(PurchSetup."Blanket Order Nos.");
        end;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10];
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit(PurchSetup."Posted Credit Memo Nos.");
        exit(PurchSetup."Posted Invoice Nos.");
    end;

    local procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[10]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024]);
    var
        NoSeries: Record "No. Series";
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.GET(NoSeriesCode);
            if NoSeries."Date Order" then
                ERROR(
                  Text040,
                  FIELDCAPTION("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  NoSeries.FIELDCAPTION("Date Order"), NoSeries."Date Order", "Document Type",
                  NoCapt, No);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        //PurchPost.TestDeleteHeader(
        //Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
        //ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
        if PurchRcptHeader."No." <> '' then
            if not CONFIRM(
                 Text009 +
                 Text010 +
                 Text011, true,
                 PurchRcptHeader."No.")
            then
                exit;
        if PurchInvHeader."No." <> '' then
            if not CONFIRM(
                 Text012 +
                 Text013 +
                 Text011, true,
                 PurchInvHeader."No.")
            then
                exit;
        if PurchCrMemoHeader."No." <> '' then
            if not CONFIRM(
                 Text014 +
                 Text015 +
                 Text011, true,
                 PurchCrMemoHeader."No.")
            then
                exit;
        if ReturnShptHeader."No." <> '' then
            if not CONFIRM(
                 Text029 +
                 Text030 +
                 Text011, true,
                 ReturnShptHeader."No.")
            then
                exit;
        if "Prepayment No." <> '' then
            if not CONFIRM(
                 Text044 +
                 Text045 +
                 Text011, true,
                 PurchInvHeaderPrepmt."No.")
            then
                exit;
        if "Prepmt. Cr. Memo No." <> '' then
            if not CONFIRM(
                 Text046 +
                 Text047 +
                 Text011, true,
                 PurchCrMemoHeaderPrepmt."No.")
            then
                exit;
        exit(true);
    end;

    local procedure GetVend(VendNo: Code[20]);
    begin
        if VendNo <> Vend."No." then
            Vend.GET(VendNo);
    end;

    procedure PurchLinesExist(): Boolean;
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        exit(PurchLine.FINDFIRST);
    end;

    procedure RecreatePurchLines(ChangedFieldName: Text[100]);
    var
        //PurchLineTmp : Record Table50039 temporary;
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        TempInteger: Record "Integer" temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ExtendedTextAdded: Boolean;
    begin
        if (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") and (xRec."Buy-from Vendor No." <> '') then begin
            //Check if lines are created.

            POLines.RESET;
            POLines.SETRANGE("Document Type", "Document Type");
            POLines.SETRANGE("Document No.", "No.");
            if POLines.FINDSET then begin
                ERROR('TalosCo. Cannot rename vendor. Delete the document and create again with the correct vendor.');
            end;

        end;
        //IF PurchLinesExist THEN BEGIN
        //  IF HideValidationDialog THEN
        //Confirmed := TRUE
        //  ELSE
        //Confirmed :=
        //  CONFIRM(
        //Text016 +
        //Text004,FALSE,ChangedFieldName);
        //  IF Confirmed THEN BEGIN
        //PurchLine.LOCKTABLE;
        //ItemChargeAssgntPurch.LOCKTABLE;
        //MODIFY;

        //PurchLine.RESET;
        //PurchLine.SETRANGE("Document Type","Document Type");
        //PurchLine.SETRANGE("Document No.","No.");
        //IF PurchLine.FINDSET THEN BEGIN
        //  REPEAT
        //PurchLine.TESTFIELD("Quantity Received",0);
        //PurchLine.TESTFIELD("Quantity Invoiced",0);
        //PurchLine.TESTFIELD("Return Qty. Shipped",0);
        //PurchLine.CALCFIELDS("Reserved Qty. (Base)");
        //PurchLine.TESTFIELD("Reserved Qty. (Base)",0);
        //PurchLine.TESTFIELD("Receipt No.",'');
        //PurchLine.TESTFIELD("Return Shipment No.",'');
        //PurchLine.TESTFIELD("Blanket Order No.",'');
        //IF PurchLine."Drop Shipment" OR PurchLine."Special Order" THEN BEGIN
        //  CASE TRUE OF
        //PurchLine."Drop Shipment":
        //  SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Sales Order No.");
        //PurchLine."Special Order":
        //  SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Special Order Sales No.");
        //  END;
        //  TESTFIELD("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
        //  TESTFIELD("Ship-to Code",SalesHeader."Ship-to Code");
        //END;

        //PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
        //PurchLineTmp := PurchLine;
        //IF PurchLine.Nonstock THEN BEGIN
        //  PurchLine.Nonstock := FALSE;
        //  PurchLine.MODIFY;
        //END;
        //PurchLineTmp.INSERT;
        //  UNTIL PurchLine.NEXT = 0;

        //  ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        //  ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
        //  IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
        //REPEAT
        //  TempItemChargeAssgntPurch.INIT;
        //  TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
        //  TempItemChargeAssgntPurch.INSERT;
        //UNTIL ItemChargeAssgntPurch.NEXT = 0;
        //ItemChargeAssgntPurch.DELETEALL;
        //  END;

        //  PurchLine.DELETEALL(TRUE);

        //  PurchLine.INIT;
        //  PurchLine."Line No." := 0;
        //  PurchLineTmp.FINDSET;
        //  ExtendedTextAdded := FALSE;
        //  REPEAT
        //IF PurchLineTmp."Attached to Line No." = 0 THEN BEGIN
        //  PurchLine.INIT;
        //  PurchLine."Line No." := PurchLine."Line No." + 10000;
        //  PurchLine.VALIDATE(Type,PurchLineTmp.Type);
        //  IF PurchLineTmp."No." = '' THEN BEGIN
        //PurchLine.VALIDATE(Description,PurchLineTmp.Description);
        //PurchLine.VALIDATE("Description 2",PurchLineTmp."Description 2");
        //PurchLine.INSERT;
        //  END ELSE BEGIN
        //PurchLine.VALIDATE("No.",PurchLineTmp."No.");
        //IF PurchLine.Type <> PurchLine.Type::" " THEN
        //  CASE TRUE OF
        //PurchLineTmp."Drop Shipment":
        //  BEGIN
        //SalesLine.GET(SalesLine."Document Type"::Order,
        //  PurchLineTmp."Sales Order No.",
        //  PurchLineTmp."Sales Order Line No.");
        //CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
        //PurchLine."Drop Shipment" := PurchLineTmp."Drop Shipment";
        //PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
        //PurchLine."Sales Order No." := PurchLineTmp."Sales Order No.";
        //PurchLine."Sales Order Line No." := PurchLineTmp."Sales Order Line No.";
        //EVALUATE(PurchLine."Inbound Whse. Handling Time",'<0D>');
        //PurchLine.VALIDATE("Inbound Whse. Handling Time");
        //PurchLine.INSERT;

        //SalesLine.VALIDATE("Unit Cost (LCY)",PurchLine."Unit Cost (LCY)");
        //SalesLine."Purchase Order No." := PurchLine."Document No.";
        //SalesLine."Purch. Order Line No." := PurchLine."Line No.";
        //SalesLine.MODIFY;
        //  END;
        //PurchLineTmp."Special Order":
        //  BEGIN
        //SalesLine.GET(SalesLine."Document Type"::Order,
        //  PurchLineTmp."Special Order Sales No.",
        //  PurchLineTmp."Special Order Sales Line No.");
        //CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,PurchLine);
        //PurchLine."Special Order" := PurchLineTmp."Special Order";
        //PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
        //PurchLine."Special Order Sales No." := PurchLineTmp."Special Order Sales No.";
        //PurchLine."Special Order Sales Line No." := PurchLineTmp."Special Order Sales Line No.";
        //PurchLine.INSERT;

        //SalesLine.VALIDATE("Unit Cost (LCY)",PurchLine."Unit Cost (LCY)");
        //SalesLine."Special Order Purchase No." := PurchLine."Document No.";
        //SalesLine."Special Order Purch. Line No." := PurchLine."Line No.";
        //SalesLine.MODIFY;
        //  END;
        //ELSE BEGIN
        //  PurchLine.VALIDATE("Unit of Measure Code",PurchLineTmp."Unit of Measure Code");
        //  PurchLine.VALIDATE("Variant Code",PurchLineTmp."Variant Code");
        //  IF (PurchLineTmp."Job No." <> '') AND (PurchLineTmp."Job Task No." <> '') THEN BEGIN
        //PurchLine.VALIDATE("Job No.",PurchLineTmp."Job No.");
        //PurchLine.VALIDATE("Job Task No.",PurchLineTmp."Job Task No.");
        //PurchLine."Job Line Type" := PurchLineTmp."Job Line Type";
        //  END;
        //  IF PurchLineTmp.Quantity <> 0 THEN
        //PurchLine.VALIDATE(Quantity,PurchLineTmp.Quantity);
        //  PurchLine."Prod. Order No." := PurchLineTmp."Prod. Order No.";
        //  PurchLine."Routing No." := PurchLineTmp."Routing No.";
        //  PurchLine."Routing Reference No." := PurchLineTmp."Routing Reference No.";
        //  PurchLine."Operation No." := PurchLineTmp."Operation No.";
        //  PurchLine."Work Center No." := PurchLineTmp."Work Center No.";
        //  PurchLine."Prod. Order Line No." := PurchLineTmp."Prod. Order Line No.";
        //  PurchLine."Overhead Rate" := PurchLineTmp."Overhead Rate";
        //  PurchLine.INSERT;
        //END;
        //  END;
        //  END;
        //  ExtendedTextAdded := FALSE;

        //  IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
        //ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        //TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",PurchLineTmp."Document Type");
        //TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",PurchLineTmp."Document No.");
        //TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",PurchLineTmp."Line No.");
        //IF TempItemChargeAssgntPurch.FINDSET THEN
        //  REPEAT
        //IF NOT TempItemChargeAssgntPurch.MARK THEN BEGIN
        //  TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
        //  TempItemChargeAssgntPurch.Description := PurchLine.Description;
        //  TempItemChargeAssgntPurch.MODIFY;
        //  TempItemChargeAssgntPurch.MARK(TRUE);
        //END;
        //  UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        //  END;
        //  IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
        //TempInteger.INIT;
        //TempInteger.Number := PurchLine."Line No.";
        //TempInteger.INSERT;
        //  END;
        //END ELSE
        //  IF NOT ExtendedTextAdded THEN BEGIN
        //TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,TRUE);
        //TransferExtendedText.InsertPurchExtText(PurchLine);
        //PurchLine.FINDLAST;
        //ExtendedTextAdded := TRUE;
        //  END;
        //  UNTIL PurchLineTmp.NEXT = 0;

        //  ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        //  PurchLineTmp.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
        //  IF PurchLineTmp.FINDSET THEN
        //REPEAT
        //  TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLineTmp."Line No.");
        //  IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
        //REPEAT
        //  TempInteger.FINDFIRST;
        //  ItemChargeAssgntPurch.INIT;
        //  ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
        //  ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
        //  ItemChargeAssgntPurch.VALIDATE("Unit Cost",0);
        //  ItemChargeAssgntPurch.INSERT;
        //UNTIL TempItemChargeAssgntPurch.NEXT = 0;
        //TempInteger.DELETE;
        //  END;
        //UNTIL PurchLineTmp.NEXT = 0;

        //  PurchLineTmp.SETRANGE(Type);
        //  PurchLineTmp.DELETEALL;
        //  ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
        //  TempItemChargeAssgntPurch.DELETEALL;
        //END;
        //  END ELSE
        //ERROR(
        //  Text018,ChangedFieldName);
        //END;
    end;

    procedure MessageIfPurchLinesExist(ChangedFieldName: Text[100]);
    begin
        if PurchLinesExist and not HideValidationDialog then
            MESSAGE(
              Text019 +
              Text020,
              ChangedFieldName);
    end;

    procedure PriceMessageIfPurchLinesExist(ChangedFieldName: Text[100]);
    begin
        if PurchLinesExist and not HideValidationDialog then
            MESSAGE(
              Text019 +
              Text021, ChangedFieldName);
    end;

    local procedure UpdateCurrencyFactor();
    begin
        if "Currency Code" <> '' then begin
            if "Posting Date" <> 0D then
                CurrencyDate := "Posting Date"
            else
                CurrencyDate := WORKDATE;

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor();
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := CONFIRM(Text022, false);
        if Confirmed then
            VALIDATE("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean);
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure UpdatePurchLines(ChangedFieldName: Text[100]);
    var
        UpdateConfirmed: Boolean;
    begin

        //IF NOT PurchLinesExist THEN
        //  EXIT;

        //IF NOT GUIALLOWED THEN
        //  UpdateConfirmed := TRUE
        //ELSE
        //  CASE ChangedFieldName OF
        //FIELDCAPTION("Expected Receipt Date"):
        //  BEGIN
        //UpdateConfirmed :=
        //  CONFIRM(
        //STRSUBSTNO(
        //  Text032 +
        //  Text033,ChangedFieldName));
        //IF UpdateConfirmed THEN
        //  ConfirmResvDateConflict;
        //  END;
        //FIELDCAPTION("Requested Receipt Date"):
        //  BEGIN
        //UpdateConfirmed :=
        //  CONFIRM(
        //STRSUBSTNO(
        //  Text032 +
        //  Text033,ChangedFieldName));
        //IF UpdateConfirmed THEN
        //  ConfirmResvDateConflict;
        //  END;
        //FIELDCAPTION("Promised Receipt Date"):
        //  BEGIN
        //UpdateConfirmed :=
        //  CONFIRM(
        //STRSUBSTNO(
        //  Text032 +
        //  Text033,ChangedFieldName));
        //IF UpdateConfirmed THEN
        //  ConfirmResvDateConflict;
        //  END;
        //FIELDCAPTION("Lead Time Calculation"):
        //  BEGIN
        //UpdateConfirmed :=
        //  CONFIRM(
        //STRSUBSTNO(
        //  Text032 +
        //  Text033,ChangedFieldName));
        //IF UpdateConfirmed THEN
        //  ConfirmResvDateConflict;
        //  END;
        //FIELDCAPTION("Inbound Whse. Handling Time"):
        //  BEGIN
        //UpdateConfirmed :=
        //  CONFIRM(
        //STRSUBSTNO(
        //  Text032 +
        //  Text033,ChangedFieldName));
        //IF UpdateConfirmed THEN
        //  ConfirmResvDateConflict;
        //  END;
        //FIELDCAPTION("Prepayment %"):
        //  UpdateConfirmed :=
        //CONFIRM(
        //  STRSUBSTNO(
        //Text032 +
        //Text033,ChangedFieldName));
        //  END;

        //PurchLine.LOCKTABLE;
        //MODIFY;

        //REPEAT
        //  xPurchLine := PurchLine;
        //  CASE ChangedFieldName OF
        //FIELDCAPTION("Expected Receipt Date"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Expected Receipt Date","Expected Receipt Date");
        //FIELDCAPTION("Currency Factor"):
        //  IF PurchLine.Type <> PurchLine.Type::" " THEN
        //PurchLine.VALIDATE("Direct Unit Cost");
        //FIELDCAPTION("Transaction Type"):
        //  PurchLine.VALIDATE("Transaction Type","Transaction Type");
        //FIELDCAPTION("Transport Method"):
        //  PurchLine.VALIDATE("Transport Method","Transport Method");
        //FIELDCAPTION("Entry Point"):
        //  PurchLine.VALIDATE("Entry Point","Entry Point");
        //FIELDCAPTION(Area):
        //  PurchLine.VALIDATE(Area,Area);
        //FIELDCAPTION("Transaction Specification"):
        //  PurchLine.VALIDATE("Transaction Specification","Transaction Specification");
        //FIELDCAPTION("Requested Receipt Date"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
        //FIELDCAPTION("Prepayment %"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Prepayment %","Prepayment %");
        //FIELDCAPTION("Promised Receipt Date"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
        //FIELDCAPTION("Lead Time Calculation"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Lead Time Calculation","Lead Time Calculation");
        //FIELDCAPTION("Inbound Whse. Handling Time"):
        //  IF UpdateConfirmed AND (PurchLine."No." <> '') THEN
        //PurchLine.VALIDATE("Inbound Whse. Handling Time","Inbound Whse. Handling Time");
        //  END;
        //  PurchLine.MODIFY(TRUE);
        //  ReservePurchLine.VerifyChange(PurchLine,xPurchLine);
        //UNTIL PurchLine.NEXT = 0;
    end;

    procedure ConfirmResvDateConflict();
    var
        ResvEngMgt: Codeunit "Reservation Engine Mgt.";
    begin
        //IF ResvEngMgt.ResvExistsForPurchHeader(Rec) THEN
        if not CONFIRM(Text050 + Text011, false) then
            ERROR('');
    end;

    procedure CreateDimFromDefaultDim(FieldNo: Integer)
    var
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        InitDefaultDimensionSources(DefaultDimSource, FieldNo);
        CreateDim(DefaultDimSource);
    end;

    local procedure InitDefaultDimensionSources(var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::Vendor, Rec."Pay-to Vendor No.", FieldNo = Rec.FieldNo("Pay-to Vendor No."));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Salesperson/Purchaser", Rec."Purchaser Code", FieldNo = Rec.FieldNo("Purchaser Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Campaign, Rec."Campaign No.", FieldNo = Rec.FieldNo("Campaign No."));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Responsibility Center", Rec."Responsibility Center", FieldNo = Rec.FieldNo("Responsibility Center"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Location, Rec."Location Code", FieldNo = Rec.FieldNo("Location Code"));
    end;

    procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    var
        SourceCodeSetup: Record "Source Code Setup";
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeCreateDim(Rec, IsHandled, DefaultDimSource, CurrFieldNo);
        if IsHandled then
            exit;

        SourceCodeSetup.Get();

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        //OnCreateDimOnBeforeUpdateLines(Rec, xRec, CurrFieldNo, OldDimSetID, DefaultDimSource);

        if (OldDimSetID <> "Dimension Set ID") and (OldDimSetID <> 0) and GuiAllowed then
            if CouldDimensionsBeKept() then
                if not ConfirmKeepExistingDimensions(OldDimSetID) then begin
                    "Dimension Set ID" := OldDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
                end;

        //OnCreateDimOnAfterConfirmKeepExisting(Rec, xRec, CurrFieldNo, OldDimSetID, DefaultDimSource);

        if (OldDimSetID <> "Dimension Set ID") and PurchLinesExist() then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure ConfirmKeepExistingDimensions(OldDimSetID: Integer) Confirmed: Boolean
    var
        IsHandled: Boolean;
        DoYouWantToKeepExistingDimensionsQst: Label 'This will change the dimension specified on the document. Do you want to recalculate/update dimensions?';
    begin
        IsHandled := false;
        //OnBeforeConfirmKeepExistingDimensions(Rec, xRec, CurrFieldNo, OldDimSetID, Confirmed, IsHandled);
        if IsHandled then
            exit(Confirmed);

        Confirmed := Confirm(DoYouWantToKeepExistingDimensionsQst);
    end;

    procedure CouldDimensionsBeKept() Result: Boolean;
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then begin
            if (xRec."Buy-from Vendor No." <> '') and (xRec."Buy-from Vendor No." <> Rec."Buy-from Vendor No.") then
                exit(false);
            if (xRec."Pay-to Vendor No." <> '') and (xRec."Pay-to Vendor No." <> Rec."Pay-to Vendor No.") then
                exit(false);
            if (Rec."Location Code" = '') and (xRec."Location Code" <> '') and (CurrFieldNo = Rec.FieldNo("Location Code")) then
                exit(true);
            if (xRec."Location Code" <> Rec."Location Code") and ((CurrFieldNo = Rec.FieldNo("Location Code"))
                or ((Rec."Sell-to Customer No." <> '') and (xRec."Sell-to Customer No." <> Rec."Sell-to Customer No."))) then
                exit(true);
            if (xRec."Purchaser Code" <> '') and (xRec."Purchaser Code" <> Rec."Purchaser Code") then
                exit(true);
            if (xRec."Responsibility Center" <> '') and (xRec."Responsibility Center" <> Rec."Responsibility Center") then
                exit(true);
            if (xRec."Sell-to Customer No." <> '') and (xRec."Sell-to Customer No." <> Rec."Sell-to Customer No.") then
                exit(true);
        end;
    end;

    // procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]);
    // var
    //     SourceCodeSetup: Record "Source Code Setup";
    //     TableID: array[10] of Integer;
    //     No: array[10] of Code[20];
    //     OldDimSetID: Integer;
    // begin
    //     SourceCodeSetup.GET;
    //     TableID[1] := Type1;
    //     No[1] := No1;
    //     TableID[2] := Type2;
    //     No[2] := No2;
    //     TableID[3] := Type3;
    //     No[3] := No3;
    //     TableID[4] := Type4;
    //     No[4] := No4;
    //     "Shortcut Dimension 1 Code" := '';
    //     "Shortcut Dimension 2 Code" := '';
    //     OldDimSetID := "Dimension Set ID";
    //     "Dimension Set ID" :=
    //       DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

    //     if (OldDimSetID <> "Dimension Set ID") and PurchLinesExist then begin
    //         MODIFY;
    //         UpdateAllLineDim("Dimension Set ID", OldDimSetID);
    //     end;
    // end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if PurchLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ReceivedPurchLinesExist(): Boolean;
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETFILTER("Quantity Received", '<>0');
        exit(PurchLine.FINDFIRST);
    end;

    procedure ReturnShipmentExist(): Boolean;
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETFILTER("Return Qty. Shipped", '<>0');
        exit(PurchLine.FINDFIRST);
    end;

    local procedure UpdateShipToAddress();
    begin
        if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then
            exit;

        if ("Location Code" <> '') and
           Location.GET("Location Code") and
           ("Sell-to Customer No." = '')
        then begin
            "Ship-to Name" := Location.Name;
            "Ship-to Name 2" := Location."Name 2";
            "Ship-to Address" := Location.Address;
            "Ship-to Address 2" := Location."Address 2";
            "Ship-to City" := Location.City;
            "Ship-to Post Code" := Location."Post Code";
            "Ship-to County" := Location.County;
            "Ship-to Country/Region Code" := Location."Country/Region Code";
            "Ship-to Contact" := Location.Contact;
        end;

        if ("Location Code" = '') and
           ("Sell-to Customer No." = '')
        then begin
            CompanyInfo.GET;
            "Ship-to Code" := '';
            "Ship-to Name" := CompanyInfo."Ship-to Name";
            "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
            "Ship-to Address" := CompanyInfo."Ship-to Address";
            "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
            "Ship-to City" := CompanyInfo."Ship-to City";
            "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
            "Ship-to County" := CompanyInfo."Ship-to County";
            "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
            "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        end;
    end;

    local procedure DeletePurchaseLines();
    begin
        if PurchLine.FINDSET then begin
            HandleItemTrackingDeletion;
            repeat
                PurchLine.SuspendStatusCheck(true);
                PurchLine.DELETE(true);
            until PurchLine.NEXT = 0;
        end;
    end;

    procedure HandleItemTrackingDeletion();
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
    begin
        with ReservEntry do begin
            RESET;
            SETCURRENTKEY(
              "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
              "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
            SETRANGE("Source Type", DATABASE::"Purchase Line");
            SETRANGE("Source Subtype", "Document Type");
            SETRANGE("Source ID", "No.");
            SETRANGE("Source Batch Name", '');
            SETRANGE("Source Prod. Order Line", 0);
            SETFILTER("Item Tracking", '> %1', "Item Tracking"::None);
            if ISEMPTY then
                exit;

            if HideValidationDialog or not GUIALLOWED then
                Confirmed := true
            else
                Confirmed := CONFIRM(Text041, false, LOWERCASE(FORMAT("Document Type")), "No.");

            if not Confirmed then
                ERROR('');

            if FINDSET then
                repeat
                    ReservEntry2 := ReservEntry;
                    ReservEntry2.ClearItemTrackingFields;
                    ReservEntry2.MODIFY;
                until NEXT = 0;
        end;
    end;

    local procedure ClearItemAssgntPurchFilter(var TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)");
    begin
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    end;

    procedure UpdateBuyFromCont(VendorNo: Code[20]);
    var
        ContBusRel: Record "Contact Business Relation";
        Vend: Record Vendor;
    begin
        if Vend.GET(VendorNo) then begin
            if Vend."Primary Contact No." <> '' then
                "Buy-from Contact No." := Vend."Primary Contact No."
            else begin
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "Buy-from Vendor No.");
                if ContBusRel.FINDFIRST then
                    "Buy-from Contact No." := ContBusRel."Contact No."
                else
                    "Buy-from Contact No." := '';
            end;
            "Buy-from Contact" := Vend.Contact;
        end;
    end;

    procedure UpdatePayToCont(VendorNo: Code[20]);
    var
        ContBusRel: Record "Contact Business Relation";
        Vend: Record Vendor;
    begin
        if Vend.GET(VendorNo) then begin
            if Vend."Primary Contact No." <> '' then
                "Pay-to Contact No." := Vend."Primary Contact No."
            else begin
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "Pay-to Vendor No.");
                if ContBusRel.FINDFIRST then
                    "Pay-to Contact No." := ContBusRel."Contact No."
                else
                    "Pay-to Contact No." := '';
            end;
            "Pay-to Contact" := Vend.Contact;
        end;
    end;

    procedure UpdateBuyFromVend(ContactNo: Code[20]);
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Vend: Record Vendor;
        Cont: Record Contact;
    begin
        if Cont.GET(ContactNo) then begin
            "Buy-from Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
                "Buy-from Contact" := Cont.Name
            else
                if Vend.GET("Buy-from Vendor No.") then
                    "Buy-from Contact" := Vend.Contact
                else
                    "Buy-from Contact" := ''
        end else begin
            "Buy-from Contact" := '';
            exit;
        end;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
        ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FINDFIRST then begin
            if ("Buy-from Vendor No." <> '') and
               ("Buy-from Vendor No." <> ContBusinessRelation."No.")
            then
                ERROR(Text037, Cont."No.", Cont.Name, "Buy-from Vendor No.");
            if "Buy-from Vendor No." = '' then begin
                SkipBuyFromContact := true;
                VALIDATE("Buy-from Vendor No.", ContBusinessRelation."No.");
                SkipBuyFromContact := false;
            end;
        end else
            ERROR(Text039, Cont."No.", Cont.Name);

        if ("Buy-from Vendor No." = "Pay-to Vendor No.") or
           ("Pay-to Vendor No." = '')
        then
            VALIDATE("Pay-to Contact No.", "Buy-from Contact No.");
    end;

    procedure UpdatePayToVend(ContactNo: Code[20]);
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Vend: Record Vendor;
        Cont: Record Contact;
    begin
        if Cont.GET(ContactNo) then begin
            "Pay-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
                "Pay-to Contact" := Cont.Name
            else
                if Vend.GET("Pay-to Vendor No.") then
                    "Pay-to Contact" := Vend.Contact
                else
                    "Pay-to Contact" := '';
        end else begin
            "Pay-to Contact" := '';
            exit;
        end;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Vendor);
        ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FINDFIRST then begin
            if "Pay-to Vendor No." = '' then begin
                SkipPayToContact := true;
                VALIDATE("Pay-to Vendor No.", ContBusinessRelation."No.");
                SkipPayToContact := false;
            end else
                if "Pay-to Vendor No." <> ContBusinessRelation."No." then
                    ERROR(Text037, Cont."No.", Cont.Name, "Pay-to Vendor No.");
        end else
            ERROR(Text039, Cont."No.", Cont.Name);
    end;

    procedure CreateInvtPutAwayPick();
    var
        WhseRequest: Record "Warehouse Request";
    begin
        TESTFIELD(Status, Status::Released);

        WhseRequest.RESET;
        WhseRequest.SETCURRENTKEY("Source Document", "Source No.");
        case "Document Type" of
            "Document Type"::Order:
                WhseRequest.SETRANGE("Source Document", WhseRequest."Source Document"::"Purchase Order");
            "Document Type"::"Return Order":
                WhseRequest.SETRANGE("Source Document", WhseRequest."Source Document"::"Purchase Return Order");
        end;
        WhseRequest.SETRANGE("Source No.", "No.");
        REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if PurchLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.LOCKTABLE;
        if PurchLine.FIND('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PurchLine."Dimension Set ID" <> NewDimSetID then begin
                    PurchLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");
                    PurchLine.MODIFY;
                end;
            until PurchLine.NEXT = 0;
    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20]);
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.", VendorNo);
        VendLedgEntry.SETRANGE(Open, true);
        if VendLedgEntry.FINDFIRST then begin
            if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        end;
    end;

    procedure SetShipToForSpecOrder();
    begin
        if Location.GET("Location Code") then begin
            "Ship-to Code" := '';
            "Ship-to Name" := Location.Name;
            "Ship-to Name 2" := Location."Name 2";
            "Ship-to Address" := Location.Address;
            "Ship-to Address 2" := Location."Address 2";
            "Ship-to City" := Location.City;
            "Ship-to Post Code" := Location."Post Code";
            "Ship-to County" := Location.County;
            "Ship-to Country/Region Code" := Location."Country/Region Code";
            "Ship-to Contact" := Location.Contact;
            "Location Code" := Location.Code;
        end else begin
            CompanyInfo.GET;
            "Ship-to Code" := '';
            "Ship-to Name" := CompanyInfo."Ship-to Name";
            "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
            "Ship-to Address" := CompanyInfo."Ship-to Address";
            "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
            "Ship-to City" := CompanyInfo."Ship-to City";
            "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
            "Ship-to County" := CompanyInfo."Ship-to County";
            "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
            "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            "Location Code" := '';
        end;
    end;

    procedure JobUpdatePurchLines();
    begin
        with PurchLine do begin
            SETFILTER("Job No.", '<>%1', '');
            SETFILTER("Job Task No.", '<>%1', '');
            LOCKTABLE;
            if FINDSET(true, false) then begin
                //    SetPurchHeader(Rec);
                repeat
                    JobSetCurrencyFactor;
                    CreateTempJobJnlLine(false);
                    UpdatePricesFromJobJnlLine;
                    MODIFY;
                until NEXT = 0;
            end;
        end
    end;

    procedure GetPstdDocLinesToRevere();
    var
        PurchPostedDocLines: Page "Posted Purchase Document Lines";
    begin
        GetVend("Buy-from Vendor No.");
        //PurchPostedDocLines.SetToPurchHeader(Rec);
        PurchPostedDocLines.SETRECORD(Vend);
        PurchPostedDocLines.LOOKUPMODE := true;
        if PurchPostedDocLines.RUNMODAL = ACTION::LookupOK then
            PurchPostedDocLines.CopyLineToDoc;

        CLEAR(PurchPostedDocLines);
    end;

    procedure SetSecurityFilterOnRespCenter();
    begin
        if UserSetupMgt.GetPurchasesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserSetupMgt.GetPurchasesFilter);
            FILTERGROUP(0);
        end;

        SETRANGE("Date Filter", 0D, WORKDATE - 1);
    end;

    procedure CalcInvDiscForHeader();
    var
        PurchaseInvDisc: Codeunit "Purch.-Calc.Discount";
    begin
        PurchSetup.GET;
        //IF PurchSetup."Calc. Inv. Discount" THEN
        //  PurchaseInvDisc.CalculateIncDiscForHeader(Rec);
    end;

    procedure AddShipToAddress(SalesHeader: Record "Sales Header"; ShowError: Boolean);
    var
        PurchLine2: Record "Purchase Line";
    begin
        if ShowError then begin
            PurchLine2.RESET;
            PurchLine2.SETRANGE("Document Type", "Document Type"::Order);
            PurchLine2.SETRANGE("Document No.", "No.");
            if not PurchLine2.ISEMPTY then begin
                if "Ship-to Name" <> SalesHeader."Ship-to Name" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Name"), "No.", SalesHeader."No.");
                if "Ship-to Name 2" <> SalesHeader."Ship-to Name 2" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Name 2"), "No.", SalesHeader."No.");
                if "Ship-to Address" <> SalesHeader."Ship-to Address" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Address"), "No.", SalesHeader."No.");
                if "Ship-to Address 2" <> SalesHeader."Ship-to Address 2" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Address 2"), "No.", SalesHeader."No.");
                if "Ship-to Post Code" <> SalesHeader."Ship-to Post Code" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Post Code"), "No.", SalesHeader."No.");
                if "Ship-to City" <> SalesHeader."Ship-to City" then
                    ERROR(Text052, FIELDCAPTION("Ship-to City"), "No.", SalesHeader."No.");
                if "Ship-to Contact" <> SalesHeader."Ship-to Contact" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Contact"), "No.", SalesHeader."No.");
            end else begin
                // no purchase line exists
                "Ship-to Name" := SalesHeader."Ship-to Name";
                "Ship-to Name 2" := SalesHeader."Ship-to Name 2";
                "Ship-to Address" := SalesHeader."Ship-to Address";
                "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
                "Ship-to Post Code" := SalesHeader."Ship-to Post Code";
                "Ship-to City" := SalesHeader."Ship-to City";
                "Ship-to Contact" := SalesHeader."Ship-to Contact";
            end;
        end;
    end;

    procedure DropShptOrderExists(SalesHeader: Record "Sales Header"): Boolean;
    var
        SalesLine2: Record "Sales Line";
    begin
        // returns TRUE if sales is either Drop Shipment of Special Order
        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type", SalesLine2."Document Type"::Order);
        SalesLine2.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine2.SETRANGE("Drop Shipment", true);
        exit(not SalesLine2.ISEMPTY);
    end;

    procedure SpecialOrderExists(SalesHeader: Record "Sales Header"): Boolean;
    var
        SalesLine3: Record "Sales Line";
    begin
        SalesLine3.RESET;
        SalesLine3.SETRANGE("Document Type", SalesLine3."Document Type"::Order);
        SalesLine3.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine3.SETRANGE("Special Order", true);
        exit(not SalesLine3.ISEMPTY);
    end;

    procedure QtyToReceiveIsZero(): Boolean;
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETFILTER("Qty. to Receive", '<>0');
        exit(PurchLine.ISEMPTY);
    end;

    procedure IsApprovedForPosting(): Boolean;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.INIT;
        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN BEGIN
        //  IF ApprovalMgt.TestPurchasePrepayment(Rec) THEN
        //    ERROR(STRSUBSTNO(Text053,"Document Type","No."));
        //  IF ApprovalMgt.TestPurchasePayment(Rec) THEN
        //    IF NOT CONFIRM(STRSUBSTNO(Text054,"Document Type","No."),TRUE) THEN
        //      EXIT(FALSE);
        //  EXIT(TRUE);
        //END;
    end;

    procedure IsApprovedForPostingBatch(): Boolean;
    var
        SalesHeader: Record "Sales Header";
    begin
        //SalesHeader.INIT;
        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN BEGIN
        //  IF ApprovalMgt.TestPurchasePrepayment(Rec) THEN
        //    EXIT(FALSE);
        //  IF ApprovalMgt.TestPurchasePayment(Rec) THEN
        //    EXIT(FALSE);
        //  EXIT(TRUE);
        //END;
    end;

    procedure SendToPosting(PostingCodeunitID: Integer);
    begin
        //IF NOT IsApprovedForPosting THEN
        //  EXIT;
        //CODEUNIT.RUN(PostingCodeunitID,Rec);
    end;

    procedure CancelBackgroundPosting();
    var
        PurchasePostViaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        //PurchasePostViaJobQueue.CancelQueueEntry(Rec);
    end;

    procedure CheckAddressDetails(SalesHeader: Record "Sales Header"): Boolean;
    begin
        NameAddressDetails :=
          SalesHeader."Ship-to Name" + SalesHeader."Ship-to Name 2" +
          SalesHeader."Ship-to Address" + SalesHeader."Ship-to Address 2" +
          SalesHeader."Ship-to Post Code" + SalesHeader."Ship-to City" +
          SalesHeader."Ship-to Contact";
        if NameAddressDetails2 = '' then
            NameAddressDetails2 := NameAddressDetails;
        exit(NameAddressDetails2 = NameAddressDetails);
    end;

    procedure AddSpecialOrderToAddress(SalesHeader: Record "Sales Header"; ShowError: Boolean);
    var
        PurchLine3: Record "Purchase Line";
        LocationCode: Record Location;
    begin
        if ShowError then begin
            PurchLine3.RESET;
            PurchLine3.SETRANGE("Document Type", "Document Type"::Order);
            PurchLine3.SETRANGE("Document No.", "No.");
            if not PurchLine3.ISEMPTY then begin
                LocationCode.GET("Location Code");
                if "Ship-to Name" <> LocationCode.Name then
                    ERROR(Text052, FIELDCAPTION("Ship-to Name"), "No.", SalesHeader."No.");
                if "Ship-to Name 2" <> LocationCode."Name 2" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Name 2"), "No.", SalesHeader."No.");
                if "Ship-to Address" <> LocationCode.Address then
                    ERROR(Text052, FIELDCAPTION("Ship-to Address"), "No.", SalesHeader."No.");
                if "Ship-to Address 2" <> LocationCode."Address 2" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Address 2"), "No.", SalesHeader."No.");
                if "Ship-to Post Code" <> LocationCode."Post Code" then
                    ERROR(Text052, FIELDCAPTION("Ship-to Post Code"), "No.", SalesHeader."No.");
                if "Ship-to City" <> LocationCode.City then
                    ERROR(Text052, FIELDCAPTION("Ship-to City"), "No.", SalesHeader."No.");
                if "Ship-to Contact" <> LocationCode.Contact then
                    ERROR(Text052, FIELDCAPTION("Ship-to Contact"), "No.", SalesHeader."No.");
            end else
                SetShipToForSpecOrder;
        end;
    end;

    local procedure ModifyPayToVendorAddress()
    var
        Vendor: Record Vendor;
        IsHandled: Boolean;
    begin


        GetPurchSetup();
        if PurchSetup."Ignore Updated Addresses" then
            exit;
        if IsCreditDocType() then
            exit;
        if ("Pay-to Vendor No." <> "Buy-from Vendor No.") and Vendor.Get("Pay-to Vendor No.") then
            if HasPayToAddress and HasDifferentPayToAddress(Vendor) then
                ShowModifyAddressNotification(GetModifyPayToVendorAddressNotificationId,
                  ModifyVendorAddressNotificationLbl, ModifyVendorAddressNotificationMsg,
                  'CopyPayToVendorAddressFieldsFromSalesDocument', "Pay-to Vendor No.",
                  "Pay-to Name", FieldName("Pay-to Vendor No."));
    end;

    local procedure GetPurchSetup()
    begin
        PurchSetup.Get();
    end;

    procedure IsCreditDocType(): Boolean
    var
        CreditDocType: Boolean;
    begin
        CreditDocType := "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"];
        exit(CreditDocType);
    end;

    procedure HasPayToAddress() Result: Boolean
    var
        IsHandled: Boolean;
    begin


        case true of
            "Pay-to Address" <> '':
                exit(true);
            "Pay-to Address 2" <> '':
                exit(true);
            "Pay-to City" <> '':
                exit(true);
            "Pay-to Country/Region Code" <> '':
                exit(true);
            "Pay-to County" <> '':
                exit(true);
            "Pay-to Post Code" <> '':
                exit(true);
            "Pay-to Contact" <> '':
                exit(true);
        end;

        exit(false);
    end;

    local procedure HasDifferentPayToAddress(Vendor: Record Vendor): Boolean
    begin
        exit(("Pay-to Address" <> Vendor.Address) or
          ("Pay-to Address 2" <> Vendor."Address 2") or
          ("Pay-to City" <> Vendor.City) or
          ("Pay-to Country/Region Code" <> Vendor."Country/Region Code") or
          ("Pay-to County" <> Vendor.County) or
          ("Pay-to Post Code" <> Vendor."Post Code") or
          ("Pay-to Contact" <> Vendor.Contact));
    end;

    local procedure ShowModifyAddressNotification(NotificationID: Guid; NotificationLbl: Text; NotificationMsg: Text; NotificationFunctionTok: Text; VendorNumber: Code[20]; VendorName: Text[100]; VendorNumberFieldName: Text)
    var
        MyNotifications: Record "My Notifications";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        ModifyVendorAddressNotification: Notification;
    begin
        if not MyNotifications.IsEnabled(NotificationID) then
            exit;

        ModifyVendorAddressNotification.Id := NotificationID;
        ModifyVendorAddressNotification.Message := StrSubstNo(NotificationMsg, VendorName);
        ModifyVendorAddressNotification.AddAction(NotificationLbl, CODEUNIT::"Document Notifications", NotificationFunctionTok);
        ModifyVendorAddressNotification.AddAction(
          DontShowAgainActionLbl, CODEUNIT::"Document Notifications", 'HidePurchaseNotificationForCurrentUser');
        ModifyVendorAddressNotification.Scope := NOTIFICATIONSCOPE::LocalScope;
        ModifyVendorAddressNotification.SetData(FieldName("Document Type"), Format("Document Type"));
        ModifyVendorAddressNotification.SetData(FieldName("No."), "No.");
        ModifyVendorAddressNotification.SetData(VendorNumberFieldName, VendorNumber);
        NotificationLifecycleMgt.SendNotification(ModifyVendorAddressNotification, RecordId);
    end;

    procedure GetModifyVendorAddressNotificationId(): Guid
    begin
        exit('CF3D0CD3-C54A-47D1-8A3F-57A6CCBA8DDE');
    end;

    procedure GetModifyPayToVendorAddressNotificationId(): Guid
    begin
        exit('16E45B3A-CB9F-4B2C-9F08-2BCE39E9E980');
    end;

    procedure GetShowExternalDocAlreadyExistNotificationId(): Guid
    begin
        exit('D87F624C-D3BE-4E6B-A369-D18AE269181A');
    end;

    procedure GetLineInvoiceDiscountResetNotificationId(): Guid
    begin
        exit('3DC9C8BC-0512-4A49-B587-256C308EBCAA');
    end;

    local procedure UpdatePayToAddressFromBuyFromAddress(FieldNumber: Integer)
    begin
        if ("Order Address Code" = '') and PayToAddressEqualsOldBuyFromAddress then
            case FieldNumber of
                FieldNo("Pay-to Address"):
                    if xRec."Buy-from Address" = "Pay-to Address" then
                        "Pay-to Address" := "Buy-from Address";
                FieldNo("Pay-to Address 2"):
                    if xRec."Buy-from Address 2" = "Pay-to Address 2" then
                        "Pay-to Address 2" := "Buy-from Address 2";
                FieldNo("Pay-to City"), FieldNo("Pay-to Post Code"):
                    begin
                        if xRec."Buy-from City" = "Pay-to City" then
                            "Pay-to City" := "Buy-from City";
                        if xRec."Buy-from Post Code" = "Pay-to Post Code" then
                            "Pay-to Post Code" := "Buy-from Post Code";
                        if xRec."Buy-from County" = "Pay-to County" then
                            "Pay-to County" := "Buy-from County";
                        if xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" then
                            "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
                    end;
                FieldNo("Pay-to County"):
                    if xRec."Buy-from County" = "Pay-to County" then
                        "Pay-to County" := "Buy-from County";
                FieldNo("Pay-to Country/Region Code"):
                    if xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" then
                        "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
            end;
    end;

    local procedure PayToAddressEqualsOldBuyFromAddress(): Boolean
    begin
        if (xRec."Buy-from Address" = "Pay-to Address") and
           (xRec."Buy-from Address 2" = "Pay-to Address 2") and
           (xRec."Buy-from City" = "Pay-to City") and
           (xRec."Buy-from County" = "Pay-to County") and
           (xRec."Buy-from Post Code" = "Pay-to Post Code") and
           (xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code")
        then
            exit(true);
    end;

    local procedure ModifyVendorAddress()
    var
        Vendor: Record Vendor;
        IsHandled: Boolean;
    begin


        GetPurchSetup();
        if PurchSetup."Ignore Updated Addresses" then
            exit;
        if IsCreditDocType() then
            exit;
        if Vendor.Get("Buy-from Vendor No.") and HasBuyFromAddress and HasDifferentBuyFromAddress(Vendor) then
            ShowModifyAddressNotification(GetModifyVendorAddressNotificationId,
              ModifyVendorAddressNotificationLbl, ModifyVendorAddressNotificationMsg,
              'CopyBuyFromVendorAddressFieldsFromSalesDocument', "Buy-from Vendor No.",
              "Buy-from Vendor Name", FieldName("Buy-from Vendor No."));
    end;


    procedure HasBuyFromAddress() Result: Boolean
    var
        IsHandled: Boolean;
    begin


        case true of
            "Buy-from Address" <> '':
                exit(true);
            "Buy-from Address 2" <> '':
                exit(true);
            "Buy-from City" <> '':
                exit(true);
            "Buy-from Country/Region Code" <> '':
                exit(true);
            "Buy-from County" <> '':
                exit(true);
            "Buy-from Post Code" <> '':
                exit(true);
            "Buy-from Contact" <> '':
                exit(true);
        end;

        exit(false);
    end;

    local procedure HasDifferentBuyFromAddress(Vendor: Record Vendor): Boolean
    begin
        exit(("Buy-from Address" <> Vendor.Address) or
          ("Buy-from Address 2" <> Vendor."Address 2") or
          ("Buy-from City" <> Vendor.City) or
          ("Buy-from Country/Region Code" <> Vendor."Country/Region Code") or
          ("Buy-from County" <> Vendor.County) or
          ("Buy-from Post Code" <> Vendor."Post Code") or
          ("Buy-from Contact" <> Vendor.Contact));
    end;
}


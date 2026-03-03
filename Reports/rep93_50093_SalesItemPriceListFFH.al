report 50093 "Sales Item Price List FFH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep93_50093_SalesItemPriceListFFH.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Item Price List';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Description", "Assembly BOM", "Inventory Posting Group";

            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
            {
            }
            column(ReqDateFormatted; StrSubstNo(AsOfTok, Format(DateReq, 0, 4)))
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }

            column(CompanyInfoGlobalGabCOCNo; CompanyInfo."GlobalGab COC No.")
            {
            }
            column(CompanyInfoBIOCertificationBody; CompanyInfo."BIO Certification Body")
            {

            }
            column(SourceType; PriceSource."Source Type")
            {
            }
            column(SourceNo; PriceSource."Source No.")
            {
            }
            column(PageCaption; StrSubstNo(PageTok, ''))
            {
            }
            column(SalesDesc; SalesDesc)
            {
            }
            column(UnitPriceFieldCaption; 'Unit Price ' + CurrencyText) //TempSalesPrice.FieldCaption("Unit Price") 
            {
            }
            column(LineDiscountFieldCaption; 'Line Discount % ' + CurrencyText) // TempSalesLineDisc.FieldCaption("Line Discount %")
            {
            }
            column(No_Item; "No.")
            {
            }
            column(PriceListCaption; PriceListCaptionLbl)
            {
            }
            column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
            {
            }
            column(CompanyInfoFaxNoCaption; CompanyInfoFaxNoCaptionLbl)
            {
            }
            column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
            {
            }
            column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
            {
            }
            column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
            {
            }
            column(CompanyInfoBankAccNoCaption; CompanyInfoBankAccNoCaptionLbl)
            {
            }
            column(ItemNoCaption; ItemNoCaptionLbl)
            {
            }
            column(ItemDescCaption; ItemDescCaptionLbl)
            {
            }
            column(UnitOfMeasureCaption; UnitOfMeasureCaptionLbl)
            {
            }
            column(MinimumQuantityCaption; MinimumQuantityCaptionLbl)
            {
            }
            column(VATTextCaption; VATTextCaptionLbl)
            {
            }

            column(StartDateFilter; vG_StartDate)
            {
            }

            column(EndDateFilter; vG_EndDate)
            {
            }
            column(ItemReference; itemReference)
            {
            }

            column(SortingField; sortingField)
            {
            }
            dataitem(SalesPrices; "Sales Price")
            {
                //DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                RequestFilterFields = "Sales Type", "Sales Code";
                DataItemLink = "Item No." = field("No.");
                column(VATText_SalesPrices; VATText)
                {
                }
                column(SalesPriceUnitPrice; "Unit Price")
                {
                    AutoFormatExpression = Currency.Code;
                    AutoFormatType = 2;
                }
                column(UOM_SalesPrices; "Unit of Measure Code") //UnitOfMeasure
                {
                }
                column(ItemNo_SalesPrices; ItemNo)
                {
                }
                column(ItemDesc_SalesPrices; ItemDesc)
                {
                }
                column(MinimumQty_SalesPrices; "Minimum Quantity")
                {
                }

                column(StartingDate_SalesPrices; Format("Starting Date"))
                {

                }

                column(EndingDate_SalesPrices; Format("Ending Date"))
                {

                }

                column(Addr1; Addr[1])
                {
                }

                column(Addr2; Addr[2])
                {
                }

                column(Addr3; Addr[3])
                {
                }

                column(Addr4; Addr[4])
                {
                }

                column(Addr5; Addr[5])
                {
                }

                column(Addr6; Addr[6])
                {
                }


                column(SalesCodeFilter; vG_SalesCodeFilter)
                {
                }
                column(salespriceItemReference; "Item Reference")
                {
                }


                trigger OnAfterGetRecord()
                begin
                    //PrintSalesPrice(false);
                    Clear(Addr);
                    if SalesPrices."Sales Type" = SalesPrices."Sales Type"::Customer then begin
                        if rG_Customer.Get("Sales Code") then begin //Location.Code Getfilter("Location Code")
                            FormatAddr.Customer(Addr, rG_Customer);
                        end;
                    end;


                    // ItemNo := item."No.";
                    // ItemDesc := item.Description;
                    //  itemReference := '';
                    //FindPriceDiscount('');

                    vG_SalesCodeFilter := SalesPrices.GetFilter("Sales Code");
                    //   itemReference := GetSalesPriceItemReference(vG_SalesCodeFilter, item."No.");
                    case vG_SortBy of
                        vG_SortBy::Description:
                            sortingField := Item.Description;
                        vG_SortBy::"Item No.":
                            sortingField := Format(Item."No.");
                        vG_SortBy::"Item Reference":
                            sortingField := Format(SalesPrices."Item Reference");
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //PreparePrintSalesPrice(false);
                    //add the filters

                    //SetRange("Sales Type", PriceSource."Source Type");
                    //SetRange("Sales Code", PriceSource."Source No.");

                    vG_SalesCodeFilter := SalesPrices.GetFilter("Sales Code");
                    //vG_StartDateFilter := SalesPrices.GetFilter("Starting Date");
                    //vG_EndDateFilter := SalesPrices.GetFilter("Ending Date");

                    if vG_StartDate <> 0D then begin
                        SalesPrices.SetFilter("Starting Date", '>=%1', vG_StartDate);
                    end;
                    if vG_EndDate <> 0D then begin
                        SalesPrices.SetFilter("Ending Date", '<=%1', vG_EndDate);
                    end;
                end;
            }



            trigger OnAfterGetRecord()
            begin
                ItemNo := "No.";
                ItemDesc := Description;
                // //  itemReference := '';
                // //FindPriceDiscount('');

                // vG_SalesCodeFilter := SalesPrices.GetFilter("Sales Code");
                // itemReference := GetSalesPriceItemReference(vG_SalesCodeFilter, "No.");
                // case vG_SortBy of
                //     vG_SortBy::Description:
                //         sortingField := Description;
                //     vG_SortBy::"Item No.":
                //         sortingField := Format("No.");
                //     vG_SortBy::"Item Reference":
                //         sortingField := Format(itemReference);
                // end;
            end;

            // trigger OnPreDataItem()
            // begin
            //     case vG_SortBy of
            //         vG_SortBy::Description:
            //             begin
            //                 SetCurrentKey(Description);
            //             end;

            //         vG_SortBy::"Item No.":
            //             begin
            //                 SetCurrentKey("No.");
            //             end;
            //     end;
            // end;
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
                    //Visible = false;

                    field(StartDate; vG_StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';

                    }
                    field(EndDate; vG_EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                    field(SortBy; vG_SortBy)
                    {
                        ApplicationArea = All;
                        Caption = 'Sort By';
                        ToolTip = 'Specifies the value of the Sort By field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if SalesSourceType.AsInteger() = 0 then
                SalesSourceType := SalesSourceType::"All Customers";
            if DateReq = 0D then
                DateReq := WorkDate();

            SourceNoCtrlEnable := SalesSourceType <> SalesSourceType::"All Customers";
        end;

        trigger OnAfterGetCurrRecord()
        begin
            ValidateMethod();
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        //if (SalesSourceNo = '') and (SalesSourceType <> SalesSourceType::"All Customers") then
        //    Error(MissSourceNoErr);

        CompanyInfo.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);

        // if CustPriceGr.Code <> '' then
        //   CustPriceGr.Find();

        //PriceSource.Validate("Source Type", SalesSourceType.AsInteger());
        //PriceSource.Validate("Source No.", SalesSourceNo);
        //PriceSource."Currency Code" := Currency.Code;
        SetCurrency();
    end;

    protected var
        Currency: Record Currency;
        PriceSource: Record "Price Source";
        //TempSalesPrice: Record "Price List Line" temporary;
        //TempSalesLineDisc: Record "Price List Line" temporary;
        PriceSourceList: Codeunit "Price Source List";

    var
        CompanyInfo: Record "Company Information";
        CustPriceGr: Record "Customer Price Group";
        Cust: Record Customer;
        Campaign: Record Campaign;
        CurrExchRate: Record "Currency Exchange Rate";
        ContBusRel: Record "Contact Business Relation";
        GLSetup: Record "General Ledger Setup";
        FormatAddr: Codeunit "Format Address";
        PriceCalcMethod: Enum "Price Calculation Method";
        PriceCalculationHandler: Enum "Price Calculation Handler";
        [InDataSet]
        SalesSourceType: Enum "Sales Price Source Type";
        LookupIsComplete: Boolean;
        [InDataSet]
        SalesSourceNo: Code[20];
        VATText: Text[20];
        DateReq: Date;
        CompanyAddr: array[8] of Text[100];
        CurrencyText: Text[30];
        UnitOfMeasure: Code[10];
        CustNo: Code[20];
        ContNo: Code[20];
        CampaignNo: Code[20];
        ItemNo: Code[20];
        ItemDesc: Text[100];
        SalesDesc: Text[100];
        CustPriceGrCode: Code[10];
        CustDiscGrCode: Code[20];
        IsFirstSalesPrice: Boolean;
        IsFirstSalesLineDisc: Boolean;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        [InDataSet]
        SourceNoCtrlEnable: Boolean;
        InclTok: Label 'Incl.';
        ExclTok: Label 'Excl.';
        PageTok: Label 'Page %1', Comment = '%1 - a page number';
        AsOfTok: Label 'As of %1', Comment = '%1 - a date';
        MissSourceNoErr: Label 'You must specify an Applies-to No., if the Applies-to Type is different from All Customers.';
        PriceListCaptionLbl: Label 'Price List';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoFaxNoCaptionLbl: Label 'Fax No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: Label 'Account No.';
        ItemNoCaptionLbl: Label 'Item No.';
        ItemDescCaptionLbl: Label 'Description';
        UnitOfMeasureCaptionLbl: Label 'Sales Unit of Measure';
        MinimumQuantityCaptionLbl: Label 'Minimum Quantity';
        VATTextCaptionLbl: Label 'VAT';

        Addr: array[8] of Text;
        rG_Customer: Record Customer;

        vG_SalesCodeFilter: Code[20];
        vG_StartDate: Date;

        vG_EndDate: Date;

        vG_SortBy: Option Description,"Item No.","Item Reference";
        itemReference: Code[20];
        sortingField: Text[100];

    local procedure GetPriceHandler(Method: Enum "Price Calculation Method"): Enum "Price Calculation Handler";

    var
        PriceCalculationSetup: Record "Price Calculation Setup";
    begin
        if PriceCalculationSetup.FindDefault(Method, PriceCalculationSetup.Type::Sale) then
            exit(PriceCalculationSetup.Implementation);
    end;

    local procedure ValidateMethod()
    begin
        if PriceCalcMethod = PriceCalcMethod::" " then
            PriceCalcMethod := PriceCalcMethod::"Lowest Price";
        PriceCalculationHandler := GetPriceHandler(PriceCalcMethod);
    end;

    local procedure SetCurrency()
    begin
        PricesInCurrency := PriceSource."Currency Code" <> '';
        if PricesInCurrency then begin
            Currency.Get(PriceSource."Currency Code");
            CurrencyText := ' (' + Currency.Code + ')';
            CurrencyFactor := 0;
        end else
            GLSetup.Get();
    end;

    local procedure ConvertPricetoUoM(var UOMCode: Code[10]; var UnitPrice: Decimal)
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if UOMCode = '' then begin
            UnitPrice :=
              UnitPrice * UOMMgt.GetQtyPerUnitOfMeasure(Item, Item."Sales Unit of Measure");
            if UOMCode = '' then
                UOMCode := Item."Sales Unit of Measure"
            else
                UOMCode := Item."Base Unit of Measure";
        end;
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then begin
                if CurrencyFactor = 0 then begin
                    Currency.TestField("Unit-Amount Rounding Precision");
                    CurrencyFactor := CurrExchRate.ExchangeRate(DateReq, Currency.Code);
                end;
                UnitPrice := CurrExchRate.ExchangeAmtLCYToFCY(DateReq, Currency.Code, UnitPrice, CurrencyFactor);
            end;
            UnitPrice := Round(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure SetCurrencyFactorInHeader(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."Posting Date" := DateReq;
        SalesHeader."Currency Code" := Currency.Code;
        SalesHeader.UpdateCurrencyFactor();
    end;

    procedure InitializeRequest(NewDateReq: Date; NewSourceType: Enum "Sales Price Source Type"; NewSourceNo: Code[20];
                                                                     NewCurrencyCode: Code[10])
    begin
        DateReq := NewDateReq;
        SalesSourceType := NewSourceType;
        SalesSourceNo := NewSourceNo;
        Currency.Code := NewCurrencyCode;

        PriceSource.Validate("Source Type", SalesSourceType.AsInteger());
        PriceSource.Validate("Source No.", SalesSourceNo);
        PriceSource."Currency Code" := Currency.Code;


    end;

    procedure GetSalesPriceItemReference(CustNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        SalesPrice: Record "Sales Price";
    begin
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", CustNo);
        SalesPrice.SetRange("Item No.", ItemNo);
        if SalesPrice.FindFirst() then
            exit(SalesPrice."Item Reference");
        exit('');
    end;

}


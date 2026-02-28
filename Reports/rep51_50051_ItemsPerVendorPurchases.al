report 50051 "Items Per Vendor Purchases"
{
    // version JG

    // TAL0.1 2021/04/08 VC add Item No. Filter , exclude blank Item No.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep51_50051_ItemsPerVendorPurchases.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Customer; Vendor)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(QuantityPerCustomer; QuantityPerCustomer)
            {
                DecimalPlaces = 0 : 5;
            }
            column(SalesPerCustomer; SalesPerCustomer)
            {
                AutoFormatType = 1;
            }
            column(DiscountPerCustomer; DiscountPerCustomer)
            {
                AutoFormatType = 1;
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_Item_PurchasesCaption; Vendor_Item_PurchasesCaptionLbl)
            {
            }
            column(Purchase_AmountCaption; Purchase_AmountCaptionLbl)
            {
            }
            column(Unit_PriceCaption; Unit_PriceCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(UoMCaption; UoMCaptionLbl)
            {
            }
            column(Discount_AmountCaption; Discount_AmountCaptionLbl)
            {
            }
            column(Item_No_Caption; Item_No_CaptionLbl)
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(Phone_No__Caption; Phone_No__CaptionLbl)
            {
            }
            column(Vendor_No__Caption; Vendor_No__CaptionLbl)
            {
            }
            column(Vendor_TotalsCaption; Vendor_TotalsCaptionLbl)
            {
            }
            column(Customer_Date_Filter; "Date Filter")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Item No.") ORDER(Ascending) WHERE("Source Type" = CONST(Vendor), "Document Type" = CONST("Purchase Invoice"));
                RequestFilterFields = "Item No.", "Inventory Posting Group", "Posting Date";
                column(Item_Description; Item.Description)
                {
                }
                column(Value_Entry__Value_Entry___Item_No__; "Value Entry"."Item No.")
                {
                }
                column(Value_Entry__Value_Entry___Invoiced_Quantity_; "Value Entry"."Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Item__Base_Unit_of_Measure_; Item."Base Unit of Measure")
                {
                }
                column(Value_Entry__Value_Entry___Discount_Amount_; "Value Entry"."Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(UnitPrice; UnitPrice)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Value_Entry__Value_Entry___Purchase_Amount__Actual__; "Value Entry"."Purchase Amount (Actual)")
                {
                }
                column(Value_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Value_Entry__Value_Entry___Invoiced_Quantity__Control1000000000; "Value Entry"."Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Item__Base_Unit_of_Measure__Control1000000001; Item."Base Unit of Measure")
                {
                }
                column(Value_Entry__Value_Entry___Purchase_Amount__Actual___Control1000000002; "Value Entry"."Purchase Amount (Actual)")
                {
                    AutoFormatType = 1;
                }
                column(Value_Entry__Value_Entry___Discount_Amount__Control1000000003; "Value Entry"."Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(Item_TotalsCaption; Item_TotalsCaptionLbl)
                {
                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Value_Entry_Source_No_; "Source No.")
                {
                }
                column(Value_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Value_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Item.INIT;
                    Item.RESET;
                    Item.GET("Value Entry"."Item No.");

                    if "Invoiced Quantity" <> 0 then
                        UnitPrice := "Purchase Amount (Actual)" / "Invoiced Quantity"
                    else
                        UnitPrice := 0;
                    /*
                    Profit :=  "Purchase Amount (Actual)" + "Cost Amount (Actual)" + "Cost Amount (Non-Invtbl.)";
                    
                    IF "Purchase Amount (Actual)" <> 0 THEN
                      ProfitPct := ROUND(100 * Profit / "Purchase Amount (Actual)",0.01)
                    ELSE
                      ProfitPct := 0;
                    */

                    if "Invoiced Quantity" <> 0 then begin
                        QuantityPerCustomer += "Invoiced Quantity";
                        SalesPerCustomer += "Purchase Amount (Actual)";
                        DiscountPerCustomer += "Discount Amount";
                        //  ProfitPerCustomer += Profit;
                    end;

                end;

                trigger OnPreDataItem();
                begin
                    "Value Entry".SETFILTER("Item No.", '<>%1', ''); //TAL0.1
                end;
            }

            trigger OnAfterGetRecord();
            begin
                QuantityPerCustomer := 0;
                SalesPerCustomer := 0;
                DiscountPerCustomer := 0;
                //ProfitPerCustomer := 0;
                //ProfitPctPerCustomer := 0;
            end;

            trigger OnPreDataItem();
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
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
        CustFilter := Customer.GETFILTERS;
        ItemLedgEntryFilter := "Value Entry".GETFILTERS;
        PeriodText := "Value Entry".GETFILTER("Posting Date");
    end;

    var
        Item: Record Item;
        Profit: Decimal;
        ProfitPct: Decimal;
        UnitPrice: Decimal;
        PrintOnlyOnePerPage: Boolean;
        Text000: Label 'Period: %1';
        PeriodText: Text[30];
        CustFilter: Text[250];
        ItemLedgEntryFilter: Text[250];
        QuantityPerCustomer: Decimal;
        SalesPerCustomer: Decimal;
        DiscountPerCustomer: Decimal;
        SalesPerItem: Decimal;
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendor_Item_PurchasesCaptionLbl: Label 'Vendor/Item Purchases';
        Purchase_AmountCaptionLbl: Label 'Purchase Amount';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        QuantityCaptionLbl: Label 'Quantity';
        UoMCaptionLbl: Label 'UoM';
        Discount_AmountCaptionLbl: Label 'Discount Amount';
        Item_No_CaptionLbl: Label 'Item No.';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        Phone_No__CaptionLbl: Label 'Phone No.:';
        Vendor_No__CaptionLbl: Label 'Vendor No.:';
        Vendor_TotalsCaptionLbl: Label 'Vendor Totals';
        Item_TotalsCaptionLbl: Label 'Item Totals';
}


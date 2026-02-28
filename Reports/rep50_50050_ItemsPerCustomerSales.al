report 50050 "Items Per Customer Sales"
{
    // version Log.SD

    // Log.SD 21.06.10 Code added to skip invoice lines which are closed with a credit memo.
    // TAL0.1 2018/09/17 VC upgrade report new page per customer has not been implemented
    //                      because the grouping is not correct.
    //                      Similar to report 113 it requires 2 groups for the customer.
    //                      by default each customer is on a new page
    // TAL0.2 2021/03/26 VC request to round amounts
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep50_50050_ItemsPerCustomerSales.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
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
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer_Item_SalesCaption; Customer_Item_SalesCaptionLbl)
            {
            }
            column(Sales_AmountCaption; Sales_AmountCaptionLbl)
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
            column(ProfitCaption; ProfitCaptionLbl)
            {
            }
            column(Profit__Caption; Profit__CaptionLbl)
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
            column(Customer_No__Caption; Customer_No__CaptionLbl)
            {
            }
            column(Customer_TotalsCaption; Customer_TotalsCaptionLbl)
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
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(ShowDetails; FORMAT(vG_ShowDetails))
            {
            }
            column(ShowAmounts; FORMAT(vG_ShowAmounts))
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Item No.") ORDER(Ascending) WHERE("Source Type" = CONST(Customer), "Document Type" = CONST("Sales Invoice"));
                RequestFilterFields = "Item No.", "Inventory Posting Group", "Posting Date";
                column(Item_Description; Item.Description)
                {
                }
                column(Value_Entry__Value_Entry___Item_No__; "Value Entry"."Item No.")
                {
                }
                column(Value_Entry___Invoiced_Quantity_; -"Value Entry"."Invoiced Quantity")
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
                column(Profit; Profit)
                {
                    AutoFormatType = 1;
                }
                column(ProfitPct; ProfitPct)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(UnitPrice; UnitPrice)
                {
                    DecimalPlaces = 3 : 3;
                }
                column(Value_Entry__Sales_Amount__Actual__; "Sales Amount (Actual)")
                {
                }
                column(Value_Entry__Value_Entry___Document_Date_; "Value Entry"."Document Date")
                {

                }
                column(Value_Entry___Invoiced_Quantity__Control1000000000; -"Value Entry"."Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Item__Base_Unit_of_Measure__Control1000000001; Item."Base Unit of Measure")
                {
                }
                column(Value_Entry__Value_Entry___Sales_Amount__Actual__; "Value Entry"."Sales Amount (Actual)")
                {
                    AutoFormatType = 1;
                }
                column(Value_Entry__Value_Entry___Discount_Amount__Control1000000003; "Value Entry"."Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(ProfitPerItem; ProfitPerItem)
                {
                    AutoFormatType = 1;
                }
                column(ProfitPctPerItem; ProfitPctPerItem)
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
                column(Value_Entry_Posting_Date; "Posting Date")
                {
                }
                column(Value_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Value_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
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
                column(ProfitPerCustomer; ProfitPerCustomer)
                {
                    AutoFormatType = 1;
                }
                column(ProfitPctPerCustomer; ProfitPctPerCustomer)
                {
                    AutoFormatType = 1;
                }
                column(ValueEntry_TotalWeight; vG_TotalWeight)
                {
                    DecimalPlaces = 0 : 2;
                }
                column(ValueEntry_TotalWeightPerCustomer; TotalWeightPerCustomer)
                {
                    DecimalPlaces = 0 : 0;
                }

                trigger OnAfterGetRecord();
                begin
                    //Log.SD--->>
                    /*
                    CustLedgerEntry.SETCURRENTKEY("Document No.");
                    CustLedgerEntry.SETRANGE("Document No.","Value Entry"."Document No.");
                    CustLedgerEntry.SETRANGE("Customer No.","Value Entry"."Source No.");
                    IF CustLedgerEntry.FINDFIRST THEN BEGIN
                      IF CustLedgerEntry."Closed by Entry No." <> 0 THEN
                        IF CustLedgerEntry2.GET(CustLedgerEntry."Closed by Entry No.") THEN
                          IF CustLedgerEntry2."Document Type" = CustLedgerEntry2."Document Type"::"Credit Memo" THEN
                            CurrReport.SKIP
                    END;
                    */
                    //Log.SD---<<
                    "Invoiced Quantity" := ROUND("Invoiced Quantity", 1); //TAL0.2


                    Item.INIT;
                    Item.RESET;
                    Item.GET("Value Entry"."Item No.");

                    if "Invoiced Quantity" <> 0 then
                        UnitPrice := "Sales Amount (Actual)" / -"Invoiced Quantity"
                    else
                        UnitPrice := 0;

                    Profit := "Sales Amount (Actual)" + "Cost Amount (Actual)" + "Cost Amount (Non-Invtbl.)";

                    if "Sales Amount (Actual)" <> 0 then
                        ProfitPct := ROUND(100 * Profit / "Sales Amount (Actual)", 0.01)
                    else
                        ProfitPct := 0;


                    vG_TotalWeight := 0;

                    if "Invoiced Quantity" <> 0 then begin
                        QuantityPerCustomer -= "Invoiced Quantity";
                        SalesPerCustomer += "Sales Amount (Actual)";
                        DiscountPerCustomer += "Discount Amount";
                        ProfitPerCustomer += Profit;

                        vG_TotalWeight := Item."Net Weight" * -"Value Entry"."Invoiced Quantity";
                        vG_TotalWeight := ROUND(vG_TotalWeight, 1); //TAL0.2
                        TotalWeightPerCustomer += vG_TotalWeight;

                    end;


                    if (SalesPerCustomer <> 0) and (ProfitPerCustomer <> 0) then begin
                        ProfitPctPerCustomer := ROUND(100 * ProfitPerCustomer / SalesPerCustomer, 0.01)
                    end else begin
                        ProfitPctPerCustomer := 0;
                    end;




                    if "Value Entry"."Invoiced Quantity" <> 0 then begin
                        //CurrReport.SHOWOUTPUT(TRUE);
                        ProfitPerItem += Profit;
                        SalesPerItem += "Sales Amount (Actual)";
                    end else begin
                        //CurrReport.SHOWOUTPUT(FALSE);
                        CurrReport.SKIP;
                    end;

                end;

                trigger OnPostDataItem();
                begin
                    //IF PrintOnlyOnePerPage THEN BEGIN
                    //  CurrReport.NEWPAGE;
                    //END;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;

                QuantityPerCustomer := 0;
                SalesPerCustomer := 0;
                DiscountPerCustomer := 0;
                ProfitPerCustomer := 0;
                ProfitPctPerCustomer := 0;

                vG_TotalWeight := 0;
                TotalWeightPerCustomer := 0;
            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
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
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = All;
                        Caption = 'New Page per Customer';
                    }
                    field(ShowDetails; vG_ShowDetails)
                    {
                        ApplicationArea = All;
                        CaptionML = ELL = 'Show Details',
                                    ENU = 'Show Details';
                    }
                    field(ShowAmounts; vG_ShowAmounts)
                    {
                        ApplicationArea = All;
                        CaptionML = ELL = 'Show Amounts',
                                    ENU = 'Show Amounts';
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
        CustFilter: Text[400];
        ItemLedgEntryFilter: Text[400];
        QuantityPerCustomer: Decimal;
        SalesPerCustomer: Decimal;
        DiscountPerCustomer: Decimal;
        ProfitPerCustomer: Decimal;
        ProfitPctPerCustomer: Decimal;
        ProfitPerItem: Decimal;
        ProfitPctPerItem: Decimal;
        SalesPerItem: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_Item_SalesCaptionLbl: Label 'Customer/Item Sales';
        Sales_AmountCaptionLbl: Label 'Sales Amount';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        QuantityCaptionLbl: Label 'Quantity';
        UoMCaptionLbl: Label 'UoM';
        Discount_AmountCaptionLbl: Label 'Discount Amount';
        ProfitCaptionLbl: Label 'Profit';
        Profit__CaptionLbl: Label 'Profit %';
        Item_No_CaptionLbl: Label 'Item No.';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        Phone_No__CaptionLbl: Label 'Phone No.:';
        Customer_No__CaptionLbl: Label 'Customer No.:';
        Customer_TotalsCaptionLbl: Label 'Customer Totals';
        Item_TotalsCaptionLbl: Label 'Item Totals';
        PageGroupNo: Integer;
        vG_TotalWeight: Decimal;
        TotalWeightPerCustomer: Decimal;
        vG_ShowDetails: Boolean;
        vG_ShowAmounts: Boolean;
}


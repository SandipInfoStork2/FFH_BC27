report 50053 "Item Sales Det/Customer period"
{
    // version Log.SD

    // TAL0.1 2018/10/11 VC Upgrade to 2018
    // TAL0.2 2019/02/14 VC review totals
    // TAL0.3 2019/02/18 VC review last column and non zero customers
    // TAL0.4 2021/03/29 VC add option export to excel
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep53_50053_ItemSalesDetCustomerperiod.rdlc';

    CaptionML = ELL = 'Item Sales Detailed/Customer period',
                ENU = 'Item Sales Detailed/Customer period';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Filter", "Item Category Code", "Statistics Group";
            column(PeriodStartDate_1_; FORMAT(PeriodStartDate[1]))
            {
            }
            column(PeriodEndDate; FORMAT(PeriodEndDate))
            {
            }
            column(PeriodLength; PeriodLength)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(PeriodStartDate_1__Control1000000097; FORMAT(PeriodStartDate[1]))
            {
            }
            column(PeriodTodate_1_; FORMAT(PeriodTodate[1]))
            {

            }
            column(TotalsText_1_; TotalsText[1])
            {

            }
            column(PeriodStartDate_2_; FORMAT(PeriodStartDate[2]))
            {
            }
            column(PeriodTodate_2_; FORMAT(PeriodTodate[2]))
            {

            }
            column(TotalsText_2_; TotalsText[2])
            {

            }
            column(PeriodStartDate_3_; FORMAT(PeriodStartDate[3]))
            {
            }
            column(PeriodTodate_3_; FORMAT(PeriodTodate[3]))
            {

            }
            column(TotalsText_3_; TotalsText[3])
            {

            }
            column(PeriodStartDate_4_; FORMAT(PeriodStartDate[4]))
            {
            }
            column(PeriodTodate_4_; FORMAT(PeriodTodate[4]))
            {

            }
            column(TotalsText_4_; TotalsText[4])
            {

            }
            column(PeriodStartDate_5_; FORMAT(PeriodStartDate[5]))
            {
            }
            column(PeriodTodate_5_; FORMAT(PeriodTodate[5]))
            {

            }
            column(TotalsText_5_; TotalsText[5])
            {

            }
            column(PeriodStartDate_6_; FORMAT(PeriodStartDate[6]))
            {
            }
            column(PeriodTodate_6_; FORMAT(PeriodTodate[6]))
            {

            }
            column(TotalsText_6_; TotalsText[6])
            {

            }
            column(PeriodStartDate_7_; FORMAT(PeriodStartDate[7]))
            {
            }
            column(PeriodTodate_7_; FORMAT(PeriodTodate[7]))
            {

            }
            column(TotalsText_7_; TotalsText[7])
            {

            }
            column(PeriodStartDate_8_; FORMAT(PeriodStartDate[8]))
            {
            }
            column(PeriodTodate_8_; FORMAT(PeriodTodate[8]))
            {

            }
            column(TotalsText_8_; TotalsText[8])
            {

            }
            column(PeriodStartDate_9_; FORMAT(PeriodStartDate[9]))
            {
            }
            column(PeriodTodate_9_; FORMAT(PeriodTodate[9]))
            {

            }
            column(TotalsText_9_; TotalsText[9])
            {

            }
            column(PeriodStartDate_10_; FORMAT(PeriodStartDate[10]))
            {
            }
            column(PeriodTodate_10_; FORMAT(PeriodTodate[10]))
            {

            }
            column(TotalsText_10_; TotalsText[10])
            {

            }
            column(PeriodStartDate_11_; FORMAT(PeriodStartDate[11]))
            {
            }
            column(PeriodTodate_11_; FORMAT(PeriodTodate[11]))
            {

            }
            column(TotalsText_11_; TotalsText[11])
            {

            }
            column(PeriodStartDate_12_; FORMAT(PeriodStartDate[12]))
            {
            }
            column(PeriodTodate_12_; FORMAT(PeriodTodate[12]))
            {

            }
            column(TotalsText_12_; TotalsText[12])
            {

            }
            column(TotalsText_13_; TotalsText[13])
            {

            }
            column(CustomerFilter; CustomerFilter)
            {
            }
            column(CustomerFilter_Control1000000005; CustomerFilter)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item_sales_quantity_per_customer_by_periodCaption; Item_sales_quantity_per_customer_by_periodCaptionLbl)
            {
            }
            column(Starting_DateCaption; Starting_DateCaptionLbl)
            {
            }
            column(Ending_DateCaption; Ending_DateCaptionLbl)
            {
            }
            column(Period_LengthCaption; Period_LengthCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer_No_Caption; Customer_No_CaptionLbl)
            {
            }
            column(Customer_NameCaption; Customer_NameCaptionLbl)
            {
            }
            column(Item_sales_quantity_per_customer_by_periodCaption_Control1000000071; Item_sales_quantity_per_customer_by_periodCaption_Control1000000071Lbl)
            {
            }
            column(Starting_DateCaption_Control1000000073; Starting_DateCaption_Control1000000073Lbl)
            {
            }
            column(Ending_DateCaption_Control1000000089; Ending_DateCaption_Control1000000089Lbl)
            {
            }
            column(Period_LengthCaption_Control1000000091; Period_LengthCaption_Control1000000091Lbl)
            {
            }
            column(CurrReport_PAGENO_Control1000000096Caption; CurrReport_PAGENO_Control1000000096CaptionLbl)
            {
            }
            column(Customer_NameCaption_Control1000000136; Customer_NameCaption_Control1000000136Lbl)
            {
            }
            column(Customer_No_Caption_Control1000000137; Customer_No_Caption_Control1000000137Lbl)
            {
            }
            column(Item_No_Caption; Item_No_CaptionLbl)
            {
            }
            column(Item_Location_Filter; "Location Filter")
            {
            }
            column(Item_Variant_Filter; "Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PeriodCount; PeriodCount)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date") WHERE("Entry Type" = CONST(Sale), "Source Type" = CONST(Customer));
                RequestFilterFields = "Source Type", "Source No.";
                column(Value_Entry__Value_Entry___Source_No__; "Item Ledger Entry"."Source No.")
                {
                }
                column(CustName; Cust.Name)
                {
                }
                column(InvoicedQuantity_ValueEntry; "Item Ledger Entry"."Invoiced Quantity")
                {
                }
                column(SalesQty_1_; SalesQty[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_2_; SalesQty[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_3_; SalesQty[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_4_; SalesQty[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_5_; SalesQty[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_6_; SalesQty[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_7_; SalesQty[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_8_; SalesQty[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_9_; SalesQty[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_10_; SalesQty[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_11_; SalesQty[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_12_; SalesQty[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_1_Base; SalesQtyBase[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_2_Base; SalesQtyBase[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_3_Base; SalesQtyBase[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_4_Base; SalesQtyBase[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_5_Base; SalesQtyBase[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_6_Base; SalesQtyBase[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_7_Base; SalesQtyBase[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_8_Base; SalesQtyBase[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_9_Base; SalesQtyBase[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_10_Base; SalesQtyBase[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_11_Base; SalesQtyBase[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_12_Base; SalesQtyBase[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_1_NetWeight; SalesNetWeight[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_2_NetWeight; SalesNetWeight[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_3_NetWeight; SalesNetWeight[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_4_NetWeight; SalesNetWeight[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_5_NetWeight; SalesNetWeight[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_6_NetWeight; SalesNetWeight[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_7_NetWeight; SalesNetWeight[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_8_NetWeight; SalesNetWeight[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_9_NetWeight; SalesNetWeight[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_10_NetWeight; SalesNetWeight[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_11_NetWeight; SalesNetWeight[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesQty_12_NetWeight; SalesNetWeight[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_1_; SalesReturnQty[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_2_; SalesReturnQty[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_3_; SalesReturnQty[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_4_; SalesReturnQty[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_5_; SalesReturnQty[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_6_; SalesReturnQty[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_7_; SalesReturnQty[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_8_; SalesReturnQty[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_9_; SalesReturnQty[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_10_; SalesReturnQty[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_11_; SalesReturnQty[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_12_; SalesReturnQty[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_1_Base; SalesReturnQtyBase[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_2_Base; SalesReturnQtyBase[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_3_Base; SalesReturnQtyBase[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_4_Base; SalesReturnQtyBase[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_5_Base; SalesReturnQtyBase[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_6_Base; SalesReturnQtyBase[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_7_Base; SalesReturnQtyBase[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_8_Base; SalesReturnQtyBase[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_9_Base; SalesReturnQtyBase[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_10_Base; SalesReturnQtyBase[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_11_Base; SalesReturnQtyBase[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_12_Base; SalesReturnQtyBase[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_1_NetWeight; SalesReturnNetWeight[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_2_NetWeight; SalesReturnNetWeight[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_3_NetWeight; SalesReturnNetWeight[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_4_NetWeight; SalesReturnNetWeight[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_5_NetWeight; SalesReturnNetWeight[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_6_NetWeight; SalesReturnNetWeight[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_7_NetWeight; SalesReturnNetWeight[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_8_NetWeight; SalesReturnNetWeight[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_9_NetWeight; SalesReturnNetWeight[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_10_NetWeight; SalesReturnNetWeight[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_11_NetWeight; SalesReturnNetWeight[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(SalesReturnQty_12_NetWeight; SalesReturnNetWeight[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(CustomerTotalSalesQty; CustomerTotalSalesQty)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(CustomerTotalSalesQtyBase; CustomerTotalSalesQtyBase)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(CustomerTotalSalesQtyRet; CustomerTotalSalesQtyRet)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(CustomerTotalSalesQtyRetBase; CustomerTotalSalesQtyRetBase)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_1_; TotalItemSalesQty[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_2_; TotalItemSalesQty[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_3_; TotalItemSalesQty[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_4_; TotalItemSalesQty[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_5_; TotalItemSalesQty[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_6_; TotalItemSalesQty[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_7_; TotalItemSalesQty[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_8_; TotalItemSalesQty[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_9_; TotalItemSalesQty[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_10_; TotalItemSalesQty[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_11_; TotalItemSalesQty[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemSalesQty_12_; TotalItemSalesQty[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(TotalItemCustomerSalesQty; TotalItemCustomerSalesQty)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Total__Caption; Total__CaptionLbl)
                {
                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Value_Entry_Item_No_; "Item No.")
                {
                }
                column(Value_Entry_Location_Code; "Location Code")
                {
                }
                column(Value_Entry_Variant_Code; "Variant Code")
                {
                }
                column(Value_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Value_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(vG_CustCount; vG_CustCount)
                {
                }
                column(GrandSalesQty_1_; GrandSalesQty[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_2_; GrandSalesQty[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_3_; GrandSalesQty[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_4_; GrandSalesQty[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_5_; GrandSalesQty[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_6_; GrandSalesQty[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_7_; GrandSalesQty[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_8_; GrandSalesQty[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_9_; GrandSalesQty[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_10_; GrandSalesQty[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_11_; GrandSalesQty[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_12_; GrandSalesQty[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_1_Base; GrandSalesQtyBase[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_2_Base; GrandSalesQtyBase[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_3_Base; GrandSalesQtyBase[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_4_Base; GrandSalesQtyBase[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_5_Base; GrandSalesQtyBase[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_6_Base; GrandSalesQtyBase[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_7_Base; GrandSalesQtyBase[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_8_Base; GrandSalesQtyBase[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_9_Base; GrandSalesQtyBase[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_10_Base; GrandSalesQtyBase[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_11_Base; GrandSalesQtyBase[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesQty_12_Base; GrandSalesQtyBase[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_1_; GrandSalesReturnQty[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_2_; GrandSalesReturnQty[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_3_; GrandSalesReturnQty[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_4_; GrandSalesReturnQty[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_5_; GrandSalesReturnQty[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_6_; GrandSalesReturnQty[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_7_; GrandSalesReturnQty[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_8_; GrandSalesReturnQty[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_9_; GrandSalesReturnQty[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_10_; GrandSalesReturnQty[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_11_; GrandSalesReturnQty[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_12_; GrandSalesReturnQty[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_1_Base; GrandSalesReturnQtyBase[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_2_Base; GrandSalesReturnQtyBase[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_3_Base; GrandSalesReturnQtyBase[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_4_Base; GrandSalesReturnQtyBase[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_5_Base; GrandSalesReturnQtyBase[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_6_Base; GrandSalesReturnQtyBase[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_7_Base; GrandSalesReturnQtyBase[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_8_Base; GrandSalesReturnQtyBase[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_9_Base; GrandSalesReturnQtyBase[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_10_Base; GrandSalesReturnQtyBase[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_11_Base; GrandSalesReturnQtyBase[11])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandSalesReturnQty_12_Base; GrandSalesReturnQtyBase[12])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandCustomerTotalSalesQty; GrandCustomerTotalSalesQty)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandCustomerTotalSalesQtyBase; GrandCustomerTotalSalesQtyBase)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandCustomerTotalSalesQtyRet; GrandCustomerTotalSalesQtyRet)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(GrandCustomerTotalSalesQtyRetBase; GrandCustomerTotalSalesQtyRetBase)
                {
                    DecimalPlaces = 0 : 0;
                }

                trigger OnAfterGetRecord();
                var
                    rL_Item: Record Item;
                    rL_ILE: Record "Item Ledger Entry";
                    rL_SalesShipmentLine: Record "Sales Shipment Line";
                    r_ReturnReceiptLine: Record "Return Receipt Line";
                begin

                    Cust.RESET;
                    if Cust.GET("Item Ledger Entry"."Source No.") then;

                    if vG_OldCust <> Cust."No." then begin
                        vG_CustCount += 1;
                        for j := 1 to PeriodCount do begin
                            //TotalItemSalesQty[j]:=0;
                        end;

                        CustomerTotalSalesQty := 0;
                        for j := 1 to 12 do begin
                            SalesQty[j] := 0;
                            SalesQtyBase[j] := 0;
                            SalesNetWeight[j] := 0;
                            SalesReturnQty[j] := 0;
                            SalesReturnQtyBase[j] := 0;
                            SalesReturnNetWeight[j] := 0;
                        end;

                        for j := 1 to PeriodCount do begin
                            rL_ILE.RESET;
                            //rL_ILE.SETCURRENTKEY("Source Type","Source No.","Item No.","Posting Date","Entry Type",Adjustment);
                            rL_ILE.SETRANGE("Item No.", Item."No.");
                            rL_ILE.SETRANGE("Entry Type", rL_ILE."Entry Type"::Sale);
                            rL_ILE.SETRANGE("Source Type", rL_ILE."Source Type"::Customer);
                            rL_ILE.SETRANGE("Source No.", "Item Ledger Entry"."Source No.");
                            rL_ILE.SETRANGE("Posting Date", PeriodStartDate[j], PeriodTodate[j]);
                            if Item.GETFILTER(Item."Global Dimension 1 Filter") <> '' then
                                rL_ILE.SETRANGE(rL_ILE."Global Dimension 1 Code", Item.GETFILTER(Item."Global Dimension 1 Filter"));
                            if rL_ILE.FINDSET then
                                repeat

                                    case rL_ILE."Document Type" of
                                        rL_ILE."Document Type"::"Sales Shipment":
                                            begin
                                                rL_SalesShipmentLine.RESET;
                                                rL_SalesShipmentLine.SETFILTER("Document No.", rL_ILE."Document No.");
                                                rL_SalesShipmentLine.SETRANGE("Line No.", rL_ILE."Document Line No.");
                                                if rL_SalesShipmentLine.FINDSET then begin
                                                    SalesQty[j] += rL_SalesShipmentLine.Quantity;
                                                    SalesQtyBase[j] += rL_SalesShipmentLine."Quantity (Base)";
                                                    SalesNetWeight[j] += rL_SalesShipmentLine."Net Weight";

                                                    GrandSalesQty[j] += rL_SalesShipmentLine.Quantity;
                                                    GrandSalesQtyBase[j] += rL_SalesShipmentLine."Quantity (Base)";
                                                end;

                                            end;

                                        rL_ILE."Document Type"::"Sales Return Receipt":
                                            begin
                                                r_ReturnReceiptLine.RESET;
                                                r_ReturnReceiptLine.SETFILTER("Document No.", rL_ILE."Document No.");
                                                r_ReturnReceiptLine.SETRANGE("Line No.", rL_ILE."Document Line No.");
                                                if r_ReturnReceiptLine.FINDSET then begin
                                                    SalesReturnQty[j] += r_ReturnReceiptLine.Quantity * -1;
                                                    SalesReturnQtyBase[j] += r_ReturnReceiptLine."Quantity (Base)" * -1;
                                                    SalesReturnNetWeight[j] += r_ReturnReceiptLine."Net Weight" * -1;

                                                    GrandSalesReturnQty[j] += r_ReturnReceiptLine.Quantity * -1;
                                                    GrandSalesReturnQtyBase[j] += r_ReturnReceiptLine."Quantity (Base)" * -1;
                                                end;

                                            end;
                                    end;
                                //read Sales Shipment Line
                                //Read Sales Return Line



                                until rL_ILE.NEXT = 0;
                            //SalesQty[j] := ABS(SalesQty[j]);
                            CustomerTotalSalesQty += SalesQty[j];
                            CustomerTotalSalesQtyBase += SalesQtyBase[j];
                            CustomerTotalSalesQtyRet += SalesReturnQty[j];
                            CustomerTotalSalesQtyRetBase += SalesReturnQtyBase[j];

                            GrandCustomerTotalSalesQty += SalesQty[j];
                            GrandCustomerTotalSalesQtyBase += SalesQtyBase[j];
                            GrandCustomerTotalSalesQtyRet += SalesReturnQty[j];
                            GrandCustomerTotalSalesQtyRetBase += SalesReturnQtyBase[j];

                            TotalItemSalesQty[j] += SalesQty[j];

                        end; //END OF PERIOD

                        if vG_ExportToExcel then begin
                            MakeLineItem();
                            MakeLineQty();
                            MakeLineQtyBase();
                            MakeLineReturnQty();
                            MakeLineReturnQtyBase();
                        end;

                        TotalItemCustomerSalesQty += CustomerTotalSalesQty;

                        //+TAL0.3
                        if (PeriodCount <> 0) and (PeriodCount < 12) then begin
                            TotalItemSalesQty[PeriodCount + 1] := TotalItemCustomerSalesQty;
                            //TotalItemCustomerSalesQty :=0;
                        end;
                        //-TAL0.3


                        //IF ShowNonzeroCustomers THEN
                        //  CurrReport.SHOWOUTPUT(CustomerTotalSalesQty <> 0 );
                        if (ShowNonzeroCustomers) and (CustomerTotalSalesQty = 0) then begin
                            CurrReport.SKIP;
                        end;

                        if (PeriodCount <> 0) and (PeriodCount < 12) then begin
                            SalesQty[PeriodCount + 1] := CustomerTotalSalesQty;
                            CustomerTotalSalesQty := 0;
                        end;
                    end else begin
                        CurrReport.SKIP;
                    end;


                    vG_OldCust := Cust."No.";
                end;

                trigger OnPreDataItem();
                begin

                    vG_OldCust := '';
                    vG_CustCount := 0;

                    "Item Ledger Entry".SETRANGE("Posting Date", PeriodStartDate[1], PeriodEndDate);
                end;
            }

            trigger OnAfterGetRecord();
            var
                rL_Item: Record Item;
            begin
                if NewPagePerItem then
                    PageGroupNo := PageGroupNo + 1;

                /*IF ShowNonzeroItem THEN BEGIN
                  Item.SETFILTER(Item."Date Filter",'%1..%2',PeriodStartDate[1],PeriodEndDate);
                  IF "Value Entry".GETFILTER("Value Entry"."Source No.") <> ''THEN
                    Item.SETFILTER(Item."Customer Filter","Value Entry".GETFILTER("Value Entry"."Source No."));
                  Item.CALCFIELDS(Item."Sales (Qty.)");
                  IF Item."Sales (Qty.)" = 0 THEN
                    CurrReport.SKIP;
                END;*/

                ItemSalesQty := 0;
                if ShowNonzeroItem then begin
                    ValueEntry1.RESET;
                    ValueEntry1.SETCURRENTKEY("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type", Adjustment);
                    ValueEntry1.SETRANGE(ValueEntry1."Item No.", Item."No.");
                    ValueEntry1.SETRANGE(ValueEntry1."Posting Date", PeriodStartDate[1], PeriodEndDate);
                    ValueEntry1.SETRANGE(ValueEntry1."Item Ledger Entry Type", ValueEntry1."Item Ledger Entry Type"::Sale);
                    if SourceNofilter <> '' then
                        ValueEntry1.SETFILTER(ValueEntry1."Source No.", '%1', SourceNofilter);
                    if ValueEntry1.FINDSET then
                        repeat

                            //IF vG_MenuOption =vG_MenuOption::"Net Weight" THEN BEGIN
                            //  rL_Item.GET(ValueEntry1."Item No.");
                            //  vG_NetWeight:=rL_Item."Net Weight" * ValueEntry1."Invoiced Quantity";
                            //  ItemSalesQty += vG_NetWeight;
                            //END ELSE BEGIN
                            ItemSalesQty += ValueEntry1."Invoiced Quantity";
                        //END;


                        until ValueEntry1.NEXT = 0;

                    if ItemSalesQty = 0 then
                        CurrReport.SKIP;
                end;


                for j := 1 to 12 do begin
                    TotalItemSalesQty[j] := 0;
                end;

                CustomerTotalSalesQty := 0;
                CustomerTotalSalesQtyBase := 0;
                CustomerTotalSalesQtyRet := 0;
                CustomerTotalSalesQtyRetBase := 0;
                TotalItemCustomerSalesQty := 0;

                if NewPagePerItem then
                    CurrReport.NEWPAGE;

            end;

            trigger OnPostDataItem();
            begin
                if vG_ExportToExcel then begin
                    MakeLineBlank();
                    MakeLineGrandQty();
                    MakeLineGrandQtyBase();
                    MakeLineGrandReturnQty();
                    MakeLineGrandReturnQtyBase();
                    ExcelBuf.CreateBookAndOpenExcel('', 'Sales', 'Sales', COMPANYNAME, USERID);
                end;
            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
                //MESSAGE(FORMAT(PeriodCount));
                ChangeTotalsPosition(PeriodCount); //TAL0.3
                CustomerFilter := "Item Ledger Entry".GETFILTERS;

                if vG_ExportToExcel then begin
                    ExcelBuf.SetUseInfoSheet;
                    ExcelBuf.AddInfoColumn(FORMAT('Company Name'), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddInfoColumn(COMPANYNAME, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.NewRow;
                    ExcelBuf.AddInfoColumn(FORMAT('Date'), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddInfoColumn(TODAY, false, false, false, false, '', ExcelBuf."Cell Type"::Text);

                    ExcelBuf.ClearNewRow;

                    MakeHeader;
                end;
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
                    field("PeriodStartDate[1]"; PeriodStartDate[1])
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field(PeriodEndDate; PeriodEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = All;
                        Caption = 'Period Length';
                    }
                    field(NewPagePerItem; NewPagePerItem)
                    {
                        ApplicationArea = All;
                        Caption = 'New page per item';
                    }
                    field(ShowNonzeroItem; ShowNonzeroItem)
                    {
                        ApplicationArea = All;
                        Caption = 'Show non zero items';
                    }
                    field(ShowNonzeroCustomers; ShowNonzeroCustomers)
                    {
                        ApplicationArea = All;
                        Caption = 'Show non zero customers';
                    }
                    field(ExportToExcel; vG_ExportToExcel)
                    {
                        ApplicationArea = All;
                        CaptionML = ELL = 'Export To Excel',
                                    ENU = 'Export To Excel';
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

    trigger OnInitReport();
    begin
        vG_NumberFormat := '#,##0';
    end;

    trigger OnPreReport();
    begin
        if PeriodStartDate[1] = 0D then
            ERROR('Please enter period start date');
        if PeriodEndDate = 0D then
            ERROR('Please enter period end date');

        SourceNofilter := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Source No.");



        TempPeriodStartDate[1] := PeriodStartDate[1];
        for i := 1 to 12 do begin
            TempPeriodStartDate[i + 1] := CALCDATE(PeriodLength, TempPeriodStartDate[i]);

            if TempPeriodStartDate[i] > PeriodEndDate then
                exit;

            if TempPeriodStartDate[i] <> 0D then
                PeriodStartDate[i] := TempPeriodStartDate[i]
            else
                PeriodStartDate[i] := 0D;

            PeriodTodate[i] := CALCDATE(PeriodLength, TempPeriodStartDate[i]) - 1;

            if PeriodTodate[i] >= PeriodEndDate then
                PeriodTodate[i] := PeriodEndDate;
            PeriodCount += 1;
        end;
    end;

    var
        PeriodLength: DateFormula;
        PeriodStartDate: array[14] of Date;
        PeriodEndDate: Date;
        i: Integer;
        TempPeriodStartDate: array[14] of Date;
        PeriodTodate: array[14] of Date;
        ItemLedgEntry: Record "Item Ledger Entry";
        PeriodCount: Integer;
        j: Integer;
        TotalsText: array[14] of Text[30];
        SalesQty: array[14] of Decimal;
        SalesQtyBase: array[14] of Decimal;
        SalesNetWeight: array[14] of Decimal;
        SalesReturnQty: array[14] of Decimal;
        SalesReturnQtyBase: array[14] of Decimal;
        SalesReturnNetWeight: array[14] of Decimal;
        GrandSalesQty: array[14] of Decimal;
        GrandSalesQtyBase: array[14] of Decimal;
        GrandSalesReturnQty: array[14] of Decimal;
        GrandSalesReturnQtyBase: array[14] of Decimal;
        NewPagePerItem: Boolean;
        ShowNonzeroItem: Boolean;
        ShowNonzeroCustomers: Boolean;
        TotalItemSalesQty: array[14] of Decimal;
        CustomerTotalSalesQty: Decimal;
        CustomerTotalSalesQtyBase: Decimal;
        CustomerTotalSalesQtyRet: Decimal;
        CustomerTotalSalesQtyRetBase: Decimal;
        GrandCustomerTotalSalesQty: Decimal;
        GrandCustomerTotalSalesQtyBase: Decimal;
        GrandCustomerTotalSalesQtyRet: Decimal;
        GrandCustomerTotalSalesQtyRetBase: Decimal;
        Cust: Record Customer;
        TotalItemCustomerSalesQty: Decimal;
        ItemSalesQty: Decimal;
        ValueEntry1: Record "Value Entry";
        SourceNofilter: Code[80];
        CustomerFilter: Text[100];
        Item_sales_quantity_per_customer_by_periodCaptionLbl: Label 'Item sales quantity per customer by period';
        Starting_DateCaptionLbl: Label 'Starting Date';
        Ending_DateCaptionLbl: Label 'Ending Date';
        Period_LengthCaptionLbl: Label 'Period Length';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_No_CaptionLbl: Label 'Customer No.';
        Customer_NameCaptionLbl: Label 'Customer Name';
        Item_sales_quantity_per_customer_by_periodCaption_Control1000000071Lbl: Label 'Item sales quantity per customer by period';
        Starting_DateCaption_Control1000000073Lbl: Label 'Starting Date';
        Ending_DateCaption_Control1000000089Lbl: Label 'Ending Date';
        Period_LengthCaption_Control1000000091Lbl: Label 'Period Length';
        CurrReport_PAGENO_Control1000000096CaptionLbl: Label 'Page';
        Customer_NameCaption_Control1000000136Lbl: Label 'Customer Name';
        Customer_No_Caption_Control1000000137Lbl: Label 'Customer No.';
        Item_No_CaptionLbl: Label 'Item No.';
        Total__CaptionLbl: Label 'Total :';
        vG_OldCust: Code[20];
        PageGroupNo: Integer;
        vG_NetWeight: Decimal;
        vG_CustCount: Integer;
        ExcelBuf: Record "Excel Buffer" temporary;
        vG_ExportToExcel: Boolean;
        vG_NumberFormat: Text;

    procedure ChangeTotalsPosition(EndingPeriod: Integer);
    begin
        if (EndingPeriod <> 0) and (EndingPeriod < 12) then begin
            TotalsText[EndingPeriod + 1] := 'Total';
        end;

        if (EndingPeriod >= 12) then
            TotalsText[13] := 'Total';
    end;

    local procedure MakeHeader();
    begin
        //ExcelBuf.NewRow;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item No.', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[1]) + '..' + FORMAT(PeriodTodate[1]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[2]) + '..' + FORMAT(PeriodTodate[2]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[3]) + '..' + FORMAT(PeriodTodate[3]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[4]) + '..' + FORMAT(PeriodTodate[4]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[5]) + '..' + FORMAT(PeriodTodate[5]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[6]) + '..' + FORMAT(PeriodTodate[6]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[7]) + '..' + FORMAT(PeriodTodate[7]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[8]) + '..' + FORMAT(PeriodTodate[8]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[9]) + '..' + FORMAT(PeriodTodate[9]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[10]) + '..' + FORMAT(PeriodTodate[10]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[11]) + '..' + FORMAT(PeriodTodate[11]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(PeriodStartDate[12]) + '..' + FORMAT(PeriodTodate[12]), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeLineItem();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Item."No.", false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeLineQty();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty (KG)', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesQty[1], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[2], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[3], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[4], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[5], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[6], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[7], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[8], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[9], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[10], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[11], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQty[12], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustomerTotalSalesQty, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineQtyBase();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty (Carton)', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesQtyBase[1], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[2], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[3], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[4], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[5], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[6], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[7], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[8], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[9], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[10], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[11], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesQtyBase[12], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustomerTotalSalesQtyBase, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineReturnQty();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Return Qty (KG)', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesReturnQty[1], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[2], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[3], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[4], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[5], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[6], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[7], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[8], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[9], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[10], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[11], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQty[12], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustomerTotalSalesQtyRet, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineReturnQtyBase();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Return Qty (Carton)', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesReturnQtyBase[1], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[2], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[3], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[4], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[5], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[6], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[7], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[8], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[9], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[10], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[11], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesReturnQtyBase[12], false, '', false, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustomerTotalSalesQtyRetBase, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineGrandQty();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Qty (KG)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GrandSalesQty[1], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[2], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[3], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[4], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[5], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[6], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[7], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[8], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[9], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[10], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[11], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQty[12], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandCustomerTotalSalesQty, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineGrandQtyBase();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Qty (Carton)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GrandSalesQtyBase[1], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[2], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[3], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[4], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[5], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[6], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[7], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[8], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[9], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[10], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[11], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesQtyBase[12], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandCustomerTotalSalesQtyBase, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineGrandReturnQty();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Return Qty (KG)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GrandSalesReturnQty[1], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[2], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[3], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[4], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[5], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[6], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[7], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[8], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[9], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[10], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[11], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQty[12], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandCustomerTotalSalesQtyRet, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineGrandReturnQtyBase();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Return Qty (Carton)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[1], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[2], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[3], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[4], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[5], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[6], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[7], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[8], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[9], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[10], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[11], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandSalesReturnQtyBase[12], false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandCustomerTotalSalesQtyRetBase, false, '', true, false, false, vG_NumberFormat, ExcelBuf."Cell Type"::Number);
    end;

    local procedure MakeLineBlank();
    begin


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', false, false, true, '', ExcelBuf."Cell Type"::Text);
    end;
}


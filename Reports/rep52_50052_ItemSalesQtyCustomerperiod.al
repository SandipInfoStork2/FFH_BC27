report 50052 "Item Sales Qty/Customer period"
{
    // version Log.SD

    // TAL0.1 2018/10/11 VC Upgrade to 2018
    // TAL0.2 2019/02/14 VC review totals
    // TAL0.3 2019/02/18 VC review last column and non zero customers
    // //
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep52_50052_ItemSalesQtyCustomerperiod.rdlc';

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
            column(MenuOption; FORMAT(vG_MenuOption))
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type", Adjustment) WHERE("Item Ledger Entry Type" = FILTER(Sale), "Source Type" = FILTER(Customer));
                RequestFilterFields = "Source No.", "Source Posting Group";
                column(Value_Entry__Value_Entry___Source_No__; "Value Entry"."Source No.")
                {
                }
                column(CustName; Cust.Name)
                {
                }
                column(InvoicedQuantity_ValueEntry; "Value Entry"."Invoiced Quantity")
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
                column(CustomerTotalSalesQty; CustomerTotalSalesQty)
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

                trigger OnAfterGetRecord();
                var
                    rL_Item: Record Item;
                begin

                    Cust.RESET;
                    if Cust.GET("Value Entry"."Source No.") then;

                    if vG_OldCust <> Cust."No." then begin
                        vG_CustCount += 1;
                        for j := 1 to PeriodCount do begin
                            //TotalItemSalesQty[j]:=0;
                        end;

                        CustomerTotalSalesQty := 0;
                        for j := 1 to 12 do begin
                            SalesQty[j] := 0;
                        end;

                        for j := 1 to PeriodCount do begin
                            ValueEntry.RESET;
                            ValueEntry.SETCURRENTKEY("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type", Adjustment);
                            ValueEntry.SETRANGE(ValueEntry."Item No.", Item."No.");
                            ValueEntry.SETRANGE(ValueEntry."Source No.", "Value Entry"."Source No.");
                            ValueEntry.SETRANGE(ValueEntry."Posting Date", PeriodStartDate[j], PeriodTodate[j]);
                            ValueEntry.SETRANGE(ValueEntry."Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                            if Item.GETFILTER(Item."Global Dimension 1 Filter") <> '' then
                                ValueEntry.SETRANGE(ValueEntry."Global Dimension 1 Code", Item.GETFILTER(Item."Global Dimension 1 Filter"));
                            if ValueEntry.FINDFIRST then
                                repeat
                                    if vG_MenuOption = vG_MenuOption::"Net Weight" then begin
                                        rL_Item.GET(ValueEntry1."Item No.");
                                        vG_NetWeight := rL_Item."Net Weight" * ValueEntry."Invoiced Quantity";
                                        SalesQty[j] += vG_NetWeight;
                                    end else begin
                                        SalesQty[j] += ValueEntry."Invoiced Quantity";
                                    end;


                                until ValueEntry.NEXT = 0;
                            SalesQty[j] := ABS(SalesQty[j]);
                            CustomerTotalSalesQty += SalesQty[j];
                            TotalItemSalesQty[j] += SalesQty[j];
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
                    "Value Entry".SETRANGE("Posting Date", PeriodStartDate[1], PeriodEndDate);
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
                    if ValueEntry1.FINDFIRST then
                        repeat

                            if vG_MenuOption = vG_MenuOption::"Net Weight" then begin
                                rL_Item.GET(ValueEntry1."Item No.");
                                vG_NetWeight := rL_Item."Net Weight" * ValueEntry1."Invoiced Quantity";
                                ItemSalesQty += vG_NetWeight;
                            end else begin
                                ItemSalesQty += ValueEntry1."Invoiced Quantity";
                            end;


                        until ValueEntry1.NEXT = 0;

                    if ItemSalesQty = 0 then
                        CurrReport.SKIP;
                end;


                for j := 1 to 12 do begin
                    TotalItemSalesQty[j] := 0;
                end;

                CustomerTotalSalesQty := 0;
                TotalItemCustomerSalesQty := 0;

                if NewPagePerItem then
                    CurrReport.NEWPAGE;

            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
                //MESSAGE(FORMAT(PeriodCount));
                ChangeTotalsPosition(PeriodCount); //TAL0.3
                CustomerFilter := "Value Entry".GETFILTERS;
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
                    field(MenuOption; vG_MenuOption)
                    {
                        ApplicationArea = All;
                        CaptionML = ELL = 'Qty/Net Weight',
                                    ENU = 'Qty/Net Weight';
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
        if PeriodStartDate[1] = 0D then
            ERROR('Please enter period start date');
        if PeriodEndDate = 0D then
            ERROR('Please enter period end date');

        SourceNofilter := "Value Entry".GETFILTER("Value Entry"."Source No.");



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
        NewPagePerItem: Boolean;
        ShowNonzeroItem: Boolean;
        ShowNonzeroCustomers: Boolean;
        TotalItemSalesQty: array[14] of Decimal;
        CustomerTotalSalesQty: Decimal;
        Cust: Record Customer;
        ValueEntry: Record "Value Entry";
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
        vG_MenuOption: Option Qty,"Net Weight";
        vG_NetWeight: Decimal;
        vG_CustCount: Integer;

    procedure ChangeTotalsPosition(EndingPeriod: Integer);
    begin
        if (EndingPeriod <> 0) and (EndingPeriod < 12) then begin
            TotalsText[EndingPeriod + 1] := 'Total';
        end;

        if (EndingPeriod >= 12) then
            TotalsText[13] := 'Total';
    end;
}


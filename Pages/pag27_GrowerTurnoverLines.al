page 50027 "Grower Turnover Lines"
{
    // version NAVW110.0

    // TAL0.2 2021/03/27 VC rename field Purchases (PKG) to Purchases (PCS/KG)

    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Date;
    SourceTableView = WHERE("Period Start" = FILTER('01012021..311225'));
    //FILTER('20210101D .. 19311231D')

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Period Start"; "Period Start")
                {
                    ApplicationArea = All;
                    Caption = 'Period Start';
                }
                field("Period Name"; "Period Name")
                {
                    ApplicationArea = All;
                    Caption = 'Period Name';
                }

                field(PurchasesQty; Grower.GetPurchasesQty())
                {
                    ApplicationArea = All;
                    Caption = 'Purchases (Qty.)';
                    DecimalPlaces = 0 : 0;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }

                field(PurchasesKG; Grower.GetPurchasesTotalNetWeight())
                {
                    ApplicationArea = All;
                    //AutoFormatType = 1;
                    CaptionML = ELL = 'Purchases (PCS/KG)',
                                ENU = 'Purchases (PCS/KG)';
                    DrillDown = true;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }

                field(SalesQty; Grower.GetSalesQty())
                {
                    ApplicationArea = All;
                    Caption = 'Sales (Qty.)';
                    DecimalPlaces = 0 : 0;
                    DrillDown = true;
                    Editable = false;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }
                field(SalesKG; Grower.GetSalesTotalNetWeight())
                {
                    ApplicationArea = All;
                    //AutoFormatType = 1;
                    CaptionML = ELL = 'Sales (KG)',
                                ENU = 'Sales (KG)';
                    DrillDown = true;
                    Editable = false;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }

                /*
                field(PurchasesQty; Grower."Purchases (Qty.)")
                {
                    ApplicationArea = All;
                    Caption = 'Purchases (Qty.)';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }
                field(PurchasesKG; Grower."Purchases (PCS/KG)")
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    CaptionML = ELL = 'Purchases (PCS/KG)',
                                ENU = 'Purchases (PCS/KG)';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }
                field(SalesQty; Grower."Sales (Qty.)")
                {
                    ApplicationArea = All;
                    Caption = 'Sales (Qty.)';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }
                field(SalesKG; Grower."Sales (KG)")
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    CaptionML = ELL = 'Sales (KG)',
                                ENU = 'Sales (KG)';
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }
                */
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        SetDateFilter;
        SetCustNoFilter;





        //Grower.CALCFIELDS("Purchases (Qty.)", "Purchases (PCS/KG)", "Sales (Qty.)", "Sales (KG)");
    end;

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        exit(PeriodFormMgt.FindDate(Which, Rec, PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        exit(PeriodFormMgt.NextDate(Steps, Rec, PeriodType));
    end;

    trigger OnOpenPage();
    begin
        RESET;
    end;

    var
        Grower: Record Grower;
        ItemLedgEntry: Record "Item Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        vG_CustomerNoFilter: Code[20];

    procedure Set(var NewGrower: Record Grower; NewPeriodType: Integer; NewAmountType: Option "Net Change","Balance at Date"; NewCustNoFilter: Code[20]);
    begin
        Grower.COPY(NewGrower);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        vG_CustomerNoFilter := NewCustNoFilter;
        CurrPage.UPDATE(false);
    end;

    local procedure ShowItemEntries(ShowSales: Boolean);
    begin
        SetDateFilter;
        ItemLedgEntry.RESET;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETCURRENTKEY("Entry Type", "Document Grower No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", Grower."No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SETFILTER("Posting Date", Grower.GETFILTER("Date Filter"));




        if ShowSales then begin
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
            if vG_CustomerNoFilter <> '' then begin
                ItemLedgEntry.SETFILTER("Source No.", vG_CustomerNoFilter);
            end;
        end else begin
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);

        end;
        PAGE.RUN(0, ItemLedgEntry);
    end;

    local procedure SetDateFilter();
    begin
        if AmountType = AmountType::"Net Change" then
            Grower.SETRANGE("Date Filter", "Period Start", "Period End")
        else
            Grower.SETRANGE("Date Filter", 0D, "Period End");
    end;

    local procedure ShowPurchaseItemEntries(ShowSales: Boolean);
    begin
        SetDateFilter;
        ItemLedgEntry.RESET;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETCURRENTKEY("Entry Type", "Source Type", "Source No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", Grower."No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SETRANGE("Source Type", ItemLedgEntry."Source Type"::Vendor);
        //ItemLedgEntry.SETFILTER("Source No.",Grower."Grower Vendor No.");
        ItemLedgEntry.SETFILTER("Posting Date", Grower.GETFILTER("Date Filter"));
        if ShowSales then
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale)
        else
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
        PAGE.RUN(0, ItemLedgEntry);
    end;

    local procedure SetCustNoFilter();
    begin
        if vG_CustomerNoFilter <> '' then begin
            Grower.SETFILTER("Customer No. Filter", vG_CustomerNoFilter);
        end else begin

        end;
    end;
}


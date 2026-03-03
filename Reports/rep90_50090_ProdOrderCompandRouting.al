report 50090 "Prod. Order Comp. and RoutingF"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep90_50090_ProdOrderCompandRouting.rdlc';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order Comp. and Routing';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.", "Creation Date", "Due Date", "Location Code"; //TAL
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; CompanyProperty.DisplayName)
            {
            }
            column(Status_ProductionOrder; Status)
            {
                IncludeCaption = true;
            }
            column(No_ProductionOrder; "No.")
            {
                IncludeCaption = true;
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(PrdOdrCmptsandRtngLinsCpt; PrdOdrCmptsandRtngLinsCptLbl)
            {
            }
            column(ProductionOrderDescCapt; ProductionOrderDescCaptLbl)
            {
            }

            //+1.0.0.229
            column(PackingAgent_ProductionOrder; "Packing Agent")
            {
            }
            //-1.0.0.229

            //+1.0.0.240
            column(ShowLotSN_ProductionOrder; ShowLotSN)
            {
            }
            //-1.0.0.240



            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.");
                RequestFilterFields = "Item No.", "Line No.";
                column(No1_ProductionOrder; "Production Order"."No.")
                {
                }
                column(Desc_ProductionOrder; "Production Order".Description)
                {
                }
                column(Desc_ProdOrderLine; Description)
                {
                }
                column(Quantity_ProdOrderLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }

                column(ShelfNo_ProdOrderLine; "Shelf No.")
                {
                }
                column(StartgDate_ProdOrderLine; Format("Starting Date"))
                {
                }
                column(StartgTime_ProdOrderLine; "Starting Time")
                {
                    IncludeCaption = true;
                }
                column(EndingDate_ProdOrderLine; Format("Ending Date"))
                {
                }
                column(EndingTime_ProdOrderLine; "Ending Time")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderLine; Format("Due Date"))
                {
                }
                column(LineNo_ProdOrderLine; "Line No.")
                {
                }
                column(ProdOdrLineStrtngDteCapt; ProdOdrLineStrtngDteCaptLbl)
                {
                }
                column(ProdOrderLineEndgDteCapt; ProdOrderLineEndgDteCaptLbl)
                {
                }
                column(ProdOrderLineDueDateCapt; ProdOrderLineDueDateCaptLbl)
                {
                }


                column(LotNosSection2_ProdOrderLine; LotNosSection2)
                {
                }



                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(ItemNo_PrdOrdrComp; "Item No.")
                    {
                    }
                    column(ItemNo_PrdOrdrCompCaption; FieldCaption("Item No."))
                    {
                    }
                    column(Description_ProdOrderComp; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_ProdOrderComp; "Quantity per")
                    {
                        IncludeCaption = true;
                    }
                    column(UntofMesrCode_PrdOrdrComp; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(RemainingQty_PrdOrdrComp; "Remaining Quantity")
                    {
                        IncludeCaption = true;
                    }
                    column(DueDate_PrdOrdrComp; Format("Due Date"))
                    {
                    }
                    column(ProdOrdrLinNo_PrdOrdrComp; "Prod. Order Line No.")
                    {
                    }
                    column(LineNo_PrdOrdrComp; "Line No.")
                    {
                    }

                    column(ExpectedQty_PrdOrdrComp; "Expected Quantity")
                    {
                        IncludeCaption = true;
                    }

                    column(PostedQty_PrdOrdrComp; "Posted Quantity")
                    {
                        IncludeCaption = true;
                    }

                    //+1.0.0.226
                    column(QuantityperBUOM_ProdOrderComp; "Quantity per BUOM")
                    {

                    }

                    column(QuantityBUOM_ProdOrderComp; QuantityBUOM)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    //-1.0.0.226

                    column(LotNos_ProdOrderComp; LotNos)
                    {

                    }

                    trigger OnAfterGetRecord()

                    var
                        //ValueEntry: Record "Value Entry";
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        "BatchNo." := '';
                        ExpDate := 0D;
                        LotNos := '';

                        //+1.0.0.226
                        QuantityBUOM := 0;
                        QuantityBUOM := "Prod. Order Component"."Quantity per BUOM" * "Production Order".Quantity;
                        //-1.0.0.226

                        if ProductionJrnlMgt.RoutingLinkValid("Prod. Order Component", "Prod. Order Line") then
                            CurrReport.Skip();

                        //+1.0.0.240
                        if ShowLotSN then begin
                            ItemLedgerEntry.Reset;
                            ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                            ItemLedgerEntry.SetRange("Order No.", "Prod. Order Component"."Prod. Order No.");
                            ItemLedgerEntry.SetRange("Order Line No.", "Prod. Order Component"."Prod. Order Line No.");
                            ItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", "Prod. Order Component"."Line No.");
                            if ItemLedgerEntry.FindFirst then begin
                                repeat
                                    "BatchNo." := ItemLedgerEntry."Lot No.";
                                    ExpDate := ItemLedgerEntry."Expiration Date";
                                    //RetrieveAppliedExpirationDate(ItemLedgerEntry);
                                    if ExpDate = 0D then begin
                                        if "BatchNo." <> '' then
                                            LotNos += StrSubstNo(' ,Qty:%1 LOT:%2', //STRSUBSTNO(' ,(Qty:%1 LOT:%2)',
                                              -1 * ItemLedgerEntry.Quantity / "Qty. per Unit of Measure", "BatchNo.");
                                    end else
                                        if "BatchNo." <> '' then
                                            LotNos += StrSubstNo(' ,Qty:%1 LOT:%2 Exp. Date:%3', // STRSUBSTNO(' ,(Qty:%1 LOT:%2 Exp. Date:%3)',
                                              -1 * ItemLedgerEntry.Quantity / "Qty. per Unit of Measure", "BatchNo.", ExpDate);
                                until ItemLedgerEntry.Next = 0;
                            end;

                            if LotNos <> '' then
                                LotNos := CopyStr(LotNos, 3, StrLen(LotNos) - 2);
                        end;
                        //-1.0.0.240

                    end;
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Routing No." = field("Routing No."), "Routing Reference No." = field("Routing Reference No."), "Prod. Order No." = field("Prod. Order No."), Status = field(Status);
                    DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                    column(OprNo_ProdOrderRtngLine; "Operation No.")
                    {
                    }
                    column(OprNo_ProdOrderRtngLineCaption; FieldCaption("Operation No."))
                    {
                    }
                    column(Type_PrdOrdRtngLin; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(LinDesc_ProdOrderRtngLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(StrgDt_ProdOrderRtngLine; Format("Starting Date"))
                    {
                    }
                    column(LinStrgTime_PrdOrdRtngLin; "Starting Time")
                    {
                        IncludeCaption = true;
                    }
                    column(EndgDte_ProdOrdrRtngLine; Format("Ending Date"))
                    {
                    }
                    column(EndgTime_ProdOrdrRtngLin; "Ending Time")
                    {
                        IncludeCaption = true;
                    }
                    column(RoutgNo_ProdOrdrRtngLine; "Routing No.")
                    {
                    }
                    dataitem(CompLink; "Prod. Order Component")
                    {
                        DataItemLink = Status = field(Status), "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Routing Reference No."), "Routing Link Code" = field("Routing Link Code");
                        DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method") where("Routing Link Code" = filter(<> ''));
                        column(ItemNo_CompLink; "Item No.")
                        {
                        }
                        column(Description_CompLink; Description)
                        {
                        }
                        column(Quantityper_CompLink; "Quantity per")
                        {
                        }
                        column(UntofMeasureCode_CompLink; "Unit of Measure Code")
                        {
                        }
                        column(DueDate_CompLink; Format("Due Date"))
                        {
                        }
                        column(RemainingQty_CompLink; "Remaining Quantity")
                        {
                        }
                        column(LineNo_CompLink; "Line No.")
                        {
                        }
                        column(RoutingLinkCode_CompLink; "Routing Link Code")
                        {
                        }
                    }
                }


                trigger OnAfterGetRecord()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    LotNosSection2 := '';
                    BatchNoSection := '';
                    ExpDateSection2 := 0D;
                    //+1.0.0.240
                    if ShowLotSN then begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                        ItemLedgerEntry.SetRange("Order No.", "Prod. Order Line"."Prod. Order No.");
                        ItemLedgerEntry.SetRange("Order Line No.", "Prod. Order Line"."Line No.");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);

                        if ItemLedgerEntry.FindFirst then begin
                            repeat
                                BatchNoSection := ItemLedgerEntry."Lot No.";
                                ExpDateSection2 := ItemLedgerEntry."Expiration Date";
                                //RetrieveAppliedExpirationDate(ItemLedgerEntry);
                                if ExpDateSection2 = 0D then begin
                                    if BatchNoSection <> '' then
                                        // LotNosSection2 += STRSUBSTNO(' ,Qty:%1 LOT:%2', //STRSUBSTNO(' ,(Qty:%1 LOT:%2)',
                                        //  ItemLedgerEntry.Quantity / "Qty. per Unit of Measure", BatchNoSection);

                                        LotNosSection2 += StrSubstNo(' ,LOT:%1', //STRSUBSTNO(' ,(Qty:%1 LOT:%2)',
                                           BatchNoSection);
                                end else
                                    if BatchNoSection <> '' then
                                        //LotNosSection2 += STRSUBSTNO(' ,Qty:%1 LOT:%2 Exp. Date:%3', // STRSUBSTNO(' ,(Qty:%1 LOT:%2 Exp. Date:%3)',
                                        //  ItemLedgerEntry.Quantity / "Qty. per Unit of Measure", BatchNoSection, ExpDateSection2);
                                        LotNosSection2 += StrSubstNo(' ,LOT:%1 Exp. Date:%2', // STRSUBSTNO(' ,(Qty:%1 LOT:%2 Exp. Date:%3)',
                                          BatchNoSection, ExpDateSection2);

                            until ItemLedgerEntry.Next = 0;
                        end;

                        if LotNosSection2 <> '' then
                            LotNosSection2 := CopyStr(LotNosSection2, 3, StrLen(LotNosSection2) - 2);

                    end;
                    //-1.0.0.240
                end;

            }
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
                    field(ShowLotSN; ShowLotSN)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Lot Number'; //'Show Lot Number Appendix';
                        ToolTip = 'Custom: Show Lot Number';
                        //ToolTip = 'Specifies if you want to print an appendix to the sales invoice report showing the lot and serial numbers in the invoice.';
                        Visible = true;
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

    local procedure RetrieveAppliedExpirationDate(ItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        if ItemLedgEntry.Positive then
            exit;

        ItemApplnEntry.Reset;
        ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
        ItemApplnEntry.SetRange("Outbound Item Entry No.", ItemLedgEntry."Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        if ItemApplnEntry.FindFirst then begin
            if ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.") then begin
                ExpDate := ItemLedgEntry."Expiration Date";
            end;

        end;


    end;

    var
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        CurrReportPageNoCaptLbl: Label 'Page';
        PrdOdrCmptsandRtngLinsCptLbl: Label 'Prod. Order - Components and Routing Lines';
        ProductionOrderDescCaptLbl: Label 'Description';
        ProdOdrLineStrtngDteCaptLbl: Label 'Starting Date';
        ProdOrderLineEndgDteCaptLbl: Label 'Ending Date';
        ProdOrderLineDueDateCaptLbl: Label 'Due Date';

        QuantityBUOM: Decimal;

        ShowLotSN: Boolean;

        LotNos: Text;
        "BatchNo.": Code[30];
        ExpDate: Date;

        LotNosSection2: Text;
        BatchNoSection: Code[30];
        ExpDateSection2: Date;
}


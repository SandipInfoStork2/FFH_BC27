page 50035 "S.Q. Lidl Costing Subform"
{
    AutoSplitKey = true;
    Caption = 'Lidl Costing Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Quote));


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                FreezeColumn = Description;
                field(Type; Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                    Visible = true;
                    Width = 5;

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field(FilteredTypeField; TypeAsText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    Editable = CurrPageIsEditable;
                    LookupPageID = "Option Lookup List";
                    TableRelation = "Option Lookup Buffer"."Option Caption" WHERE("Lookup Type" = CONST(Sales));
                    ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
                    Visible = IsFoundation;

                    trigger OnValidate()
                    begin
                        TempOptionLookupBuffer.SetCurrentType(Rec.Type.AsInteger());
                        if TempOptionLookupBuffer.AutoCompleteLookup(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Sales) then
                            Rec.Validate(Type, TempOptionLookupBuffer.ID);
                        TempOptionLookupBuffer.ValidateOption(TypeAsText);
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }



                field("Item Reference No."; "Item Reference No.")
                {
                    ApplicationArea = Suite, ItemReferences;
                    ToolTip = 'Specifies the referenced item number.';
                    Visible = ItemReferenceVisible;
                    Width = 5;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemReferenceMgt: Codeunit "Item Reference Management";
                    begin
                        ItemReferenceMgt.SalesReferenceNoLookup(Rec);
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        OnItemReferenceNoOnLookup(Rec);
                    end;

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        DeltaUpdateTotals();
                    end;
                }

                field(Checked; Checked)
                {
                    ApplicationArea = all;
                    Width = 1;
                }



                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = NOT IsCommentLine;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                    StyleExpr = vG_Style;
                    Width = 8;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }

                field(Description; Description)
                {
                    ApplicationArea = all;
                    Width = 30;
                }
                field("Category 1"; "Category 1")
                {
                    ApplicationArea = all;
                    Width = 5;
                }

                field("Pallet Qty"; "Pallet Qty")
                {
                    ApplicationArea = all;
                    Width = 5;
                }

                field("Package Qty"; "Package Qty")
                {
                    ApplicationArea = all;
                    Caption = 'Κιβώτιο -  Περιεχόμενο';
                    Width = 5;

                }

                field(Variety; Variety)
                {
                    ApplicationArea = all;
                    Width = 15;
                }

                //Cost
                field("Cost Per KG"; "Cost Per KG")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Cost kg/stk"; "Cost kg/stk")
                {
                    ApplicationArea = all;
                    Width = 5;

                    trigger OnValidate()
                    begin
                        "Manual kg/stk" := true;
                    end;
                }

                field("Manual kg/stk"; "Manual kg/stk")
                {
                    ApplicationArea = all;
                    caption = '';
                    Width = 1;
                }

                field("Cost KG/PC"; "Cost KG/PC")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Cost Carton"; "Cost Carton")
                {
                    ApplicationArea = all;
                    Width = 5;

                    trigger OnValidate()
                    begin
                        "Manual Cost Carton" := true;
                    end;
                }

                field("Manual Cost Carton"; "Manual Cost Carton")
                {
                    ApplicationArea = all;
                    caption = '';
                    Width = 1;
                }

                field("Cost Cup"; "Cost Cup")
                {
                    ApplicationArea = all;
                    Width = 5;

                    trigger OnValidate()
                    begin
                        "Manual Cost Cup" := true;
                    end;
                }
                field("Manual Cost Cup"; "Manual Cost Cup")
                {
                    ApplicationArea = all;
                    caption = '';
                    Width = 1;
                }

                field("Cost Other"; "Cost Other")
                {
                    ApplicationArea = all;
                    Width = 5;

                    trigger OnValidate()
                    begin
                        "Manual Cost Other" := true;
                    end;
                }
                field("Manual Cost Other"; "Manual Cost Other")
                {
                    ApplicationArea = all;
                    caption = '';
                    Width = 1;
                }
                field("Cost Offer"; "Cost Offer")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Cost Profit %"; "Cost Profit %")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Width = 5;
                }
                field("Cost Offer+GP"; "Cost Offer+GP")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    Width = 5;
                }

                field("Cost Valuation"; "Cost Valuation")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Sales Profit %"; "Sales Profit %")
                {
                    ApplicationArea = all;
                    ToolTip = ' "Sales Profit %" := (("Price PCS" - "Cost Offer+GP") / "Cost Offer+GP") * 100';
                    Width = 5;
                }



                //Cost Lines

                field("Price Previous Week Box"; "Price Previous Week Box")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Width = 5;
                }
                field("Price Previous Week PCS"; "Price Previous Week PCS")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Width = 5;
                }
                field("Price Previous Week KG"; "Price Previous Week KG")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Width = 5;
                }
                field("Price Box"; "Price Box")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                }
                field("Price PCS"; "Price PCS")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                }
                field("Price KG"; "Price KG")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                }

                field("Cost YAM"; "Cost YAM")
                {
                    ApplicationArea = all;
                    Style = Ambiguous;
                    Width = 5;
                }

                field("Cost YS"; "Cost YS")
                {
                    ApplicationArea = all;
                    Style = Ambiguous;
                    Width = 5;
                }

                field("Cost YL"; "Cost YL")
                {
                    ApplicationArea = all;
                    Style = Ambiguous;
                    Width = 5;
                }

                field("Cost YAM Comment"; "Cost YAM Comment")
                {
                    ApplicationArea = all;
                    Width = 10;

                }

                field("Cost YS Comment"; "Cost YS Comment")
                {
                    ApplicationArea = all;
                    Width = 10;

                }

                field("Cost YL Comment"; "Cost YL Comment")
                {
                    ApplicationArea = all;
                    Width = 10;

                }

                /*
                field(CostingPriceExists; vL_CostingPriceExists)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Line Source"; "Line Source")
                {
                    ApplicationArea = all;
                    Width = 5;

                    trigger OnAssistEdit()
                    var
                        rL_SalesHeader: Record "Sales Header";
                    begin
                        rL_SalesHeader.RESET;
                        rL_SalesHeader.SetFilter("External Document No.", "Line Source");
                        rL_SalesHeader.SetFilter("Sell-to Customer No.", "Sell-to Customer No.");
                        if rL_SalesHeader.FindSet() then begin
                            page.RunModal(page::"Sales Quote", rL_SalesHeader);
                        end;

                    end;
                }

                field("Shelf No."; "Shelf No.")
                {
                    ApplicationArea = all;
                    Caption = 'IAN/Shelf No.';
                    Width = 5;

                    trigger OnValidate();
                    begin
                        GetItemFromShelfNo();
                    end;
                }

                /*
                field(CostingPriceExistsPreviousWeek; vL_CostingPriceExistsPreviousWeek)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Width = 1;
                }
                */


            }

        }
    }

    actions
    {
        area(processing)
        {
            action(SelectMultiItems)
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select items';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Add two or more items from the full list of your inventory items.';

                trigger OnAction()
                begin
                    SelectMultipleItemsPFV();
                end;
            }

            action("Select Nonstoc&k Items")
            {
                AccessByPermission = TableData "Nonstock Item" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select Ca&talog Items';
                Image = NonStockItem;
                ToolTip = 'View the list of catalog items that exist in the system. ';

                trigger OnAction()
                begin
                    ShowNonstockItems();
                end;
            }

            action(ExportCompPrices)
            {
                ApplicationArea = All;
                caption = 'Export Competitors Prices Template';
                Image = ImportExcel;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportLidlCompetitorsPrices("Document No.");
                end;
            }

            action(ImportCompPrices)
            {
                ApplicationArea = All;
                caption = 'Import Competitors Prices';
                Image = ImportExcel;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportLidlCompetitorsPrices("Document No.");
                end;
            }


            action(ItemCard)
            {
                ApplicationArea = All;
                caption = 'Item Card';
                Image = Item;
                // RunObject = page "Item Card";
                //RunPageLink = "No." = field("No.");

                trigger OnAction()
                var
                    Item: Record Item;

                begin
                    item.Get("No.");

                    page.Run(page::"Item Card", item);

                end;

            }

            action(ProductionBOM)
            {
                ApplicationArea = All;
                caption = 'Item Production BOM';
                Image = Item;
                trigger OnAction()
                var
                    Item: Record Item;
                    ProductionBOMHeader: Record "Production BOM Header";
                begin
                    item.Get("No.");
                    Item.TestField("Production BOM No.");

                    ProductionBOMHeader.GET(item."Production BOM No.");
                    page.Run(page::"Production BOM", ProductionBOMHeader);

                end;

            }

            action(History)
            {
                ApplicationArea = All;
                caption = 'Previous Offered Prices';
                Image = History;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";

                begin
                    SalesLine.RESET;

                    //SalesLine.SetCurrentKey("Posting Date");
                    //SalesLine.SetAscending("Posting Date", true);
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("No.", "No.");
                    if SalesLine.FindSet() then;
                    page.Run(page::"Sales Quote Lidl Lines", SalesLine);
                end;

            }

            /*
            Action("Set Special Prices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Prices';
                Image = Price;
                ToolTip = 'Set up sales prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                trigger OnAction()
                var
                    SalesPrice: Record "Sales Price";
                    SalesHeader: Record "Sales Header";
                    vL_StartDate: Date;
                    vL_EndDate: Date;
                begin
                    SalesHeader.get("Document Type", "Document No.");

                    vL_StartDate := SalesHeader.GetPriceStartDate();
                    vL_EndDate := SalesHeader.GetPriceEndDate();

                    SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
                    SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
                    SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));
                    SalesPrice.SetRange("Item No.", "No.");
                    Page.Run(Page::"Sales Prices", SalesPrice);
                end;
            }
            */

            Action("Set Special PricesPrevious")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Previous Sales Prices';
                Image = Price;
                ToolTip = 'Set up sales prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                trigger OnAction()
                var
                    SalesPrice: Record "Sales Price";
                    SalesHeader: Record "Sales Header";
                    vL_StartDate: Date;
                    vL_EndDate: Date;
                begin
                    SalesHeader.get("Document Type", "Document No.");

                    vL_StartDate := SalesHeader."Price Start Date"; //SalesHeader.GetPriceStartDatePreviousWeek();
                    vL_EndDate := SalesHeader."Price End Date";  //SalesHeader.GetPriceEndDatePreviousWeek();

                    SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
                    SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
                    SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));
                    SalesPrice.SetRange("Item No.", "No.");
                    Page.Run(Page::"Sales Prices", SalesPrice);
                end;
            }

            Action("Update Prices Previous Week")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Prices';
                Image = Price;
                ToolTip = 'Set up sales prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';


                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.UpdatePrices("Document No.");
                end;

            }

            action("Item Re&ferences")
            {
                ApplicationArea = Suite, ItemReferences;
                Caption = 'Item Re&ferences';
                Visible = ItemReferenceVisible;
                Image = Change;
                //RunObject = Page "Item Reference Entries";
                //RunPageLink = "Item No." = FIELD("No.");
                ToolTip = 'Set up a customer''s or vendor''s own identification of the item. Item references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
                trigger OnAction()
                var
                    pItemReferenceEnties: Page "Item Reference Entries";
                    //"Item Reference"
                    ItemReference: Record "Item Reference";

                begin
                    clear(pItemReferenceEnties);
                    ItemReference.RESET;
                    ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                    ItemReference.SetFilter("Reference Type No.", "Bill-to Customer No.");
                    if ItemReference.FindSet() then begin

                    end;
                    pItemReferenceEnties.SetTableView(ItemReference);
                    pItemReferenceEnties.Run();

                end;
            }


            group("Page")
            {
                Caption = 'Page';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;

                    Visible = IsSaaSExcelAddinEnabled;
                    ToolTip = 'Send the data in the sub page to an Excel file for analysis or editing';
                    AccessByPermission = System "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                    begin
                        EditinExcel.EditPageInExcel(
                            'Sales_QuoteSalesLines',
                            CurrPage.ObjectId(false),
                            StrSubstNo('Document_No eq ''%1''', Rec."Document No."),
                            StrSubstNo(ExcelFileNameTxt, Rec."Document No."));
                    end;

                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //GetTotalSalesHeader;
        //CalculateTotals;
        UpdateEditableOnRow();
        //UpdateTypeText();
        //SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
        vL_StyleIssue: Boolean;
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
    begin
        //ShowShortcutDimCode(ShortcutDimCode);
        //UpdateTypeText();
        //SetItemChargeFieldsStyle();

        //vL_CostingPriceExists := CostingPriceExists();
        //vL_CostingPriceExistsPreviousWeek := CostingPriceExistsPreviousWeek();

        //check if Item has production BOM
        //Check if proiduction BOM has lines

        vG_Style := '';
        vL_StyleIssue := false;
        if Item.GET("No.") then begin
            if Item."Production BOM No." = '' then begin
                vL_StyleIssue := true;
            end;

            if not ProductionBOMHeader.GET(Item."Production BOM No.") then begin
                vL_StyleIssue := true;
            end;

            ProductionBOMLine.RESET;
            ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
            ProductionBOMLine.setrange(Type, ProductionBOMLine.type::Item);
            ProductionBOMLine.SetFilter("Quantity per", '<>%1', 0);
            if not ProductionBOMLine.FindSet() then begin
                vL_StyleIssue := true;
            end;
        end;

        if vL_StyleIssue then begin
            vG_Style := 'Attention';
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
            Commit();
            if not SalesLineReserve.DeleteLineConfirm(Rec) then
                exit(false);
            SalesLineReserve.DeleteLine(Rec);
        end;
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DocumentTotals.SalesCheckAndClearTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        exit(Find(Which));
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        SalesSetup.Get();
        Currency.InitRoundingPrecision;
        TempOptionLookupBuffer.FillLookupBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
        IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitType;
        OnNewRecordOnAfterInitType(Rec, xRec, BelowxRec);
        SetDefaultType();

        Clear(ShortcutDimCode);
        UpdateTypeText();

        //vL_CostingPriceExists := false;
        vL_CostingPriceExistsPreviousWeek := false;
    end;

    trigger OnOpenPage()
    begin
        SetOpenPage();

        //SetDimensionsVisibility();
        SetItemReferenceVisibility();
    end;

    var
        Currency: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        AmountWithDiscountAllowed: Decimal;
        IsFoundation: Boolean;
        CurrPageIsEditable: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        ExtendedPriceEnabled: Boolean;
        TypeAsText: Text[30];
        ExcelFileNameTxt: Label 'Sales Quote %1 - Lines', Comment = '%1 = document number, ex. 10000';

    protected var
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        InvDiscAmountEditable: Boolean;
        IsBlankNumber: Boolean;
        IsCommentLine: Boolean;
        SuppressTotals: Boolean;
        [InDataSet]
        ItemReferenceVisible: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        ItemChargeStyleExpression: Text;
        VATAmount: Decimal;

        //vL_CostingPriceExists: Boolean;
        vL_CostingPriceExistsPreviousWeek: Boolean;

        vG_Style: Text;

    local procedure SetOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
    begin
        OnBeforeSetOpenPage();

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
    end;

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        SalesHeader.Get("Document Type", "Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        DocumentTotals.SalesDocTotalsNotUpToDate();
        CurrPage.Update(false);
    end;

    procedure CalcInvDisc()
    var
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
    begin
        SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    local procedure ExplodeBOM()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        OnBeforeInsertExtendedText(Rec);
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            Commit();
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;

    local procedure ShowItemSub()
    begin
        ShowItemSub;
    end;

    local procedure ShowNonstockItems()
    begin
        ShowNonstock;
    end;

    local procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt();
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();

        OnAfterNoOnAfterValidate(Rec, xRec);

        SaveAndAutoAsmToOrder;
    end;

    protected procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    protected procedure QuantityOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord();
            AutoReserve();
        end;
        DeltaUpdateTotals();

        OnAfterQuantityOnAfterValidate(Rec, xRec);
    end;

    protected procedure UnitofMeasureCodeOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SaveRecord();
            AutoReserve();
        end;
        DeltaUpdateTotals();
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
            CurrPage.SaveRecord();
            AutoAsmToOrder;
        end;
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not HasTypeToFillMandatoryFields;
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := not IsCommentLine;

        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable :=
            CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount" and
            (TotalSalesHeader.Status = TotalSalesHeader.Status::Open);

        OnAfterUpdateEditableOnRow(Rec, IsCommentLine, IsBlankNumber);
    end;

    local procedure UpdatePage()
    var
        SalesHeader: Record "Sales Header";
    begin
        CurrPage.Update();
        SalesHeader.Get("Document Type", "Document No.");
        SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(TotalSalesHeader."Invoice Discount Amount", SalesHeader);
    end;

    local procedure GetTotalSalesHeader()
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;

    procedure ClearTotalSalesHeader();
    begin
        Clear(TotalSalesHeader);
    end;

    procedure CalculateTotals()
    begin
        OnBeforeCalculateTotals(TotalSalesLine, SuppressTotals);

        if SuppressTotals then
            exit;

        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshSalesLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    begin
        if SuppressTotals then
            exit;

        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        if "Line Amount" <> xRec."Line Amount" then
            SendLineInvoiceDiscountResetNotification();
    end;

    procedure ForceTotalsCalculation()
    begin
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure RedistributeTotalsOnAfterValidate()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        CurrPage.SaveRecord();

        SalesHeader.Get("Document Type", "Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update(false);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        OnBeforeUpdateTypeText(Rec);

        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(FieldNo(Type)));
    end;

    procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        if AssignedItemCharge then
            ItemChargeStyleExpression := 'Unfavorable';
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);

        OnAfterSetDimensionsVisibility();
    end;

    local procedure SetItemReferenceVisibility()
    var
        ItemReferenceMgt: Codeunit "Item Reference Management";
    begin
        ItemReferenceVisible := ItemReferenceMgt.IsEnabled();
    end;

    local procedure ValidateShortcutDimension(DimIndex: Integer)
    var
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
        AssembleToOrderLink.UpdateAsmDimFromSalesLine(Rec);

        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, DimIndex);
    end;

    local procedure SetDefaultType()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetDefaultType(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if xRec."Document No." = '' then
            Type := GetDefaultLineType();
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateEditableOnRow(SalesLine: Record "Sales Line"; var IsCommentLine: Boolean; var IsBlankNumber: Boolean);
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateDescription(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SalesLine: Record "Sales Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertExtendedText(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateTypeText(var SalesLine: Record "Sales Line")
    begin
    end;

#if not CLEAN17
    [IntegrationEvent(false, false)]
    local procedure OnCrossReferenceNoOnLookup(var SalesLine: Record "Sales Line")
    begin
    end;
#endif

    [IntegrationEvent(false, false)]
    local procedure OnItemReferenceNoOnLookup(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNewRecordOnAfterInitType(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; BelowxRec: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateTotals(var TotalSalesLine: Record "Sales Line"; SuppressTotals: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetDefaultType(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetOpenPage()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetDimensionsVisibility();
    begin
    end;
}

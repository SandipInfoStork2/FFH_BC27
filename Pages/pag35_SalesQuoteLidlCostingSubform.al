page 50035 "S.Q. Lidl Costing Subform"
{
    AutoSplitKey = true;
    Caption = 'Lidl Costing Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Quote));
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                FreezeColumn = Description;
                field(Type; Rec.Type)
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
                    LookupPageId = "Option Lookup List";
                    TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const(Sales));
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



                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = Suite, ItemReferences;
                    ToolTip = 'Specifies the referenced item number.';
                    //Visible = ItemReferenceVisible;
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

                field(Checked; Rec.Checked)
                {
                    ApplicationArea = All;
                    Width = 1;
                    ToolTip = 'Specifies the value of the Checked field.';
                }



                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                    StyleExpr = vG_Style;
                    Width = 8;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Width = 30;
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';
                }
                field("Category 1"; Rec."Category 1")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Packing Group field.';
                }

                field("Pallet Qty"; Rec."Pallet Qty")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Περιεχ.Παλ. field.';
                }

                field("Package Qty"; Rec."Package Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Κιβώτιο -  Περιεχόμενο';
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο -  Περιεχόμενο field.';

                }

                field(Variety; Rec.Variety)
                {
                    ApplicationArea = All;
                    Width = 15;
                    ToolTip = 'Specifies the value of the Ποικιλία field.';
                }

                //Cost
                field("Cost Per KG"; Rec."Cost Per KG")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Cost Per KG field.';
                }
                field("Cost kg/stk"; Rec."Cost kg/stk")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the kg/stk field.';

                    trigger OnValidate()
                    begin
                        Rec."Manual kg/stk" := true;
                    end;
                }

                field("Manual kg/stk"; Rec."Manual kg/stk")
                {
                    ApplicationArea = All;
                    Caption = '';
                    Width = 1;
                    ToolTip = 'Specifies the value of the Manual kg/stk field.';
                }

                field("Cost KG/PC"; Rec."Cost KG/PC")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the KG/PC field.';
                }
                field("Cost Carton"; Rec."Cost Carton")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Carton >0.10 field.';

                    trigger OnValidate()
                    begin
                        Rec."Manual Cost Carton" := true;
                    end;
                }

                field("Manual Cost Carton"; Rec."Manual Cost Carton")
                {
                    ApplicationArea = All;
                    Caption = '';
                    Width = 1;
                    ToolTip = 'Specifies the value of the Manual Carton >0.10 field.';
                }

                field("Cost Cup"; Rec."Cost Cup")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κουπάκι field.';

                    trigger OnValidate()
                    begin
                        Rec."Manual Cost Cup" := true;
                    end;
                }
                field("Manual Cost Cup"; Rec."Manual Cost Cup")
                {
                    ApplicationArea = All;
                    Caption = '';
                    Width = 1;
                    ToolTip = 'Specifies the value of the Manual Κουπάκι field.';
                }

                field("Cost Other"; Rec."Cost Other")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Film/Labels/Net field.';

                    trigger OnValidate()
                    begin
                        Rec."Manual Cost Other" := true;
                    end;
                }
                field("Manual Cost Other"; Rec."Manual Cost Other")
                {
                    ApplicationArea = All;
                    Caption = '';
                    Width = 1;
                    ToolTip = 'Specifies the value of the Manual Film/Labels/Net field.';
                }
                field("Cost Offer"; Rec."Cost Offer")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the COST field.';
                }
                field("Cost Profit %"; Rec."Cost Profit %")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Cost Profit % field.';
                }
                field("Cost Offer+GP"; Rec."Cost Offer+GP")
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    Width = 5;
                    ToolTip = 'Specifies the value of the COST+GP field.';
                }

                field("Cost Valuation"; Rec."Cost Valuation")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Selling Price - (Cost + GP) field.';
                }
                field("Sales Profit %"; Rec."Sales Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = ' "Sales Profit %" := (("Price PCS" - "Cost Offer+GP") / "Cost Offer+GP") * 100';
                    Width = 5;
                }



                //Cost Lines

                field("Price Previous Week Box"; Rec."Price Previous Week Box")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας ανά  Κιβ. field.';
                }
                field("Price Previous Week PCS"; Rec."Price Previous Week PCS")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας ανά τεμ/συσκ field.';
                }
                field("Price Previous Week KG"; Rec."Price Previous Week KG")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας  ανά kg field.';
                }
                field("Price Box"; Rec."Price Box")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά Κιβ. field.';
                }
                field("Price PCS"; Rec."Price PCS")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά τεμ/συσκ field.';
                }
                field("Price KG"; Rec."Price KG")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Strong;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά kg field.';
                }

                field("Cost YAM"; Rec."Cost YAM")
                {
                    ApplicationArea = All;
                    Style = Ambiguous;
                    Width = 5;
                    ToolTip = 'Specifies the value of the ΥΑΜ field.';
                }

                field("Cost YS"; Rec."Cost YS")
                {
                    ApplicationArea = All;
                    Style = Ambiguous;
                    Width = 5;
                    ToolTip = 'Specifies the value of the ΥΣ field.';
                }

                field("Cost YL"; Rec."Cost YL")
                {
                    ApplicationArea = All;
                    Style = Ambiguous;
                    Width = 5;
                    ToolTip = 'Specifies the value of the ΥΛ field.';
                }

                field("Cost YAM Comment"; Rec."Cost YAM Comment")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the ΥΑΜ Comment field.';

                }

                field("Cost YS Comment"; Rec."Cost YS Comment")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the ΥΣ Comment field.';

                }

                field("Cost YL Comment"; Rec."Cost YL Comment")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the ΥΛ Comment field.';

                }

                /*
                field(CostingPriceExists; vL_CostingPriceExists)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                */

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the line number.';
                }
                field("Line Source"; Rec."Line Source")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Line Source field.';

                    trigger OnAssistEdit()
                    var
                        rL_SalesHeader: Record "Sales Header";
                    begin
                        rL_SalesHeader.Reset;
                        rL_SalesHeader.SetFilter("External Document No.", Rec."Line Source");
                        rL_SalesHeader.SetFilter("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        if rL_SalesHeader.FindSet() then begin
                            Page.RunModal(Page::"Sales Quote", rL_SalesHeader);
                        end;

                    end;
                }

                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Caption = 'IAN/Shelf No.';
                    Width = 5;
                    ToolTip = 'Specifies the value of the IAN/Shelf No. field.';

                    trigger OnValidate();
                    begin
                        Rec.GetItemFromShelfNo();
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
        area(Processing)
        {
            action(SelectMultiItems)
            {
                AccessByPermission = tabledata Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select items';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Add two or more items from the full list of your inventory items.';

                trigger OnAction()
                begin
                    Rec.SelectMultipleItemsPFV();
                end;
            }

            action("Select Nonstoc&k Items")
            {
                AccessByPermission = tabledata "Nonstock Item" = R;
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
                Caption = 'Export Competitors Prices Template';
                Image = ImportExcel;
                ToolTip = 'Executes the Export Competitors Prices Template action.';

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportLidlCompetitorsPrices(Rec."Document No.");
                end;
            }

            action(ImportCompPrices)
            {
                ApplicationArea = All;
                Caption = 'Import Competitors Prices';
                Image = ImportExcel;
                ToolTip = 'Executes the Import Competitors Prices action.';

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportLidlCompetitorsPrices(Rec."Document No.");
                end;
            }


            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = Item;
                ToolTip = 'Executes the Item Card action.';
                // RunObject = page "Item Card";
                //RunPageLink = "No." = field("No.");

                trigger OnAction()
                var
                    Item: Record Item;

                begin
                    Item.Get(Rec."No.");

                    Page.Run(Page::"Item Card", Item);

                end;

            }

            action(ProductionBOM)
            {
                ApplicationArea = All;
                Caption = 'Item Production BOM';
                Image = Item;
                ToolTip = 'Executes the Item Production BOM action.';
                trigger OnAction()
                var
                    Item: Record Item;
                    ProductionBOMHeader: Record "Production BOM Header";
                begin
                    Item.Get(Rec."No.");
                    Item.TestField("Production BOM No.");

                    ProductionBOMHeader.Get(Item."Production BOM No.");
                    Page.Run(Page::"Production BOM", ProductionBOMHeader);

                end;

            }

            action(History)
            {
                ApplicationArea = All;
                Caption = 'Previous Offered Prices';
                Image = History;
                ToolTip = 'Executes the Previous Offered Prices action.';
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";

                begin
                    SalesLine.Reset;

                    //SalesLine.SetCurrentKey("Posting Date");
                    //SalesLine.SetAscending("Posting Date", true);
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("No.", Rec."No.");
                    if SalesLine.FindSet() then;
                    Page.Run(Page::"Sales Quote Lidl Lines", SalesLine);
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

            action("Set Special PricesPrevious")
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
                    SalesHeader.get(Rec."Document Type", Rec."Document No.");

                    vL_StartDate := SalesHeader."Price Start Date"; //SalesHeader.GetPriceStartDatePreviousWeek();
                    vL_EndDate := SalesHeader."Price End Date";  //SalesHeader.GetPriceEndDatePreviousWeek();

                    SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
                    SalesPrice.SetFilter("Sales Code", Rec."Bill-to Customer No.");
                    SalesPrice.SetFilter("Starting Date", Format(vL_StartDate) + '..' + Format(vL_EndDate));
                    SalesPrice.SetRange("Item No.", Rec."No.");
                    Page.Run(Page::"Sales Prices", SalesPrice);
                end;
            }

            action("Update Prices Previous Week")
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
                    cu_GeneralMgt.UpdatePrices(Rec."Document No.");
                end;

            }

            action("Item Re&ferences")
            {
                ApplicationArea = Suite, ItemReferences;
                Caption = 'Item Re&ferences';
                //Visible = ItemReferenceVisible;
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
                    Clear(pItemReferenceEnties);
                    ItemReference.Reset;
                    ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                    ItemReference.SetFilter("Reference Type No.", Rec."Bill-to Customer No.");
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
                    AccessByPermission = system "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                    begin
                        EditinExcel.EditPageInExcel(
                            'Sales_QuoteSalesLines', 50035);
                        /* CurrPage.ObjectId(false),
                        StrSubstNo('Document_No eq ''%1''', Rec."Document No."),
                        StrSubstNo(ExcelFileNameTxt, Rec."Document No.")); 28FEB2026*/
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
        if Item.GET(Rec."No.") then begin
            if Item."Production BOM No." = '' then begin
                vL_StyleIssue := true;
            end;

            if not ProductionBOMHeader.Get(Item."Production BOM No.") then begin
                vL_StyleIssue := true;
            end;

            ProductionBOMLine.Reset;
            ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
            ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
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
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
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
        exit(Rec.Find(Which));
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
        Rec.InitType;
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
        //SetItemReferenceVisibility();
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
        // [InDataSet]
        // ItemReferenceVisible: Boolean;
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
        Codeunit.Run(Codeunit::"Sales-Disc. (Yes/No)", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
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
        Codeunit.Run(Codeunit::"Sales-Explode BOM", Rec);
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
        Rec.ShowItemSub;
    end;

    local procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock;
    end;

    local procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt();
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
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
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
        end;
        DeltaUpdateTotals();

        OnAfterQuantityOnAfterValidate(Rec, xRec);
    end;

    protected procedure UnitofMeasureCodeOnAfterValidate()
    begin
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
        end;
        DeltaUpdateTotals();
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Rec.Type = Rec.Type::Item) and Rec.IsAsmToOrderRequired then begin
            CurrPage.SaveRecord();
            Rec.AutoAsmToOrder;
        end;
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not Rec.HasTypeToFillMandatoryFields;
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
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
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
        if Rec."Line Amount" <> xRec."Line Amount" then
            Rec.SendLineInvoiceDiscountResetNotification();
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

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update(false);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        OnBeforeUpdateTypeText(Rec);

        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        if Rec.AssignedItemCharge then
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

    /* local procedure SetItemReferenceVisibility()
    var
        ItemReferenceMgt: Codeunit "Item Reference Management";
    begin
        ItemReferenceVisible := ItemReferenceMgt.IsEnabled();
    end; */

    local procedure ValidateShortcutDimension(DimIndex: Integer)
    var
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        Rec.ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
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
            Rec.Type := Rec.GetDefaultLineType();
    end;

    [IntegrationEvent(true, false)]
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

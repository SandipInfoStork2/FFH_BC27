page 50034 "Sales Quote Lidl Subform"
{
    AutoSplitKey = true;
    Caption = 'Lidl Lines';
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



                //item cross reference

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
                field("Pallet Qty"; "Pallet Qty")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Country/Region of Origin Code"; "Country/Region of Origin Code")
                {
                    ApplicationArea = all;
                    Caption = 'Προέλευση';
                    Width = 2;

                }

                field("Product Class"; "Product Class")
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
                field("Calibration Min."; "Calibration Min.")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Calibration Max."; "Calibration Max.")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Calibration UOM"; "Calibration UOM")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field(Variety; Variety)
                {
                    ApplicationArea = all;
                    Width = 15;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        //myInt: Integer;
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                        ItemAttributeValue: Record "Item Attribute Value";

                        rL_ItemVariant: Record "Item Variant";
                    begin
                        rL_ItemVariant.RESET;
                        rL_ItemVariant.SetFilter("Item No.", "No.");

                        IF PAGE.RUNMODAL(PAGE::"Item Variants", rL_ItemVariant) = ACTION::LookupOK THEN BEGIN
                            Variety := rL_ItemVariant.Description;
                        end;



                        /*
                        ItemAttribute.RESET;
                        ItemAttribute.SetFilter(Name, 'Variety');
                        if ItemAttribute.FindSet() then;

                        ItemAttributeValue.RESET;
                        ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                        ItemAttributeValue.SetRange(Blocked, false);
                        ItemAttributeValue.SetFilter(Value, '<>%1', '');
                        if ItemAttributeValue.FindSet() then begin
                            Message(format(ItemAttributeValue.Count));
                        end;
                        */

                        //Item Attribute Value Mapping
                        /*
                        ItemAttributeValueMapping.RESET;
                        ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
                        ItemAttributeValueMapping.SetFilter("No.", "No.");
                        ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttribute.ID);
                        ItemAttributeValueMapping.SetRange();
                        if ItemAttributeValueMapping.FindSet() then begin
                            Message(format(ItemAttributeValueMapping.Count);
                        end;
                        */

                    end;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                    Caption = 'Νόμισμα';
                    Width = 3;
                }
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
                    Width = 5;
                }
                field("Price PCS"; "Price PCS")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Width = 5;
                }
                field("Price KG"; "Price KG")
                {
                    ApplicationArea = all;
                    BlankZero = true;
                    Width = 5;
                }
                field("Row Index"; "Row Index")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Qty Box Date 1"; "Qty Box Date 1")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Width = 5;
                }

                field("Qty Box Date 2"; "Qty Box Date 2")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Width = 5;
                }

                field("Qty Box Date 3"; "Qty Box Date 3")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Width = 5;
                }

                field("Qty Box Date 4"; "Qty Box Date 4")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Width = 5;
                }

                field("Qty Box Date 5"; "Qty Box Date 5")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Width = 5;
                }

                field("Qty Box Date 6"; "Qty Box Date 6")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Width = 5;
                }

                field("Qty Box Date 7"; "Qty Box Date 7")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Width = 5;
                }
                field("Qty Box Date 8"; "Qty Box Date 8")
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Width = 5;
                }
                field("Total Qty on Boxes"; "Total Qty on Boxes")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Additional Information"; "Additional Information")
                {
                    ApplicationArea = all;
                    Width = 15;
                }
                field("Pressure Min."; "Pressure Min.")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Pressure Max."; "Pressure Max.")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Brix Min"; "Brix Min")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("QC 1 Min"; "QC 1 Min")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("QC 1 Max"; "QC 1 Max")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("QC 1 Text"; "QC 1 Text")
                {
                    ApplicationArea = all;
                    Width = 5;
                }

                field("QC 2 Min"; "QC 2 Min")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("QC 2 Max"; "QC 2 Max")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("QC 2 Text"; "QC 2 Text")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Width"; "Box Width")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Char 1"; "Box Char 1")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Length"; "Box Length")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Char 2"; "Box Char 2")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Height"; "Box Height")
                {
                    ApplicationArea = all;
                    Width = 5;
                }
                field("Box Changed Date"; "Box Changed Date")
                {
                    ApplicationArea = all;
                    Width = 5;

                }
                field("Harvest Temp. From"; "Harvest Temp. From")
                {
                    ApplicationArea = all;
                    Width = 10;
                }
                field("Harvest Temp. To"; "Harvest Temp. To")
                {
                    ApplicationArea = all;
                    Width = 10;
                }

                field("Freezer Harvest Temp. From"; "Freezer Harvest Temp. From")
                {
                    ApplicationArea = all;
                    Width = 10;
                }
                field("Freezer Harvest Temp. To"; "Freezer Harvest Temp. To")
                {
                    ApplicationArea = all;
                    Width = 10;
                }
                field("Transfer Temp. From"; "Transfer Temp. From")
                {
                    ApplicationArea = all;
                    Width = 10;
                }
                field("Transfer Temp. To"; "Transfer Temp. To")
                {
                    ApplicationArea = all;
                    Width = 10;
                }




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
                field(Confirmed; Confirmed)
                {
                    ApplicationArea = all;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = all;
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



            action(ItemCard)
            {
                ApplicationArea = All;
                caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");

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
            action(CostingLines)
            {
                ApplicationArea = All;
                caption = 'Costing Lines';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");

            }
            */


            group("Page")
            {
                Caption = 'Page';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    //Promoted = true;
                    //PromotedCategory = Category8;
                    //PromotedIsBig = true;
                    //PromotedOnly = true;
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
    var
        vL_Date1: Date;
        vL_Date2: Date;
        vL_Date3: Date;
        vL_Date4: Date;
        vL_Date5: Date;
        vL_Date6: Date;
        vL_Date7: Date;
        vL_Date8: Date;
        SalesHeader: Record "Sales Header";
        BoxLabel: Label ' Ποσότητα σε κιβώτια';
    begin
        //GetTotalSalesHeader;
        //CalculateTotals;
        UpdateEditableOnRow();
        //UpdateTypeText();
        //SetItemChargeFieldsStyle();

        SalesHeader.RESET;
        SalesHeader.SetRange("Document Type", "Document Type");
        SalesHeader.SetFilter("No.", "Document No.");
        if SalesHeader.FindSet() then begin
            if SalesHeader."Requested Delivery Date" <> 0D then begin
                vL_Date1 := CalcDate('-WD6', SalesHeader."Requested Delivery Date");
                vL_Date2 := CalcDate('-WD6+1D', SalesHeader."Requested Delivery Date");
                vL_Date3 := CalcDate('-WD6+2D', SalesHeader."Requested Delivery Date");
                vL_Date4 := CalcDate('-WD6+3D', SalesHeader."Requested Delivery Date");
                vL_Date5 := CalcDate('-WD6+4D', SalesHeader."Requested Delivery Date");
                vL_Date6 := CalcDate('-WD6+5D', SalesHeader."Requested Delivery Date");
                vL_Date7 := CalcDate('-WD6+6D', SalesHeader."Requested Delivery Date");
                vL_Date8 := CalcDate('-WD6+7D', SalesHeader."Requested Delivery Date");
            end else begin


            end;
        end;

        if vL_Date1 <> 0D then begin
            MATRIX_ColumnCaption[1] := FORMAT(vL_Date1) + BoxLabel;
            MATRIX_ColumnCaption[2] := FORMAT(vL_Date2) + BoxLabel;
            MATRIX_ColumnCaption[3] := FORMAT(vL_Date3) + BoxLabel;
            MATRIX_ColumnCaption[4] := FORMAT(vL_Date4) + BoxLabel;
            MATRIX_ColumnCaption[5] := FORMAT(vL_Date5) + BoxLabel;
            MATRIX_ColumnCaption[6] := FORMAT(vL_Date6) + BoxLabel;
            MATRIX_ColumnCaption[7] := FORMAT(vL_Date7) + BoxLabel;
            MATRIX_ColumnCaption[8] := FORMAT(vL_Date8) + BoxLabel;
        end else begin
            MATRIX_ColumnCaption[1] := 'Date 1 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[2] := 'Date 2 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[3] := 'Date 3 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[4] := 'Date 4 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[5] := 'Date 5 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[6] := 'Date 6 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[7] := 'Date 7 Ποσότητα σε κιβώτια';
            MATRIX_ColumnCaption[8] := 'Date 8 Ποσότητα σε κιβώτια';
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);
        //UpdateTypeText();
        //SetItemChargeFieldsStyle();
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
    end;

    trigger OnOpenPage()
    var

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

        MATRIX_ColumnCaption: array[8] of Text;

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

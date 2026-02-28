page 50070 "Horeca Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                /*
                field(Type; Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //  NoOnAfterValidate();
                        //   SetLocationCodeMandatory();
                        UpdateEditableOnRow();
                        //  UpdateTypeText();
                        // DeltaUpdateTotals();
                    end;
                }
                */

                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = Type <> Type::" ";
                    ToolTip = 'Specifies what you are selling, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        //  NoOnAfterValidate();
                        UpdateEditableOnRow();
                        // ShowShortcutDimCode(ShortcutDimCode);

                        // QuantityOnAfterValidate();
                        // UpdateTypeText();
                        // DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    ShowMandatory = Rec.Type <> Rec.Type::" ";
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';
                    Editable = false;
                    Width = 70;
                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow();

                        //Rec.RestoreLookupSelection();

                        if Rec."No." = xRec."No." then
                            exit;

                        //  NoOnAfterValidate();
                        //  Rec.ShowShortcutDimCode(ShortcutDimCode);
                        // UpdateTypeText();
                        // DeltaUpdateTotals();
                        // OnAfterValidateDescription(Rec, xRec);
                    end;

                    trigger OnAfterLookup(Selected: RecordRef)
                    begin
                        //Rec.SaveLookupSelection(Selected);
                    end;
                }
                /*
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    //Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';
                    Visible = true;
                    Editable = false;
                    Width = 70;
                }
                */

                field(Quantity; Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = NOT IsCommentLine;
                    Enabled = NOT IsCommentLine;
                    ShowMandatory = (Type <> Type::" ") AND ("No." <> '');
                    ToolTip = 'Specifies how many units are being sold.';

                    AboutTitle = 'How much is being ordered';
                    AboutText = 'The quantity on a line specifies how much of an item a customer is ordering. This quantity determines whether the order qualifies for special prices or discounts.';
                    //ExtendedDatatype = ;
                    trigger OnValidate()

                    var
                        rL_Item: Record Item;
                        Modulus: Decimal;
                        Text50000: Label 'Η ποσότητα (Quantity) %1 να είναι στα πολλαπλασια του packing %2. Quantity %1 must be in multiple of packing %2';
                        Text50001: Label 'Negative Qty is not allowed';
                    begin
                        // QuantityOnAfterValidate();
                        // DeltaUpdateTotals();
                        // SetItemChargeFieldsStyle();
                        // if SalesSetup."Calc. Inv. Discount" and (Quantity = 0) then
                        //     CurrPage.Update(false);

                        if (Quantity < 0) then begin
                            Error(Text50001);
                        end;

                        if rec."Unit of Measure Code" <> rec."Unit of Measure (Base)" then begin
                            if rL_Item.Get("No.") then begin
                                if (rL_Item."Package Qty" <> 0) and (rec.Quantity <> 0) then begin
                                    Modulus := rec.Quantity mod rL_Item."Package Qty";

                                    if Modulus <> 0 then begin
                                        if not rL_Item."Allow Modulus" then begin
                                            Error(Text50000, FORMAT(rec.Quantity), FORMAT(rL_Item."Package Qty"));
                                        end;

                                    end;
                                end;
                            end;
                        end;

                        DeltaUpdateTotals();
                    end;


                }

                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the item or resource on the sales line.';
                    Visible = true;
                    Editable = false;
                }

                /*
                field("Packing Group Description"; Item."Packing Group Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                */

                field("Quantity (Base)"; "Quantity (Base)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }



                field("Unit of Measure (Base)"; "Unit of Measure (Base)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                /*
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    ApplicationArea = All;
                    Visible = true;
                    Editable = false;
                }
                */

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                    //Enabled = NOT IsBlankNumber;
                    //ShowMandatory = (Type <> Type::" ") AND ("No." <> '');
                    ToolTip = 'Specifies the price for one unit on the sales line.';


                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                    //Enabled = NOT IsBlankNumber;
                    //ShowMandatory = (Type <> Type::" ") AND ("No." <> '');
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';


                }
            }

            group(Control51)
            {
                ShowCaption = false;
                /*
                group(Control45)
                {
                    ShowCaption = false;
                    field("TotalSalesLine.""Line Amount"""; TotalSalesLine."Line Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                        Caption = 'Subtotal Excl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
                    }

                    field("Invoice Discount Amount"; InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FieldCaption("Inv. Discount Amount"), Currency.Code);
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

                        trigger OnValidate()
                        begin
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                            ValidateInvoiceDiscountAmount();
                        end;
                    }


                    field("Invoice Disc. Pct."; InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 3;
                        Editable = InvDiscAmountEditable;
                        ToolTip = 'Specifies a discount percentage that is applied to the invoice, based on sales lines where the Allow Invoice Disc. field is selected. The percentage and criteria are defined in the Customer Invoice Discounts page, but you can enter or change the percentage manually.';

                        trigger OnValidate()
                        begin
                            DocumentTotals.SalesDocTotalsNotUpToDate();
                            AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
                            InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount();
                        end;
                    }

                }
                 */
                group(Control28)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    {
        /*
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
        */
    }

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin

        Currency.InitRoundingPrecision();

    end;

    trigger OnModifyRecord(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get("Document Type", "Document No.");
        SalesHeader.TestStatusOpen();
        SalesHeader.TestHORECAStatusOpen();

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        clear(Item);

        if Item.GET("No.") then begin
            Item.CalcFields("Packing Group Description");
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        IsHandled: Boolean;
    begin
        GetTotalSalesHeader();
        CalculateTotals();
        UpdateEditableOnRow();
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not HasTypeToFillMandatoryFields();
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := not IsCommentLine;

        CurrPageIsEditable := CurrPage.Editable;

    end;

    procedure CalculateTotals()
    var
        IsHandled: Boolean;
    begin

        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshSalesLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    var
        IsHandled: Boolean;
    begin
        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
    end;

    local procedure GetTotalSalesHeader()
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;

    procedure ClearTotalSalesHeader();
    begin
        Clear(TotalSalesHeader);
    end;

    var

        TotalSalesHeader: Record "Sales Header";
        IsCommentLine: Boolean;
        IsBlankNumber: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        CurrPageIsEditable: Boolean;

        Item: Record Item;

        DocumentTotals: Codeunit "Document Totals";

        TotalSalesLine: Record "Sales Line";

        VATAmount: Decimal;

        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;

        Currency: Record Currency;

}
page 50077 "Horeca SIH Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";
    InsertAllowed = false;
    Editable = false;
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

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    ShowMandatory = Rec.Type <> Rec.Type::" ";
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';
                    Editable = false;
                    Width = 70;


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

                /*
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                    //Enabled = NOT IsBlankNumber;
                    //ShowMandatory = (Type <> Type::" ") AND ("No." <> '');
                    ToolTip = 'Specifies the price for one unit on the sales line.';


                }
                */

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }


            }

            group(Control28)
            {
                ShowCaption = false;
                /*
                group(Control23)
                {
                    ShowCaption = false;
                    field("Invoice Discount Amount"; TotalSalesInvoiceHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalSalesInvoiceHeader."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                        ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on sales lines where the Allow Invoice Disc. field is selected.';
                    }
                }
                */
                group(Control9)
                {
                    ShowCaption = false;
                    field("Total Amount Excl. VAT"; TotalSalesInvoiceHeader.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalSalesInvoiceHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalSalesInvoiceHeader."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                        ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalSalesInvoiceHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalSalesInvoiceHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
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

    begin


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
    begin
        DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader, VATAmount, Rec);
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

        TotalSalesInvoiceHeader: Record "Sales Invoice Header";

}
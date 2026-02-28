page 50073 "Horeca SSH Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Shipment Line";
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
    var
        IsHandled: Boolean;
    begin

        UpdateEditableOnRow();
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not HasTypeToFillMandatoryFields();
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := not IsCommentLine;

        CurrPageIsEditable := CurrPage.Editable;

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
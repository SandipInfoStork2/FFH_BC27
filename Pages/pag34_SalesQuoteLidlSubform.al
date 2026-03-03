page 50034 "Sales Quote Lidl Subform"
{
    AutoSplitKey = true;
    Caption = 'Lidl Lines';
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



                //item cross reference

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
                field("Pallet Qty"; Rec."Pallet Qty")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Περιεχ.Παλ. field.';
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = All;
                    Caption = 'Προέλευση';
                    Width = 2;
                    ToolTip = 'Specifies the value of the Προέλευση field.';

                }

                field("Product Class"; Rec."Product Class")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Product Class (Κατηγορία) field.';
                }
                field("Package Qty"; Rec."Package Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Κιβώτιο -  Περιεχόμενο';
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο -  Περιεχόμενο field.';

                }
                field("Calibration Min."; Rec."Calibration Min.")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Καλιμπράζ Ελαχ. field.';
                }
                field("Calibration Max."; Rec."Calibration Max.")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Καλιμπράζ Μεγ. field.';
                }
                field("Calibration UOM"; Rec."Calibration UOM")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Καλιμπράζ 47 field.';
                }
                field(Variety; Rec.Variety)
                {
                    ApplicationArea = All;
                    Width = 15;
                    ToolTip = 'Specifies the value of the Ποικιλία field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        //myInt: Integer;
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                        ItemAttributeValue: Record "Item Attribute Value";

                        rL_ItemVariant: Record "Item Variant";
                    begin
                        rL_ItemVariant.Reset;
                        rL_ItemVariant.SetFilter("Item No.", Rec."No.");

                        if Page.RunModal(Page::"Item Variants", rL_ItemVariant) = Action::LookupOK then begin
                            Rec.Variety := rL_ItemVariant.Description;
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Νόμισμα';
                    Width = 3;
                    ToolTip = 'Specifies the currency code for the amount on this line.';
                }
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
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά Κιβ. field.';
                }
                field("Price PCS"; Rec."Price PCS")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά τεμ/συσκ field.';
                }
                field("Price KG"; Rec."Price KG")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Τιμές ανά kg field.';
                }
                field("Row Index"; Rec."Row Index")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Ποσότητα ανά σειρά field.';
                }
                field("Qty Box Date 1"; Rec."Qty Box Date 1")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 1 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 2"; Rec."Qty Box Date 2")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 2 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 3"; Rec."Qty Box Date 3")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 3 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 4"; Rec."Qty Box Date 4")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 4 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 5"; Rec."Qty Box Date 5")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 5 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 6"; Rec."Qty Box Date 6")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 6 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 7"; Rec."Qty Box Date 7")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 7 Ποσότητα σε κιβώτια field.';
                }
                field("Qty Box Date 8"; Rec."Qty Box Date 8")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Width = 5;
                    ToolTip = 'Specifies the value of the Date 8 Ποσότητα σε κιβώτια field.';
                }
                field("Total Qty on Boxes"; Rec."Total Qty on Boxes")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Συνολική ποσότητα σε κιβώτια field.';
                }
                field("Additional Information"; Rec."Additional Information")
                {
                    ApplicationArea = All;
                    Width = 15;
                    ToolTip = 'Specifies the value of the Πρόσθετες πληροφορίες field.';
                }
                field("Pressure Min."; Rec."Pressure Min.")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πίεση kg/cm² Ελαχ. field.';
                }
                field("Pressure Max."; Rec."Pressure Max.")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πίεση kg/cm² Μεγ. field.';
                }
                field("Brix Min"; Rec."Brix Min")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Brix σε ° Ελαχ. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Επωνυμία field.';
                }
                field("QC 1 Min"; Rec."QC 1 Min")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
                }
                field("QC 1 Max"; Rec."QC 1 Max")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
                }
                field("QC 1 Text"; Rec."QC 1 Text")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
                }

                field("QC 2 Min"; Rec."QC 2 Min")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
                }
                field("QC 2 Max"; Rec."QC 2 Max")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
                }
                field("QC 2 Text"; Rec."QC 2 Text")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
                }
                field("Box Width"; Rec."Box Width")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Πλάτος σε cm field.';
                }
                field("Box Char 1"; Rec."Box Char 1")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
                }
                field("Box Length"; Rec."Box Length")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Μήκος σε cm field.';
                }
                field("Box Char 2"; Rec."Box Char 2")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
                }
                field("Box Height"; Rec."Box Height")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Ύψος σε cm field.';
                }
                field("Box Changed Date"; Rec."Box Changed Date")
                {
                    ApplicationArea = All;
                    Width = 5;
                    ToolTip = 'Specifies the value of the Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου field.';

                }
                field("Harvest Temp. From"; Rec."Harvest Temp. From")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Από field.';
                }
                field("Harvest Temp. To"; Rec."Harvest Temp. To")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Έως field.';
                }

                field("Freezer Harvest Temp. From"; Rec."Freezer Harvest Temp. From")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Από field.';
                }
                field("Freezer Harvest Temp. To"; Rec."Freezer Harvest Temp. To")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Έως field.';
                }
                field("Transfer Temp. From"; Rec."Transfer Temp. From")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Από field.';
                }
                field("Transfer Temp. To"; Rec."Transfer Temp. To")
                {
                    ApplicationArea = All;
                    Width = 10;
                    ToolTip = 'Specifies the value of the παράδοση στις αποθ.Lidl σε Cº Έως field.';
                }




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



            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Executes the Item Card action.';

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
                    AccessByPermission = system "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                    begin
                        EditinExcel.EditPageInExcel(
                            'Sales_QuoteSalesLines', 50034);
                        /*CurrPage.ObjectId(true) ,
                        StrSubstNo('Document_No eq ''%1''', Rec."Document No."),
                        StrSubstNo(ExcelFileNameTxt, Rec."Document No.")); 28FEB2026*/
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

        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetFilter("No.", Rec."Document No.");
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
            MATRIX_ColumnCaption[1] := Format(vL_Date1) + BoxLabel;
            MATRIX_ColumnCaption[2] := Format(vL_Date2) + BoxLabel;
            MATRIX_ColumnCaption[3] := Format(vL_Date3) + BoxLabel;
            MATRIX_ColumnCaption[4] := Format(vL_Date4) + BoxLabel;
            MATRIX_ColumnCaption[5] := Format(vL_Date5) + BoxLabel;
            MATRIX_ColumnCaption[6] := Format(vL_Date6) + BoxLabel;
            MATRIX_ColumnCaption[7] := Format(vL_Date7) + BoxLabel;
            MATRIX_ColumnCaption[8] := Format(vL_Date8) + BoxLabel;
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
    end;

    trigger OnOpenPage()
    var

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
        //[InDataSet]
        //ItemReferenceVisible: Boolean;
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

page 50037 "Sales Quote Lidl Lines"
{
    //AutoSplitKey = true;
    Caption = 'Lidl Lines List';
    // DelayedInsert = true;
    // LinksAllowed = false;
    //MultipleNewLines = true;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Date") order(descending) where("Document Type" = filter(Quote));
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }


                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Week No."; Rec."Week No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week No. field.';
                }

                field("Line Source"; Rec."Line Source")
                {
                    ApplicationArea = All;
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

                field(Type; Rec.Type)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';

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

                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Caption = 'IAN/Shelf No.';
                    ToolTip = 'Specifies the value of the IAN/Shelf No. field.';

                    trigger OnValidate();
                    begin
                        Rec.GetItemFromShelfNo();
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

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

                field(vG_CorrectItemNo; vG_CorrectItemNo)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the vG_CorrectItemNo field.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';
                }
                field("Pallet Qty"; Rec."Pallet Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Περιεχ.Παλ. field.';
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = All;
                    Caption = 'Προέλευση';
                    ToolTip = 'Specifies the value of the Προέλευση field.';
                }

                field("Product Class"; Rec."Product Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Class (Κατηγορία) field.';
                }
                field("Package Qty"; Rec."Package Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Κιβώτιο -  Περιεχόμενο';
                    ToolTip = 'Specifies the value of the Κιβώτιο -  Περιεχόμενο field.';

                }
                field("Calibration Min."; Rec."Calibration Min.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Καλιμπράζ Ελαχ. field.';
                }
                field("Calibration Max."; Rec."Calibration Max.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Καλιμπράζ Μεγ. field.';
                }
                field("Calibration UOM"; Rec."Calibration UOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Καλιμπράζ 47 field.';
                }
                field(Variety; Rec.Variety)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ποικιλία field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Νόμισμα';
                    ToolTip = 'Specifies the currency code for the amount on this line.';
                }
                field("Price Previous Week Box"; Rec."Price Previous Week Box")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας ανά  Κιβ. field.';
                }
                field("Price Previous Week PCS"; Rec."Price Previous Week PCS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας ανά τεμ/συσκ field.';
                }
                field("Price Previous Week KG"; Rec."Price Previous Week KG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές προηγούμενης Εβδομάδας  ανά kg field.';
                }
                field("Price Box"; Rec."Price Box")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές ανά Κιβ. field.';
                }
                field("Price PCS"; Rec."Price PCS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές ανά τεμ/συσκ field.';
                }
                field("Price KG"; Rec."Price KG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Τιμές ανά kg field.';
                }
                field("Row Index"; Rec."Row Index")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ποσότητα ανά σειρά field.';
                }
                field("Qty Box Date 1"; Rec."Qty Box Date 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 1 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 2"; Rec."Qty Box Date 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 2 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 3"; Rec."Qty Box Date 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 3 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 4"; Rec."Qty Box Date 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 4 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 5"; Rec."Qty Box Date 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 5 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 6"; Rec."Qty Box Date 6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 6 Ποσότητα σε κιβώτια field.';
                }

                field("Qty Box Date 7"; Rec."Qty Box Date 7")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 7 Ποσότητα σε κιβώτια field.';
                }
                field("Qty Box Date 8"; Rec."Qty Box Date 8")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date 8 Ποσότητα σε κιβώτια field.';
                }
                field("Total Qty on Boxes"; Rec."Total Qty on Boxes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Συνολική ποσότητα σε κιβώτια field.';
                }
                field("Additional Information"; Rec."Additional Information")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετες πληροφορίες field.';
                }
                field("Pressure Min."; Rec."Pressure Min.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πίεση kg/cm² Ελαχ. field.';
                }
                field("Pressure Max."; Rec."Pressure Max.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πίεση kg/cm² Μεγ. field.';
                }
                field("Brix Min"; Rec."Brix Min")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Brix σε ° Ελαχ. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Επωνυμία field.';
                }
                field("QC 1 Min"; Rec."QC 1 Min")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
                }
                field("QC 1 Max"; Rec."QC 1 Max")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
                }
                field("QC 1 Text"; Rec."QC 1 Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
                }

                field("QC 2 Min"; Rec."QC 2 Min")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
                }
                field("QC 2 Max"; Rec."QC 2 Max")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
                }
                field("QC 2 Text"; Rec."QC 2 Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
                }
                field("Box Width"; Rec."Box Width")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Πλάτος σε cm field.';
                }
                field("Box Char 1"; Rec."Box Char 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
                }
                field("Box Length"; Rec."Box Length")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Μήκος σε cm field.';
                }
                field("Box Char 2"; Rec."Box Char 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
                }
                field("Box Height"; Rec."Box Height")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Ύψος σε cm field.';
                }
                field("Box Changed Date"; Rec."Box Changed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου field.';

                }
                field("Harvest Temp. From"; Rec."Harvest Temp. From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Από field.';
                }
                field("Harvest Temp. To"; Rec."Harvest Temp. To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Έως field.';
                }

                field("Freezer Harvest Temp. From"; Rec."Freezer Harvest Temp. From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Από field.';
                }
                field("Freezer Harvest Temp. To"; Rec."Freezer Harvest Temp. To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Έως field.';
                }
                field("Transfer Temp. From"; Rec."Transfer Temp. From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Από field.';
                }
                field("Transfer Temp. To"; Rec."Transfer Temp. To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the παράδοση στις αποθ.Lidl σε Cº Έως field.';
                }

                field(Checked; Rec.Checked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checked field.';
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmed field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed field.';
                }


            }

        }
    }

    actions
    {
        area(Processing)
        {

            action(OpenDocument)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Open Document';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Open Sales Quote';
                RunObject = page "Sales Quote";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");



            }

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
                    Rec.SelectMultipleItems;
                end;
            }
            action(InsertExtTexts)
            {
                AccessByPermission = tabledata "Extended Text Header" = R;
                ApplicationArea = Suite;
                Caption = 'Insert &Ext. Texts';
                Image = Text;
                ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';

                trigger OnAction()
                begin
                    InsertExtendedText(true);
                end;
            }
            action(Dimensions)
            {
                AccessByPermission = tabledata Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortcutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Enabled = Rec.Type = Rec.Type::Item;
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = tabledata Location = R;
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        ToolTip = 'View the actual and projected quantity of the item per location.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action(Lot)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Lot';
                        Image = LotInfo;
                        RunObject = page "Item Availability by Lot No.";
                        RunPageLink = "No." = field("No."),
                            "Location Filter" = field("Location Code"),
                            "Variant Filter" = field("Variant Code");
                        ToolTip = 'View the current and projected quantity of the item in each lot.';
                    }
                    action("BOM Level")
                    {
                        AccessByPermission = tabledata "BOM Buffer" = R;
                        ApplicationArea = Assembly;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                action("Select Item Substitution")
                {
                    ApplicationArea = Suite;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;
                    ToolTip = 'Select another item that has been set up to be sold instead of the original item if it is unavailable.';

                    trigger OnAction()
                    begin
                        Rec.ShowItemSub;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }
                action("Item Charge &Assignment")
                {
                    AccessByPermission = tabledata "Item Charge" = R;
                    ApplicationArea = ItemCharges;
                    Caption = 'Item Charge &Assignment';
                    Enabled = Rec.Type = Rec.Type::"Charge (Item)";
                    Image = ItemCosts;
                    ToolTip = 'Record additional direct costs, for example for freight. This action is available only for Charge (Item) line types.';

                    trigger OnAction()
                    begin
                        ItemChargeAssgnt();
                        SetItemChargeFieldsStyle();
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortcutKey = 'Shift+Ctrl+I';
                    Enabled = Rec.Type = Rec.Type::Item;
                    ToolTip = 'View or edit serial and lot numbers for the selected item. This action is available only for lines that contain an item.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.Get(Rec."No.");
                        Item.TestField("Assembly Policy", Item."Assembly Policy"::"Assemble-to-Stock");
                        Rec.TestField("Qty. to Asm. to Order (Base)", 0);
                        Rec.OpenItemTrackingLines();
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
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                group("Assemble to Order")
                {
                    Caption = 'Assemble to Order';
                    Image = AssemblyBOM;
                    action("Assemble-to-Order Lines")
                    {
                        AccessByPermission = tabledata "BOM Component" = R;
                        ApplicationArea = Assembly;
                        Caption = 'Assemble-to-Order Lines';
                        ToolTip = 'View any linked assembly order lines if the documents represents an assemble-to-order sale.';

                        trigger OnAction()
                        begin
                            Rec.ShowAsmToOrderLines();
                        end;
                    }
                    action("Roll Up &Price")
                    {
                        AccessByPermission = tabledata "BOM Component" = R;
                        ApplicationArea = Assembly;
                        Caption = 'Roll Up &Price';
                        Ellipsis = true;
                        ToolTip = 'Update the unit price of the assembly item according to any changes that you have made to the assembly components.';

                        trigger OnAction()
                        begin
                            Rec.RollupAsmPrice;
                        end;
                    }
                    action("Roll Up &Cost")
                    {
                        AccessByPermission = tabledata "BOM Component" = R;
                        ApplicationArea = Assembly;
                        Caption = 'Roll Up &Cost';
                        Ellipsis = true;
                        ToolTip = 'Update the unit cost of the assembly item according to any changes that you have made to the assembly components.';

                        trigger OnAction()
                        begin
                            Rec.RollUpAsmCost;
                        end;
                    }
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
#if not CLEAN19
                action("Get &Price")
                {
                    AccessByPermission = tabledata "Sales Price" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get &Price';
                    Ellipsis = true;
                    Image = Price;
                    ToolTip = 'Insert the lowest possible price in the Unit Price field according to any special price that you have set up.';
                    Visible = not ExtendedPriceEnabled;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';

                    trigger OnAction()
                    begin
                        Rec.PickPrice();
                    end;
                }
                action("Get Li&ne Discount")
                {
                    AccessByPermission = tabledata "Sales Line Discount" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;
                    ToolTip = 'Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.';
                    Visible = not ExtendedPriceEnabled;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';

                    trigger OnAction()
                    begin
                        Rec.PickDiscount();
                    end;
                }
#endif
                action(GetPrice)
                {
                    AccessByPermission = tabledata "Sales Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get &Price';
                    Ellipsis = true;
                    Image = Price;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'Insert the lowest possible price in the Unit Price field according to any special price that you have set up.';

                    trigger OnAction()
                    begin
                        Rec.PickPrice();
                    end;
                }
                action(GetLineDiscount)
                {
                    AccessByPermission = tabledata "Sales Discount Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.';

                    trigger OnAction()
                    begin
                        Rec.PickDiscount();
                    end;
                }
                action("E&xplode BOM")
                {
                    AccessByPermission = tabledata "BOM Component" = R;
                    ApplicationArea = Suite;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;
                    Enabled = Rec.Type = Rec.Type::Item;
                    ToolTip = 'Add a line for each component on the bill of materials for the selected item. For example, this is useful for selling the parent item as a kit. CAUTION: The line for the parent item will be deleted and only its description will display. To undo this action, delete the component lines and add a line for the parent item again. This action is available only for lines that contain an item.';

                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }
            }
            group("Page")
            {
                Caption = 'Page';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = IsSaaSExcelAddinEnabled;
                    ToolTip = 'Send the data in the sub page to an Excel file for analysis or editing';
                    AccessByPermission = system "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                    begin
                        EditinExcel.EditPageInExcel(
                            'Sales_QuoteSalesLines', 50037);
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
        GetTotalSalesHeader;
        CalculateTotals;
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    var
        rL_Item: Record Item;
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText();
        SetItemChargeFieldsStyle();


        //+

        vG_CorrectItemNo := '';
        if Rec."Shelf No." <> '' then begin
            rL_Item.Reset;
            rL_Item.SetFilter("Shelf No.", Rec."Shelf No.");
            rL_Item.SETRANGE("Package Qty", Rec."Package Qty");
            if rL_Item.FindSet() then begin
                vG_CorrectItemNo := rL_Item."No.";
            end;
        end;


        //-
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
    begin
        SetOpenPage();

        SetDimensionsVisibility();
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
        [InDataSet]
        ItemReferenceVisible: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        ItemChargeStyleExpression: Text;
        VATAmount: Decimal;

        vG_CorrectItemNo: Code[20];

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

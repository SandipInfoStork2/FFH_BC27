pageextension 50129 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }
        }

        addafter("Deferral Code")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }

            field("Qty. Requested"; Rec."Qty. Requested")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Requested field.';
            }
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
            }
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment No. field.';
            }
        }

        modify("Net Weight")
        {
            Visible = true;
        }
        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
            }
        }
        */

        modify("ShortcutDimCode[5]")
        {
            Visible = true;
        }
        modify("Variant Code")
        {
            Visible = true;
        }

        addafter("ShortcutDimCode[8]")
        {
            field("Shipping Temperature"; Rec."Shipping Temperature")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
            }
            field("Shipping Quality Control"; Rec."Shipping Quality Control")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Shipping Quality Control field.';
            }

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Req. Country field.';
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Custom: Country/Region of Origin Code';
            }



            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Product Class (Κατηγορία)';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Potatoes District Region';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;
                ToolTip = 'Executes the Item &Tracking Entries action.';

                trigger OnAction();
                begin
                    Rec.ShowItemTrackingLines;
                end;
            }


        }

        addafter(DocumentLineTracking)
        {
            action("Update Categories")
            {
                ApplicationArea = Suite;
                Caption = 'Update Categories';
                Image = Edit;
                ToolTip = 'Custom: Update Categories';

                trigger OnAction()
                var
                    PostedSalesInvoiceLineUpdate: Page "Posted Sales Line I- Update";
                begin
                    PostedSalesInvoiceLineUpdate.LookupMode := true;
                    PostedSalesInvoiceLineUpdate.SetRec(Rec);
                    PostedSalesInvoiceLineUpdate.RunModal;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
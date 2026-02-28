pageextension 50129 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = all;
            }
        }

        addafter("Deferral Code")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = all;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }

            field("Qty. Requested"; "Qty. Requested")
            {
                ApplicationArea = all;
            }
            field("Shipment Date"; "Shipment Date")
            {
                ApplicationArea = all;
            }
            field("Shipment No."; "Shipment No.")
            {
                ApplicationArea = all;
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
            field("Shipping Temperature"; "Shipping Temperature")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Shipping Quality Control"; "Shipping Quality Control")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = all;
                Visible = true;
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Visible = true;
            }



            field("Product Class"; "Product Class")
            {
                ApplicationArea = all;
            }
            field("Category 9"; "Category 9")
            {
                ApplicationArea = all;
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

                trigger OnAction();
                begin
                    ShowItemTrackingLines;
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
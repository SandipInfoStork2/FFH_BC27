/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50135 PostedPurchInvoiceSubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Description 2")
        {
            Visible = true;
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
        addbefore(Quantity)
        {
            field("Location Code"; "Location Code")
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
            action("Update Line")
            {
                ApplicationArea = Suite;
                Caption = 'Update Line';
                Image = Edit;

                ToolTip = 'Custom: Update Line';

                trigger OnAction()
                var
                    PostedPurchaseInvoiceLineUpdateExt: Page "Posted Purchase Line - Update";
                begin
                    PostedPurchaseInvoiceLineUpdateExt.LookupMode := true;
                    PostedPurchaseInvoiceLineUpdateExt.SetRec(Rec);
                    PostedPurchaseInvoiceLineUpdateExt.RunModal;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
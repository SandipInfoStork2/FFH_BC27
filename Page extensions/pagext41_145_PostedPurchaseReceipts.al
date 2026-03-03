/*
TAL0.1 2019/01/03 VC add Deliver to vendor fields 
TAL0.2 2021/04/02 VC add field Order No.
TAL0.3 2021/04/06 VC add PrintAppendixRecords
TAL0.4 2021/10/26 VC add "Gen. Bus. Posting Group" for filter

*/
pageextension 50141 PostedPurchaseReceiptsExt extends "Posted Purchase Receipts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shipment Method Code")
        {
            field("Deliver-to Vendor No."; Rec."Deliver-to Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deliver-to Vendor No. field.';
            }
            field("Deliver-to Name"; Rec."Deliver-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deliver-to Name field.';
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number of the order that created the entry.';
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }
        }

        modify("Posting Date")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action("Grower Receipt")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Grower Receipt action.';

                trigger OnAction();
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintGrowerReceiptRecords(PurchRcptHeader);
                end;
            }
            action("Item Tracking Appendix")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintAppendixRecords(PurchRcptHeader);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
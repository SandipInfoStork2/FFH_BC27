/*
TAL0.1 2021/04/02 VC add field Order No.

*/
pageextension 50142 PostedPurchaseInvoicesExt extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        modify("Vendor Invoice No.")
        {
            Visible = true;
        }
        modify("Order No.")
        {
            Visible = true;
        }

        //TAL 1.0.0.71 >>
        addfirst(Control1)
        {
            field("Posting Date57194"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Width = 13;
            }
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify(Closed)
        {
            Visible = false;
        }
        modify(Cancelled)
        {
            Visible = false;
        }
        modify(Corrective)
        {
            Visible = false;
        }
        moveafter("Amount Including VAT"; "Remaining Amount")
        moveafter("Amount Including VAT"; Amount)
        //TAL 1.0.0.71 <<

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
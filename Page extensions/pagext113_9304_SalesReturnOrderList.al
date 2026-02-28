/*
TAL0.1 2021/03/26 VC add Field Lot No.
TAL0.1 2021/03/26 VC add Total Qty Received for Return Shipments

*/
pageextension 50213 SalesReturnOrderListExt extends "Sales Return Order List"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }

        movebefore("No."; "Posting Date")
        modify("Currency Code")
        {
            Visible = true;
        }
        modify(Status)
        {
            Visible = true;
        }
        addafter("Status")
        {
            field("Lot No."; "Lot No.")
            {
                ApplicationArea = all;
            }
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Qty Received"; "Total Qty Received")
            {
                ApplicationArea = all;
            }
            field("Total Qty Invoiced"; "Total Qty Invoiced")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
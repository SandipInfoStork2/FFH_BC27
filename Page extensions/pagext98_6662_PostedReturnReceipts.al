/*
TAL0.1 2019/09/17 VC add missing logic for Print to print for a specific customer, bill-to customer No. was always blank 
TAL0.2 2021/03/26 VC add Field Lot No.

*/
pageextension 50198 PostedReturnReceiptsExt extends "Posted Return Receipts"
{
    layout
    {
        // Add changes to page layout here

        modify("Shipment Date")
        {
            Visible = true;
        }
        addafter("Shipment Date")
        {
            field("Lot No."; "Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = All;
            }
            field("Total Qty (Base)"; "Total Qty (Base)")
            {
                ApplicationArea = All;
            }
            field("Total Weight"; "Total Weight")
            {
                ApplicationArea = All;
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
    }

    var
        myInt: Integer;
}
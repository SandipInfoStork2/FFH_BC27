/*
2020/06/09 TAL0.1 VC design Posting Date

*/
pageextension 50175 GetShipmentLinesExt extends "Get Shipment Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. Shipped Not Invoiced")
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
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
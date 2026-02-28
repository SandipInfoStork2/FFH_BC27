/*
TAL0.1 2021/10/04 VC add field Posting Date 

*/

pageextension 50193 GetReturnShipmentLinesExt extends "Get Return Shipment Lines"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Document No.")
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
/*
TAL0.1 2021/03/26 VC add Field Lot No.

*/
pageextension 50190 SalesReturnOrderExt extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Lot No."; "Lot No.")
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
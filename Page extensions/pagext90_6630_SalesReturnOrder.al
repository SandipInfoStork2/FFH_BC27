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
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No. field.';
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
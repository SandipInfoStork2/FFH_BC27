/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record

*/
pageextension 50180 PostedTransferReceiptExt extends "Posted Transfer Receipt"
{
    layout
    {
        // Add changes to page layout here
        addafter("In-Transit Code")
        {
            field("Salesperson Code"; "Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("Salesperson Name"; "Salesperson Name")
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
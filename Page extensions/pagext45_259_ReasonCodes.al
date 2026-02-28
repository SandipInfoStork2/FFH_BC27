/*
TAL0.1 2018/11/09 VC add field EDI Code

*/
pageextension 50145 ReasonCodesExt extends "Reason Codes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("EDI Code"; "EDI Code")
            {
                ApplicationArea = All;
            }
            field("Mark Invoice Entries"; "Mark Invoice Entries")
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
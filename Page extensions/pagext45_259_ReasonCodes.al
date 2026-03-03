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
            field("EDI Code"; Rec."EDI Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EDI Code field.';
            }
            field("Mark Invoice Entries"; Rec."Mark Invoice Entries")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mark Invoice Entries field.';
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
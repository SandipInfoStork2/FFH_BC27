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
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salesperson Code field.';
            }
            field("Salesperson Name"; Rec."Salesperson Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salesperson Name field.';
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
/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
no changes
*/
pageextension 50136 PostedPurchaseCreditMemoExt extends "Posted Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. Printed")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';
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
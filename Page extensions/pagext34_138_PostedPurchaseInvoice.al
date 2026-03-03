/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
//no changes
*/
pageextension 50134 PostedPurchaseInvoiceExt extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(Corrective)
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
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
            field("Posting Description"; "Posting Description")
            {
                ApplicationArea = all;
                Editable = false;
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
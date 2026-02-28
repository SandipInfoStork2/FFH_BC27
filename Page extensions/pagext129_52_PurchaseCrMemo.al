/*
TAL0.1 2017/12/07 VC design Pay-to Name

*/
pageextension 50229 PurchaseCreditMemoExt extends "Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Description")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
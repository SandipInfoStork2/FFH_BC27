pageextension 50240 PurchaseReturnOrderListExt extends "Purchase Return Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Status")
        {

            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Return Qty Shipped"; "Total Return Qty Shipped")
            {
                ApplicationArea = all;
            }

            field("Total Qty Invoiced"; "Total Qty Invoiced")
            {
                ApplicationArea = all;
            }
        }

        modify("Document Date")
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
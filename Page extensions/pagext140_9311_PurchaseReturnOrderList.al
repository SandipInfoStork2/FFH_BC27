pageextension 50240 PurchaseReturnOrderListExt extends "Purchase Return Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {

            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Return Qty Shipped"; Rec."Total Return Qty Shipped")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Return Qty Shipped field.';
            }

            field("Total Qty Invoiced"; Rec."Total Qty Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Invoiced field.';
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
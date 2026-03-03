/*
TAL0.1 2021/03/26 VC add Field Lot No.
TAL0.1 2021/03/26 VC add Total Qty Received for Return Shipments

*/
pageextension 50213 SalesReturnOrderListExt extends "Sales Return Order List"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }

        movebefore("No."; "Posting Date")
        modify("Currency Code")
        {
            Visible = true;
        }
        modify(Status)
        {
            Visible = true;
        }
        addafter(Status)
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty Received"; Rec."Total Qty Received")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Received field.';
            }
            field("Total Qty Invoiced"; Rec."Total Qty Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Invoiced field.';
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
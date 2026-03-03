/*
TAL0.1 2019/09/17 VC add missing logic for Print to print for a specific customer, bill-to customer No. was always blank 
TAL0.2 2021/03/26 VC add Field Lot No.

*/
pageextension 50198 PostedReturnReceiptsExt extends "Posted Return Receipts"
{
    layout
    {
        // Add changes to page layout here

        modify("Shipment Date")
        {
            Visible = true;
        }
        addafter("Shipment Date")
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty (Base)"; Rec."Total Qty (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty (Base) field.';
            }
            field("Total Weight"; Rec."Total Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Weight field.';
            }
        }

        modify("Posting Date")
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
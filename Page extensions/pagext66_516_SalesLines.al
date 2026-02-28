/*
08/11/13 TAL0.1 PopulateAllFields set to true
                "Qty. per Unit of Measure"
                "Quantity (Base)"
*/
pageextension 50166 SalesLinesExt extends "Sales Lines"
{

    layout
    {

        // Add changes to page layout here
        addafter("Outstanding Quantity")
        {
            field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Ship-to Code"; "Ship-to Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("Shipment Date")
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
                Visible = false;
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
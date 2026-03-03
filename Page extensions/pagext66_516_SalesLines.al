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
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an auto-filled number if you have included Sales Unit of Measure on the item card and a quantity in the Qty. per Unit of Measure field.';
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ship-to Code field.';
            }
        }

        addafter("Shipment Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Posting Date field.';
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
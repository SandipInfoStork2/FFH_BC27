pageextension 50208 MyItemsExt extends "My Items"
{
    layout
    {
        // Add changes to page layout here
        addafter(Inventory)
        {
            field("Inventory Aradipou - Main"; Rec."Inventory Aradipou - Main")
            {
                ApplicationArea = All;
                Caption = 'Inventory Aradipou - Main';
                ToolTip = 'Specifies the value of the Inventory Aradipou - Main field.';
            }
            field("Inventory Fresh Cut"; Rec."Inventory Fresh Cut")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory Fresh Cut field.';
            }
            field("Inventory Kitchen"; Rec."Inventory Kitchen")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory Kitchen field.';
            }
            field("Inventory Potatoes"; Rec."Inventory Potatoes")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory Potatoes field.';
            }

        }
        modify("Unit Price")
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
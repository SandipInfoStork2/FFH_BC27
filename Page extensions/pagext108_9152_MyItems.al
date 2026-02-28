pageextension 50208 MyItemsExt extends "My Items"
{
    layout
    {
        // Add changes to page layout here
        addafter(Inventory)
        {
            field("Inventory Aradipou - Main"; "Inventory Aradipou - Main")
            {
                ApplicationArea = all;
                Caption = 'Inventory Aradipou - Main';
            }
            field("Inventory Fresh Cut"; "Inventory Fresh Cut")
            {
                ApplicationArea = All;
            }
            field("Inventory Kitchen"; "Inventory Kitchen")
            {
                ApplicationArea = All;
            }
            field("Inventory Potatoes"; "Inventory Potatoes")
            {
                ApplicationArea = All;
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
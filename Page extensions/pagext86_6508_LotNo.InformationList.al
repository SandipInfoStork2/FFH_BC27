/*
TAL0.1 2021/04/02 VC add field Producer Group Name

*/
pageextension 50186 LotNoInformationListExt extends "Lot No. Information List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {
            field("Item Description"; "Item Description")
            {
                ApplicationArea = All;
            }
        }

        addafter("Lot No.")
        {
            field("Category 1"; "Category 1")
            {
                ApplicationArea = All;
            }
            field("Producer Group Name"; "Producer Group Name")
            {
                ApplicationArea = All;
            }
            field("Grower No."; "Grower No.")
            {
                ApplicationArea = All;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = All;
            }
            field("Grower GGN"; "Grower GGN")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor GLN"; "Vendor GLN")
            {
                ApplicationArea = All;
            }
            field("Vendor GGN"; "Vendor GGN")
            {
                ApplicationArea = All;
            }
        }

        addafter("Expired Inventory")
        {
            field("Category 4"; "Category 4")
            {
                ApplicationArea = All;
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
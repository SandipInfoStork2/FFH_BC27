
pageextension 50183 InventoryPostingSetupExt extends "Inventory Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Invt. Posting Group Code")
        {
            field("Location Name"; "Location Name")
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
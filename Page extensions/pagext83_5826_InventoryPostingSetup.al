
pageextension 50183 InventoryPostingSetupExt extends "Inventory Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Invt. Posting Group Code")
        {
            field("Location Name"; Rec."Location Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Name field.';
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
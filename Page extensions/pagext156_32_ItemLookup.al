pageextension 50256 ItemLookupExt extends "Item Lookup"
{
    layout
    {
        // Add changes to page layout here

        modify("Shelf No.")
        {
            visible = true;
        }
        addafter("Shelf No.")
        {
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
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
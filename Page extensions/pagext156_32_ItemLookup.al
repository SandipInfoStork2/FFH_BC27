pageextension 50256 ItemLookupExt extends "Item Lookup"
{
    layout
    {
        // Add changes to page layout here

        modify("Shelf No.")
        {
            Visible = true;
        }
        addafter("Shelf No.")
        {
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';
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
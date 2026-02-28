pageextension 50227 FixedAssetCardExt extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        modify("No.")
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
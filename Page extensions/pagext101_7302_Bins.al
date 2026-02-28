pageextension 50201 BinsExt extends "Bins"
{
    layout
    {
        // Add changes to page layout here
        addafter(Dedicated)
        {
            field("Hide MN"; "Hide MN")
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
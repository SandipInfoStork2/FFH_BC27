pageextension 50201 BinsExt extends Bins
{
    layout
    {
        // Add changes to page layout here
        addafter(Dedicated)
        {
            field("Hide MN"; Rec."Hide MN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Hide MN field.';
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
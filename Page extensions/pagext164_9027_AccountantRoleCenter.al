pageextension 50264 AccountantRoleCenterExt extends "Accountant Role Center"
{
    layout
    {
        // Add changes to page layout here

        addafter(Control1902304208)
        {
            part(Control19023042081; "SO Processor Activities")
            {
                ApplicationArea = Basic, Suite;
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
pageextension 50239 ItemJournalTemplatesExt extends "Item Journal Templates"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Report ID")
        {
            Visible = true;
        }
        modify("Posting Report Caption")
        {
            Visible = true;
        }
        modify("Test Report ID")
        {
            Visible = true;
        }

        addafter("Posting Report Caption")
        {
            field("Posting Report ID 2"; "Posting Report ID 2")
            {
                ApplicationArea = All;
            }
            field("Posting Report Caption 2"; "Posting Report Caption 2")
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
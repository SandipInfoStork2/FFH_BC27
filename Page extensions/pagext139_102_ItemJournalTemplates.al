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
            field("Posting Report ID 2"; Rec."Posting Report ID 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Report ID 2 field.';
            }
            field("Posting Report Caption 2"; Rec."Posting Report Caption 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Report Caption 2 field.';
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
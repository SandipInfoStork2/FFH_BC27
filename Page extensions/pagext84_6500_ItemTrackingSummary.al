pageextension 50184 ItemTrackingSummaryExt extends "Item Tracking Summary"
{
    layout
    {
        // Add changes to page layout here
        modify("Serial No.")
        {
            Visible = false;
        }
        modify("Expiration Date")
        {
            Visible = true;
        }

        addafter("Expiration Date")
        {
            field("Producer Group"; Rec."Producer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group field.';
            }
            field("Grower No."; Rec."Grower No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower GGN field.';
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
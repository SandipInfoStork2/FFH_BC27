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
            field("Producer Group"; "Producer Group")
            {
                ApplicationArea = All;
            }
            field("Grower No."; "Grower No.")
            {
                ApplicationArea = All;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = All;
            }
            field("Grower GGN"; "Grower GGN")
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
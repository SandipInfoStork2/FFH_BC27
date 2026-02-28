pageextension 50165 ReservationEntriesExt extends "Reservation Entries"
{
    layout
    {
        // Add changes to page layout here

        addafter("Transferred from Entry No.")
        {
            field("Producer Group"; "Producer Group")
            {
                ApplicationArea = All;
            }
            field("Lot Grower No."; "Lot Grower No.")
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
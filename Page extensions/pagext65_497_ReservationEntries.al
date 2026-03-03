pageextension 50165 ReservationEntriesExt extends "Reservation Entries"
{
    layout
    {
        // Add changes to page layout here

        addafter("Transferred from Entry No.")
        {
            field("Producer Group"; Rec."Producer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group field.';
            }
            field("Lot Grower No."; Rec."Lot Grower No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Grower No. field.';
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
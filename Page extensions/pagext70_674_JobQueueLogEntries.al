/*
TAL.JQEMail 2017/11/20 VC Design entry No.

*/
pageextension 50170 JobQueueLogEntriesExt extends "Job Queue Log Entries"
{
    layout
    {
        // Add changes to page layout here

        addbefore(Status)
        {
            field("Entry No."; "Entry No.")
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
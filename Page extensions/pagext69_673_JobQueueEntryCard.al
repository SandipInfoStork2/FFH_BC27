/*
TAL.JQEMail 2017/11/20 VC add field "Email Result", Add action Start

*/
pageextension 50169 JobQueueEntryCardExt extends "Job Queue Entry Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Email Result"; "Email Result")
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
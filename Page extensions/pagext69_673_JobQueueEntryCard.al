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
            field("Email Result"; Rec."Email Result")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email Result field.';
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
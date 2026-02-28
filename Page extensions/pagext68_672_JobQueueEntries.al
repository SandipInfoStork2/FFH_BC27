/*
TAL.JQEMail 2017/11/20 VC add field "Email Result", Add action Start

*/
pageextension 50168 JobQueueEntriesExt extends "Job Queue Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Ending Time")
        {
            field("Email Result"; "Email Result")
            {
                ApplicationArea = All;
            }
        }

        addafter("User ID")
        {
            field("Execute User ID"; "Execute User ID")
            {
                ApplicationArea = all;
                ToolTip = 'Custom: Execute User ID';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter(Restart)
        {
            action(UpdateUser)
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Update User';

                trigger OnAction()
                var
                    //cu_EventsGeneral: Codeunit "EventsGeneral";
                    rL_JobQueueEntry: Record "Job Queue Entry";
                    rL_User: Record User;
                    vL_User: Code[50];
                begin

                    //pop up to select user
                    rL_User.RESET;
                    rL_User.SetFilter("License Type", '%1|%2', rL_User."License Type"::"Device Only User", rL_User."License Type"::"Full User");
                    rL_User.SetRange(State, rL_User.State::Enabled);
                    if rL_User.findset then begin
                        if page.RunModal(Page::"Users", rL_User) = Action::LookupOK then begin
                            vL_User := rL_User."User Name";
                        end;
                    end;

                    if vL_User = '' then begin
                        exit;
                    end;

                    rL_JobQueueEntry.RESET;
                    if rL_JobQueueEntry.FindSet() then begin
                        repeat
                            rL_JobQueueEntry."User ID" := vL_User;
                            rL_JobQueueEntry."Execute User ID" := "User ID";
                            rL_JobQueueEntry.Modify();

                        until rL_JobQueueEntry.next = 0;
                    end;
                    Message('Process Completed');


                end;
            }
        }
    }

    var
        myInt: Integer;
}
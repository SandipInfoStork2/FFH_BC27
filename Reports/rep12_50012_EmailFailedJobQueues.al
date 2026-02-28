report 50012 "Email Failed Job Queues"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //DefaultRenderingLayout = LayoutName;
    ProcessingOnly = true;

    dataset
    {
        dataitem(JobQueueEntry; "Job Queue Entry")
        {

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
            end;

            trigger OnAfterGetRecord()
            var
                Email: Codeunit Email;
                EmailMessage: Codeunit "Email Message";
                rL_UserSetup: Record "User Setup";
                Body: Text;
            begin

                rL_UserSetup.RESET;
                rL_UserSetup.SETRANGE(rL_UserSetup."Job Queue Email", TRUE);
                rL_UserSetup.SETFILTER(rL_UserSetup."E-Mail", '<>%1', '');
                IF rL_UserSetup.FINDFIRST THEN BEGIN
                    REPEAT
                        clear(EmailMessage);
                        clear(Email);


                        Body := 'Description: ' + FORMAT(JobQueueEntry.Description) + ' <b>Status: ' + FORMAT(JobQueueEntry.Status) + '</b></br>';
                        if JobQueueEntry."Error Message" <> '' then begin
                            Body += ' - ' + JobQueueEntry."Error Message";
                        end;

                        EmailMessage.Create(rL_UserSetup."E-Mail", 'Error Job Queue Entry  ' + JobQueueEntry.Description + ' - ' + CompanyProperty.DisplayName(), Body, true);
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

                    UNTIL rL_UserSetup.NEXT = 0;
                END;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        myInt: Integer;
}
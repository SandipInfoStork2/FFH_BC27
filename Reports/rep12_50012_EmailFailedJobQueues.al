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

                rL_UserSetup.Reset;
                rL_UserSetup.SetRange(rL_UserSetup."Job Queue Email", true);
                rL_UserSetup.SetFilter(rL_UserSetup."E-Mail", '<>%1', '');
                if rL_UserSetup.FindFirst then begin
                    repeat
                        Clear(EmailMessage);
                        Clear(Email);


                        Body := 'Description: ' + Format(JobQueueEntry.Description) + ' <b>Status: ' + Format(JobQueueEntry.Status) + '</b></br>';
                        if JobQueueEntry."Error Message" <> '' then begin
                            Body += ' - ' + JobQueueEntry."Error Message";
                        end;

                        EmailMessage.Create(rL_UserSetup."E-Mail", 'Error Job Queue Entry  ' + JobQueueEntry.Description + ' - ' + CompanyProperty.DisplayName(), Body, true);
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

                    until rL_UserSetup.Next = 0;
                end;

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
            area(Processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }



    var
        myInt: Integer;
}
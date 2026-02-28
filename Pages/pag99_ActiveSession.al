page 50099 "Active Session"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = all;
                }
                field("Client Computer Name"; "Client Computer Name")
                {
                    ApplicationArea = all;
                }
                field("Session ID"; "Session ID")
                {
                    ApplicationArea = all;
                }
                field("Client Type"; "Client Type")
                {
                    ApplicationArea = all;
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = all;
                }

                field("Server Instance ID"; "Server Instance ID")
                {
                    ApplicationArea = all;
                }
                field("Server Computer Name"; "Server Computer Name")
                {
                    ApplicationArea = all;
                }



            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
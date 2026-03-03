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
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Login Datetime field.';
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Computer Name field.';
                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Session ID field.';
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Type field.';
                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance Name field.';
                }

                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance ID field.';
                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Computer Name field.';
                }



            }
        }
        area(FactBoxes)
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
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
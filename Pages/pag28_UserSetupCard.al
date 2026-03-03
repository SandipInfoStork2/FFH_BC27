page 50028 "User Setup Card"
{

    PageType = Card;
    SourceTable = "User Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Name';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson or purchaser code that relates to the User ID field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the user in the User ID field.';
                }
            }
            group(Signature)
            {
                Caption = 'Signature';
                field(Control1000000004; Rec.Signature)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Signature field.';
                }
            }

        }
    }

    actions
    {
    }
}


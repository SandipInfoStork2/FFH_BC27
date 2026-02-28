page 50028 "User Setup Card"
{

    PageType = Card;
    SourceTable = "User Setup";
    
    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field(Name; Name)
                {
                    ApplicationArea = all;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = all;
                }
            }
            group(Signature)
            {
                Caption = 'Signature';
                field(Control1000000004; Signature)
                {
                    ApplicationArea = all;
                }
            }

        }
    }

    actions
    {
    }
}


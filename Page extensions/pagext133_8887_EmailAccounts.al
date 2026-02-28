pageextension 50233 EmailAccountsExt extends "Email Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Delete)
        {
            action(AddCCbcc)
            {
                ApplicationArea = All;
                Caption = 'Add Cc-Bcc';
                //RunObject = page "O365 Email CC and BCC Settings"; //Page removed from BC25
                Image = ContactPerson;
                PromotedCategory = Process;
                PromotedOnly = true;
                Promoted = true;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
pageextension 50242 PostedSalesInvUpdateExt extends "Posted Sales Inv. - Update"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payment Reference")
        {
            field("Sell-to E-Mail"; "Sell-to E-Mail")
            {
                ApplicationArea = all;
                Caption = 'Sell-to E-Mail';
            }
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
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
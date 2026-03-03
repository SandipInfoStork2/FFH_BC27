pageextension 50242 PostedSalesInvUpdateExt extends "Posted Sales Inv. - Update"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payment Reference")
        {
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                Caption = 'Sell-to E-Mail';
                ToolTip = 'Specifies the value of the Sell-to E-Mail field.';
            }
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
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
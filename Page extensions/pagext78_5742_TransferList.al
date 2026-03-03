pageextension 50178 TransferListExt extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter("Receipt Date")
        {
            field("Req. Vendor No."; Rec."Req. Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Req. Vendor No. field.';
            }
        }

        modify("Receipt Date")
        {
            Visible = true;
        }
        modify("Shipment Date")
        {
            Visible = true;
            Caption = 'Shipment/Delivery Date';
        }

        addafter("Shipment Date")
        {
            field("Shipment/Delivery Time"; Rec."Shipment/Delivery Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment/Delivery Time field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Print")
        {
            action(Email)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Email';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                ToolTip = 'Custom: Email Transfer Order';
                trigger OnAction()
                begin
                    Rec.PrintTransferOrder(true);
                end;

            }
        }
    }

    var
        myInt: Integer;
}
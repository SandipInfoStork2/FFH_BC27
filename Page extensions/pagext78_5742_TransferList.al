pageextension 50178 TransferListExt extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter("Receipt Date")
        {
            field("Req. Vendor No."; "Req. Vendor No.")
            {
                ApplicationArea = All;
            }
        }

        modify("Receipt Date")
        {
            Visible = true;
        }
        modify("Shipment Date")
        {
            Visible = true;
            caption = 'Shipment/Delivery Date';
        }

        addafter("Shipment Date")
        {
            field("Shipment/Delivery Time"; "Shipment/Delivery Time")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Print")
        {
            action("Email")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Email';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                ToolTip = 'Custom: Email Transfer Order';
                trigger onAction()
                begin
                    PrintTransferOrder(true);
                end;

            }
        }
    }

    var
        myInt: Integer;
}
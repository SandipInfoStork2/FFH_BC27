pageextension 50177 TransferOrderExt extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here


        addafter("In-Transit Code")
        {
            field("Salesperson Code"; "Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("Salesperson Name"; "Salesperson Name")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Shipment Date2"; "Shipment Date")
            {
                ApplicationArea = All;
                caption = 'Shipment/Delivery Date';
                ShowMandatory = true;
            }
            field("Shipment/Delivery Time"; "Shipment/Delivery Time")
            {
                caption = 'Shipment/Delivery Time';
                ShowMandatory = true;
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

            action("Get Expiring Items")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    ExpiringItems: Report "Transfer Expiring Items";
                begin

                    CLEAR(ExpiringItems);
                    ExpiringItems.SetHeader(Rec);
                    ExpiringItems.RUNMODAL;
                    CurrPage.UPDATE(false);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
pageextension 50177 TransferOrderExt extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here


        addafter("In-Transit Code")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salesperson Code field.';
            }
            field("Salesperson Name"; Rec."Salesperson Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Salesperson Name field.';
            }

            field("Shipment Date2"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                Caption = 'Shipment/Delivery Date';
                ShowMandatory = true;
                ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
            }
            field("Shipment/Delivery Time"; Rec."Shipment/Delivery Time")
            {
                Caption = 'Shipment/Delivery Time';
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Shipment/Delivery Time field.';
                ApplicationArea = All;
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

            action("Get Expiring Items")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Get Expiring Items action.';

                trigger OnAction();
                var
                    ExpiringItems: Report "Transfer Expiring Items";
                begin

                    Clear(ExpiringItems);
                    ExpiringItems.SetHeader(Rec);
                    ExpiringItems.RunModal;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
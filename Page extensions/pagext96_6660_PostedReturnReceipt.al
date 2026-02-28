/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
TAL0.2 2019/09/17 VC add missing logic for Print to print for a specific customer, bill-to customer No. was always blank 
TAL0.3 2021/03/26 VC add Field Lot No.
*/

pageextension 50196 PostedReturnReceiptExt extends "Posted Return Receipt"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. Printed")
        {
            field("Lot No."; "Lot No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }

        modify("Ship-to")
        {
            Visible = true;
        }

        modify("Bill-to")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {

            action(Customer)
            {

                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                Image = Customer;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Sell-to Customer No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the customer.';
            }

        }
    }

    var
        myInt: Integer;
}
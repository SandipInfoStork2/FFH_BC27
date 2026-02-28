/*
TAL0.1 2018/11/14 VC add field GLN Delivery for EDI

*/

pageextension 50148 ShiptoAddressExt extends "Ship-to Address"
{
    layout
    {
        // Add changes to page layout here

        addafter("Customer No.")
        {
            field("GLN Delivery"; "GLN Delivery")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Interface Code"; "Interface Code")
            {
                ApplicationArea = all;
            }

            field(Blocked; Blocked)
            {
                ApplicationArea = all;
            }
        }

        addafter(General)
        {
            group(DD)
            {
                caption = 'Delivery Days';
                field(Monday; Monday)
                {
                    ApplicationArea = All;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = All;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = All;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = All;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = All;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = All;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            field("Notify Place Order"; "Notify Place Order")
            {
                ApplicationArea = All;
            }

            field("Shop Password"; "Shop Password")
            {
                ApplicationArea = All;
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
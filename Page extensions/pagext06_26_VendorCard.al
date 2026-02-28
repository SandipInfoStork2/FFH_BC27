/*
10/02/15 TAL0.1 design  field Customer
TAL0.2 2020/03/06 VC add field Grower Vendor No.
                     GGN
                     TC
                     Category 1-3

TAL0.3 2020/03/06 VC add field GGN Expiry Date
TAL0.4 2021/03/23 VC add field Grower Certified, rename category 5
*/
pageextension 50106 VendorCardExt extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        modify("Name 2")
        {
            Visible = true;
        }

        addafter("Responsibility Center")
        {
            field(Customer; Customer)
            {
                ApplicationArea = All;
            }
            group(Grower)
            {
                field("Category 5"; "Category 5")
                {
                    ApplicationArea = All;
                }
                field("Grower Certified"; "Grower Certified")
                {
                    ApplicationArea = All;
                }
                field(GGN; GGN)
                {
                    ApplicationArea = All;
                }
                field("GGN Expiry Date"; "GGN Expiry Date")
                {
                    ApplicationArea = All;
                }
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
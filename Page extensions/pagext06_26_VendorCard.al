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
            field(Customer; Rec.Customer)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer field.';
            }
            group(Grower)
            {
                field("Category 5"; Rec."Category 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 5 field.';
                }
                field("Grower Certified"; Rec."Grower Certified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Certified field.';
                }
                field(GGN; Rec.GGN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN field.';
                }
                field("GGN Expiry Date"; Rec."GGN Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN Expiry Date field.';
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
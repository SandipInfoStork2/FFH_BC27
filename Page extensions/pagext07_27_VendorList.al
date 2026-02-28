
/*
TAL0.1 2020/03/06 VC add field Grower Vendor No.
                     GGN
                     TC
                     Category 1-3

TAL0.2 2020/03/06 VC add field GGN Expiry Date
TAL0.3 2021/03/23 VC add field Grower Certified, rename category 5
*/
pageextension 50107 VendorListExt extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        modify("Name 2")
        {
            Visible = false;//TAL 1.0.0.71
        }

        moveafter("Payments (LCY)"; "Country/Region Code")
        modify("Country/Region Code")
        {
            Visible = true;
        }

        addafter("Country/Region Code")
        {
            field("Category 5"; "Category 5")
            {
                ApplicationArea = All;
            }
            field("Grower Certified"; "Grower Certified")
            {
                ApplicationArea = All;
            }
            field(GLN; GLN)
            {
                ApplicationArea = All;
                Visible = false;//TAL 1.0.0.71
            }
            field(GGN; GGN)
            {
                ApplicationArea = All;
            }
            field("GGN Expiry Date"; "GGN Expiry Date")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.71 >>
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        //TAL 1.0.0.71 <<

    }

    actions
    {
        // Add changes to page actions here
    }

    views
    {
        //TAL 1.0.0.71 >>
        addfirst
        {
            view("Vendors with Balance01056")
            {
                Filters = where("Balance (LCY)" = filter(> 0));
                OrderBy = ascending("No.");
                SharedLayout = true;
                CaptionML = ENG = 'Vendors with Balance', ENU = 'Vendors with Balance';
            }
        }
        //TAL 1.0.0.71 <<
    }
    var
        myInt: Integer;
}
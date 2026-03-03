
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
            field(GLN; Rec.GLN)
            {
                ApplicationArea = All;
                Visible = false;
                //TAL 1.0.0.71                ToolTip = 'Specifies the vendor in connection with electronic document receiving.';

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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s VAT registration number.';
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
/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50120 PurchInvoiceSubformExt extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Description 2")
        {
            Visible = true;
        }
        modify("Net Weight")
        {
            Visible = true;
        }

        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
            }
        }
        */
        //TAL 1.0.0.71 >>
        addafter("Line Amount")
        {
            field("VAT Calculation Type06196"; Rec."VAT Calculation Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("VAT %78370"; Rec."VAT %")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Visible = false;
            }

        }
        addafter("VAT %78370")
        {
            field("VAT Prod. Posting Group83232"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        //TAL 1.0.0.71 <<
    }

    actions
    {
        // Add changes to page actions here
        addfirst("Item Availability by")
        {
            action("Item &Tracking Lines2")
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction();
                begin
                    OpenItemTrackingLines;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
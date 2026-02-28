pageextension 50245 ItemReferencesExt extends "Item References"
{
    layout
    {
        // Add changes to page layout here

        addbefore("Reference No.")
        {
            field("Reference Type"; "Reference Type")
            {
                ApplicationArea = all;
            }
            field("Reference Type No."; "Reference Type No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit of Measure")
        {
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; "Description 3")
            {
                ApplicationArea = all;
            }
            field("Category 2"; "Category 2")
            {
                ApplicationArea = all;
            }

            field("S. Quote Description"; "S. Quote Description")
            {
                ApplicationArea = all;
            }

            field("Item Description"; "Item Description")
            {
                ApplicationArea = all;
            }
            field("Item Description 2 (GR)"; "Item Description 2 (GR)")
            {
                ApplicationArea = all;
            }
            field(Discontinued; Discontinued)
            {
                ApplicationArea = all;
            }

            field(vG_NoSQLines; vG_NoSQLines)
            {
                caption = 'No. of S.Q. Lines';
                ApplicationArea = all;
                Editable = false;

                trigger OnDrillDown()
                var
                    myInt: Integer;
                begin
                    Page.Run(Page::"Sales Quote Lidl Lines", SaleLine);
                end;
            }

            field(Package; Package)
            {
                ApplicationArea = all;
            }
            field(EAN; EAN)
            {
                ApplicationArea = all;
            }
            field("Family Code"; "Family Code")
            {
                ApplicationArea = all;
            }
        }

        /*
        addafter("Description 2")
        {
            field("Description 3"; "Description 3")
            {
                ApplicationArea = All;
            }
        }
        */

        /*
        addafter("Cross-Reference Type No.")
        {
            field("Category 2"; "Category 2")
            {
                ApplicationArea = All;
            }
        }
        */
        /*
        modify("Description 2")
        {
            Visible = true;
        }
        */
    }

    actions
    {
        // Add changes to page actions here
        addlast(Navigation)
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                Promoted = true;
                PromotedCategory = Process;
                Image = Item;

            }
        }
    }

    trigger OnAfterGetRecord()
    var

    begin
        vG_NoSQLines := 0;
        SaleLine.RESET;
        SaleLine.SetRange("Document Type", SaleLine."Document Type"::Quote);
        SaleLine.SetFilter("No.", "Item No.");
        if SaleLine.FindSet() then begin
            vG_NoSQLines := SaleLine.Count;
        end;
    end;

    var

        vG_NoSQLines: Integer;

        SaleLine: Record "Sales Line";
}
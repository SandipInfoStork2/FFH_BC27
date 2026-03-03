pageextension 50245 ItemReferencesExt extends "Item References"
{
    layout
    {
        // Add changes to page layout here

        addbefore("Reference No.")
        {
            /* field("Reference Type"; "Reference Type")
            {
                ApplicationArea = all;
            }
            field("Reference Type No."; "Reference Type No.")
            {
                ApplicationArea = all;
            } */
        }

        addafter("Unit of Measure")
        {
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 3 field.';
            }
            field("Category 2"; Rec."Category 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product No. field.';
            }

            field("S. Quote Description"; Rec."S. Quote Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the S. Quote Description field.';
            }

            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
            field("Item Description 2 (GR)"; Rec."Item Description 2 (GR)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description 2 (GR) field.';
            }
            field(Discontinued; Rec.Discontinued)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Discontinued field.';
            }

            field(vG_NoSQLines; vG_NoSQLines)
            {
                Caption = 'No. of S.Q. Lines';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the No. of S.Q. Lines field.';

                trigger OnDrillDown()
                var
                    myInt: Integer;
                begin
                    Page.Run(Page::"Sales Quote Lidl Lines", SaleLine);
                end;
            }

            field(Package; Rec.Package)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package field.';
            }
            field(EAN; Rec.EAN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Barcode field.';
            }
            field("Family Code"; Rec."Family Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Family Code field.';
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
                ToolTip = 'Executes the Item Card action.';

            }
        }
    }

    trigger OnAfterGetRecord()
    var

    begin
        vG_NoSQLines := 0;
        SaleLine.Reset;
        SaleLine.SetRange("Document Type", SaleLine."Document Type"::Quote);
        SaleLine.SetFilter("No.", Rec."Item No.");
        if SaleLine.FindSet() then begin
            vG_NoSQLines := SaleLine.Count;
        end;
    end;

    var

        vG_NoSQLines: Integer;

        SaleLine: Record "Sales Line";
}
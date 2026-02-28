pageextension 50224 ReleasedProdOrderLinesExt extends "Released Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here


        modify("Variant Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        modify("ShortcutDimCode[5]")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            Visible = true;
        }

        moveafter("Item No."; "Variant Code")
        moveafter("Variant Code"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; "ShortcutDimCode[5]")

        modify("Production BOM No.")
        {
            Visible = true;
        }
        modify("Routing No.")
        {
            Visible = true;
        }
        modify("Production BOM Version Code")
        {
            Visible = true;
        }

        moveafter("Cost Amount"; "Production BOM No.")
        moveafter("Production BOM No."; "Routing No.")
        moveafter("Routing No."; "Production BOM Version Code")

        addafter("Item No.")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        //+1.0.0.228
        modify("Unit Cost")
        {
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(Components2)
            {
                ApplicationArea = All;
                Caption = 'Components';
                Image = Components;

                trigger OnAction();
                begin
                    ShowComponents;
                end;
            }
            action("Item Card")
            {
                ApplicationArea = All;
                Image = Item;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Item No.");
            }
        }
    }

    local procedure ShowComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, Status);
        ProdOrderComp.SetRange("Prod. Order No.", "Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", "Line No.");

        PAGE.Run(PAGE::"Prod. Order Components", ProdOrderComp);
    end;

    //+1.0.0.228
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
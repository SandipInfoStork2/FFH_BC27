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
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Shelf No. field.';
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
                ToolTip = 'Executes the Components action.';

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
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                ToolTip = 'Executes the Item Card action.';
            }
        }
    }

    local procedure ShowComponents()
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, Rec.Status);
        ProdOrderComp.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderComp.SetRange("Prod. Order Line No.", Rec."Line No.");

        Page.Run(Page::"Prod. Order Components", ProdOrderComp);
    end;

    //+1.0.0.228
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
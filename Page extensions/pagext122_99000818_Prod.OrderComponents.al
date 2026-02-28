/*
TAL0.1 2018/07/25 VC add Item Category Code
TAL0.2 2019/06/06 VC delete action type
TAL0.3 2022/01/11 VC add field Last Date Modified
                          Created By
                          Client Computer Name

*/

pageextension 50222 ProdOrderComponentsExt extends "Prod. Order Components"
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code")
        {
            Visible = true;
        }
        modify("Variant Code")
        {
            Visible = true;
        }

        modify("Scrap %")
        {
            Visible = true;
        }
        modify("Cost Amount")
        {
            Visible = true;
        }


        modify("ShortcutDimCode[4]")
        {
            Visible = true;
        }


        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }

        addafter("Remaining Quantity")
        {
            field("Requisition Quantity"; "Requisition Quantity")
            {
                ApplicationArea = all;
            }
        }

        moveafter(Description; "Location Code")
        moveafter("Location Code"; "Variant Code")

        moveafter("Requisition Quantity"; "Substitution Available")
        moveafter("Substitution Available"; "Bin Code")

        moveafter("Bin Code"; "Scrap %")

        moveafter("Scrap %"; "Cost Amount")

        moveafter("Cost Amount"; "ShortcutDimCode[4]")
        moveafter("ShortcutDimCode[4]"; "Shortcut Dimension 2 Code")

        addafter("Shortcut Dimension 2 Code")
        {
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }



        //+1.0.0.228
        modify("Unit Cost")
        {
            Editable = UnitCostEditable;
            Visible = true;
        }
        //-1.0.0.228
        moveafter("Item Category Code"; "Unit Cost")

        modify("Qty. Picked")
        {
            Visible = true;
        }
        modify("Qty. Picked (Base)")
        {
            Visible = true;
        }
        moveafter("Unit Cost"; "Qty. Picked")
        moveafter("Qty. Picked"; "Qty. Picked (Base)")

        addafter("Qty. Picked (Base)")
        {
            field("Last Date Modified"; "Last Date Modified")
            {
                ApplicationArea = all;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = all;
            }
            field("Client Computer Name"; "Client Computer Name")
            {
                ApplicationArea = all;
            }

            field(Status; Status)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Prod. Order No."; "Prod. Order No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }

            field("Quantity per BUOM"; "Quantity per BUOM")
            {
                ApplicationArea = all;
            }
        }

        addafter("Expected Quantity")
        {
            field("Posted Quantity"; "Posted Quantity")
            {
                ApplicationArea = all;
            }
        }


        /*
        addafter("Item No.")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }
        */




    }

    actions
    {
        // Add changes to page actions here
        addafter("Item Ledger E&ntries")
        {
            action("Item Card")
            {
                ApplicationArea = all;
                Image = Item;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Item No.");

            }
            action("Item SKU")
            {
                ApplicationArea = all;
                Image = Item;
                RunObject = Page "Stockkeeping Unit List";
                RunPageLink = "Item No." = FIELD("Item No.");

            }
            action("Finished Production Order ")
            {
                ApplicationArea = all;
                RunObject = Page "Finished Production Order";
                RunPageLink = Status = FIELD(Status),
                                  "No." = FIELD("Prod. Order No.");

            }
        }
    }

    views
    {
        addfirst
        {
            view(ARAD4)
            {
                Caption = 'ARAD-4';
                Filters = where("Location Code" = filter('ARAD-4'), Status = filter('Released'));

            }


        }
    }


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
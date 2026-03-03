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
            field("Requisition Quantity"; Rec."Requisition Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requisition Quantity field.';
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
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Item Category Code field.';
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
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Date Modified field.';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.';
            }
            field("Client Computer Name"; Rec."Client Computer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Client Computer Name field.';
            }

            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the status of the production order to which the component list belongs.';
            }
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the number of the related production order.';
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Line No. field.';
            }

            field("Quantity per BUOM"; Rec."Quantity per BUOM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity per BUOM field.';
            }
        }

        addafter("Expected Quantity")
        {
            field("Posted Quantity"; Rec."Posted Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posted Quantity field.';
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
                ApplicationArea = All;
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                ToolTip = 'Executes the Item Card action.';

            }
            action("Item SKU")
            {
                ApplicationArea = All;
                Image = Item;
                RunObject = page "Stockkeeping Unit List";
                RunPageLink = "Item No." = field("Item No.");
                ToolTip = 'Executes the Item SKU action.';

            }
            action("Finished Production Order ")
            {
                ApplicationArea = All;
                RunObject = page "Finished Production Order";
                RunPageLink = Status = field(Status),
                                  "No." = field("Prod. Order No.");
                ToolTip = 'Executes the Finished Production Order  action.';

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
        UserSetup.Get(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
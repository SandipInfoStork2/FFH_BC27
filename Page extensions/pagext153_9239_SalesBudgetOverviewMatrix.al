pageextension 50253 SalesBudgetOverviewMatrixExt extends "Sales Budget Overview Matrix"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("Shelf No."; rG_Item."Shelf No.")
            {
                Caption = 'Shelf No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';

            }

            field("Package Qty"; rG_Item."Package Qty")
            {
                Caption = 'Package Qty';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';

            }

            field(ItemReference; ItemReference."Reference No.")
            {
                Caption = 'Item Reference';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Reference field.';
                trigger OnDrillDown()
                begin
                    Page.Run(Page::"Item Reference Entries", ItemReference);
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Processing)
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field(Code);
                ToolTip = 'Executes the Item Card action.';


                trigger OnAction()
                begin

                end;
            }

            action("Import Lidl Budget")
            {
                ApplicationArea = All;
                Caption = 'Import Lidl Budget';
                ToolTip = 'Custom: Lidl Budget';
                Image = ImportExcel;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin

                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportLidlBudget(ItemBudgetName);
                end;
            }
        }


    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(rG_Item);
        Clear(ItemReference);
        if rG_Item.GET(Rec.Code) then begin
            ItemReference.Reset;
            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
            ItemReference.SetFilter("Reference Type No.", 'CUST00032');
            ItemReference.SetFilter("Item No.", rG_Item."No.");
            if ItemReference.FindSet() then begin

            end;
        end;
    end;

    var
        myInt: Integer;

        rG_Item: Record Item;

        ItemReference: Record "Item Reference";
}
pageextension 50253 SalesBudgetOverviewMatrixExt extends "Sales Budget Overview Matrix"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("Shelf No."; rG_Item."Shelf No.")
            {
                caption = 'Shelf No.';
                ApplicationArea = all;

            }

            field("Package Qty"; rG_Item."Package Qty")
            {
                caption = 'Package Qty';
                ApplicationArea = all;

            }

            field(ItemReference; ItemReference."Reference No.")
            {
                caption = 'Item Reference';
                ApplicationArea = all;
                trigger OnDrillDown()
                begin
                    page.Run(page::"Item Reference Entries", ItemReference);
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
                caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field(Code);


                trigger OnAction()
                begin

                end;
            }

            action("Import Lidl Budget")
            {
                ApplicationArea = All;
                Caption = 'Import Lidl Budget';
                Tooltip = 'Custom: Lidl Budget';
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
        clear(ItemReference);
        if rG_Item.GET(Code) then begin
            ItemReference.RESET;
            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Customer");
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
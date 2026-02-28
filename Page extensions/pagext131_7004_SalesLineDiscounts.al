/*
TAL0.1 2021/10/11 VC add field Item description 
                     add last modified by/date
                     item category dim2   
                     add action to open item card/ production bom
*/
pageextension 50231 SalesLineDiscountsExt extends "Sales Line Discounts"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("Item Description"; "Item Description")
            {
                ApplicationArea = All;
            }
        }

        addafter("Ending Date")
        {
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Last Modified Date"; "Last Modified Date")
            {
                ApplicationArea = All;
            }
            field("Last Modified By"; "Last Modified By")
            {
                ApplicationArea = All;
            }
        }

        modify(Code)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                CurrPage.Update(true);
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(navigation)
        {
            action("Item Card")
            {
                ApplicationArea = All;
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Code");
            }
            action("Production BOM")
            {
                ApplicationArea = All;
                Caption = 'Production BOM';
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Open the item''s production bill of material to view or edit its components.';

                trigger OnAction();
                var
                    rL_Item: Record Item;
                    rL_ProductionBOMHeader: Record "Production BOM Header";
                begin

                    rL_Item.GET("Code");
                    rL_ProductionBOMHeader.GET(rL_Item."Production BOM No.");
                    PAGE.RUN(PAGE::"Production BOM", rL_ProductionBOMHeader);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin


        CALCFIELDS("Item Category Code");
        CALCFIELDS("Global Dimension 2 Code");
    end;

    var
        myInt: Integer;
}
/*
TAL0.1 2021/10/11 VC add field Item description 
                     add last modified by/date
                     item category dim2   
                     add action to open item card/ production bom
*/
pageextension 50230 PurchasePricesExt extends "Purchase Prices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
        }

        addafter("Ending Date")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("Last Modified Date"; Rec."Last Modified Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Modified Date field.';
            }
            field("Last Modified By"; Rec."Last Modified By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Modified By field.';
            }
        }

        modify("Item No.")
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
        addfirst(Navigation)
        {
            action("Item Card")
            {
                ApplicationArea = All;
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                ToolTip = 'Executes the Item Card action.';
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

                    rL_Item.GET(Rec."Item No.");
                    rL_ProductionBOMHeader.Get(rL_Item."Production BOM No.");
                    Page.Run(Page::"Production BOM", rL_ProductionBOMHeader);
                end;
            }

            action(ItemPriceListFFH)
            {
                ApplicationArea = All;
                Caption = 'Purchase Item Price List FFH';
                Image = Price;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Purchase Item Price List Report FFH';

                trigger OnAction();
                var
                    rpt_PurchItemPriceListFFH: Report "Purch. Item Price List FFH";
                    tenum: Enum "Sales Price Source Type";
                    rL_PurchasePrice: Record "Purchase Price";
                begin
                    //rL_SalesPrice.RESET;
                    //rL_SalesPrice.SetRange("Sales Type","Sales Type");
                    //rL_SalesPrice.SetFilter("Sales Code","Sales Code");
                    //if 


                    Clear(rpt_PurchItemPriceListFFH);
                    rpt_PurchItemPriceListFFH.InitializeRequest(WorkDate(), tenum::Customer, '', '');
                    rpt_PurchItemPriceListFFH.Run();

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin


        Rec.CALCFIELDS("Item Category Code");
        Rec.CALCFIELDS("Global Dimension 2 Code");
    end;

    var
        myInt: Integer;
}
/*
TAL0.1 2021/10/11 VC add field Item description 
                     add last modified by/date
                     item category dim2   
                     add action to open item card/ production bom
*/
pageextension 50199 SalesPricesExt extends "Sales Prices"
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
            field("Item Reference"; Rec."Item Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item reference.';

                trigger OnValidate()
                var
                    ItemReference: Record "Item Reference";
                begin
                    if Rec."Item Reference" = '' then exit;
                    ItemReference.SetFilter("Reference Type", '%1|%2', ItemReference."Reference Type"::"Bar Code", ItemReference."Reference Type"::Customer);
                    ItemReference.SetFilter("Reference Type No.", '%1|%2', Rec."Sales Code", '');
                    ItemReference.SetRange("Reference No.", Rec."Item Reference");

                    if ItemReference.Count() = 0 then Error('Item Reference %1 not found', Rec."Item Reference");

                    if ItemReference.Count() = 1 then begin
                        ItemReference.FindFirst();
                        Rec.Validate("Item No.", ItemReference."Item No.");
                    end;

                    if ItemReference.Count() > 1 then begin
                        if Page.RunModal(Page::"Item References", ItemReference) = Action::LookupOK then begin
                            Rec."Item Reference" := ItemReference."Reference No.";
                            Rec.Validate("Item No.", ItemReference."Item No.");
                        end
                        else
                            Rec."Item Reference" := '';
                        // Error('Please choose an Item Reference');
                    end;
                end;
            }
        }

        addafter("VAT Bus. Posting Gr. (Price)")
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
                ItemReference: Record "Item Reference";
            begin
                // ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
                // ItemReference.SetRange("Item No.", Rec."Item No.");
                ItemReference.SetFilter("Reference Type", '%1|%2', ItemReference."Reference Type"::"Bar Code", ItemReference."Reference Type"::Customer);
                ItemReference.SetFilter("Reference Type No.", '%1|%2', Rec."Sales Code", '');
                ItemReference.SetRange("Item No.", Rec."Item No.");


                if ItemReference.Count() = 1 then begin
                    if ItemReference.FindFirst() then
                        Rec."Item Reference" := ItemReference."Reference No.";
                end;

                if ItemReference.Count() > 1 then begin
                    if Page.RunModal(Page::"Item References", ItemReference) = Action::LookupOK then
                        Rec."Item Reference" := ItemReference."Reference No."
                    else
                        // Rec."Item Reference" := '';
                        Error('Please choose an Item Reference');
                end;

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

            action(ItemPriceList)
            {
                ApplicationArea = All;
                Caption = 'Item Price List';
                Image = Price;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Item Price List Report';

                trigger OnAction();
                var
                    rpt_ItemPriceList: Report "Item Price List";
                    tenum: Enum "Sales Price Source Type";
                begin
                    Clear(rpt_ItemPriceList);
                    rpt_ItemPriceList.InitializeRequest(WorkDate(), tenum::Customer, '', '');
                    rpt_ItemPriceList.Run();

                end;
            }

            action(ItemPriceListFFH)
            {
                ApplicationArea = All;
                Caption = 'Sales Item Price List FFH';
                Image = Price;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Sales Item Price List Report FFH';

                trigger OnAction();
                var
                    rpt_SalesItemPriceListFFH: Report "Sales Item Price List FFH";
                    tenum: Enum "Sales Price Source Type";
                    rL_SalesPrice: Record "Sales Price";
                begin
                    //rL_SalesPrice.RESET;
                    //rL_SalesPrice.SetRange("Sales Type","Sales Type");
                    //rL_SalesPrice.SetFilter("Sales Code","Sales Code");
                    //if 


                    Clear(rpt_SalesItemPriceListFFH);
                    rpt_SalesItemPriceListFFH.InitializeRequest(WorkDate(), tenum::Customer, '', '');
                    rpt_SalesItemPriceListFFH.Run();

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
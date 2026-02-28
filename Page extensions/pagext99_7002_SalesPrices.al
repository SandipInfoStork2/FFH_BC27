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
            field("Item Description"; "Item Description")
            {
                ApplicationArea = All;
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
                    ItemReference.SetFilter("Reference Type No.", '%1|%2', "Sales Code", '');
                    ItemReference.SetRange("Reference No.", Rec."Item Reference");

                    if ItemReference.Count() = 0 then Error('Item Reference %1 not found', Rec."Item Reference");

                    if ItemReference.Count() = 1 then begin
                        ItemReference.FindFirst();
                        Rec.Validate("Item No.", ItemReference."Item No.");
                    end;

                    if ItemReference.Count() > 1 then begin
                        if PAGE.RunModal(PAGE::"Item References", ItemReference) = ACTION::LookupOK then begin
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
                ItemReference.SetFilter("Reference Type No.", '%1|%2', "Sales Code", '');
                ItemReference.SetRange("Item No.", Rec."Item No.");


                if ItemReference.Count() = 1 then begin
                    if ItemReference.FindFirst() then
                        Rec."Item Reference" := ItemReference."Reference No.";
                end;

                if ItemReference.Count() > 1 then begin
                    if PAGE.RunModal(PAGE::"Item References", ItemReference) = ACTION::LookupOK then
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
                RunPageLink = "No." = FIELD("Item No.");
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

                    rL_Item.GET("Item No.");
                    rL_ProductionBOMHeader.GET(rL_Item."Production BOM No.");
                    PAGE.RUN(PAGE::"Production BOM", rL_ProductionBOMHeader);
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


        CALCFIELDS("Item Category Code");
        CALCFIELDS("Global Dimension 2 Code");
    end;

    var
        myInt: Integer;
}
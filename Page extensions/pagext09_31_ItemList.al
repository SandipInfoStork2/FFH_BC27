/*
TAL0.3 2018/06/10 VC add fields
        Package Qty
        Category 1
        Packing Group Description

TAL0.4 2019/05/03 VC add Max Unit Cost Field 
TAL0.5 2020/03/04 VC Chain of Custody Fields
TAL0.6 2021/03/16 VC delete Chain of Custody Fields and add to General Categories
TAL0.7 2021/09/28 VC add action Item Analysis to show where used movement 
TAL0.8 2021/10/25 VC Item Analysis add Set Ascending when showing Production BOM RFV-00045 to appear first

*/
pageextension 50109 ItemListExt extends "Item List"
{
    layout
    {
        // Add changes to page layout here
        modify("Shelf No.")
        {
            Visible = true;
        }

        addafter(Description)
        {
            /* field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            } */
            field("Extended Description"; Rec."Extended Description")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Extended Description field.';
            }
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';
            }
            field("Category 1"; Rec."Category 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group field.';
            }
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }

            //+1.0.0.232
            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Agent field.';
            }
            //-1.0.0.232
            field("Rounding Precision"; Rec."Rounding Precision")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how calculated consumption quantities are rounded when entered on consumption journal lines.';
            }
        }

        moveafter("Packing Group Description"; "Shelf No.")


        addafter("Unit Cost")
        {
            field("Max Unit Cost"; Rec."Max Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Max Unit Cost field.';
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the net weight of the item.';
            }
            field("Lot Nos."; Rec."Lot Nos.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the number series code that will be used when assigning lot numbers.';
            }
        }

        addafter("Net Weight")
        {
            field("Closed Storage Life"; Rec."Closed Storage Life")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Closed Storage Life field.';
            }
            field("Fridge Storage Life"; Rec."Fridge Storage Life")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fridge Storage Life field.';
            }
            field("Freezer Storage Life"; Rec."Freezer Storage Life")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Freezer Storage Life field.';

            }

            field("Category 10"; Rec."Category 10")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 10';
                CaptionClass = '3,' + vG_Cat10Caption;
                Visible = vG_Cat10CaptionVisible;
            }

            field("Category 11"; Rec."Category 11")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 11';
                CaptionClass = '3,' + vG_Cat11Caption;
                Visible = vG_Cat11CaptionVisible;
            }
            field("Category 12"; Rec."Category 12")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 12';
                CaptionClass = '3,' + vG_Cat12Caption;
                Visible = vG_Cat12CaptionVisible;
            }
            field("Category 13"; Rec."Category 13")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 13';
                CaptionClass = '3,' + vG_Cat13Caption;
                Visible = vG_Cat13CaptionVisible;
            }
            field("Category 14"; Rec."Category 14")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 14';
                CaptionClass = '3,' + vG_Cat14Caption;
                Visible = vG_Cat14CaptionVisible;
            }
            field("Category 15"; Rec."Category 15")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 15';
                CaptionClass = '3,' + vG_Cat15Caption;
                Visible = vG_Cat15CaptionVisible;
            }
            field("Category 16"; Rec."Category 16")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 16';
                CaptionClass = '3,' + vG_Cat16Caption;
                Visible = vG_Cat16CaptionVisible;
            }
            field("Category 17"; Rec."Category 17")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 17';
                CaptionClass = '3,' + vG_Cat17Caption;
                Visible = vG_Cat17CaptionVisible;
            }
            field("Category 18"; Rec."Category 18")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 18';
                CaptionClass = '3,' + vG_Cat18Caption;
                Visible = vG_Cat18CaptionVisible;
            }
            field("Category 19"; Rec."Category 19")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 19';
                CaptionClass = '3,' + vG_Cat19Caption;
                Visible = vG_Cat19CaptionVisible;
            }
            field("Category 20"; Rec."Category 20")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Category 20';
                CaptionClass = '3,' + vG_Cat20Caption;
                Visible = vG_Cat20CaptionVisible;
            }
        }

        addafter("Shelf No.")
        {
            field(ItemReferenceNo; ItemReference."Reference No.")
            {
                Caption = 'Customer Reference No.';
                ApplicationArea = All;
                ToolTip = 'Custom: Lookup value from Item Refefence.';
            }

            field(ItemReferenceNoUOM; ItemReferenceUOM."Reference No.")
            {
                Caption = 'Customer Reference No. Same UOM';
                ApplicationArea = All;
                ToolTip = 'Custom: Lookup value from Item Refefence.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Item Tracing")
        {
            action("Item Analysis")
            {
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Item Analysis action.';
                ApplicationArea = All;

                trigger OnAction();
                var
                    rL_Item: Record Item;
                    pItemAnalysis: Page "Item Analysis";
                    WhereUsedMgt: Codeunit "Where-Used Management";
                    rL_BOMLoop: Record "Integer" temporary;
                    CalculateDate: Date;
                    BomFound: Boolean;
                    First: Boolean;
                    WhereUsedList: Record "Where-Used Line";
                    vL_FindRecord: Boolean;
                    vL_NextRecord: Integer;
                    vL_Filter: Text;
                    ProdBOM: Record "Production BOM Header";
                    rL_ProductionBOMLine: Record "Production BOM Line";
                begin
                    //+TAL0.7
                    rL_Item.Reset;
                    rL_Item.SETFILTER("No.", Rec."No.");
                    if rL_Item.FindSet then;

                    CalculateDate := WorkDate;

                    if rL_Item."Production BOM No." <> '' then begin

                        ProdBOM.Reset;
                        ProdBOM.SetFilter("No.", rL_Item."Production BOM No.");
                        if ProdBOM.FindSet then;

                        //WhereUsedMgt.WhereUsedFromProdBOM(ProdBOM,CalculateDate,TRUE)
                    end else begin
                        WhereUsedMgt.WhereUsedFromItem(rL_Item, CalculateDate, true);
                    end;




                    //loop the results
                    Clear(rL_BOMLoop);
                    rL_BOMLoop.SetCurrentKey(Number);

                    First := true;
                    BomFound := true;
                    vL_Filter := rL_Item."No."; //filter includes the

                    while BomFound do begin
                        if First then begin
                            vL_FindRecord := WhereUsedMgt.FindRecord('-', WhereUsedList);

                            if vL_FindRecord then begin
                                //MESSAGE(WhereUsedList."Item No.");
                            end;

                            if not vL_FindRecord then begin
                                BomFound := false;
                            end;

                            First := false;
                        end else begin
                            vL_NextRecord := WhereUsedMgt.NextRecord(1, WhereUsedList);
                            if vL_NextRecord <> 0 then begin
                                //MESSAGE(WhereUsedList."Item No.");
                            end;
                            if vL_NextRecord = 0 then begin
                                BomFound := false;
                            end;

                        end;


                        if WhereUsedList."Item No." <> '' then begin
                            if vL_Filter = '' then
                                vL_Filter := WhereUsedList."Item No."
                            else
                                vL_Filter += '|' + WhereUsedList."Item No.";
                        end;

                    end;

                    if rL_Item."Production BOM No." <> '' then begin
                        rL_ProductionBOMLine.Reset;
                        rL_ProductionBOMLine.SetFilter("Production BOM No.", rL_Item."Production BOM No.");
                        rL_ProductionBOMLine.SetRange(Type, rL_ProductionBOMLine.Type::Item);
                        if rL_ProductionBOMLine.FindSet then begin
                            repeat
                                vL_Filter += '|' + rL_ProductionBOMLine."No.";
                            until rL_ProductionBOMLine.Next = 0;
                        end;
                    end;





                    //search again with new filter
                    rL_Item.Reset;
                    rL_Item.SetFilter("No.", vL_Filter);
                    if rL_Item.FindSet then;
                    Clear(pItemAnalysis);
                    pItemAnalysis.SetTableView(rL_Item);
                    pItemAnalysis.SetAscending(); //TAL0.8
                    pItemAnalysis.Run();
                    //Page Item Analysis
                    //-TAL0.7
                end;
            }

            action("Boxes Statement By Location")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;
                PromotedOnly = true;
                Caption = 'Boxes Statement By Location';
                RunObject = report "Boxes Statement By Location";
                ToolTip = 'Executes the Boxes Statement By Location action.';
            }



        }

        addafter("Item Expiration - Quantity")
        {
            action("LOT Per Item")
            {
                ApplicationArea = All;
                Image = Report;
                ToolTip = 'Executes the LOT Per Item action.';
                //Promoted = true;
                //PromotedCategory = "Report";
                //PromotedIsBig = false;
                //PromotedOnly = true;

                trigger OnAction();
                var
                    rpt_LOTPerItem: Report "LOT Per Item";
                    rL_Item: Record Item;
                begin
                    rL_Item.Reset;
                    rL_Item.SetFilter("No.", Rec."No.");
                    if rL_Item.FindSet() then;

                    Clear(rpt_LOTPerItem);

                    rpt_LOTPerItem.SetTableView(rL_Item);
                    rpt_LOTPerItem.Run;
                end;
            }
        }
    }

    procedure SelectActiveItemsForSalePFV(): Text
    var
        Item: Record Item;
    begin
        Item.SetRange("Sales Blocked", false);
        Item.SetFilter("No.", 'PFV*');
        exit(SelectInItemList(Item));
    end;

    trigger OnOpenPage()
    var
        InvSetup: Record "Inventory Setup";
    begin
        InvSetup.Get;
        vG_Cat10Caption := InvSetup."Item Cat. 10 Caption";
        vG_Cat11Caption := InvSetup."Item Cat. 11 Caption";
        vG_Cat12Caption := InvSetup."Item Cat. 12 Caption";
        vG_Cat13Caption := InvSetup."Item Cat. 13 Caption";
        vG_Cat14Caption := InvSetup."Item Cat. 14 Caption";
        vG_Cat15Caption := InvSetup."Item Cat. 15 Caption";
        vG_Cat16Caption := InvSetup."Item Cat. 16 Caption";
        vG_Cat17Caption := InvSetup."Item Cat. 17 Caption";
        vG_Cat18Caption := InvSetup."Item Cat. 18 Caption";
        vG_Cat19Caption := InvSetup."Item Cat. 19 Caption";
        vG_Cat20Caption := InvSetup."Item Cat. 20 Caption";

        vG_Cat10CaptionVisible := InvSetup."Item Cat. 10 Caption" <> '';
        vG_Cat11CaptionVisible := InvSetup."Item Cat. 11 Caption" <> '';
        vG_Cat12CaptionVisible := InvSetup."Item Cat. 12 Caption" <> '';
        vG_Cat13CaptionVisible := InvSetup."Item Cat. 13 Caption" <> '';
        vG_Cat14CaptionVisible := InvSetup."Item Cat. 14 Caption" <> '';
        vG_Cat15CaptionVisible := InvSetup."Item Cat. 15 Caption" <> '';
        vG_Cat16CaptionVisible := InvSetup."Item Cat. 16 Caption" <> '';
        vG_Cat17CaptionVisible := InvSetup."Item Cat. 17 Caption" <> '';
        vG_Cat18CaptionVisible := InvSetup."Item Cat. 18 Caption" <> '';
        vG_Cat19CaptionVisible := InvSetup."Item Cat. 19 Caption" <> '';
        vG_Cat20CaptionVisible := InvSetup."Item Cat. 20 Caption" <> '';
    end;


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Clear(ItemReference);
        ItemReference.Reset();
        ItemReference.SetFilter("Item No.", Rec."No.");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
        if ItemReference.FindSet() then;

        Clear(ItemReferenceUOM);
        ItemReferenceUOM.Reset();
        ItemReferenceUOM.SetFilter("Item No.", Rec."No.");
        ItemReferenceUOM.SetRange("Reference Type", ItemReferenceUOM."Reference Type"::Customer);
        ItemReferenceUOM.SetFilter("Unit of Measure", Rec."Sales Unit of Measure");
        if ItemReferenceUOM.FindSet() then;
    end;

    var
        vG_Cat10Caption: Text;
        vG_Cat11Caption: Text;
        vG_Cat12Caption: Text;
        vG_Cat13Caption: Text;
        vG_Cat14Caption: Text;
        vG_Cat15Caption: Text;
        vG_Cat16Caption: Text;
        vG_Cat17Caption: Text;
        vG_Cat18Caption: Text;
        vG_Cat19Caption: Text;
        vG_Cat20Caption: Text;

        vG_Cat10CaptionVisible: Boolean;
        vG_Cat11CaptionVisible: Boolean;
        vG_Cat12CaptionVisible: Boolean;
        vG_Cat13CaptionVisible: Boolean;
        vG_Cat14CaptionVisible: Boolean;
        vG_Cat15CaptionVisible: Boolean;
        vG_Cat16CaptionVisible: Boolean;
        vG_Cat17CaptionVisible: Boolean;
        vG_Cat18CaptionVisible: Boolean;
        vG_Cat19CaptionVisible: Boolean;
        vG_Cat20CaptionVisible: Boolean;

        ItemReference: Record "Item Reference";
        ItemReferenceUOM: Record "Item Reference";
}
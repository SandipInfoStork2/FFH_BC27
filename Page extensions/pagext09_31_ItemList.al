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
            field("Extended Description"; "Extended Description")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = All;
            }
            field("Category 1"; "Category 1")
            {
                ApplicationArea = All;
            }
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = All;
            }

            //+1.0.0.232
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
            }
            //-1.0.0.232
            field("Rounding Precision"; "Rounding Precision")
            {
                ApplicationArea = All;
            }
        }

        moveafter("Packing Group Description"; "Shelf No.")


        addafter("Unit Cost")
        {
            field("Max Unit Cost"; "Max Unit Cost")
            {
                ApplicationArea = All;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Net Weight"; "Net Weight")
            {
                ApplicationArea = All;
            }
            field("Lot Nos."; "Lot Nos.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }

        addafter("Net Weight")
        {
            field("Closed Storage Life"; "Closed Storage Life")
            {
                ApplicationArea = All;
            }
            field("Fridge Storage Life"; "Fridge Storage Life")
            {
                ApplicationArea = All;
            }
            field("Freezer Storage Life"; "Freezer Storage Life")
            {
                ApplicationArea = All;

            }

            field("Category 10"; Rec."Category 10")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 10';
                CaptionClass = '3,' + vG_Cat10Caption;
                Visible = vG_Cat10CaptionVisible;
            }

            field("Category 11"; Rec."Category 11")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 11';
                CaptionClass = '3,' + vG_Cat11Caption;
                Visible = vG_Cat11CaptionVisible;
            }
            field("Category 12"; Rec."Category 12")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 12';
                CaptionClass = '3,' + vG_Cat12Caption;
                Visible = vG_Cat12CaptionVisible;
            }
            field("Category 13"; Rec."Category 13")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 13';
                CaptionClass = '3,' + vG_Cat13Caption;
                Visible = vG_Cat13CaptionVisible;
            }
            field("Category 14"; Rec."Category 14")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 14';
                CaptionClass = '3,' + vG_Cat14Caption;
                Visible = vG_Cat14CaptionVisible;
            }
            field("Category 15"; Rec."Category 15")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 15';
                CaptionClass = '3,' + vG_Cat15Caption;
                Visible = vG_Cat15CaptionVisible;
            }
            field("Category 16"; Rec."Category 16")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 16';
                CaptionClass = '3,' + vG_Cat16Caption;
                Visible = vG_Cat16CaptionVisible;
            }
            field("Category 17"; Rec."Category 17")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 17';
                CaptionClass = '3,' + vG_Cat17Caption;
                Visible = vG_Cat17CaptionVisible;
            }
            field("Category 18"; Rec."Category 18")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 18';
                CaptionClass = '3,' + vG_Cat18Caption;
                Visible = vG_Cat18CaptionVisible;
            }
            field("Category 19"; Rec."Category 19")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 19';
                CaptionClass = '3,' + vG_Cat19Caption;
                Visible = vG_Cat19CaptionVisible;
            }
            field("Category 20"; Rec."Category 20")
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Category 20';
                CaptionClass = '3,' + vG_Cat20Caption;
                Visible = vG_Cat20CaptionVisible;
            }
        }

        addafter("Shelf No.")
        {
            field(ItemReferenceNo; ItemReference."Reference No.")
            {
                caption = 'Customer Reference No.';
                ApplicationArea = All;
                Tooltip = 'Custom: Lookup value from Item Refefence.';
            }

            field(ItemReferenceNoUOM; ItemReferenceUOM."Reference No.")
            {
                caption = 'Customer Reference No. Same UOM';
                ApplicationArea = All;
                Tooltip = 'Custom: Lookup value from Item Refefence.';
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
                    rL_Item.RESET;
                    rL_Item.SETFILTER("No.", "No.");
                    if rL_Item.FINDSET then;

                    CalculateDate := WORKDATE;

                    if rL_Item."Production BOM No." <> '' then begin

                        ProdBOM.RESET;
                        ProdBOM.SETFILTER("No.", rL_Item."Production BOM No.");
                        if ProdBOM.FINDSET then;

                        //WhereUsedMgt.WhereUsedFromProdBOM(ProdBOM,CalculateDate,TRUE)
                    end else begin
                        WhereUsedMgt.WhereUsedFromItem(rL_Item, CalculateDate, true);
                    end;




                    //loop the results
                    CLEAR(rL_BOMLoop);
                    rL_BOMLoop.SETCURRENTKEY(Number);

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
                        rL_ProductionBOMLine.RESET;
                        rL_ProductionBOMLine.SETFILTER("Production BOM No.", rL_Item."Production BOM No.");
                        rL_ProductionBOMLine.SETRANGE(Type, rL_ProductionBOMLine.Type::Item);
                        if rL_ProductionBOMLine.FINDSET then begin
                            repeat
                                vL_Filter += '|' + rL_ProductionBOMLine."No.";
                            until rL_ProductionBOMLine.NEXT = 0;
                        end;
                    end;





                    //search again with new filter
                    rL_Item.RESET;
                    rL_Item.SETFILTER("No.", vL_Filter);
                    if rL_Item.FINDSET then;
                    CLEAR(pItemAnalysis);
                    pItemAnalysis.SETTABLEVIEW(rL_Item);
                    pItemAnalysis.SetAscending(); //TAL0.8
                    pItemAnalysis.RUN();
                    //Page Item Analysis
                    //-TAL0.7
                end;
            }

            action("Boxes Statement By Location")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;
                PromotedOnly = true;
                Caption = 'Boxes Statement By Location';
                RunObject = report "Boxes Statement By Location";
            }



        }

        addafter("Item Expiration - Quantity")
        {
            action("LOT Per Item")
            {
                ApplicationArea = all;
                Image = Report;
                //Promoted = true;
                //PromotedCategory = "Report";
                //PromotedIsBig = false;
                //PromotedOnly = true;

                trigger OnAction();
                var
                    rpt_LOTPerItem: Report "LOT Per Item";
                    rL_Item: Record "Item";
                begin
                    rL_Item.RESET;
                    rL_Item.SetFilter("No.", "No.");
                    if rL_Item.FindSet() then;

                    CLEAR(rpt_LOTPerItem);

                    rpt_LOTPerItem.SETTABLEVIEW(rL_Item);
                    rpt_LOTPerItem.RUN;
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
        InvSetup.GET;
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
        clear(ItemReference);
        ItemReference.Reset();
        ItemReference.SetFilter("Item No.", Rec."No.");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
        if ItemReference.FindSet() then;

        clear(ItemReferenceUOM);
        ItemReferenceUOM.Reset();
        ItemReferenceUOM.SetFilter("Item No.", Rec."No.");
        ItemReferenceUOM.SetRange("Reference Type", ItemReferenceUOM."Reference Type"::Customer);
        ItemReferenceUOM.SetFilter("Unit of Measure", rec."Sales Unit of Measure");
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
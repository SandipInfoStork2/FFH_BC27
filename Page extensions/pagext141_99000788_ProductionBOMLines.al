pageextension 50241 ProductionBOMLinesExt extends "Production BOM Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Variant Code")
        {
            Visible = true;
        }
        //TAL 1.0.0.71 >>
        /*
        addafter(Description)
        {
            field("Variant Code68455"; Rec."Variant Code")
            {
                ApplicationArea = All;
            }
        }
        */
        //TAL 1.0.0.71 <<

        addafter("Routing Link Code")
        {
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = all;
            }

            field("Last Direct Cost"; "Last Direct Cost")
            {
                ApplicationArea = all;
            }

            field(LastDirectCostPerKG; vG_LastDirectCostPerKG)
            {
                ApplicationArea = all;
                Editable = false;
                caption = 'Last Direct Cost per KG';
                ToolTip = 'Custom: Last Direct Cost per KG';
                DecimalPlaces = 2 : 5;
                trigger OnDrillDown()
                begin
                    //DrillDownLandedCost();
                end;
            }

            field(LandedUnitCost; vG_LandedUnitCost)
            {
                ApplicationArea = all;
                Editable = false;
                caption = 'Last Landed Unit Cost';
                ToolTip = 'Custom: Last Landed Unit Cost = Item Ldger Entry Last Purchase Receipt SUM("Cost Amount (Actual)" + "Cost Amount (Expected)")/Quantity';
                DecimalPlaces = 2 : 5;
                Visible = false;
                trigger OnDrillDown()
                begin
                    DrillDownLandedCost();
                end;
            }



            field("Unit Cost"; "Unit Cost")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field(SystemCreatedAt; SystemCreatedAt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Created At';
            }

            field(SystemCreatedBy; rG_User1."User Name")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Created By';
            }

            field(SystemModifiedAt; SystemModifiedAt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Modified At';
            }

            field(SystemModifiedBy; rG_User2."User Name")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Modified By';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("Where-Used")
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        rL_Item: Record Item;
        rL_ItemMaster: Record Item;
        vL_LastDirectCost: Decimal;
        ItemCategory: Record "Item Category";
        CostOtherFixed: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
    begin
        vG_LandedUnitCost := 0;
        vG_LastDirectCostPerKG := 0;
        vL_LastDirectCost := 0;

        if (Type = Type::Item) and ("No." <> '') then begin
            if rL_Item.GET("No.") then begin
                vL_LastDirectCost := rL_Item."Last Direct Cost"; //rL_Item.GetLandedCost();
                vG_LandedUnitCost := rL_Item.GetLandedCost();
                rL_ItemMaster.RESET;
                rL_ItemMaster.SetFilter("Production BOM No.", "Production BOM No.");
                if rL_ItemMaster.FindSet() then begin

                    SRSetup.Get;
                    CostOtherFixed := 0;
                    ItemCategory.RESET;
                    ItemCategory.SetFilter(Code, SRSetup."FILM Category Filter");
                    if ItemCategory.FindSet() then begin
                        repeat
                            if "Item Category Code" = ItemCategory.Code then begin
                                CostOtherFixed := SRSetup."FILM Cost";
                            end;
                        until ItemCategory.Next() = 0;
                    end;

                    if CostOtherFixed <> 0 then begin
                        vG_LastDirectCostPerKG := CostOtherFixed;
                    end else begin
                        //+1.0.0.197
                        if rL_ItemMaster."Package Qty" <> 0 then begin
                            vG_LastDirectCostPerKG := Round((vL_LastDirectCost / rL_ItemMaster."Package Qty") * "Quantity per", 0.01, '>');
                        end;
                        //-1.0.0.197

                    end;


                end;


            end;

        end;

        clear(rG_User1);
        if rG_User1.Get(Rec.SystemCreatedBy) then;

        clear(rG_User2);
        if rG_User2.Get(Rec.SystemModifiedBy) then;


    end;



    var
        vG_LandedUnitCost: Decimal;
        vG_LastDirectCostPerKG: Decimal;
        rG_User1: Record User;

        rG_User2: Record User;
}
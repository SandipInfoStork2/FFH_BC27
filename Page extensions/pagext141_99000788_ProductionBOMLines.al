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
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
            }

            field("Last Direct Cost"; Rec."Last Direct Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Direct Cost field.';
            }

            field(LastDirectCostPerKG; vG_LastDirectCostPerKG)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Last Direct Cost per KG';
                ToolTip = 'Custom: Last Direct Cost per KG';
                DecimalPlaces = 2 : 5;
                trigger OnDrillDown()
                begin
                    //DrillDownLandedCost();
                end;
            }

            field(LandedUnitCost; vG_LandedUnitCost)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Last Landed Unit Cost';
                ToolTip = 'Custom: Last Landed Unit Cost = Item Ldger Entry Last Purchase Receipt SUM("Cost Amount (Actual)" + "Cost Amount (Expected)")/Quantity';
                DecimalPlaces = 2 : 5;
                Visible = false;
                trigger OnDrillDown()
                begin
                    Rec.DrillDownLandedCost();
                end;
            }



            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Unit Cost field.';
            }

            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Created At';
                ToolTip = 'Specifies the value of the System Created At field.';
            }

            field(SystemCreatedBy; rG_User1."User Name")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Created By';
                ToolTip = 'Specifies the value of the System Created By field.';
            }

            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Modified At';
                ToolTip = 'Specifies the value of the System Modified At field.';
            }

            field(SystemModifiedBy; rG_User2."User Name")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'System Modified By';
                ToolTip = 'Specifies the value of the System Modified By field.';
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
                Caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Executes the Item Card action.';

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

        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            if rL_Item.GET(Rec."No.") then begin
                vL_LastDirectCost := rL_Item."Last Direct Cost"; //rL_Item.GetLandedCost();
                vG_LandedUnitCost := rL_Item.GetLandedCost();
                rL_ItemMaster.Reset;
                rL_ItemMaster.SetFilter("Production BOM No.", Rec."Production BOM No.");
                if rL_ItemMaster.FindSet() then begin

                    SRSetup.Get;
                    CostOtherFixed := 0;
                    ItemCategory.Reset;
                    ItemCategory.SetFilter(Code, SRSetup."FILM Category Filter");
                    if ItemCategory.FindSet() then begin
                        repeat
                            if Rec."Item Category Code" = ItemCategory.Code then begin
                                CostOtherFixed := SRSetup."FILM Cost";
                            end;
                        until ItemCategory.Next() = 0;
                    end;

                    if CostOtherFixed <> 0 then begin
                        vG_LastDirectCostPerKG := CostOtherFixed;
                    end else begin
                        //+1.0.0.197
                        if rL_ItemMaster."Package Qty" <> 0 then begin
                            vG_LastDirectCostPerKG := Round((vL_LastDirectCost / rL_ItemMaster."Package Qty") * Rec."Quantity per", 0.01, '>');
                        end;
                        //-1.0.0.197

                    end;


                end;


            end;

        end;

        Clear(rG_User1);
        if rG_User1.Get(Rec.SystemCreatedBy) then;

        Clear(rG_User2);
        if rG_User2.Get(Rec.SystemModifiedBy) then;


    end;



    var
        vG_LandedUnitCost: Decimal;
        vG_LastDirectCostPerKG: Decimal;
        rG_User1: Record User;

        rG_User2: Record User;
}
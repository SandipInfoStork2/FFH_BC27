/*
TAL0.3 2018/06/10 VC add fields
        Package Qty
        Category 1
        Packing Group Description

TAL0.4 2019/05/03 VC add Max Unit Cost Field 
TAL0.5 2020/03/03 VC add Ship-to Fields 
TAL0.6 2020/03/04 VC Chain of Custody Fields
TAL0.7 2021/03/16 VC delete Chain of Custody Fields and add to General Categories

*/
pageextension 50108 ItemCardExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Description 2 (GR)',
                                ENU = 'Description 2 (GR)';
            }
            field("Extended Description"; "Extended Description")
            {
                ApplicationArea = All;
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
        }

        addafter("Unit Cost")
        {
            field("Max Unit Cost"; "Max Unit Cost")
            {
                ApplicationArea = All;
            }

        }

        addafter("Cost is Posted to G/L")
        {
            //+1.0.0.289
            field("TAL Exclude Item from Adjustme"; "TAL Exclude Item from Adjustme")
            {
                ApplicationArea = All;
            }
            //-1.0.0.289
        }

        addafter(Inventory)
        {
            field("No. of Sales Quotes"; "No. of Sales Quotes")
            {
                ApplicationArea = All;
                DrillDownPageId = "Sales Quote Lidl Lines";
            }
        }
        addafter("Purchasing Code")
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("Expiration Calculation")
        {
            group("Storage Life")
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
            }

        }

        addafter("Last Direct Cost")
        {
            field(LandedUnitCost; vG_LandedUnitCost)
            {
                ApplicationArea = all;
                Editable = false;
                caption = 'Last Landed Unit Cost';
                ToolTip = 'Custom: Last Landed Unit Cost = Item Ldger Entry Last Purchase Receipt SUM("Cost Amount (Actual)" + "Cost Amount (Expected)")/Quantity';
                trigger OnDrillDown()
                begin
                    DrillDownLandedCost();
                end;
            }
        }

        addafter(VariantMandatoryDefaultNo)
        {
            field("Allow Modulus"; "Allow Modulus")
            {
                ApplicationArea = all;
            }
        }


        addafter("Item Category Code")
        {
            field("Category 8"; "Category 8")
            {
                ApplicationArea = all;
                ToolTip = 'Κατηγορία';
            }
            field("Category 9"; "Category 9")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        addafter(Warehouse)
        {
            group(Categories)
            {
                field("Category 10"; rec."Category 10")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 10';
                    CaptionClass = '3,' + vG_Cat10Caption;
                }
                field("Category 11"; rec."Category 11")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 11';
                    CaptionClass = '3,' + vG_Cat11Caption;
                }
                field("Category 12"; rec."Category 12")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 12';
                    CaptionClass = '3,' + vG_Cat12Caption;
                }
                field("Category 13"; rec."Category 13")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 13';
                    CaptionClass = '3,' + vG_Cat13Caption;
                }
                field("Category 14"; rec."Category 14")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 14';
                    CaptionClass = '3,' + vG_Cat14Caption;
                }
                field("Category 15"; rec."Category 15")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 15';
                    CaptionClass = '3,' + vG_Cat15Caption;
                }
                field("Category 16"; rec."Category 16")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 16';
                    CaptionClass = '3,' + vG_Cat16Caption;
                }
                field("Category 17"; rec."Category 17")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 17';
                    CaptionClass = '3,' + vG_Cat17Caption;
                }
                field("Category 18"; rec."Category 18")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 18';
                    CaptionClass = '3,' + vG_Cat18Caption;
                }
                field("Category 19"; rec."Category 19")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 19';
                    CaptionClass = '3,' + vG_Cat19Caption;
                }
                field("Category 20"; rec."Category 20")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Category 20';
                    CaptionClass = '3,' + vG_Cat20Caption;
                }

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

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
    end;

    trigger OnAfterGetRecord()
    var
        rL_GeneralCategories: Record "General Categories";
    begin
        //+TAL0.5
        vG_Pack := '';
        if "Package Qty" <> 0 then begin
            vG_Pack := FORMAT("Package Qty") + ' ' + cu_GeneralMgt.Capitalise(FORMAT("Sales Unit of Measure"));
        end;

        vG_Caliber := '';
        if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, "Category 6") then begin
            vG_Caliber := "Category 4" + '-' + "Category 5" + ' ' + rL_GeneralCategories.Description;
        end;
        //CALCFIELDS("Ship-to Product Name");
        //-TAL0.5

        vG_LandedUnitCost := GetLandedCost();
    end;

    var
        vG_Pack: Text;
        cu_GeneralMgt: Codeunit "General Mgt.";
        vG_Caliber: Text;

        vG_LandedUnitCost: Decimal;

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
}
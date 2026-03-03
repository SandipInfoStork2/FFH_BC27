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
            /* field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Description 2 (GR)',
                                ENU = 'Description 2 (GR)';
            } */
            field("Extended Description"; Rec."Extended Description")
            {
                ApplicationArea = All;
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
        }

        addafter("Unit Cost")
        {
            field("Max Unit Cost"; Rec."Max Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Max Unit Cost field.';
            }

        }

        addafter("Cost is Posted to G/L")
        {
            //+1.0.0.289
            field("TAL Exclude Item from Adjustme"; Rec."TAL Exclude Item from Adjustme")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exclude Item from Adjustmet field.';
            }
            //-1.0.0.289
        }

        addafter(Inventory)
        {
            field("No. of Sales Quotes"; Rec."No. of Sales Quotes")
            {
                ApplicationArea = All;
                DrillDownPageId = "Sales Quote Lidl Lines";
                ToolTip = 'Specifies the value of the No. of Sales Quotes field.';
            }
        }
        addafter("Purchasing Code")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Code field.';
            }
        }

        addafter("Expiration Calculation")
        {
            group("Storage Life")
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
            }

        }

        addafter("Last Direct Cost")
        {
            field(LandedUnitCost; vG_LandedUnitCost)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Last Landed Unit Cost';
                ToolTip = 'Custom: Last Landed Unit Cost = Item Ldger Entry Last Purchase Receipt SUM("Cost Amount (Actual)" + "Cost Amount (Expected)")/Quantity';
                trigger OnDrillDown()
                begin
                    Rec.DrillDownLandedCost();
                end;
            }
        }

        addafter(VariantMandatoryDefaultNo)
        {
            field("Allow Modulus"; Rec."Allow Modulus")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Modulus field.';
            }
        }


        addafter("Item Category Code")
        {
            field("Category 8"; Rec."Category 8")
            {
                ApplicationArea = All;
                ToolTip = 'Κατηγορία';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Potatoes District Region field.';
            }
        }

        addafter(Warehouse)
        {
            group(Categories)
            {
                field("Category 10"; Rec."Category 10")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 10';
                    CaptionClass = '3,' + vG_Cat10Caption;
                }
                field("Category 11"; Rec."Category 11")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 11';
                    CaptionClass = '3,' + vG_Cat11Caption;
                }
                field("Category 12"; Rec."Category 12")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 12';
                    CaptionClass = '3,' + vG_Cat12Caption;
                }
                field("Category 13"; Rec."Category 13")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 13';
                    CaptionClass = '3,' + vG_Cat13Caption;
                }
                field("Category 14"; Rec."Category 14")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 14';
                    CaptionClass = '3,' + vG_Cat14Caption;
                }
                field("Category 15"; Rec."Category 15")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 15';
                    CaptionClass = '3,' + vG_Cat15Caption;
                }
                field("Category 16"; Rec."Category 16")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 16';
                    CaptionClass = '3,' + vG_Cat16Caption;
                }
                field("Category 17"; Rec."Category 17")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 17';
                    CaptionClass = '3,' + vG_Cat17Caption;
                }
                field("Category 18"; Rec."Category 18")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 18';
                    CaptionClass = '3,' + vG_Cat18Caption;
                }
                field("Category 19"; Rec."Category 19")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 19';
                    CaptionClass = '3,' + vG_Cat19Caption;
                }
                field("Category 20"; Rec."Category 20")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Category 20';
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
    end;

    trigger OnAfterGetRecord()
    var
        rL_GeneralCategories: Record "General Categories";
    begin
        //+TAL0.5
        vG_Pack := '';
        if Rec."Package Qty" <> 0 then begin
            vG_Pack := FORMAT(Rec."Package Qty") + ' ' + cu_GeneralMgt.Capitalise(FORMAT(Rec."Sales Unit of Measure"));
        end;

        vG_Caliber := '';
        if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, Rec."Category 6") then begin
            vG_Caliber := Rec."Category 4" + '-' + Rec."Category 5" + ' ' + rL_GeneralCategories.Description;
        end;
        //CALCFIELDS("Ship-to Product Name");
        //-TAL0.5

        vG_LandedUnitCost := Rec.GetLandedCost();
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
page 50020 "General Categories"
{
    // version TAL.SEPA,COC

    // TAL0.2 2020/03/04 VC add Description 2

    PageType = List;
    SourceTable = "General Categories";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Palette Qty"; Rec."Palette Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisiblePaletteQty;
                    ToolTip = 'Specifies the value of the Palette Qty field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'SWIFT Code',
                                ENU = 'SWIFT Code';
                    Visible = vG_VisibleReferenceNo;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleReferenceNo;
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Label Description Line 1"; Rec."Label Description Line 1")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Label Description Line 1 field.';
                }
                field("Label Description Line 2"; Rec."Label Description Line 2")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Label Description Line 2 field.';
                }
                field("Ship-to Description"; Rec."Ship-to Description")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Ship-to Description field.';
                }
                field("Pallet Qty"; Rec."Pallet Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Pallet Qty field.';
                }
                field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Country/Region Purchased Code field.';
                }
                field("Category 3"; Rec."Category 3")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field("Package Qty"; Rec."Package Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Package Qty field.';
                }
                field("Category 4"; Rec."Category 4")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Caliber Min field.';
                }
                field("Category 5"; Rec."Category 5")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Caliber Max field.';
                }
                field("Category 6"; Rec."Category 6")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Caliber UOM field.';
                }
                field("Category 7"; Rec."Category 7")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Variety field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(vG_Pack; vG_Pack)
                {
                    ApplicationArea = All;
                    Caption = 'Packing';
                    Editable = false;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Packing field.';
                }
                field(vG_Caliber; vG_Caliber)
                {
                    ApplicationArea = All;
                    Caption = 'Caliber';
                    Editable = false;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Caliber field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Create Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Print Receipt"; Rec."Print Receipt")
                {
                    ApplicationArea = All;
                    Visible = vG_Visible_23_Cat1;
                    ToolTip = 'Specifies the value of the Print Receipt field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    var
        rL_GeneralCategories: Record "General Categories";
    begin
        vG_Pack := '';
        vG_Caliber := '';
        if (Rec."Table No." = 27) and (Rec.Type = Rec.Type::Category2) then begin
            if Rec."Package Qty" <> 0 then begin
                vG_Pack := FORMAT(Rec."Package Qty") + ' ' + cu_GeneralMgt.Capitalise(FORMAT(Rec."Unit of Measure"));
            end;

            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, Rec."Category 6") then begin
                vG_Caliber := Rec."Category 4" + '-' + Rec."Category 5" + ' ' + rL_GeneralCategories.Description;
            end;
        end;
    end;

    trigger OnOpenPage();
    begin

        //+TAL0.1
        vG_VisiblePaletteQty := false;
        if (Rec."Table No." = 27) and (Rec.Type = Rec.Type::Category1) then begin
            vG_VisiblePaletteQty := true;
        end;
        //-TAL0.1

        //+TAL0.2
        vG_VisibleDescription2 := false;
        if (Rec."Table No." = 27) and (Rec.Type = Rec.Type::Category2) or
           (Rec."Table No." = 6505) and (Rec.Type = Rec.Type::Category2) or
           (Rec."Table No." = 6505) and (Rec.Type = Rec.Type::Category3)
           then begin
            vG_VisibleDescription2 := true;
        end;
        //-TAL0.2


        //+TAL0.3
        vG_VisibleReferenceNo := false;
        if (Rec."Table No." = 288) then begin
            vG_VisibleReferenceNo := true;
        end;
        //-TAL0.3

        vG_Visible_23_Cat1 := false;
        if (Rec."Table No." = 23) and (Rec.Type = Rec.Type::Category1) then begin
            vG_Visible_23_Cat1 := true;
        end;
    end;

    var
        [InDataSet]
        vG_VisiblePaletteQty: Boolean;
        [InDataSet]
        vG_VisibleDescription2: Boolean;
        [InDataSet]
        vG_VisibleReferenceNo: Boolean;
        vG_Pack: Text;
        vG_Caliber: Text;
        cu_GeneralMgt: Codeunit "General Mgt.";
        vG_Visible_23_Cat1: Boolean;
}


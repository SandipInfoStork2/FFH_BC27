page 50020 "General Categories"
{
    // version TAL.SEPA,COC

    // TAL0.2 2020/03/04 VC add Description 2

    PageType = List;
    SourceTable = "General Categories";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Palette Qty"; "Palette Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisiblePaletteQty;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Reference No."; "Reference No.")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'SWIFT Code',
                                ENU = 'SWIFT Code';
                    Visible = vG_VisibleReferenceNo;
                }
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleReferenceNo;
                }
                field("Label Description Line 1"; "Label Description Line 1")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Label Description Line 2"; "Label Description Line 2")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Ship-to Description"; "Ship-to Description")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Pallet Qty"; "Pallet Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Country/Region Purchased Code"; "Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Category 3"; "Category 3")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Package Qty"; "Package Qty")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Category 4"; "Category 4")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Category 5"; "Category 5")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Category 6"; "Category 6")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Category 7"; "Category 7")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field(vG_Pack; vG_Pack)
                {
                    ApplicationArea = All;
                    Caption = 'Packing';
                    Editable = false;
                    Visible = vG_VisibleDescription2;
                }
                field(vG_Caliber; vG_Caliber)
                {
                    ApplicationArea = All;
                    Caption = 'Caliber';
                    Editable = false;
                    Visible = vG_VisibleDescription2;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Create Date"; "Create Date")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = All;
                    Visible = vG_VisibleDescription2;
                }
                field("Print Receipt"; "Print Receipt")
                {
                    ApplicationArea = All;
                    Visible = vG_Visible_23_Cat1;
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
        if ("Table No." = 27) and (Type = Type::Category2) then begin
            if "Package Qty" <> 0 then begin
                vG_Pack := FORMAT("Package Qty") + ' ' + cu_GeneralMgt.Capitalise(FORMAT("Unit of Measure"));
            end;

            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, "Category 6") then begin
                vG_Caliber := "Category 4" + '-' + "Category 5" + ' ' + rL_GeneralCategories.Description;
            end;
        end;
    end;

    trigger OnOpenPage();
    begin

        //+TAL0.1
        vG_VisiblePaletteQty := false;
        if ("Table No." = 27) and (Type = Type::Category1) then begin
            vG_VisiblePaletteQty := true;
        end;
        //-TAL0.1

        //+TAL0.2
        vG_VisibleDescription2 := false;
        if ("Table No." = 27) and (Type = Type::Category2) or
           ("Table No." = 6505) and (Type = Type::Category2) or
           ("Table No." = 6505) and (Type = Type::Category3)
           then begin
            vG_VisibleDescription2 := true;
        end;
        //-TAL0.2


        //+TAL0.3
        vG_VisibleReferenceNo := false;
        if ("Table No." = 288) then begin
            vG_VisibleReferenceNo := true;
        end;
        //-TAL0.3

        vG_Visible_23_Cat1 := false;
        if ("Table No." = 23) and (Type = Type::Category1) then begin
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


page 50022 "Lidl Item List"
{
    PageType = List;
    SourceTable = "General Categories";
    SourceTableView = WHERE("Table No." = CONST(27),
                            Type = FILTER(Category2));

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
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                }
                field("Label Description Line 1"; "Label Description Line 1")
                {
                    ApplicationArea = All;
                }
                field("Label Description Line 2"; "Label Description Line 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Description"; "Ship-to Description")
                {
                    ApplicationArea = All;
                }
                field("Pallet Qty"; "Pallet Qty")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Purchased Code"; "Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                }
                field("Category 3"; "Category 3")
                {
                    ApplicationArea = All;
                }
                field("Package Qty"; "Package Qty")
                {
                    ApplicationArea = All;
                }
                field("Category 4"; "Category 4")
                {
                    ApplicationArea = All;
                }
                field("Category 5"; "Category 5")
                {
                    ApplicationArea = All;
                }
                field("Category 6"; "Category 6")
                {
                    ApplicationArea = All;
                }
                field("Category 7"; "Category 7")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(vG_Pack; vG_Pack)
                {
                    ApplicationArea = All;
                    Caption = 'Packing';
                    Editable = false;
                }
                field(vG_Caliber; vG_Caliber)
                {
                    ApplicationArea = All;
                    Caption = 'Caliber';
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Create Date"; "Create Date")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = All;
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

    var
        vG_Pack: Text;
        vG_Caliber: Text;
        cu_GeneralMgt: Codeunit "General Mgt.";
}


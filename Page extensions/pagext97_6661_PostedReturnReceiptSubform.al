/*
TAL0.1 24/12/2018 VC design Shelf No., Description 2, Packaging Group Description   
TAL0.2 2019/09/17 VC add field Unit of Measure (Base), Quantity Base
TAL0.3 2019/12/13 VC add ShowShortcutDimCode
TAL0.4 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.5 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50197 PostedReturnReceiptSubformExt extends "Posted Return Receipt Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Shelf No."; rG_Item."Shelf No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
            field("Packing Group Description"; rG_Item."Packing Group Description")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter("Shortcut Dimension 2 Code")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = All;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = All;
            }
            field("ShortcutDimCode[3]"; ShortcutDimCode[3])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,3';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible3;
            }
            field("ShortcutDimCode[4]"; ShortcutDimCode[4])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,4';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible4;
            }
            field("ShortcutDimCode[5]"; ShortcutDimCode[5])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,5';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible5;
            }
            field("ShortcutDimCode[6]"; ShortcutDimCode[6])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,6';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible6;
            }
            field("ShortcutDimCode[7]"; ShortcutDimCode[7])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,7';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible7;
            }
            field("ShortcutDimCode[8]"; ShortcutDimCode[8])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,8';
                Editable = false;
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible8;
            }
            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = all;
                Visible = true;
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Visible = true;
            }



            field("Product Class"; "Product Class")
            {
                ApplicationArea = all;
            }
            field("Category 9"; "Category 9")
            {
                ApplicationArea = all;
            }

        }

        modify("Net Weight")
        {
            Visible = true;
        }
        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = All;
            }
        }
        */
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;

                trigger OnAction();
                begin
                    ShowItemTrackingLines;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        SetDimensionsVisibility; //TAL0.3
    end;

    trigger OnAfterGetRecord();
    begin
        //+TAL0.1
        CLEAR(rG_Item);
        if Type = Type::Item then begin
            rG_Item.GET("No.");
            rG_Item.CALCFIELDS("Packing Group Description");
            //"Packing Group Description":=Item."Packing Group Description";
            //"Shelf No.":=Item."Shelf No.";
        end;
        //-TAL0.1

        ShowShortcutDimCode(ShortcutDimCode); //TAL0.3
    end;

    local procedure SetDimensionsVisibility();
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        CLEAR(DimMgt);
    end;

    var
        rG_Item: Record Item;
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
}
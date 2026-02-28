pageextension 50259 PostedSalesShipmentLinesExt extends "Posted Sales Shipment Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Document No.")
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("No.")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = all;
            }
        }

        addafter("Quantity Invoiced")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }

            field("Qty. Requested"; "Qty. Requested")
            {
                ApplicationArea = all;
            }
            field("Qty. Confirmed"; "Qty. Confirmed")
            {
                ApplicationArea = all;
            }

            /*
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = DimVisible1;
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                Visible = DimVisible2;
            }
            */
            field("ShortcutDimCode[3]"; ShortcutDimCode[3])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,3';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible3;
            }
            field("ShortcutDimCode[4]"; ShortcutDimCode[4])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible4;
            }
            field("ShortcutDimCode[5]"; ShortcutDimCode[5])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible5;
            }
            field("ShortcutDimCode[6]"; ShortcutDimCode[6])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible6;
            }
            field("ShortcutDimCode[7]"; ShortcutDimCode[7])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible7;
            }
            field("ShortcutDimCode[8]"; ShortcutDimCode[8])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,8';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                Visible = DimVisible8;
            }

            field(Correction; Correction)
            {
                ApplicationArea = All;
            }
            field("Order No."; "Order No.")
            {
                ApplicationArea = All;
            }
            field("Order Line No."; "Order Line No.")
            {
                ApplicationArea = All;
            }

            field("Transfer-from Code"; "Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Code"; "Transfer-to Code")
            {
                ApplicationArea = All;
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





        modify("Variant Code")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Item &Tracking Lines")
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");

            }

            action(ProductionBOM)
            {
                ApplicationArea = All;
                caption = 'Item Production BOM';
                Image = Item;
                trigger OnAction()
                var
                    Item: Record Item;
                    ProductionBOMHeader: Record "Production BOM Header";
                begin
                    item.Get("No.");
                    Item.TestField("Production BOM No.");

                    ProductionBOMHeader.GET(item."Production BOM No.");
                    page.Run(page::"Production BOM", ProductionBOMHeader);

                end;

            }

            action("Update Line")
            {
                ApplicationArea = Suite;
                Caption = 'Update Line';
                Image = Edit;

                ToolTip = 'Custom: Update Line';

                trigger OnAction()
                var
                    PostedSalesShipmentLineUpdate: Page "Posted Sales Ship. L.-Update";
                begin
                    PostedSalesShipmentLineUpdate.LookupMode := true;
                    PostedSalesShipmentLineUpdate.SetRec(Rec);
                    PostedSalesShipmentLineUpdate.RunModal;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetDimensionsVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    local procedure SetDimensionsVisibility()
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

        Clear(DimMgt);


    end;

    var
        myInt: Integer;

    protected var
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
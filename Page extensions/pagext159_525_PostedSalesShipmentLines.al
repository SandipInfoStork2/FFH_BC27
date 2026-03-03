pageextension 50259 PostedSalesShipmentLinesExt extends "Posted Sales Shipment Lines"
{
    layout
    {
        // Add changes to page layout here

        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting date for the entry.';
            }
        }
        addafter("No.")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }
        }

        addafter("Quantity Invoiced")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 3;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }

            field("Qty. Requested"; Rec."Qty. Requested")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Qty. Requested';
            }
            field("Qty. Confirmed"; Rec."Qty. Confirmed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Confirmed field.';
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
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible3;
                ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';
            }
            field("ShortcutDimCode[4]"; ShortcutDimCode[4])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible4;
                ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';
            }
            field("ShortcutDimCode[5]"; ShortcutDimCode[5])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible5;
                ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';
            }
            field("ShortcutDimCode[6]"; ShortcutDimCode[6])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible6;
                ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';
            }
            field("ShortcutDimCode[7]"; ShortcutDimCode[7])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible7;
                ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';
            }
            field("ShortcutDimCode[8]"; ShortcutDimCode[8])
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,8';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                Visible = DimVisible8;
                ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';
            }

            field(Correction; Rec.Correction)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies that this sales shipment line has been posted as a corrective entry.';
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order No. field.';
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Line No. field.';
            }

            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Req. Country field.';
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Custom: Country/Region of Origin Code';
            }



            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Product Class (Κατηγορία)';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Potatoes District Region';
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
                Caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Executes the Item Card action.';

            }

            action(ProductionBOM)
            {
                ApplicationArea = All;
                Caption = 'Item Production BOM';
                Image = Item;
                ToolTip = 'Executes the Item Production BOM action.';
                trigger OnAction()
                var
                    Item: Record Item;
                    ProductionBOMHeader: Record "Production BOM Header";
                begin
                    Item.Get(Rec."No.");
                    Item.TestField("Production BOM No.");

                    ProductionBOMHeader.Get(Item."Production BOM No.");
                    Page.Run(Page::"Production BOM", ProductionBOMHeader);

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
        Rec.ShowShortcutDimCode(ShortcutDimCode);
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
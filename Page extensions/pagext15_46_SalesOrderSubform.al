/*
18/06/17 TAL0.1 add fields
              "Quantity (Base)"
              "Unit of Measure (Base)"
              "Shelf No."
TAL0.2 2018/01/10 VC control for web orders, editable fields 
TAL0.3 2018/05/04 ANP added Clear Qty. to Ship in Actions
TAL0.4 2018/06/23 VC 
TAL0.5 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.6 2021/03/22 VC add fields Total Net Weight,Net Weight
*/

pageextension 50115 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {


        // Add changes to page layout here
        moveafter(Type; "Item Reference No.")
        //TAL 1.0.0.71 >>
        modify("Item Reference No.")
        {
            Visible = false;
        }
        //TAL 1.0.0.71 <<




        modify("Variant Code")
        {
            Visible = true;//TAL 1.0.0.71
        }

        moveafter("No."; "Variant Code")

        addafter("Variant Code")
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    //CheckWebOrder; //TAL0.2
                end;
            }
        }
        modify("Description 2")
        {
            Visible = false;
        }

        moveafter("Description 2"; ShortcutDimCode5)



        addafter(ShortcutDimCode5)
        {
            //TAL 1.0.0.71 >>
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }

            // field("Quantity (Base)"; "Quantity (Base)")
            // {
            //     DecimalPlaces = 0 : 3;
            // }

            // field("Qty. Requested"; "Qty. Requested")
            // {
            //     ApplicationArea = all;
            // }
            //TAL 1.0.0.71 <<
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
                Visible = false;//TAL 1.0.0.71
            }

        }


        moveafter("Unit of Measure (Base)"; Quantity)

        moveafter(Quantity; "Qty. to Ship")

        moveafter("Qty. to Ship"; "Quantity Shipped")

        modify("Unit of Measure")
        {
            Visible = true;
            Width = 5;//TAL 1.0.0.71
        }

        moveafter("Quantity Shipped"; "Unit of Measure")

        moveafter("Unit of Measure"; "Location Code")

        moveafter("Location Code"; "Unit of Measure Code")

        moveafter("Unit of Measure Code"; "Unit Price")

        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        moveafter("Unit Price"; "VAT Prod. Posting Group")

        moveafter("VAT Prod. Posting Group"; "Line Amount")

        moveafter("Line Amount"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        moveafter("Quantity Invoiced"; "Reserved Quantity")


        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }


        addafter("Reserved Quantity")
        {
            field("Req. Country"; "Req. Country")
            {
                caption = 'Req. Country';
                ApplicationArea = all;
                Visible = true;//TAL 1.0.0.71
                ToolTip = 'Custom: Req. Country/Country/Region of Origin Code';
            }
            field("Country/Region of Origin Code"; "Country/Region of Origin Code")
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
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        moveafter("Packing Group Description"; "Line Discount %")

        modify("Line Discount Amount")
        {
            Visible = false;//TAL 1.0.0.71
        }
        moveafter("Shipment Date"; "Line Discount Amount")




        modify("Net Weight")
        {
            Visible = false;//TAL 1.0.0.71
        }


        addafter("Net Weight")
        {

            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        //TAL 1.0.0.71 >>
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        moveafter("Unit Price"; "Line Amount")
        moveafter("Line Amount"; "VAT Prod. Posting Group")
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        moveafter("Location Code"; "Shortcut Dimension 2 Code")

        addafter("Shortcut Dimension 2 Code")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                DecimalPlaces = 0 : 3;
            }
        }
        moveafter("Quantity (Base)"; "Unit of Measure")
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("New Order Qty"; "New Order Qty")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field("Qty. Requested"; "Qty. Requested")
            {
                ApplicationArea = all;
            }
            field("Qty. Confirmed"; "Qty. Confirmed")
            {
                ApplicationArea = all;
            }
            field("Shipped Not Inv. (LCY) No VAT54230"; Rec."Shipped Not Inv. (LCY) No VAT")
            {
                ApplicationArea = All;
            }
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify(ShortcutDimCode7)
        {
            Visible = false;
        }
        //TAL 1.0.0.71 <<
        //TAL 1.0.0.201 >>
        addafter("Location Code")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.201 <<

        //+1.0.0.228
        modify("Unit Cost (LCY)")
        {
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

        addafter(ShortcutDimCode8)
        {
            field("Shipping Temperature"; "Shipping Temperature")
            {
                ApplicationArea = all;
            }
            field("Shipping Quality Control"; "Shipping Quality Control")
            {
                ApplicationArea = all;
            }
        }




    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action("Clear Qty. to Ship ")
            {
                ApplicationArea = all;
                Image = Completed;
                Promoted = true;

                trigger OnAction();
                var
                    Text50000: Label 'Are you sure to mark items as completed? %1 lines found';
                    rL_SalesLine: Record "Sales Line";
                begin
                    //+TAL0.3
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE("Document Type", "Document Type");
                    rL_SalesLine.SETRANGE("Document No.", "Document No.");


                    if rL_SalesLine.FINDSET then begin
                        repeat
                            rL_SalesLine.VALIDATE("Qty. to Ship", 0); //TAL0.4
                            rL_SalesLine.MODIFY;
                        until rL_SalesLine.NEXT = 0;
                    end;

                    //-TAL0.3
                end;
            }
            action(ItemTrackingLines2)
            {
                ApplicationArea = all;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction();
                begin
                    OpenItemTrackingLines;
                end;
            }

            action("Delete Zero Line Qty")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;

                trigger OnAction();
                var
                    Text50000: Label 'Are you sure to Delete Zero Line Qty? %1 lines found';
                    rL_SalesLine: Record "Sales Line";
                begin
                    //+TAL0.3
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE("Document Type", "Document Type");
                    rL_SalesLine.SETRANGE("Document No.", "Document No.");
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetRange(Quantity, 0);
                    if rL_SalesLine.FINDSET then begin
                        if not confirm(Text50000, false, rL_SalesLine.Count) then begin
                            exit;
                        end;

                        repeat
                            rL_SalesLine.Delete(true);
                        until rL_SalesLine.NEXT = 0;
                    end;

                    //-TAL0.3
                end;
            }

            //+1.0.0.277
            action(ImportExcelGeneral)
            {
                ApplicationArea = all;
                Caption = 'Import Excel General';
                ToolTip = 'Custom: Col 1: Reeference No., Col 2 Desc., Col 3 Qty';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";

                    rL_SalesHeader: Record "Sales Header";
                begin
                    CLEAR(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", "Document Type");
                    rL_SalesHeader.SETFILTER("No.", "Document No.");
                    if rL_SalesHeader.FINDFIRST then begin
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportFoodyLines(rL_SalesHeader);
                    end;

                    // Message(Rec."Document No.");
                end;
            }
            //-1.0.0.277
        }

        addafter("Select Nonstoc&k Items")
        {

        }
    }

    //+1.0.0.228
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
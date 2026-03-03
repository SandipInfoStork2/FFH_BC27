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
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';

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
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
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
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                Visible = false;
                //TAL 1.0.0.71                                                                                                                                                                                                                                                                                                                            ToolTip = 'Specifies the value of the Package Qty field.';

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
            field("Req. Country"; Rec."Req. Country")
            {
                Caption = 'Req. Country';
                ApplicationArea = All;
                Visible = true;//TAL 1.0.0.71
                ToolTip = 'Custom: Req. Country/Country/Region of Origin Code';
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Country/Region of Origin Code field.';
            }

            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Class (Κατηγορία) field.';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Potatoes District Region field.';
            }
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
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

            field("Total Net Weight"; Rec."Total Net Weight")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Total Net Weight field.';
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
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                DecimalPlaces = 0 : 3;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
                ApplicationArea = All;
            }
        }
        moveafter("Quantity (Base)"; "Unit of Measure")
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("New Order Qty"; Rec."New Order Qty")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the New Order Qty field.';
            }

            field("Qty. Requested"; Rec."Qty. Requested")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Requested field.';
            }
            field("Qty. Confirmed"; Rec."Qty. Confirmed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Confirmed field.';
            }
            field("Shipped Not Inv. (LCY) No VAT54230"; Rec."Shipped Not Inv. (LCY) No VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipped Not Invoiced (LCY) field.';
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
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
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
            field("Shipping Temperature"; Rec."Shipping Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
            }
            field("Shipping Quality Control"; Rec."Shipping Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Quality Control field.';
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
                ApplicationArea = All;
                Image = Completed;
                Promoted = true;
                ToolTip = 'Executes the Clear Qty. to Ship  action.';

                trigger OnAction();
                var
                    Text50000: Label 'Are you sure to mark items as completed? %1 lines found';
                    rL_SalesLine: Record "Sales Line";
                begin
                    //+TAL0.3
                    rL_SalesLine.Reset;
                    rL_SalesLine.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesLine.SETRANGE("Document No.", Rec."Document No.");


                    if rL_SalesLine.FindSet then begin
                        repeat
                            rL_SalesLine.Validate("Qty. to Ship", 0); //TAL0.4
                            rL_SalesLine.Modify;
                        until rL_SalesLine.Next = 0;
                    end;

                    //-TAL0.3
                end;
            }
            action(ItemTrackingLines2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Executes the Item &Tracking Lines action.';

                trigger OnAction();
                begin
                    Rec.OpenItemTrackingLines;
                end;
            }

            action("Delete Zero Line Qty")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                ToolTip = 'Executes the Delete Zero Line Qty action.';

                trigger OnAction();
                var
                    Text50000: Label 'Are you sure to Delete Zero Line Qty? %1 lines found';
                    rL_SalesLine: Record "Sales Line";
                begin
                    //+TAL0.3
                    rL_SalesLine.Reset;
                    rL_SalesLine.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesLine.SETRANGE("Document No.", Rec."Document No.");
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetRange(Quantity, 0);
                    if rL_SalesLine.FindSet then begin
                        if not Confirm(Text50000, false, rL_SalesLine.Count) then begin
                            exit;
                        end;

                        repeat
                            rL_SalesLine.Delete(true);
                        until rL_SalesLine.Next = 0;
                    end;

                    //-TAL0.3
                end;
            }

            //+1.0.0.277
            action(ImportExcelGeneral)
            {
                ApplicationArea = All;
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
                    Clear(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesHeader.SETFILTER("No.", Rec."Document No.");
                    if rL_SalesHeader.FindFirst then begin
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
        UserSetup.Get(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
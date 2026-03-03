page 50065 "Order Qty"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Order Qty";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }

                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version No. field.';
                }

                field("Max Version No."; Rec."Max Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Version No. field.';
                }
                field(Deleted; Rec.Deleted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deleted field.';
                }

                field("Sales Unit of Measure Code"; Rec."Sales Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Unit of Measure Code field.';
                }

                field("Sales Line Quantity"; Rec."Sales Line Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Line Quantity field.';
                }

                field("Create Datime"; Rec."Create Datime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Create Datime field.';
                }

                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                }
                field("New Order Qty"; Rec."New Order Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Order Qty field.';
                }

                field("Qty. Requested"; Rec."Qty. Requested")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty. Requested field.';
                }

                field("Previous Qty. Requested"; Rec."Previous Qty. Requested")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Qty. Requested field.';
                }

                field("Stat. Qty. Requested Change"; Rec."Stat. Qty. Requested Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stat. Qty. Requested Change field.';
                }

                field("Stat. Qty. Requested Change %"; Rec."Stat. Qty. Requested Change %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stat. Qty. Requested Change % field.';
                }

                field("Qty. Confirmed"; Rec."Qty. Confirmed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty. Confirmed field.';
                }
                field("Previous Qty. Confirmed"; Rec."Previous Qty. Confirmed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Qty. Confirmed field.';
                }

                field("Stat. Qty. Confirmed Change"; Rec."Stat. Qty. Confirmed Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stat. Qty. Confirmed Change field.';
                }

                field("Stat. Qty. Confirmed Change %"; Rec."Stat. Qty. Confirmed Change %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stat. Qty. Confirmed Change % field.';
                }

                field("UOM (Base)"; Rec."UOM (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM (Base) field.';
                }

            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Show Document';
                Image = Document;
                ToolTip = 'Executes the Show Document action.';

                trigger OnAction();
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    case Rec."Document Type" of
                        "Order Qty Document Type"::"Sales Order":
                            begin
                                Clear(SalesHeader);

                                if SalesHeader.get(Rec."Document Type", Rec."Document No.") then begin
                                    Page.Run(Page::"Sales Order", SalesHeader);
                                end else begin
                                    Clear(SalesShipmentHeader);
                                    SalesShipmentHeader.SetFilter("Order No.", Rec."Document No.");
                                    if SalesShipmentHeader.FindSet() then begin
                                        Page.Run(Page::"Posted Sales Shipments", SalesShipmentHeader);
                                    end;

                                end;

                            end;

                        "Order Qty Document Type"::"Sales Shipment":
                            begin
                                Clear(SalesShipmentHeader);
                                SalesShipmentHeader.get(Rec."Document No.");
                                Page.Run(Page::"Posted Sales Shipment", SalesShipmentHeader);
                            end;

                    end;



                end;
            }

            action(RecCount)
            {
                ApplicationArea = All;
                Caption = 'Count';
                ToolTip = 'Executes the Count action.';

                trigger OnAction()
                begin
                    Message('# Records:' + Format(Rec.Count));
                end;
            }

            action(UpdateMax)
            {
                ApplicationArea = All;
                Caption = 'Update Max';
                ToolTip = 'Executes the Update Max action.';

                trigger OnAction()
                begin
                    Rec.UpdateMaxVersionNo(Rec);

                end;
            }
        }
    }
}
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
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }

                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }

                field("Version No."; "Version No.")
                {
                    ApplicationArea = all;
                }

                field("Max Version No."; "Max Version No.")
                {
                    ApplicationArea = all;
                }
                field(Deleted; Deleted)
                {
                    ApplicationArea = all;
                }

                field("Sales Unit of Measure Code"; "Sales Unit of Measure Code")
                {
                    ApplicationArea = all;
                }

                field("Sales Line Quantity"; "Sales Line Quantity")
                {
                    ApplicationArea = all;
                }

                field("Create Datime"; "Create Datime")
                {
                    ApplicationArea = all;
                }

                field("Order Date"; "Order Date")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                }

                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Shelf No."; "Shelf No.")
                {
                    ApplicationArea = all;
                }
                field("New Order Qty"; "New Order Qty")
                {
                    ApplicationArea = all;
                }

                field("Qty. Requested"; "Qty. Requested")
                {
                    ApplicationArea = all;
                }

                field("Previous Qty. Requested"; "Previous Qty. Requested")
                {
                    ApplicationArea = all;
                }

                field("Stat. Qty. Requested Change"; "Stat. Qty. Requested Change")
                {
                    ApplicationArea = all;
                }

                field("Stat. Qty. Requested Change %"; "Stat. Qty. Requested Change %")
                {
                    ApplicationArea = all;
                }

                field("Qty. Confirmed"; "Qty. Confirmed")
                {
                    ApplicationArea = all;
                }
                field("Previous Qty. Confirmed"; "Previous Qty. Confirmed")
                {
                    ApplicationArea = all;
                }

                field("Stat. Qty. Confirmed Change"; "Stat. Qty. Confirmed Change")
                {
                    ApplicationArea = all;
                }

                field("Stat. Qty. Confirmed Change %"; "Stat. Qty. Confirmed Change %")
                {
                    ApplicationArea = all;
                }

                field("UOM (Base)"; "UOM (Base)")
                {
                    ApplicationArea = all;
                }

            }
        }
        area(Factboxes)
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

                trigger OnAction();
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    case "Document Type" of
                        "Order Qty Document Type"::"Sales Order":
                            begin
                                clear(SalesHeader);

                                if SalesHeader.get("Document Type", "Document No.") then begin
                                    page.Run(Page::"Sales Order", SalesHeader);
                                end else begin
                                    clear(SalesShipmentHeader);
                                    SalesShipmentHeader.SetFilter("Order No.", "Document No.");
                                    if SalesShipmentHeader.FindSet() then begin
                                        page.Run(Page::"Posted Sales Shipments", SalesShipmentHeader);
                                    end;

                                end;

                            end;

                        "Order Qty Document Type"::"Sales Shipment":
                            begin
                                clear(SalesShipmentHeader);
                                SalesShipmentHeader.get("Document No.");
                                page.Run(Page::"Posted Sales Shipment", SalesShipmentHeader);
                            end;

                    end;



                end;
            }

            action(RecCount)
            {
                ApplicationArea = All;
                caption = 'Count';

                trigger OnAction()
                begin
                    Message('# Records:' + Format(rec.Count));
                end;
            }

            action(UpdateMax)
            {
                ApplicationArea = All;
                caption = 'Update Max';

                trigger OnAction()
                begin
                    UpdateMaxVersionNo(Rec);

                end;
            }
        }
    }
}
report 50058 "Sales Order Mat. Requisition"
{
    // TAL0.1 Anp add ship to name
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep58_50058_SalesOrderMatRequisition.rdlc';

    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            RequestFilterFields = "No.", "Shortcut Dimension 2 Code", "Shipment Date", "Ship-to Code";
            column(DocumentType_SalesLine; "Sales Line"."Document Type")
            {
            }
            column(DocumentNo_SalesLine; "Sales Line"."Document No.")
            {
            }
            column(No_SalesLine; "Sales Line"."No.")
            {
            }
            column(Description_SalesLine; "Sales Line".Description)
            {
            }
            column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureBase_SalesLine; "Sales Line"."Unit of Measure (Base)")
            {
            }
            column(Quantity_SalesLine; "Sales Line".Quantity)
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
            {
            }
            column(ShipmentDate_SalesLine; Format("Sales Line"."Shipment Date"))
            {
            }
            column(ShiptoCode_SalesLine; "Sales Line"."Ship-to Code")
            {
            }
            column(vG_ShowDetails; Format(vG_ShowDetails))
            {
            }
            column(ItemWithRouting; ItemWithRouting)
            {
            }
            column(DisplayName; DisplayName)
            {
            }
            column(ShiptoCity; rG_ShiptoAddress.City)
            {
            }
            column(ShiptoName; rG_ShiptoAddress.Name)
            {
            }
            column(ShiptoAddress; rG_ShiptoAddress.Address)
            {
            }
            column(vG_ShiptoName; vG_ShiptoName)
            {
            }
            column(Item_ProductionBOMNo; rG_Item."Production BOM No.")
            {
            }
            column(Desc_ProductionBOMNo; rG_ProductionBOMHeader.Description)
            {
            }
            column(vG_ShipmentDateFilter; vG_ShipmentDateFilter)
            {
            }
            column(vG_ShowSalesOrder; Format(vG_ShowSalesOrder))
            {
            }
            dataitem("Production BOM Line"; "Production BOM Line")
            {
                column(Type_ProductionBOMLine; "Production BOM Line".Type)
                {
                }
                column(No_ProductionBOMLine; "Production BOM Line"."No.")
                {
                }
                column(Description_ProductionBOMLine; "Production BOM Line".Description)
                {
                }
                column(UnitofMeasureCode_ProductionBOMLine; "Production BOM Line"."Unit of Measure Code")
                {
                }
                column(Quantity_ProductionBOMLine; "Production BOM Line".Quantity)
                {
                }
                column(Quantityper_ProductionBOMLine; "Production BOM Line"."Quantity per")
                {
                }
                column(QuantityToOrder_ProductionBOMLine; vG_QtytoOrder)
                {
                    DecimalPlaces = 0 : 1;
                }
                column(InventoryPostingGroup_ProductionBOMLine; rG_ItemBOMLine."Inventory Posting Group")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    vG_QtytoOrder := 0;
                    Clear(rG_ItemBOMLine);
                    if rG_ItemBOMLine.Get("Production BOM Line"."No.") then;

                    vG_QtytoOrder := "Production BOM Line"."Quantity per" * "Sales Line"."Quantity (Base)";
                end;

                trigger OnPreDataItem();
                begin

                    if rG_Item."Production BOM No." = '' then begin
                        CurrReport.Skip;
                    end;

                    "Production BOM Line".SetFilter("Production BOM No.", rG_Item."Production BOM No.");
                    "Production BOM Line".SetFilter("Production BOM Line"."Quantity per", '<>%1', 0);
                end;
            }

            trigger OnAfterGetRecord();
            begin

                rG_Item.Get("No.");
                ItemWithRouting := rG_Item."Routing No." <> '';

                rG_SalesHeader.Get("Sales Line"."Document Type", "Sales Line"."Document No.");
                //rG_ShiptoAddress.GET(rG_SalesHeader."Bill-to Customer No.",rG_SalesHeader."Ship-to Code");

                //TAL0.1+
                vG_ShiptoName := '';
                rG_ShiptoAddress.Reset;
                rG_ShiptoAddress.SetFilter("Customer No.", rG_SalesHeader."Bill-to Customer No.");
                rG_ShiptoAddress.SetRange(Code, "Sales Line"."Ship-to Code");
                if rG_ShiptoAddress.FindSet then begin
                    vG_ShiptoName := rG_ShiptoAddress.Name;
                end;

                //TAL0.1-

                vG_QtytoOrder := 0;

                Clear(rG_ProductionBOMHeader);
                if rG_ProductionBOMHeader.Get(rG_Item."Production BOM No.") then begin

                end;
            end;

            trigger OnPreDataItem();
            begin
                "Sales Line".SetRange("Document Type", "Sales Line"."Document Type"::Order);
                "Sales Line".SetRange(Type, "Sales Line".Type::Item);
                "Sales Line".SetFilter(Quantity, '<>%1', 0);

                rG_CompanyInformation.Get;
                DisplayName := rG_CompanyInformation.Name;

                vG_ShipmentDateFilter := "Sales Line".GetFilter("Shipment Date");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(vG_ShowDetails; vG_ShowDetails)
                    {
                        Caption = 'Show Details';
                        Visible = true;
                        ToolTip = 'Specifies the value of the Show Details field.';
                        ApplicationArea = All;
                    }
                    field(vG_ShowSalesOrder; vG_ShowSalesOrder)
                    {
                        Caption = 'Show Sales Order';
                        Visible = false;
                        ToolTip = 'Specifies the value of the Show Sales Order field.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        vG_ShowDetails: Boolean;
        rG_Item: Record Item;
        ItemWithRouting: Boolean;
        DisplayName: Text;
        rG_CompanyInformation: Record "Company Information";
        rG_ShiptoAddress: Record "Ship-to Address";
        rG_SalesHeader: Record "Sales Header";
        vG_ShiptoName: Text;
        vG_QtytoOrder: Decimal;
        vG_ShipmentDateFilter: Text;
        vG_ShowSalesOrder: Boolean;
        rG_ItemBOMLine: Record Item;
        rG_ProductionBOMHeader: Record "Production BOM Header";
}


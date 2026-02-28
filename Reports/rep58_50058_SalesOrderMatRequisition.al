report 50058 "Sales Order Mat. Requisition"
{
    // TAL0.1 Anp add ship to name
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep58_50058_SalesOrderMatRequisition.rdlc';

    PreviewMode = PrintLayout;

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
            column(ShipmentDate_SalesLine; FORMAT("Sales Line"."Shipment Date"))
            {
            }
            column(ShiptoCode_SalesLine; "Sales Line"."Ship-to Code")
            {
            }
            column(vG_ShowDetails; FORMAT(vG_ShowDetails))
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
            column(vG_ShowSalesOrder; FORMAT(vG_ShowSalesOrder))
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
                    CLEAR(rG_ItemBOMLine);
                    if rG_ItemBOMLine.GET("Production BOM Line"."No.") then;

                    vG_QtytoOrder := "Production BOM Line"."Quantity per" * "Sales Line"."Quantity (Base)";
                end;

                trigger OnPreDataItem();
                begin

                    if rG_Item."Production BOM No." = '' then begin
                        CurrReport.SKIP;
                    end;

                    "Production BOM Line".SETFILTER("Production BOM No.", rG_Item."Production BOM No.");
                    "Production BOM Line".SETFILTER("Production BOM Line"."Quantity per", '<>%1', 0);
                end;
            }

            trigger OnAfterGetRecord();
            begin

                rG_Item.GET("No.");
                ItemWithRouting := rG_Item."Routing No." <> '';

                rG_SalesHeader.GET("Sales Line"."Document Type", "Sales Line"."Document No.");
                //rG_ShiptoAddress.GET(rG_SalesHeader."Bill-to Customer No.",rG_SalesHeader."Ship-to Code");

                //TAL0.1+
                vG_ShiptoName := '';
                rG_ShiptoAddress.RESET;
                rG_ShiptoAddress.SETFILTER("Customer No.", rG_SalesHeader."Bill-to Customer No.");
                rG_ShiptoAddress.SETRANGE(Code, "Sales Line"."Ship-to Code");
                if rG_ShiptoAddress.FINDSET then begin
                    vG_ShiptoName := rG_ShiptoAddress.Name;
                end;

                //TAL0.1-

                vG_QtytoOrder := 0;

                CLEAR(rG_ProductionBOMHeader);
                if rG_ProductionBOMHeader.GET(rG_Item."Production BOM No.") then begin

                end;
            end;

            trigger OnPreDataItem();
            begin
                "Sales Line".SETRANGE("Document Type", "Sales Line"."Document Type"::Order);
                "Sales Line".SETRANGE(Type, "Sales Line".Type::Item);
                "Sales Line".SETFILTER(Quantity, '<>%1', 0);

                rG_CompanyInformation.GET;
                DisplayName := rG_CompanyInformation.Name;

                vG_ShipmentDateFilter := "Sales Line".GETFILTER("Shipment Date");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(vG_ShowDetails; vG_ShowDetails)
                    {
                        Caption = 'Show Details';
                        Visible = true;
                    }
                    field(vG_ShowSalesOrder; vG_ShowSalesOrder)
                    {
                        Caption = 'Show Sales Order';
                        Visible = false;
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


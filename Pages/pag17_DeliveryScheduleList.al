page 50017 "Delivery Schedule List"
{
    // version COC

    PageType = List;
    SourceTable = "Delivery Schedule";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Delivery No."; Rec."Delivery No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery No. field.';
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field(Van; Rec.Van)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Van field.';
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Date field.';
                }
                field("Week No."; Rec."Week No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week No. field.';
                }
                field("Van Start Time"; Rec."Van Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Van Start Time field.';
                }
                field("Van End Time"; Rec."Van End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Van End Time field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("No. of Sales Orders"; Rec."No. of Sales Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Sales Orders field.';
                }
                field("No. of Sales Shipments"; Rec."No. of Sales Shipments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Sales Shipments field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Print Date"; Rec."Print Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Print Date field.';
                }
                field("Print By"; Rec."Print By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Print By field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            //Caption = 'Link';
            action("Sales Orders")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Sales Orders action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                    rL_ResourceVan: Record Resource;
                    p_SalesOrderList: Page "Sales Order List";
                begin
                    //
                    rL_ResourceVan.GET(Rec.Van);

                    rL_SalesHeader.Reset;
                    rL_SalesHeader.SETRANGE("Posting Date", Rec."Delivery Date");
                    rL_SalesHeader.SetFilter("Bill-to Customer No.", 'CUST00032');


                    Clear(p_SalesOrderList);
                    //p_PostedSalesShipments.
                    p_SalesOrderList.SetTableView(rL_SalesHeader);
                    p_SalesOrderList.Editable(true);
                    p_SalesOrderList.RunModal();
                end;
            }
            action("Posted Sales Shipments")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Posted Sales Shipments action.';

                trigger OnAction();
                var
                    rL_SalesShipmentHeader: Record "Sales Shipment Header";
                    rL_ResourceVan: Record Resource;
                    p_PostedSalesShipments: Page "Posted Sales Shipments";
                begin
                    //
                    rL_ResourceVan.GET(Rec.Van);

                    rL_SalesShipmentHeader.Reset;
                    rL_SalesShipmentHeader.SETRANGE("Posting Date", Rec."Delivery Date");
                    rL_SalesShipmentHeader.SetFilter("Bill-to Customer No.", 'CUST00032');


                    Clear(p_PostedSalesShipments);
                    //p_PostedSalesShipments.
                    p_PostedSalesShipments.SetTableView(rL_SalesShipmentHeader);
                    p_PostedSalesShipments.Editable(true);
                    p_PostedSalesShipments.RunModal();
                end;
            }
        }
        area(Reporting)
        {
            action("Draft - Export Packing List")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Draft - Export Packing List action.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportChainOfCustody(Rec."Delivery No.", true);
                end;
            }
            action("Export Packing List")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Export Packing List action.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportChainOfCustody(Rec."Delivery No.", false);
                end;
            }
        }
    }
}


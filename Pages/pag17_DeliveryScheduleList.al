page 50017 "Delivery Schedule List"
{
    // version COC

    PageType = List;
    SourceTable = "Delivery Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Delivery No."; "Delivery No.")
                {
                    ApplicationArea = All;
                }
                field(Driver; Driver)
                {
                    ApplicationArea = All;
                }
                field(Van; Van)
                {
                    ApplicationArea = All;
                }
                field("Delivery Date"; "Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Week No."; "Week No.")
                {
                    ApplicationArea = All;
                }
                field("Van Start Time"; "Van Start Time")
                {
                    ApplicationArea = All;
                }
                field("Van End Time"; "Van End Time")
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("No. of Sales Orders"; "No. of Sales Orders")
                {
                    ApplicationArea = All;
                }
                field("No. of Sales Shipments"; "No. of Sales Shipments")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = All;
                }
                field("Print Date"; "Print Date")
                {
                    ApplicationArea = All;
                }
                field("Print By"; "Print By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption = 'Link';
            action("Sales Orders")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                    rL_ResourceVan: Record Resource;
                    p_SalesOrderList: Page "Sales Order List";
                begin
                    //
                    rL_ResourceVan.GET(Van);

                    rL_SalesHeader.RESET;
                    rL_SalesHeader.SETRANGE("Posting Date", "Delivery Date");
                    rL_SalesHeader.SETFILTER("Bill-to Customer No.", 'CUST00032');


                    CLEAR(p_SalesOrderList);
                    //p_PostedSalesShipments.
                    p_SalesOrderList.SETTABLEVIEW(rL_SalesHeader);
                    p_SalesOrderList.EDITABLE(true);
                    p_SalesOrderList.RUNMODAL();
                end;
            }
            action("Posted Sales Shipments")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    rL_SalesShipmentHeader: Record "Sales Shipment Header";
                    rL_ResourceVan: Record Resource;
                    p_PostedSalesShipments: Page "Posted Sales Shipments";
                begin
                    //
                    rL_ResourceVan.GET(Van);

                    rL_SalesShipmentHeader.RESET;
                    rL_SalesShipmentHeader.SETRANGE("Posting Date", "Delivery Date");
                    rL_SalesShipmentHeader.SETFILTER("Bill-to Customer No.", 'CUST00032');


                    CLEAR(p_PostedSalesShipments);
                    //p_PostedSalesShipments.
                    p_PostedSalesShipments.SETTABLEVIEW(rL_SalesShipmentHeader);
                    p_PostedSalesShipments.EDITABLE(true);
                    p_PostedSalesShipments.RUNMODAL();
                end;
            }
        }
        area(reporting)
        {
            action("Draft - Export Packing List")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ExportChainOfCustody("Delivery No.", true);
                end;
            }
            action("Export Packing List")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ExportChainOfCustody("Delivery No.", false);
                end;
            }
        }
    }
}


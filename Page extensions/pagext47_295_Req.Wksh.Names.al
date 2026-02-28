/*
TAL0.1 2019/05/17 VC add Log fields, Vendor No, Type 

*/
pageextension 50147 ReqWkshNamesExt extends "Req. Wksh. Names"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Create Date"; "Create Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Last Modified Date"; "Last Modified Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Last Modified By"; "Last Modified By")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Transaction Type"; "Transaction Type")
            {
                ApplicationArea = All;
            }
            field("No. of Lines"; "No. of Lines")
            {
                ApplicationArea = All;
            }
            field(ProductionOrder; vG_ProductionOrderCount)
            {
                ApplicationArea = All;
                //Editable = false;
                CaptionML = ELL = 'Production Order',
                                ENU = 'Production Order';
                DrillDown = true;

                trigger OnDrillDown();
                begin
                    PAGE.RUN(PAGE::"Released Production Orders", rG_ProductionOrder);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Released Production Orders", rG_ProductionOrder);
                end;
                */
            }
            field(vG_TransferOrderCount; vG_TransferOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Transfer Orders',
                                ENU = 'Transfer Orders';
                DrillDown = true;

                trigger OnDrillDown()
                begin

                    PAGE.RUN(PAGE::"Transfer Orders", rG_TransferHeader);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin

                    PAGE.RUN(PAGE::"Transfer Orders", rG_TransferHeader);
                end;
                */
            }
            field(vG_SalesReturnOrderCount; vG_SalesReturnOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Sales Return Order',
                                ENU = 'Sales Return Order';
                //DrillDownPageID = "Sales Return Order List";
                DrillDown = true;

                trigger OnDrillDown();
                begin

                    PAGE.RUN(PAGE::"Sales Return Order List", rG_SalesReturnOrder);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin

                    PAGE.RUN(PAGE::"Sales Return Order List", rG_SalesReturnOrder);
                end;
                */
            }
            field(vG_SalesOrderCount; vG_SalesOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Sales Order',
                                ENU = 'Sales Order';
                //DrillDownPageID = "Sales Order List";
                DrillDown = true;

                trigger OnDrillDown();
                begin
                    PAGE.RUN(PAGE::"Sales Order List", rG_SalesOrder);
                end;
                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Sales Order List", rG_SalesOrder);
                end;
                */
            }
            field("No. of Boxes"; "No. of Boxes")
            {
                ApplicationArea = All;
                DrillDownPageID = "Purchase List Addon";
                DrillDown = true;
            }
            field(vG_PurchaseOrderCount; vG_PurchaseOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Purchase Order',
                                ENU = 'Purchase Order';
                //DrillDownPageID = "Sales Order List";
                DrillDown = true;

                trigger OnDrillDown();
                begin
                    PAGE.RUN(PAGE::"Purchase Order List", rG_PurchaseOrder);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Purchase Order List", rG_PurchaseOrder);
                end;
                */
            }
            field(vG_PurchaseReturnOrderCount; vG_PurchaseReturnOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Purchase Return Order',
                                ENU = 'Purchase Return Order';
                //DrillDownPageID = "Sales Return Order List";
                DrillDown = true;

                trigger OnDrillDown();
                begin
                    PAGE.RUN(PAGE::"Purchase Return Order List", rG_PurchaseReturnOrder);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Purchase Return Order List", rG_PurchaseReturnOrder);
                end;
                */
            }
            field("Print Date Time"; "Print Date Time")
            {
                ApplicationArea = All;
            }
            field("Print By"; "Print By")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord();
    begin

        //TRANSFERS
        vG_TransferOrderCount := 0;

        CLEAR(rG_TransferHeader);
        if "Vendor No." <> '' then begin
            VendorLocation := DELSTR("Vendor No.", 2, 3);

            rG_TransferHeader.RESET;
            rG_TransferHeader.SETFILTER("Req. Vendor No.", "Vendor No.");
            if "Transaction Type" = "Transaction Type"::Inbound then begin
                rG_TransferHeader.SETFILTER("Transfer-from Code", VendorLocation);
            end else
                if "Transaction Type" = "Transaction Type"::Outbound then begin
                    rG_TransferHeader.SETFILTER("Transfer-to Code", VendorLocation);
                end;

            if rG_TransferHeader.FINDSET then begin
                vG_TransferOrderCount := rG_TransferHeader.COUNT;
            end;
        end;

        //Production Order
        vG_ProductionOrderCount := 0;
        if "Transaction Type" = "Transaction Type"::Inbound then begin
            rG_ProductionOrder.RESET;
            rG_ProductionOrder.SETRANGE(Status, rG_ProductionOrder.Status::Released);
            rG_ProductionOrder.SETFILTER("Vendor No.", "Vendor No.");
            if rG_ProductionOrder.FINDSET then begin
                vG_ProductionOrderCount := rG_ProductionOrder.COUNT;
            end;
        end;

        //sales
        //Count("Sales Header" WHERE (Document Type=FILTER(Order),Req. Vendor No.=FIELD(Vendor No.)))
        vG_SalesOrderCount := 0;
        vG_SalesReturnOrderCount := 0;
        if "Transaction Type" = "Transaction Type"::Inbound then begin
            rG_SalesReturnOrder.RESET;
            rG_SalesReturnOrder.SETRANGE("Document Type", rG_SalesReturnOrder."Document Type"::"Return Order");
            rG_SalesReturnOrder.SETFILTER("Req. Vendor No.", "Vendor No.");
            if rG_SalesReturnOrder.FINDSET then begin
                vG_SalesReturnOrderCount := rG_SalesReturnOrder.COUNT;
            end;

        end else
            if "Transaction Type" = "Transaction Type"::Outbound then begin
                rG_SalesOrder.RESET;
                rG_SalesOrder.SETRANGE("Document Type", rG_SalesOrder."Document Type"::Order);
                rG_SalesOrder.SETFILTER("Req. Vendor No.", "Vendor No.");
                if rG_SalesOrder.FINDSET then begin
                    vG_SalesOrderCount := rG_SalesOrder.COUNT;
                end;
            end;

        //Purhcases
        //Count("Purchase Header" WHERE (Buy-from Vendor No.=FIELD(Vendor No.),Document Type=FILTER(Order)))
        vG_PurchaseOrderCount := 0;
        vG_PurchaseReturnOrderCount := 0;
        if "Transaction Type" = "Transaction Type"::Inbound then begin
            rG_PurchaseOrder.RESET;
            rG_PurchaseOrder.SETRANGE("Document Type", rG_PurchaseOrder."Document Type"::Order);
            rG_PurchaseOrder.SETFILTER("Buy-from Vendor No.", "Vendor No.");
            if rG_PurchaseOrder.FINDSET then begin
                vG_PurchaseOrderCount := rG_PurchaseOrder.COUNT;
            end;

        end else
            if "Transaction Type" = "Transaction Type"::Outbound then begin
                rG_PurchaseReturnOrder.RESET;
                rG_PurchaseReturnOrder.SETRANGE("Document Type", rG_PurchaseReturnOrder."Document Type"::"Return Order");
                rG_PurchaseReturnOrder.SETFILTER("Buy-from Vendor No.", "Vendor No.");
                if rG_PurchaseReturnOrder.FINDSET then begin
                    vG_PurchaseReturnOrderCount := rG_PurchaseReturnOrder.COUNT;
                end;
            end;
    end;

    var
        vG_TransferOrderCount: Integer;
        rG_TransferHeader: Record "Transfer Header";
        VendorLocation: Code[20];
        vG_ProductionOrderCount: Integer;
        rG_ProductionOrder: Record "Production Order";
        rG_SalesOrder: Record "Sales Header";
        rG_SalesReturnOrder: Record "Sales Header";
        vG_SalesOrderCount: Integer;
        vG_SalesReturnOrderCount: Integer;
        rG_PurchaseOrder: Record "Purchase Header";
        rG_PurchaseReturnOrder: Record "Purchase Header";
        vG_PurchaseOrderCount: Integer;
        vG_PurchaseReturnOrderCount: Integer;
}
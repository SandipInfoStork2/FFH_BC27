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
            field("Create Date"; Rec."Create Date")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Create Date field.';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Created By field.';
            }
            field("Last Modified Date"; Rec."Last Modified Date")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Last Modified Date field.';
            }
            field("Last Modified By"; Rec."Last Modified By")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Last Modified By field.';
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transaction Type field.';
            }
            field("No. of Lines"; Rec."No. of Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Lines field.';
            }
            field(ProductionOrder; vG_ProductionOrderCount)
            {
                ApplicationArea = All;
                //Editable = false;
                CaptionML = ELL = 'Production Order',
                                ENU = 'Production Order';
                DrillDown = true;
                ToolTip = 'Specifies the value of the vG_ProductionOrderCount field.';

                trigger OnDrillDown();
                begin
                    Page.Run(Page::"Released Production Orders", rG_ProductionOrder);
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
                ToolTip = 'Specifies the value of the vG_TransferOrderCount field.';

                trigger OnDrillDown()
                begin

                    Page.Run(Page::"Transfer Orders", rG_TransferHeader);
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
                ToolTip = 'Specifies the value of the vG_SalesReturnOrderCount field.';

                trigger OnDrillDown();
                begin

                    Page.Run(Page::"Sales Return Order List", rG_SalesReturnOrder);
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
                ToolTip = 'Specifies the value of the vG_SalesOrderCount field.';

                trigger OnDrillDown();
                begin
                    Page.Run(Page::"Sales Order List", rG_SalesOrder);
                end;
                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Sales Order List", rG_SalesOrder);
                end;
                */
            }
            field("No. of Boxes"; Rec."No. of Boxes")
            {
                ApplicationArea = All;
                DrillDownPageId = "Purchase List Addon";
                DrillDown = true;
                ToolTip = 'Specifies the value of the No. of Boxes field.';
            }
            field(vG_PurchaseOrderCount; vG_PurchaseOrderCount)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Purchase Order',
                                ENU = 'Purchase Order';
                //DrillDownPageID = "Sales Order List";
                DrillDown = true;
                ToolTip = 'Specifies the value of the vG_PurchaseOrderCount field.';

                trigger OnDrillDown();
                begin
                    Page.Run(Page::"Purchase Order List", rG_PurchaseOrder);
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
                ToolTip = 'Specifies the value of the vG_PurchaseReturnOrderCount field.';

                trigger OnDrillDown();
                begin
                    Page.Run(Page::"Purchase Return Order List", rG_PurchaseReturnOrder);
                end;

                /*
                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Purchase Return Order List", rG_PurchaseReturnOrder);
                end;
                */
            }
            field("Print Date Time"; Rec."Print Date Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Print Date Time field.';
            }
            field("Print By"; Rec."Print By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Print By field.';
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

        Clear(rG_TransferHeader);
        if Rec."Vendor No." <> '' then begin
            VendorLocation := DELSTR(Rec."Vendor No.", 2, 3);

            rG_TransferHeader.Reset;
            rG_TransferHeader.SETFILTER("Req. Vendor No.", Rec."Vendor No.");
            if Rec."Transaction Type" = Rec."Transaction Type"::Inbound then begin
                rG_TransferHeader.SetFilter("Transfer-from Code", VendorLocation);
            end else
                if Rec."Transaction Type" = Rec."Transaction Type"::Outbound then begin
                    rG_TransferHeader.SetFilter("Transfer-to Code", VendorLocation);
                end;

            if rG_TransferHeader.FindSet then begin
                vG_TransferOrderCount := rG_TransferHeader.Count;
            end;
        end;

        //Production Order
        vG_ProductionOrderCount := 0;
        if Rec."Transaction Type" = Rec."Transaction Type"::Inbound then begin
            rG_ProductionOrder.Reset;
            rG_ProductionOrder.SetRange(Status, rG_ProductionOrder.Status::Released);
            rG_ProductionOrder.SETFILTER("Vendor No.", Rec."Vendor No.");
            if rG_ProductionOrder.FindSet then begin
                vG_ProductionOrderCount := rG_ProductionOrder.Count;
            end;
        end;

        //sales
        //Count("Sales Header" WHERE (Document Type=FILTER(Order),Req. Vendor No.=FIELD(Vendor No.)))
        vG_SalesOrderCount := 0;
        vG_SalesReturnOrderCount := 0;
        if Rec."Transaction Type" = Rec."Transaction Type"::Inbound then begin
            rG_SalesReturnOrder.Reset;
            rG_SalesReturnOrder.SetRange("Document Type", rG_SalesReturnOrder."Document Type"::"Return Order");
            rG_SalesReturnOrder.SETFILTER("Req. Vendor No.", Rec."Vendor No.");
            if rG_SalesReturnOrder.FindSet then begin
                vG_SalesReturnOrderCount := rG_SalesReturnOrder.Count;
            end;

        end else
            if Rec."Transaction Type" = Rec."Transaction Type"::Outbound then begin
                rG_SalesOrder.Reset;
                rG_SalesOrder.SetRange("Document Type", rG_SalesOrder."Document Type"::Order);
                rG_SalesOrder.SETFILTER("Req. Vendor No.", Rec."Vendor No.");
                if rG_SalesOrder.FindSet then begin
                    vG_SalesOrderCount := rG_SalesOrder.Count;
                end;
            end;

        //Purhcases
        //Count("Purchase Header" WHERE (Buy-from Vendor No.=FIELD(Vendor No.),Document Type=FILTER(Order)))
        vG_PurchaseOrderCount := 0;
        vG_PurchaseReturnOrderCount := 0;
        if Rec."Transaction Type" = Rec."Transaction Type"::Inbound then begin
            rG_PurchaseOrder.Reset;
            rG_PurchaseOrder.SetRange("Document Type", rG_PurchaseOrder."Document Type"::Order);
            rG_PurchaseOrder.SETFILTER("Buy-from Vendor No.", Rec."Vendor No.");
            if rG_PurchaseOrder.FindSet then begin
                vG_PurchaseOrderCount := rG_PurchaseOrder.Count;
            end;

        end else
            if Rec."Transaction Type" = Rec."Transaction Type"::Outbound then begin
                rG_PurchaseReturnOrder.Reset;
                rG_PurchaseReturnOrder.SetRange("Document Type", rG_PurchaseReturnOrder."Document Type"::"Return Order");
                rG_PurchaseReturnOrder.SETFILTER("Buy-from Vendor No.", Rec."Vendor No.");
                if rG_PurchaseReturnOrder.FindSet then begin
                    vG_PurchaseReturnOrderCount := rG_PurchaseReturnOrder.Count;
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
/*
03/10/17 TAL0.1 add action Print Proforma Invoice
TAL0.2 2017/11/13 VC design post and print action from 2015
TAL0.3 2017/11/23 VC design Sell to customer no, sell to fields are set to standard and not additional 
TAL0.4 2017/12/07 VC design Bill-to Name
TAL0.5 2018/01/10 VC control for web orders, editable fields 
TAL0.6 2018/01/11 VC link item picture
TAL0.7 2018/01/29 VC review post & send button 
TAL0.8 2018/06/11 VC add action import from Excel 
TAL0.9 2018/07/22 VC add field Batch No. 
TAL0.10 2019/03/29 VC add action Email Work Order

TAL0.11 2020/03/06 VC add field Lot No.
TAL0.12 2020/03/06 VC add field Delivery No.,Delivery Sequence,Chain of Custody Tracking
TAL0.13 2021/04/06 VC add PrintAppendixRecords
TAL0.14 2021/06/23 VC review Print Proforma Invoice logic from 17
TAL0.15 2021/12/14 ANP Create New action -CreatePurchaseOrder
*/

pageextension 50112 SalesOrderExt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Name2"; Rec."Bill-to Name")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bill-to Name';
                //Editable = BillToOptions = BillToOptions::"Another Customer";
                //Enabled = BillToOptions = BillToOptions::"Another Customer";
                Importance = Promoted;
                ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';

                trigger OnValidate()
                begin
                    if Rec.GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                        if Rec."Bill-to Customer No." <> xRec."Bill-to Customer No." then
                            Rec.SetRange("Bill-to Customer No.");

                    CurrPage.SaveRecord;
                    //if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                    //SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);

                    CurrPage.Update(false);
                end;
            }
        }

        modify("Sell-to Address")
        {
            Importance = Standard;
        }
        modify("Sell-to Address 2")
        {
            Importance = Standard;
        }
        modify("Sell-to Post Code")
        {
            Importance = Standard;
        }
        modify("Sell-to City")
        {
            Importance = Standard;
        }

        modify("Sell-to Contact")
        {
            Importance = Standard;
        }

        addafter("External Document No.")
        {
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
        }

        addafter("Package Tracking No.")
        {
            field("Delivery No."; Rec."Delivery No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery No. field.';
            }
            field("Delivery Sequence"; Rec."Delivery Sequence")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Sequence field.';
            }
            field("Chain of Custody Tracking"; Rec."Chain of Custody Tracking")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Chain of Custody Tracking field.';
            }
        }

        addafter(Control1900201301)
        {
            group(Log)
            {
                Caption = 'Log';
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Create Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
            }

            group(QC)
            {
                Caption = 'Quality Control';
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

        addafter(WorkflowStatus)
        {
            part(ItemPicture; "Item Picture - Sales Line")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
            }
        }

        addafter("Your Reference")
        {
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
            }
        }

        addafter("Promised Delivery Date")
        {
            field("Excel Order Date"; Rec."Excel Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Excel Order Date field.';
            }
        }

        modify("Requested Delivery Date")
        {
            ShowMandatory = true;
        }

        addafter("Requested Delivery Date")
        {
            field("Requested Delivery Time"; Rec."Requested Delivery Time")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Requested Delivery Time field.';
            }
        }

        modify("Shipment Date")
        {
            ShowMandatory = true;
        }

        addafter("Shipment Date")
        {
            field("Shipment Time"; Rec."Shipment Time")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Shipment Time field.';
            }
        }

        addafter(Status)
        {
            field("Location Code2"; Rec."Location Code")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the location from where items are to be shipped. This field acts as the default location for new lines. You can update the location code for individual lines as needed.';
            }

        }

        addafter("Work Description")
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

        addafter("Combine Shipments")
        {
            field("HORECA Status"; Rec."HORECA Status")
            {
                ApplicationArea = All;
                StyleExpr = HorecaStatusStyleTxt;
                ToolTip = 'Specifies the value of the HORECA Status field.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(CreatePurchaseOrder)
        {

            //out of the box feature
            action(CreatePurchaseOrder_Simple)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Purchase Order (Simple)';
                Image = NewPurchaseInvoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category8;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                ToolTip = 'Create a new purchase Order so you can buy items from a vendor.';

                trigger OnAction();
                var
                    SelectedSalesLine: Record "Sales Line";
                begin
                    //TAL0.15
                    CurrPage.SalesLines.Page.SetSelectionFilter(SelectedSalesLine);
                    Rec.f_CreatePurchaseOrder(Rec, SelectedSalesLine);
                    //TAL0.15
                end;
            }

        }


        addafter("Send IC Sales Order")
        {
            action("Import Lidl Order")
            {
                ApplicationArea = Basic, Suite;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Lidl Order action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.8
                    Clear(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesHeader.SETFILTER("No.", Rec."No.");
                    if rL_SalesHeader.FindFirst then begin
                        //MESSAGE(FORMAT(rL_SalesHeader.COUNT));
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportLidlOrder(rL_SalesHeader);
                    end;
                    //-TAL0.8
                end;
            }

            action("Import Lidl Order Confirmation")
            {
                ApplicationArea = Basic, Suite;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Lidl Order Confirmation action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.8
                    Clear(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesHeader.SETFILTER("No.", Rec."No.");
                    if rL_SalesHeader.FindFirst then begin
                        //MESSAGE(FORMAT(rL_SalesHeader.COUNT));
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportLidlOrderConfirmation(rL_SalesHeader);
                    end;
                    //-TAL0.8
                end;
            }

            action(ImportExcelFoody)
            {
                ApplicationArea = All;
                Caption = 'Import Foody Order';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Foody Order action.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";

                    rL_SalesHeader: Record "Sales Header";
                begin
                    Clear(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesHeader.SETFILTER("No.", Rec."No.");
                    if rL_SalesHeader.FindFirst then begin
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportFoodyHeader(rL_SalesHeader);
                    end;

                    // Message(Rec."Document No.");
                end;
            }

            action(ImportExcelWolt)
            {
                ApplicationArea = All;
                Caption = 'Import Wolt Order';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Wolt Order action.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";

                    rL_SalesHeader: Record "Sales Header";
                begin
                    Clear(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    rL_SalesHeader.SETFILTER("No.", Rec."No.");
                    if rL_SalesHeader.FindFirst then begin
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportWolt(rL_SalesHeader);
                    end;

                    // Message(Rec."Document No.");
                end;
            }

            action(RecalcuatePrices)
            {
                ApplicationArea = All;
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Recalcuate Prices';
                ToolTip = 'Executes the Recalcuate Prices action.';

                trigger OnAction()

                var
                    rL_SalesLine: Record "Sales Line";
                    vL_PriceCount: Integer;
                    SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";

                    vL_Text50000: Label 'Are you sure to update all item prices based on Order Date %1?';
                    vL_Text50001: Label 'Prices not found for Item %1';
                    vL_Text50002: Label 'Item %1 Old Price %2 --> New Price %3';
                    vL_OldPrice: Decimal;
                    vL_NewPrice: Decimal;
                begin
                    if not Confirm(vL_Text50000, false, Format(Rec."Order Date")) then begin
                        exit;
                    end;

                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange("Document Type", Rec."Document Type");
                    rL_SalesLine.SetFilter("Document No.", Rec."No.");
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    if rL_SalesLine.FindSet() then begin
                        repeat
                            vL_PriceCount := SalesInfoPaneMgt.CalcNoOfSalesPrices(rL_SalesLine);
                            if vL_PriceCount >= 1 then begin

                                vL_OldPrice := rL_SalesLine."Unit Price";
                                rL_SalesLine.UpdateUnitPriceByFieldCustom(rL_SalesLine.FieldNo(Quantity));
                                rL_SalesLine.Modify();

                                Message(vL_Text50002, rL_SalesLine."No.", vL_OldPrice, rL_SalesLine."Unit Price");

                            end else begin
                                Message(vL_Text50001, rL_SalesLine."No.");
                            end;


                        until rL_SalesLine.Next() = 0;
                    end;

                end;
            }
        }




        addafter(PostAndSend)
        {
            action("Post and &Print")
            {
                ApplicationArea = All;
                Caption = 'Post and &Print';
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortcutKey = 'Shift+F9';
                ToolTip = 'Executes the Post and &Print action.';

                trigger OnAction();
                begin

                    LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                    Rec.SendToPosting(Codeunit::"Sales-Post + Print");
                end;
            }
        }



        addafter("Work Order")
        {
            action("Email Work Order")
            {
                ApplicationArea = All;
                Caption = 'Email Work Order';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';

                trigger OnAction();
                begin
                    cu_GeneralMgt.EmailSalesOrder(Rec, Usage::"Work Order");

                end;
            }

            action("Email Work Order Multiple")
            {
                ApplicationArea = All;
                Caption = 'Email Work Order Multiple';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';

                trigger OnAction();
                begin
                    cu_GeneralMgt.EmailSalesOrderMultiple(Rec, Usage::"Work Order");

                end;
            }

            action("Email Work Order Parameters")
            {
                ApplicationArea = All;
                Caption = 'Email Work Order Parameters';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';
                Visible = false;
                trigger OnAction();
                var
                    parameters: Text;
                    rpt_WorkOrder: Report "Work Order Lidl";
                    SalesHeader: Record "Sales Header";
                    SalesLineWorkOrder: Record "Sales Line";
                begin
                    SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesHeader);


                    Clear(rpt_WorkOrder);
                    rpt_WorkOrder.SetTableView(SalesHeader);

                    SalesLineWorkOrder.Reset;
                    SalesLineWorkOrder.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLineWorkOrder.SetFilter("Document No.", SalesHeader."No.");
                    SalesLineWorkOrder.SetRange(Type, SalesLineWorkOrder.Type::Item);
                    SalesLineWorkOrder.SetFilter("Location Code", '%1', 'ARAD-3');
                    if SalesLineWorkOrder.FindSet then;

                    rpt_WorkOrder.SetTableView(SalesLineWorkOrder);

                    //rpt_WorkOrder.RunModal();


                    parameters := rpt_WorkOrder.RunRequestPage();
                    Message(parameters);
                    //<?xml version="1.0" standalone="yes"?><ReportParameters name="Work Order Lidl" id="50006"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(%1))</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Line">VERSION(1) SORTING(Field1,Field3,Field4) WHERE(Field1=1(1),Field3=1(%1),Field5=1(2),Field7=1(%2))</DataItem><DataItem name="Order Qty">VERSION(1) SORTING(Field40)</DataItem><DataItem name="Sales Comment Line">VERSION(1) SORTING(Field1,Field2,Field7,Field3)</DataItem><DataItem name="Extra Lines">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>
                end;
            }


            action("Item Tracking Appendix")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    vL_SalesHeader: Record "Sales Header";
                begin
                    vL_SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(vL_SalesHeader);
                    vL_SalesHeader.PrintAppendixRecords(vL_SalesHeader);
                end;
            }


        }

        addafter(PageInteractionLogEntries)
        {
            action(LidlOrderHistory)
            {
                Caption = 'Lidl Order History';
                ApplicationArea = All;
                RunObject = page "Lidl Order Archive";
                RunPageLink = "Sales Order No." = field("No.");
                ToolTip = 'Executes the Lidl Order History action.';
            }
        }

        addafter(AssemblyOrders)
        {
            action(OrderQty)
            {
                Caption = 'Order Qty';
                ApplicationArea = All;
                ToolTip = 'Executes the Order Qty action.';
                //RunObject = page "Order Qty";
                //  RunPageLink = "Customer No." = field("Sell-to Customer No."),
                // "Order Date" = field("Order Date");   //"Document No." = field("No.");

                trigger OnAction()
                var
                    OrderQty: Record "Order Qty";
                begin
                    OrderQty.Reset;
                    OrderQty.SetCurrentKey("Customer No.", "Order Date", "Shelf No.", "Version No.");
                    OrderQty.SetFilter("Customer No.", Rec."Sell-to Customer No.");
                    OrderQty.SetRange("Order Date", Rec."Order Date");
                    if OrderQty.FindSet() then begin
                        Page.Run(Page::"Order Qty", OrderQty);
                    end;

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //+TAL0.5
        vG_EditWebOrder := true;
        if rG_UserSetup.Get(UserId) then begin
            if (rG_UserSetup."User Department" = rG_UserSetup."User Department"::"Web Order") and (rG_UserSetup."Sales Resp. Ctr. Filter" <> '') then begin
                vG_EditWebOrder := false;
            end;
        end;
        //-TAL0.5
    end;

    trigger OnAfterGetRecord()
    begin
        HorecaStatusStyleTxt := Rec.GetHorecaStatusStyleText();
    end;

    var
        [InDataSet]
        vG_EditWebOrder: Boolean;
        rG_UserSetup: Record "User Setup";
        cu_GeneralMgt: Codeunit "General Mgt.";

        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";

        HorecaStatusStyleTxt: Text;
}
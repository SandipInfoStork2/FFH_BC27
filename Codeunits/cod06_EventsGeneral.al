
codeunit 50006 EventsGeneral
{

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Receipt Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLineRRH(ReturnRcptHeader: Record "Return Receipt Header"; SalesLine: Record "Sales Line"; var ReturnRcptLine: Record "Return Receipt Line")
    begin
        ReturnRcptLine."Net Weight" := SalesLine."Net Weight";
        ReturnRcptLine."Total Net Weight" := ReturnRcptLine."Quantity (Base)" * ReturnRcptLine."Net Weight";

        //ReturnRcptLine."Country/Region of Origin Code" := SalesLine."Country/Region of Origin Code";
        //ReturnRcptLine."Req. Country" := SalesLine."Req. Country";
        ReturnRcptLine."Product Class" := SalesLine."Product Class";
        ReturnRcptLine."Category 9" := SalesLine."Category 9";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnValidateItemNoOnAfterUpdateUOMFromItem', '', false, false)]
    local procedure OnValidateItemNoOnAfterUpdateUOMFromItem(var ProdOrderComponent: Record "Prod. Order Component"; xProdOrderComponent: Record "Prod. Order Component"; Item: Record Item)
    begin
        ProdOrderComponent."Item Category Code" := Item."Item Category Code"; //TAL0.1
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnUpdateDescriptionFromItem', '', false, false)]
    local procedure OnUpdateDescriptionFromItem(var RequisitionLine: Record "Requisition Line"; Item: Record Item)
    begin
        RequisitionLine."Extended Description" := Item."Extended Description";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnBeforeValidateReplenishmentSystem', '', false, false)]
    local procedure OnBeforeValidateReplenishmentSystem(var RequisitionLine: Record "Requisition Line"; StockkeepingUnit: Record "Stockkeeping Unit"; var IsHandled: Boolean)
    begin
        IsHandled := true;
        //comment from update
    end;

    //+1.0.0.46 
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem_Req_line(var RequisitionLine: Record "Requisition Line"; Item: Record Item)
    begin
        RequisitionLine.UpdateDescription();
    end;
    //-1.0.0.46 


    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLineCR(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; PurchLine: Record "Purchase Line"; var PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    begin
        PurchCrMemoLine."Net Weight" := PurchLine."Net Weight";
        PurchCrMemoLine."Total Net Weight" := PurchCrMemoLine."Quantity (Base)" * PurchCrMemoLine."Net Weight";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLineIn(PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; var PurchInvLine: Record "Purch. Inv. Line")
    begin
        PurchInvLine."Net Weight" := PurchLine."Net Weight";
        PurchInvLine."Total Net Weight" := PurchInvLine."Quantity (Base)" * PurchInvLine."Net Weight";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin

        PurchRcptLine."Net Weight" := PurchLine."Net Weight";
        PurchRcptLine."Total Net Weight" := PurchRcptLine."Quantity (Base)" * PurchRcptLine."Net Weight";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLineSCML(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line")
    begin
        SalesCrMemoLine."Net Weight" := SalesLine."Net Weight";
        SalesCrMemoLine."Total Net Weight" := SalesCrMemoLine."Quantity (Base)" * SalesCrMemoLine."Net Weight";
        //SalesCrMemoLine."Req. Country" := SalesLine."Req. Country";
        //SalesCrMemoLine."Country/Region of Origin Code" := SalesLine."Country/Region of Origin Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item; CurrentFieldNo: Integer)
    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        SRSetup.Get();

        //+TAL0.3
        Item.CalcFields("Packing Group Description");
        SalesLine."Packing Group Description" := Item."Packing Group Description";
        SalesLine.Validate("Shelf No.", Item."Shelf No.");
        SalesLine."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
        SalesLine."Package Qty" := Item."Package Qty";
        SalesLine."Unit of Measure (Base)" := Item."Base Unit of Measure";
        //-TAL0.3


        SalesLine."Product Class" := Item."Category 8"; //'Product Class'
        //+1.0.0.291
        if Item."Inventory Posting Group" = SRSetup."Fresh Inventory Posting Group" then begin
            //if SalesLine."Req. Country" = '' then begin
            if SalesLine."Country/Region of Origin Code" = '' then begin
                SalesLine."Country/Region of Origin Code" := SRSetup."Default Country of Origin Code";
                //SalesLine."Req. Country" := SRSetup."Default Country of Origin Code";
            end;

            if SalesLine."Product Class" = '' then begin
                SalesLine."Product Class" := SRSetup."Default Product Class";
            end;
        end;
        //+1.0.0.291

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLine_SSL(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        SalesShptLine."Net Weight" := SalesLine."Net Weight";
        SalesShptLine."Total Net Weight" := SalesShptLine."Quantity (Base)" * SalesShptLine."Net Weight";
        //SalesShptLine."Req. Country" := SalesLine."Country/Region of Origin Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLine_SIL(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        SalesInvLine."Net Weight" := SalesLine."Net Weight";
        SalesInvLine."Total Net Weight" := SalesInvLine."Quantity (Base)" * SalesInvLine."Net Weight";
        //SalesInvLine."Req. Country" := SalesLine."Country/Region of Origin Code";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeader_TSH(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        //TAL 0.1 ANP
        TransferShipmentHeader."Salesperson Code" := TransferHeader."Salesperson Code";
        TransferShipmentHeader."Salesperson Name" := TransferHeader."Salesperson Name";
        //TAL 0.1 ANP
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeader_TRH(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        //TAL 0.1 ANP 
        TransferReceiptHeader."Salesperson Code" := TransferHeader."Salesperson Code";
        TransferReceiptHeader."Salesperson Name" := TransferHeader."Salesperson Name";
        //TAL 0.1 ANP

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Item Tracking Appendix" then
            NewReportId := Report::"Item Tracking Appendix FFH";

        if ReportId = Report::"Customer - Detail Trial Bal." then
            NewReportId := Report::"Customer - Detail Trial Bal. F";

        if ReportId = Report::"Customer - Payment Receipt" then
            NewReportId := Report::"Customer - Payment Receipt FFH";



        if ReportId = Report::"Vendor - Payment Receipt" then
            NewReportId := Report::"Vendor - Payment Receipt FFH";

        //vendor
        if ReportId = Report::"Vendor - Detail Trial Balance" then
            NewReportId := Report::"Vend. - Detail Trial Balance F";

        if ReportId = Report::"Suggest Vendor Payments" then
            NewReportId := Report::"Suggest Vendor Payments FFH";

        //cost
        if ReportId = Report::"Post Inventory Cost to G/L" then
            NewReportId := Report::"Post Inventory Cost to G/L FFH";

        if ReportId = Report::"Adjust Cost - Item Entries" then
            NewReportId := Report::"Adjust Cost - Item Entries FFH";

        //bank
        if ReportId = Report::"Bank Acc. - Detail Trial Bal." then
            NewReportId := Report::"Bank Acc. - Detail Trial Bal.F";

        //warehouse
        if ReportId = Report::"Item Register - Quantity" then
            NewReportId := Report::"Item Register - Quantity FFH";

        if ReportId = Report::"Item Register - Value" then
            NewReportId := Report::"Item Register - Value FFH";

        if ReportId = Report::"Phys. Inventory List" then
            NewReportId := Report::"Phys. Inventory List FFH";

        if ReportId = Report::"Inventory Posting - Test" then
            NewReportId := Report::"Inventory Posting - Test FFH";

        //manufacturing
        if ReportId = Report::"Prod. Order Comp. and Routing" then
            NewReportId := Report::"Prod. Order Comp. and RoutingF";

        //Prices
        /*
        if ReportId = Report::"Item Price List" then
            NewReportId := Report::"Item Price List FFH";
            */

        if ReportId = Report::"Item Tracing Specification" then
            NewReportId := Report::"TAL:Item Tracing Specification";

    end;

    //BillToName logic comments in 2017
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateBillToName', '', false, false)]
    local procedure OnBeforeValidateBillToName(var SalesHeader: Record "Sales Header"; var Customer: Record Customer; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Payee Name (GL Cheque)" := Vendor.Name; //TAL0.1
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        ItemJnlLine."Document Lot No." := SalesHeader."Lot No."; //TAL0.3
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."Shelf No." := SalesLine."Shelf No."; //TAL0.3
    end;

    //+1.0.0.229
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyFromProdOrderLine', '', false, false)]
    local procedure OnAfterCopyFromProdOrderLine(var ItemJournalLine: Record "Item Journal Line"; ProdOrderLine: Record "Prod. Order Line")
    var
        ProductionOrder: Record "Production Order";

    begin
        ProductionOrder.Reset;
        ProductionOrder.SetRange(Status, ProdOrderLine.Status);
        ProductionOrder.SetFilter("No.", ProdOrderLine."Prod. Order No.");
        if ProductionOrder.FindSet() then begin
            ItemJournalLine."Packing Agent" := ProductionOrder."Packing Agent";
        end;

    end;
    //-1.0.0.229

    //+1.0.0.229
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyFromProdOrderComp', '', false, false)]
    local procedure OnAfterCopyFromProdOrderComp(var ItemJournalLine: Record "Item Journal Line"; ProdOrderComponent: Record "Prod. Order Component")
    var
        ProductionOrder: Record "Production Order";
    begin

        ProductionOrder.Reset;
        ProductionOrder.SetRange(Status, ProdOrderComponent.Status);
        ProductionOrder.SetFilter("No.", ProdOrderComponent."Prod. Order No.");
        if ProductionOrder.FindSet() then begin
            ItemJournalLine."Packing Agent" := ProductionOrder."Packing Agent";
        end;
    end;
    //-1.0.0.229

    [EventSubscriber(ObjectType::Page, Page::"Customer Report Selections", 'OnValidateUsage2OnCaseElse', '', false, false)]
    local procedure OnValidateUsage2OnCaseElse(var CustomReportSelection: Record "Custom Report Selection"; ReportUsage: Option)
    begin
        if Format(ReportUsage) = 'S.Ret.Rcpt' then begin
            CustomReportSelection.Usage := CustomReportSelection.Usage::"S.Ret.Rcpt.";
        end;

        //TAL 1.0.0.319 >>
        if Format(ReportUsage) = 'Payment Receipt' then begin
            CustomReportSelection.Usage := CustomReportSelection.Usage::"Payment Receipt";
        end;
        //TAL 1.0.0.319 <<
    end;

    /* [EventSubscriber(ObjectType::page, page::"Customer Report Selections", 'OnMapTableUsageValueToPageValueOnCaseElse', '', false, false)]
    local procedure OnMapTableUsageValueToPageValueOnCaseElse(CustomReportSelection: Record "Custom Report Selection"; var ReportUsage: Option)
    var
        Usage2: Option Quote,"Confirmation Order",Invoice,"Credit Memo","Customer Statement","Job Quote",Reminder,Shipment,"S.Ret.Rcpt.","Payment Receipt";
    begin
        case CustomReportSelection.Usage of
            CustomReportSelection.Usage::"S.Ret.Rcpt.":
                ReportUsage := Usage2::"S.Ret.Rcpt.";

            //TAL 1.0.0.319 >>
            CustomReportSelection.Usage::"Payment Receipt":
                ReportUsage := Usage2::"Payment Receipt";
        //TAL 1.0.0.319 <<
        end;
    end; */

    [EventSubscriber(ObjectType::Page, Page::"Customer Report Selections", 'OnAfterOnMapTableUsageValueToPageValue', '', false, false)]
    local procedure OnMapTableUsageValueToPageValueOnCaseElse(CustomReportSelection: Record "Custom Report Selection"; var Usage2: Enum "Custom Report Selection Sales")
    var
    //Usage2: Option Quote,"Confirmation Order",Invoice,"Credit Memo","Customer Statement","Job Quote",Reminder,Shipment,"S.Ret.Rcpt.","Payment Receipt";
    begin
        case CustomReportSelection.Usage of
            CustomReportSelection.Usage::"S.Ret.Rcpt.":
                Usage2 := Usage2::"S.Ret.Rcpt.";

            //TAL 1.0.0.319 >>
            CustomReportSelection.Usage::"Payment Receipt":
                Usage2 := Usage2::"Payment Receipt";
        //TAL 1.0.0.319 <<
        end;
    end;

    //TAL 1.0.0.319 >>
    [EventSubscriber(ObjectType::Page, Page::"Vendor Report Selections", 'OnValidateUsage2OnCaseElse', '', false, false)]
    local procedure OnValidateUsage2OnCaseElseVend(var CustomReportSelection: Record "Custom Report Selection"; ReportUsage: Enum "Report Selection Usage Vendor")
    begin
        if Format(ReportUsage) = 'Vendor Receipt' then begin
            CustomReportSelection.Usage := CustomReportSelection.Usage::"Vendor Receipt";
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor Report Selections", 'OnMapTableUsageValueToPageValueOnCaseElse', '', false, false)]
    local procedure OnMapTableUsageValueToPageValueOnCaseElseVend(CustomReportSelection: Record "Custom Report Selection"; var ReportUsage: Enum "Report Selection Usage Vendor"; Rec: Record "Custom Report Selection")
    begin
        case CustomReportSelection.Usage of
            "Report Selection Usage"::"Vendor Receipt":
                ReportUsage := "Report Selection Usage Vendor"::"Vendor Receipt";
        end;
    end;
    //TAL 1.0.0.319 <<

    /*
    cu22
    TAL0.1 2020/03/04 VC Transfer Grower Fields;
    TAL0.2 2021/03/26 VC Transfer Document Lot No, Shelf No.  
    TAL0.3 2021/04/02 VC Update the Lot Grower No. from Lot information card

    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        rL_Item: Record Item;
        rL_LotNoInformation: Record "Lot No. Information";
    begin
        //+TAL0.1
        //ItemLedgEntry."Vendor No.":="Vendor No.";
        //ItemLedgEntry."Grower No.":="Grower No.";
        //-TAL0.1

        //+TAL0.2
        NewItemLedgEntry."Shelf No." := ItemJournalLine."Shelf No.";
        NewItemLedgEntry."Document Lot No." := ItemJournalLine."Document Lot No.";
        //-TAL0.2

        //+TAL0.3
        rL_LotNoInformation.Reset;
        rL_LotNoInformation.SetFilter("Item No.", NewItemLedgEntry."Item No.");
        rL_LotNoInformation.SetFilter("Lot No.", NewItemLedgEntry."Lot No.");
        if rL_LotNoInformation.FindSet then begin
            NewItemLedgEntry."Lot Grower No." := rL_LotNoInformation."Grower No.";
        end;
        //-TAL0.3

        //+TAL0.2
        rL_Item.Get(ItemJournalLine."Item No.");
        NewItemLedgEntry."Net Weight" := rL_Item."Net Weight";
        NewItemLedgEntry."Total Net Weight" := NewItemLedgEntry."Net Weight" * NewItemLedgEntry.Quantity;
        //-TAL0.2

        NewItemLedgEntry."Packing Agent" := ItemJournalLine."Packing Agent";
    end;

    /*
    cu 80
    TAL0.1 2018/11/04 VC EDI control

    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)]
    local procedure OnAfterCheckSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
        cu_GeneralMgt: Codeunit "General Mgt.";
    begin
        cu_GeneralMgt.CheckEDISH(SalesHeader); //TAL0.1
    end;


    /*
    cu 391
    TAL0.1 2020/03/04 update Delivery
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        //+TAL0.1
        SalesShptHeader."Delivery No." := FromSalesShptHeader."Delivery No.";
        SalesShptHeader."Delivery Sequence" := FromSalesShptHeader."Delivery Sequence";
        //-TAL0.1

        SalesShptHeader."Shipping Temperature" := FromSalesShptHeader."Shipping Temperature";
        SalesShptHeader."Shipping Quality Control" := FromSalesShptHeader."Shipping Quality Control";
    end;


    //******************************************************************
    //**
    //** Job Queue
    //**
    //******************************************************************

    //******************************************************************
    //**
    //** Job Queue
    //**
    //******************************************************************
    procedure StartJobQueue(var pJobQueueEntry: Record "Job Queue Entry")
    var
        cu_JobQueueDispatcher: Codeunit "Job Queue Dispatcher";
    begin
        Clear(cu_JobQueueDispatcher);
        cu_JobQueueDispatcher.Run(pJobQueueEntry);
        //cu_JobQueueDispatcher.HandleRequest();
        Message(Format(pJobQueueEntry.Status));
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Dispatcher", 'OnAfterHandleRequest', '', false, false)]
    local procedure OnAfterHandleRequest(var JobQueueEntry: Record "Job Queue Entry"; WasSuccess: Boolean)
    var
        rL_UserSetup: Record "User Setup";
        SenderAddress: Text;
        SenderAddressList: List of [Text];
        SMTP: Codeunit "SMTP Mail";
        Subject: Text;
        Body: Text;
        FromUser: Text;
        SenderName: Text;
        rL_JobQueueLogEntry: Record "Job Queue Log Entry";
        rL_CompanySetup: Record "Company Information";
        rL_SMTP: Record "SMTP Mail Setup";
        Text50000: Label '<br/><br/><br/> This is an automatically generated email.<br/> Powered by <a href="www.talosco.com/">Microsoft Dynamics NAV</a>';
    begin
        if (JobQueueEntry."Notify On Success") or (JobQueueEntry."Email Result") then begin
            rL_CompanySetup.GET;
            rL_CompanySetup.TESTFIELD("E-Mail");

            rL_UserSetup.RESET;
            rL_UserSetup.SETRANGE(rL_UserSetup."Job Queue Email", TRUE);
            rL_UserSetup.SETFILTER(rL_UserSetup."E-Mail", '<>%1', '');
            IF rL_UserSetup.FINDFIRST THEN BEGIN
                REPEAT
                    IF SenderAddress = '' THEN
                        SenderAddress := rL_UserSetup."E-Mail"
                    ELSE
                        SenderAddress := SenderAddress + ';' + rL_UserSetup."E-Mail";
                UNTIL rL_UserSetup.NEXT = 0;
            END ELSE
                EXIT;

            //+TAL0.3
            rL_JobQueueLogEntry.RESET;
            rL_JobQueueLogEntry.SETRANGE(ID, JobQueueEntry.ID);
            //rL_JobQueueEntry.SETRANGE("Entry No.", JobQueueEntry."Entry No.");
            IF rL_JobQueueLogEntry.FindLast() THEN BEGIN
                //rL_JobQueueEntry.CALCFIELDS("Object Name to Run");

                //+TAL.0.2
                rL_SMTP.GET;
                FromUser := rL_SMTP."User ID";
                //-TAL.0.2

                rL_JobQueueLogEntry.CALCFIELDS("Object Caption to Run");

                Subject := rL_JobQueueLogEntry."Object Caption to Run" + ' - Status: ' + FORMAT(rL_JobQueueLogEntry.Status);//+' '+rL_JobQueueEntry."Object Name to Run";
                                                                                                                            // +' '+ pJobQueueLogEntry."Object Name to Run"
                Body := 'Entry No: ' + FORMAT(rL_JobQueueLogEntry."Entry No.") + ' Status: ' + FORMAT(rL_JobQueueLogEntry.Status);
                if rL_JobQueueLogEntry."Error Message" <> '' then begin
                    Body += ' - ' + rL_JobQueueLogEntry."Error Message";
                end;

                SenderName := COMPANYNAME;
                SenderAddressList.Add(SenderAddress);
                SMTP.CreateMessage(SenderName, FromUser, SenderAddressList, Subject, Body, TRUE);

                Body := '<br>Start Time: ' + FORMAT(rL_JobQueueLogEntry."Start Date/Time");
                SMTP.AppendBody(Body);

                Body := '<br>End Time: ' + FORMAT(rL_JobQueueLogEntry."End Date/Time");
                SMTP.AppendBody(Body);

                Body := Text50000;
                SMTP.AppendBody(Body);


                SMTP.Send;
            END;
        end;

    end;
    */

    //******************************
    //**
    //**
    //** Payment Exports
    //**
    //**
    //*******************************

    //+1498
    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", 'OnAfterSetVendorAsRecipient', '', false, false)]
    local procedure OnAfterSetVendorAsRecipient(var PaymentExportData: Record "Payment Export Data"; var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account");
    var
        CRLF: array[2] of Char;
        vL_SpecialChars: Text;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        vL_SpecialChars := '\/:*?"<>|''';
        //+1502
        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', CRLF[1]);
        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', CRLF[2]);
        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', vL_SpecialChars);
        PaymentExportData."Recipient Address" := ConvertStr(PaymentExportData."Recipient Address", ''' ', '  ');

        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', CRLF[1]);
        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', CRLF[2]);
        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', vL_SpecialChars);
        PaymentExportData."Recipient Address 2" := ConvertStr(PaymentExportData."Recipient Address 2", ''' ', '  ');

        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', CRLF[1]);
        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', CRLF[2]);
        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', vL_SpecialChars);
        PaymentExportData."Recipient Name" := ConvertStr(PaymentExportData."Recipient Name", ''' ', '  ');




        //"Recipient Address" := CONVERTSTR("Recipient Address", vL_SpecialChars, '          ');
        //"Recipient Address 2" := CONVERTSTR("Recipient Address 2", vL_SpecialChars, '          ');
        //"Recipient Name" := CONVERTSTR("Recipient Name", vL_SpecialChars, '          ');

        PaymentExportData."Recipient Address" := CopyStr(PaymentExportData."Recipient Address", 1, 35);
        PaymentExportData."Recipient Address 2" := CopyStr(PaymentExportData."Recipient Address 2", 1, 35);
        PaymentExportData."Recipient Name" := CopyStr(PaymentExportData."Recipient Name", 1, 35);
        PaymentExportData."Applies-to Ext. Doc. No." := '';
        //message(format(StrLen("Recipient Address")));
        //+1502
    end;


    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", 'OnAfterSetCustomerAsRecipient', '', false, false)]
    local procedure OnAfterSetCustomerAsRecipient(var PaymentExportData: Record "Payment Export Data"; var Customer: Record Customer; var CustomerBankAccount: Record "Customer Bank Account");
    var
        CRLF: array[2] of Char;
        vL_SpecialChars: Text;
    begin
        //+1502
        CRLF[1] := 13;
        CRLF[2] := 10;
        vL_SpecialChars := '\/:*?"<>|''';

        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', CRLF[1]);
        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', CRLF[2]);
        PaymentExportData."Recipient Address" := DelChr(PaymentExportData."Recipient Address", '=', vL_SpecialChars);
        PaymentExportData."Recipient Address" := ConvertStr(PaymentExportData."Recipient Address", ''' ', '  ');

        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', CRLF[1]);
        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', CRLF[2]);
        PaymentExportData."Recipient Address 2" := DelChr(PaymentExportData."Recipient Address 2", '=', vL_SpecialChars);
        PaymentExportData."Recipient Address 2" := ConvertStr(PaymentExportData."Recipient Address 2", ''' ', '  ');

        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', CRLF[1]);
        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', CRLF[2]);
        PaymentExportData."Recipient Name" := DelChr(PaymentExportData."Recipient Name", '=', vL_SpecialChars);
        PaymentExportData."Recipient Name" := ConvertStr(PaymentExportData."Recipient Name", ''' ', '  ');


        //"Recipient Address" := CONVERTSTR("Recipient Address", vL_SpecialChars, '          ');
        //"Recipient Address 2" := CONVERTSTR("Recipient Address 2", vL_SpecialChars, '          ');
        //"Recipient Name" := CONVERTSTR("Recipient Name", vL_SpecialChars, '          ');

        PaymentExportData."Recipient Address" := CopyStr(PaymentExportData."Recipient Address", 1, 35);
        PaymentExportData."Recipient Address 2" := CopyStr(PaymentExportData."Recipient Address 2", 1, 35);
        PaymentExportData."Recipient Name" := CopyStr(PaymentExportData."Recipient Name", 1, 35);
        PaymentExportData."Applies-to Ext. Doc. No." := '';
        //-1502
    end;

    /* [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", 'OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer', '', false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary; SummarizePerVend: Boolean)
    begin
        GenJournalLine."Message to Recipient" := '';
    end; */
    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", 'OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer', '', false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary; SummarizePerVend: Boolean)
    begin
        GenJournalLine."Message to Recipient" := '';
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeShowStatusMessage', '', false, false)]
    local procedure OnBeforeShowStatusMessage(ProdOrder: Record "Production Order"; ToProdOrder: Record "Production Order"; var IsHandled: Boolean)
    var
        Text000: Label '%2 %3  with status %1 has been changed to %5 %6 with status %4.';
    begin
        Message(Text000, ProdOrder.Status, ProdOrder.TableCaption, ProdOrder."No.", ToProdOrder.Status, ToProdOrder.TableCaption, ToProdOrder."No.");

        ProdOrder.Reset;
        ProdOrder.SetRange(Status, ToProdOrder.Status); //TAL0.2
        ProdOrder.SetFilter("No.", ToProdOrder."No."); //TAL0.2
        if ProdOrder.FindSet then begin
            Report.Run(Report::"Prod. Order Comp. and Routing", true, true, ProdOrder);
        end;

        IsHandled := true;
    end;

    /*
       TAL0.1 2021/04/09 VC when undo shipment undo the Weights
   */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Purchase Receipt Line", 'OnBeforeNewPurchRcptLineInsert', '', false, false)]
    local procedure OnBeforeNewPurchRcptLineInsert(var NewPurchRcptLine: Record "Purch. Rcpt. Line"; OldPurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        //+TAL0.1
        NewPurchRcptLine."Net Weight" := OldPurchRcptLine."Net Weight";
        //NewPurchRcptLine."Total Net Weight" := NewPurchRcptLine."Net Weight" * NewPurchRcptLine."Quantity (Base)";
        NewPurchRcptLine."Gross Weight" := OldPurchRcptLine."Gross Weight";
        //-TAL0.1
    end;

    /*
        TAL0.1 2021/04/09 VC when undo shipment undo the Weights
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Return Shipment Line", 'OnBeforeNewReturnShptLineInsert', '', false, false)]
    local procedure OnBeforeNewReturnShptLineInsert(var NewReturnShipmentLine: Record "Return Shipment Line"; OldReturnShipmentLine: Record "Return Shipment Line")
    begin
        //+TAL0.1
        NewReturnShipmentLine."Net Weight" := OldReturnShipmentLine."Net Weight";
        //NewReturnShipmentLine."Total Net Weight" := NewReturnShipmentLine."Net Weight" * NewReturnShipmentLine.Quantity;
        NewReturnShipmentLine."Gross Weight" := OldReturnShipmentLine."Gross Weight";
        //-TAL0.1
    end;

    /*
        TAL0.1 2021/02/17 VC when undo shipment undo the Weights
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Sales Shipment Line", 'OnBeforeNewSalesShptLineInsert', '', false, false)]
    local procedure OnBeforeNewSalesShptLineInsert(var NewSalesShipmentLine: Record "Sales Shipment Line"; OldSalesShipmentLine: Record "Sales Shipment Line")
    begin
        //+TAL0.1
        NewSalesShipmentLine."Net Weight" := OldSalesShipmentLine."Net Weight";
        //NewSalesShipmentLine."Total Net Weight" := NewSalesShipmentLine."Net Weight" * NewSalesShipmentLine."Quantity (Base)";
        NewSalesShipmentLine."Gross Weight" := OldSalesShipmentLine."Gross Weight";
        //-TAL0.1

        //+1.0.0.176  
        if OldSalesShipmentLine."Qty. Requested" <> 0 then begin
            NewSalesShipmentLine."Qty. Requested" := -OldSalesShipmentLine."Qty. Requested";
            NewSalesShipmentLine."Qty. Confirmed" := OldSalesShipmentLine."Qty. Confirmed";
        end;
        //-1.0.0.176  
    end;

    /*
        TAL0.1 2021/04/09 VC when undo shipment undo the Weights
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Return Receipt Line", 'OnBeforeNewReturnRcptLineInsert', '', false, false)]
    local procedure OnBeforeNewReturnRcptLineInsert(var NewReturnReceiptLine: Record "Return Receipt Line"; OldReturnReceiptLine: Record "Return Receipt Line")
    begin
        //+TAL0.1
        NewReturnReceiptLine."Net Weight" := OldReturnReceiptLine."Net Weight";
        //NewReturnReceiptLine."Total Net Weight" := NewReturnReceiptLine."Net Weight" * NewReturnReceiptLine."Quantity (Base)";
        NewReturnReceiptLine."Gross Weight" := OldReturnReceiptLine."Gross Weight";
        //-TAL0.1
    end;

    //+1.0.0.22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        rL_SalesInvoiceHeader: Record "Sales Invoice Header";
        rL_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        rL_Customer: Record Customer;
    begin

        //is not the work order
        if ReportUsage <> 40 then begin
            if TempEmailItem."Send BCC" <> '' then begin
                TempEmailItem."Send BCC" := '';
            end;

            if TempEmailItem."Send CC" <> '' then begin
                TempEmailItem."Send CC" := '';
            end;

        end;

        //email to co workers
        if ReportUsage = 40 then begin
            TempEmailItem."Send to" := TempEmailItem."Send CC";
            TempEmailItem."Send CC" := '';
        end;

        if (IsFromPostedDoc) and (PostedDocNo <> '') then begin
            if rL_SalesInvoiceHeader.Get(PostedDocNo) then begin
                rL_Customer.Get(rL_SalesInvoiceHeader."Bill-to Customer No.");
                if (TempEmailItem."Send CC" = '') and (rL_Customer."E-Mail CC" <> '') then begin
                    TempEmailItem."Send CC" := rL_Customer."E-Mail CC";
                end;
            end;

            if rL_SalesCrMemoHeader.Get(PostedDocNo) then begin
                rL_Customer.Get(rL_SalesCrMemoHeader."Bill-to Customer No.");
                if (TempEmailItem."Send CC" = '') and (rL_Customer."E-Mail CC" <> '') then begin
                    TempEmailItem."Send CC" := rL_Customer."E-Mail CC";
                end;
            end;
        end;

    end;
    //-1.0.0.22

    //+1.0.0.24
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Email Scenario Mapping", 'OnAfterFromReportSelectionUsage', '', false, false)]
    local procedure OnAfterFromReportSelectionUsage(ReportSelectionUsage: Enum "Report Selection Usage"; var EmailScenario: Enum "Email Scenario")
    begin
        case ReportSelectionUsage of
            ReportSelectionUsage::"S.Work Order":
                begin
                    EmailScenario := EmailScenario::"Work Order";
                end;

            ReportSelectionUsage::"Payment Receipt":
                begin
                    EmailScenario := EmailScenario::"Payment Receipt";
                end;

            ReportSelectionUsage::"Vendor Receipt":
                begin
                    EmailScenario := EmailScenario::"Vendor Receipt";
                end;


        end;
    end;
    //-1.0.0.24


    //+1.0.0.42 
    //item templates are not empty
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnTemplatesAreNotEmpty', '', false, false)]
    local procedure OnTemplatesAreNotEmpty(var Result: Boolean; var IsHandled: Boolean)
    begin
        Result := false;
        IsHandled := true;
    end;
    //-1.0.0.42 


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post+Print", 'OnBeforePrintItemRegister', '', false, false)]
    local procedure OnBeforePrintItemRegister(ItemRegister: Record "Item Register"; ItemJournalTemplate: Record "Item Journal Template"; var IsHandled: Boolean)
    var
        vL_Text50000: Label 'Print %1 report?';

    begin

        //ItemReg.SetRecFilter();
        //Report.Run(ItemJnlTemplate."Posting Report ID", false, false, ItemReg);

        ItemRegister.SetRecFilter();
        Report.Run(ItemJournalTemplate."Posting Report ID", false, false, ItemRegister);

        if ItemJournalTemplate."Posting Report ID 2" <> 0 then begin
            ItemJournalTemplate.CalcFields("Posting Report Caption 2");

            if Confirm(StrSubstNo(vL_Text50000, ItemJournalTemplate."Posting Report Caption 2"), true) then begin
                Report.Run(ItemJournalTemplate."Posting Report ID 2", false, false, ItemRegister);
            end;

        end;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        IsChanged := (SalesInvoiceHeader."Payment Method Code" <> xSalesInvoiceHeader."Payment Method Code") or
(SalesInvoiceHeader."Payment Reference" <> xSalesInvoiceHeader."Payment Reference") or
(SalesInvoiceHeader."Sell-to E-Mail" <> xSalesInvoiceHeader."Sell-to E-Mail") or
(SalesInvoiceHeader."Customer Reference No." <> xSalesInvoiceHeader."Customer Reference No.") or
(SalesInvoiceHeader."Reason Code" <> xSalesInvoiceHeader."Reason Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnOnRunOnBeforeTestFieldNo', '', false, false)]
    local procedure OnOnRunOnBeforeTestFieldNo(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Sell-to E-Mail" := SalesInvoiceHeaderRec."Sell-to E-Mail";
        SalesInvoiceHeader."Customer Reference No." := SalesInvoiceHeaderRec."Customer Reference No.";
        SalesInvoiceHeader."Reason Code" := SalesInvoiceHeaderRec."Reason Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        if Item."Location Code" <> '' then begin
            SalesLine.Validate("Location Code", Item."Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line"; ItemJournalTemplate: Record "Item Journal Template")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Get(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        if ItemJnlBatch."Def. Gen. Bus. Posting Group" <> '' then begin
            ItemJournalLine."Gen. Bus. Posting Group" := ItemJnlBatch."Def. Gen. Bus. Posting Group";
        end;

        //inherited from Item card
        if ItemJnlBatch."Def. Gen. Prod. Posting Group" <> '' then begin
            ItemJournalLine."Gen. Prod. Posting Group" := ItemJnlBatch."Def. Gen. Prod. Posting Group";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracing Buffer", 'OnAfterCopyTrackingFromItemLedgEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemLedgEntry(var ItemTracingBuffer: Record "Item Tracing Buffer"; ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ItemLedgEntry.CalcFields("Reason Code");
        ItemTracingBuffer."Reason Code" := ItemLedgEntry."Reason Code";
        // ItemTracingBuffer."Expiration Date" := ItemLedgEntry."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", 'OnBeforeInsertItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; var InventoryBuffer: Record "Inventory Buffer");
    var
        ItemJnlBatch: Record "Item Journal Batch";
        Location: Record Location;
    begin

        ItemJnlBatch.Get(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        if ItemJnlBatch."Def. Gen. Bus. Posting Group" <> '' then begin
            ItemJournalLine."Gen. Bus. Posting Group" := ItemJnlBatch."Def. Gen. Bus. Posting Group";
        end;

        if Location.Get(ItemJournalLine."Location Code") then begin
            if (Location."Default Reason Code" <> '') and (ItemJournalLine."Reason Code" = '') then begin
                ItemJournalLine."Reason Code" := Location."Default Reason Code";
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Code", 'OnAfterIsSpecificTrackingChanged', '', false, false)]
    local procedure OnAfterIsSpecificTrackingChanged(ItemTrackingCode: Record "Item Tracking Code"; ItemTrackingCode2: Record "Item Tracking Code"; var TrackingChanged: Boolean)
    var
        InvSetup: Record "Inventory Setup";

    begin
        InvSetup.Get();
        if InvSetup."Allow Change Tracking Code" then begin
            TrackingChanged := false;
        end;


    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Code", 'OnAfterIsWarehouseTrackingChanged', '', false, false)]
    local procedure OnAfterIsWarehouseTrackingChanged(ItemTrackingCode: Record "Item Tracking Code"; ItemTrackingCode2: Record "Item Tracking Code"; var TrackingChanged: Boolean)
    var
        InvSetup: Record "Inventory Setup";
    begin
        InvSetup.Get();
        if InvSetup."Allow Change Tracking Code" then begin
            TrackingChanged := false;
        end;
    end;

    //+1.0.0.110
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertToSalesLine', '', false, false)]
    local procedure OnBeforeInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; FromDocType: Option; RecalcLines: Boolean; var ToSalesHeader: Record "Sales Header"; DocLineNo: Integer; var NextLineNo: Integer; RecalculateAmount: Boolean)
    var
        SRSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
    begin
        if (FromSalesLine.Type = FromSalesLine.Type::Item) and (FromSalesLine."No." = '') then begin
            ToSalesLine.Type := ToSalesLine.Type::" ";
        end;
        //transfer

        //+1.0.0.176  
        ToSalesLine.Validate("Qty Box Date 1", FromSalesLine."Qty Box Date 1");
        ToSalesLine.Validate("Qty Box Date 2", FromSalesLine."Qty Box Date 2");
        ToSalesLine.Validate("Qty Box Date 3", FromSalesLine."Qty Box Date 3");
        ToSalesLine.Validate("Qty Box Date 4", FromSalesLine."Qty Box Date 4");
        ToSalesLine.Validate("Qty Box Date 5", FromSalesLine."Qty Box Date 5");
        ToSalesLine.Validate("Qty Box Date 6", FromSalesLine."Qty Box Date 6");
        ToSalesLine.Validate("Qty Box Date 7", FromSalesLine."Qty Box Date 7");
        ToSalesLine.Validate("Qty Box Date 8", FromSalesLine."Qty Box Date 8");
        //-1.0.0.176  

        if ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Quote then begin
            SRSetup.Get;
            GLSetup.Get;
            if (ToSalesHeader."Sell-to Customer No." = SRSetup."Lidl Customer No.") and (SRSetup."Lidl Customer No." <> '') then begin
                if (FromSalesLine."No." = '') and (FromSalesLine.Description <> '') then begin

                    /*
                     ToSalesLine."Document Type" := ToSalesHeader."Document Type";
                     ToSalesLine."Document No." := ToSalesHeader."No.";
                     ToSalesLine."Line No." := NextLineNo;
                   
                    tmpDocNo := ToSalesLine."Document No.";
                    tmpLineNo := ToSalesLine."Line No.";
                    ToSalesLine := FromSalesLine;

                    ToSalesLine."Document No." := tmpDocNo;
                    ToSalesLine."Line No." := tmpLineNo;
                     */

                    ToSalesLine."Shelf No." := FromSalesLine."Shelf No.";
                    ToSalesLine."Country/Region of Origin Code" := FromSalesLine."Country/Region of Origin Code";
                    ToSalesLine."Package Qty" := FromSalesLine."Package Qty";
                    ToSalesLine."Pallet Qty" := FromSalesLine."Pallet Qty";
                    ToSalesLine."Product Class" := FromSalesLine."Product Class";
                    ToSalesLine."Calibration Min." := FromSalesLine."Calibration Min.";
                    ToSalesLine."Calibration Max." := FromSalesLine."Calibration Max.";
                    ToSalesLine."Calibration UOM" := FromSalesLine."Calibration UOM";
                    ToSalesLine.Variety := FromSalesLine.Variety;
                    ToSalesLine."Additional Information" := FromSalesLine."Additional Information";
                    ToSalesLine."Pressure Min." := FromSalesLine."Pressure Min.";
                    ToSalesLine."Pressure Max." := FromSalesLine."Pressure Max.";
                    ToSalesLine."Brix Min" := FromSalesLine."Brix Min";
                    ToSalesLine."QC 1 Min" := FromSalesLine."QC 1 Min";
                    ToSalesLine."QC 1 Max" := FromSalesLine."QC 1 Max";
                    ToSalesLine."QC 1 Text" := FromSalesLine."QC 1 Text";
                    ToSalesLine."QC 2 Min" := FromSalesLine."QC 2 Min";
                    ToSalesLine."QC 2 Max" := FromSalesLine."QC 2 Max";
                    ToSalesLine."QC 2 Text" := FromSalesLine."QC 2 Text";
                    ToSalesLine."Box Width" := FromSalesLine."Box Width";
                    ToSalesLine."Box Char 1" := FromSalesLine."Box Char 1";
                    ToSalesLine."Box Length" := FromSalesLine."Box Length";
                    ToSalesLine."Box Char 2" := FromSalesLine."Box Char 2";
                    ToSalesLine."Box Height" := FromSalesLine."Box Height";
                    ToSalesLine."Box Changed Date" := FromSalesLine."Box Changed Date";
                    ToSalesLine."Harvest Temp. From" := FromSalesLine."Harvest Temp. From";
                    ToSalesLine."Harvest Temp. To" := FromSalesLine."Harvest Temp. To";
                    ToSalesLine."Freezer Harvest Temp. From" := FromSalesLine."Freezer Harvest Temp. From";
                    ToSalesLine."Freezer Harvest Temp. To" := FromSalesLine."Freezer Harvest Temp. To";
                    ToSalesLine."Transfer Temp. From" := FromSalesLine."Transfer Temp. From";
                    ToSalesLine."Transfer Temp. To" := FromSalesLine."Transfer Temp. To";
                    ToSalesLine."Currency Code" := GLSetup."LCY Code";
                    ToSalesLine."Vendor Name" := 'FARMER''S FRESH';
                end;
            end;

        end;
    end;
    //-1.0.0.110

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Reference Management", 'OnAfterValidateSalesReferenceNo', '', false, false)]
    local procedure OnAfterValidateSalesReferenceNo(var SalesLine: Record "Sales Line"; ItemReference: Record "Item Reference"; ReturnedItemReference: Record "Item Reference")
    var
        rL_ItemReference: Record "Item Reference";
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            //when its a valid REference No.

            //+1.0.0.165 
            rL_ItemReference.Reset;
            rL_ItemReference.SetRange("Reference Type", rL_ItemReference."Reference Type"::Customer);
            rL_ItemReference.SetFilter("Reference Type No.", SalesLine."Bill-to Customer No.");
            rL_ItemReference.SetFilter("Reference No.", SalesLine."Item Reference No.");
            if not rL_ItemReference.FindSet() then begin
                exit;
            end;

            //-1.0.0.165 

            if ReturnedItemReference."S. Quote Description" <> '' then begin
                SalesLine.Description := ReturnedItemReference."S. Quote Description";
                SalesLine.CopyLastSettings();
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Reference Management", 'OnAfterSalesItemReferenceFound', '', false, false)]
    local procedure OnAfterSalesItemReferenceFound(var SalesLine: Record "Sales Line"; ItemReference: Record "Item Reference")
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            if ItemReference."S. Quote Description" <> '' then begin
                SalesLine.Description := ItemReference."S. Quote Description";
                SalesLine.CopyLastSettings();
            end;
        end;
    end;

    //+1.0.0.114    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnCheckMissingOutput', '', false, false)]
    local procedure OnCheckMissingOutput(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var ShowWarning: Boolean)
    var
        rL_MNUSetup: Record "Manufacturing Setup";
        Text004: Label '%1 %2 has not been finished. Please post the Production Journal.';
    begin

        if ShowWarning then begin
            rL_MNUSetup.Get;
            if rL_MNUSetup."Mandatory Output Posting" then begin
                Error(StrSubstNo(Text004, ProductionOrder.TableCaption, ProductionOrder."No."));
            end;
        end;
    end;
    //-1.0.0.114

    //+1.0.0.295
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnCheckMissingConsumption', '', false, false)]
    local procedure OnCheckMissingConsumption(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var ShowWarning: Boolean)
    var
        rL_MNUSetup: Record "Manufacturing Setup";
        Text004: Label '%1 %2 has not been finished. Please post the Production Journal.';
    begin
        if ShowWarning then begin
            rL_MNUSetup.Get;
            if rL_MNUSetup."Mandatory Output Posting" then begin
                Error(StrSubstNo(Text004, ProductionOrder.TableCaption, ProductionOrder."No."));
            end;
        end;
    end;
    //-1.0.0.295


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeShowNonStock', '', false, false)]
    local procedure OnBeforeShowNonStock(var SalesLine: Record "Sales Line"; var NonstockItem: Record "Nonstock Item"; var IsHandled: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            if Page.RunModal(Page::"Catalog Item List", NonstockItem) = Action::LookupOK then begin

                GLSetup.Get;
                SalesLine.Description := NonstockItem.Description;

                SalesLine."Shelf No." := NonstockItem."Shelf No.";
                SalesLine."Country/Region of Origin Code" := NonstockItem."Country/Region of Origin Code";
                SalesLine."Package Qty" := NonstockItem."Package Qty";
                SalesLine."Pallet Qty" := NonstockItem."Pallet Qty";
                SalesLine."Product Class" := NonstockItem."Product Class";
                SalesLine."Calibration Min." := NonstockItem."Calibration Min.";
                SalesLine."Calibration Max." := NonstockItem."Calibration Max.";
                SalesLine."Calibration UOM" := NonstockItem."Calibration UOM";
                SalesLine.Variety := NonstockItem.Variety;
                SalesLine."Additional Information" := NonstockItem."Additional Information";
                SalesLine."Pressure Min." := NonstockItem."Pressure Min.";
                SalesLine."Pressure Max." := NonstockItem."Pressure Max.";
                SalesLine."Brix Min" := NonstockItem."Brix Min";
                SalesLine."QC 1 Min" := NonstockItem."QC 1 Min";
                SalesLine."QC 1 Max" := NonstockItem."QC 1 Max";
                SalesLine."QC 1 Text" := NonstockItem."QC 1 Text";
                SalesLine."QC 2 Min" := NonstockItem."QC 2 Min";
                SalesLine."QC 2 Max" := NonstockItem."QC 2 Max";
                SalesLine."QC 2 Text" := NonstockItem."QC 2 Text";
                SalesLine."Box Width" := NonstockItem."Box Width";
                SalesLine."Box Char 1" := NonstockItem."Box Char 1";
                SalesLine."Box Length" := NonstockItem."Box Length";
                SalesLine."Box Char 2" := NonstockItem."Box Char 2";
                SalesLine."Box Height" := NonstockItem."Box Height";
                SalesLine."Box Changed Date" := NonstockItem."Box Changed Date";
                SalesLine."Harvest Temp. From" := NonstockItem."Harvest Temp. From";
                SalesLine."Harvest Temp. To" := NonstockItem."Harvest Temp. To";
                SalesLine."Freezer Harvest Temp. From" := NonstockItem."Freezer Harvest Temp. From";
                SalesLine."Freezer Harvest Temp. To" := NonstockItem."Freezer Harvest Temp. To";
                SalesLine."Transfer Temp. From" := NonstockItem."Transfer Temp. From";
                SalesLine."Transfer Temp. To" := NonstockItem."Transfer Temp. To";
                SalesLine."Currency Code" := GLSetup."LCY Code";
                SalesLine."Vendor Name" := 'FARMER''S FRESH';
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckShipmentDateBeforeWorkDate', '', false, false)]
    local procedure OnBeforeCheckShipmentDateBeforeWorkDate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; var HasBeenShown: Boolean; var IsHandled: Boolean)
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            IsHandled := true;
        end;
    end;

    //+1.0.0.165 
    //codeunit 5720 "Item Reference Management"
    //allow invalid item reference no. to be typed.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Reference Management", 'OnBeforeReferenceLookupSalesItem', '', false, false)]
    local procedure OnBeforeReferenceLookupSalesItem(var SalesLine: Record "Sales Line"; var ItemReference: Record "Item Reference"; ShowDialog: Boolean; var IsHandled: Boolean)
    var
        rL_ItemReference: Record "Item Reference";
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            if SalesLine."Item Reference No." <> '' then begin
                rL_ItemReference.Reset;
                rL_ItemReference.SetRange("Reference Type", rL_ItemReference."Reference Type"::Customer);
                rL_ItemReference.SetFilter("Reference Type No.", SalesLine."Bill-to Customer No.");
                rL_ItemReference.SetFilter("Reference No.", SalesLine."Item Reference No.");
                if not rL_ItemReference.FindSet() then begin
                    ItemReference."Reference Type" := ItemReference."Reference Type"::Customer;
                    ItemReference."Reference Type No." := SalesLine."Bill-to Customer No.";
                    ItemReference."Reference No." := SalesLine."Item Reference No.";

                    IsHandled := true;
                end;

            end;
        end;
    end;

    //table 37 "Sales Line"
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPriceProcedure', '', false, false)]
    local procedure OnBeforeUpdateUnitPriceProcedure(var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            if CalledByFieldNo = 5725 then begin
                IsHandled := true;
            end;
        end;
    end;
    //-1.0.0.165 

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInitFromSalesLine', '', false, false)]
    local procedure OnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    var
        SalesShptLineSearch: Record "Sales Shipment Line";
    begin

        if SalesShptLine.Quantity = 0 then begin
            SalesShptLine."Qty. Requested" := 0;
            SalesShptLine."Qty. Confirmed" := 0;
        end;

        //+1.0.0.174 
        if SalesShptLine."Qty. Requested" <> 0 then begin
            if SalesShptLine."Order No." <> '' then begin
                SalesShptLineSearch.Reset;
                SalesShptLineSearch.SetFilter("Order No.", SalesShptLine."Order No.");
                SalesShptLineSearch.SetRange("Order Line No.", SalesShptLine."Order Line No.");
                SalesShptLineSearch.SetRange("Posting Date", SalesShptLine."Posting Date");
                SalesShptLineSearch.SetFilter("Qty. Requested", '<>%1', 0);
                if SalesShptLineSearch.FindSet() then begin
                    if SalesShptLineSearch.Count >= 1 then begin
                        SalesShptLine."Qty. Requested" := 0;
                    end;
                end;
            end;
        end;

        if SalesShptLine."Qty. Confirmed" <> 0 then begin
            if SalesShptLine."Order No." <> '' then begin
                SalesShptLineSearch.Reset;
                SalesShptLineSearch.SetFilter("Order No.", SalesShptLine."Order No.");
                SalesShptLineSearch.SetRange("Order Line No.", SalesShptLine."Order Line No.");
                SalesShptLineSearch.SetRange("Posting Date", SalesShptLine."Posting Date");
                SalesShptLineSearch.SetFilter("Qty. Confirmed", '<>%1', 0);
                if SalesShptLineSearch.FindSet() then begin
                    if SalesShptLineSearch.Count >= 1 then begin
                        SalesShptLine."Qty. Confirmed" := 0;
                    end;
                end;
            end;
        end;
        //-1.0.0.174 

    end;

    //+1.0.0.178
    //report 790 "Calculate Inventory"
    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", 'OnItemLedgerEntryOnAfterPreDataItem', '', false, false)]
    local procedure OnItemLedgerEntryOnAfterPreDataItem(var ItemLedgerEntry: Record "Item Ledger Entry"; var Item: Record Item)
    begin
        //Message(Item.GetFilter("Date Filter"));

        if Item.GetFilter("Date Filter") <> '' then begin
            ItemLedgerEntry.SetFilter("Posting Date", Item.GetFilter("Date Filter"));
        end;
    end;
    //-1.0.0.178

    //+1.0.0.212
    //codeunit 99000845 "Reservation Management"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnBeforeDeleteItemTrackingConfirm', '', false, false)]
    local procedure OnBeforeDeleteItemTrackingConfirm(var CalcReservEntry2: Record "Reservation Entry"; var IsHandled: Boolean; var Result: Boolean)
    begin
        IsHandled := true;
        Result := true;
    end;

    //-1.0.0.212

    //+1.0.0.226
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure OnAfterTransferBOMComponent(var ProdOrderLine: Record "Prod. Order Line"; var ProductionBOMLine: Record "Production BOM Line"; var ProdOrderComponent: Record "Prod. Order Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        ProdOrderComponent."Quantity per BUOM" := ProdOrderComponent."Quantity per";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnBeforeProdOrderCompModify', '', false, false)]
    local procedure OnBeforeProdOrderCompModify(var ProdOrderComp: Record "Prod. Order Component"; var ProdBOMLine: Record "Production BOM Line"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    begin
        ProdOrderComp."Quantity per BUOM" := ProdOrderComp."Quantity per";
    end;
    //-1.0.0.226

    //+1.0.0.229
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeInsertConsumptionJnlLine', '', false, false)]
    local procedure OnBeforeInsertConsumptionJnlLine(var ItemJournalLine: Record "Item Journal Line"; ProdOrderComp: Record "Prod. Order Component"; ProdOrderLine: Record "Prod. Order Line"; Level: Integer)
    var
        ProductionOrder: Record "Production Order";
    begin

        ProductionOrder.Reset;
        ProductionOrder.SetRange(Status, ProdOrderComp.Status);
        ProductionOrder.SetFilter("No.", ProdOrderComp."Prod. Order No.");
        if ProductionOrder.FindSet() then begin
            ItemJournalLine."Packing Agent" := ProductionOrder."Packing Agent";
        end;

    end;
    //-1.0.0.229

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnBeforeScheduleTask', '', false, false)]
    local procedure OnBeforeScheduleTask(var JobQueueEntry: Record "Job Queue Entry"; var TaskGUID: Guid; var IsHandled: Boolean)
    begin
        if JobQueueEntry."Execute User ID" <> '' then begin
            JobQueueEntry."User ID" := JobQueueEntry."Execute User ID";
        end;
    end;


    //+1.0.0.232
    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnBeforeAssignItemNo', '', false, false)]
    local procedure OnBeforeAssignItemNo(var ProdOrder: Record "Production Order"; xProdOrder: Record "Production Order"; var Item: Record Item; CallingFieldNo: Integer)
    begin
        ProdOrder."Packing Agent" := Item."Packing Agent";
    end;
    //-1.0.0.232

    //+1.0.0.237
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeMatrOrCapConsumpExists', '', false, false)]
    local procedure OnBeforeMatrOrCapConsumpExists(ProdOrderLine: Record "Prod. Order Line"; var EntriesExist: Boolean; var IsHandled: Boolean)
    var
        MFSetup: Record "Manufacturing Setup";
    begin
        MFSetup.Get();
        if MFSetup."skip MatrOrCapConsumpExists" then begin
            IsHandled := true;
            EntriesExist := false;
        end;

    end;
    //-1.0.0.237


    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Shipment - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged_Ship(var SalesShipmentHeader: Record "Sales Shipment Header"; xSalesShipmentHeader: Record "Sales Shipment Header"; var IsChanged: Boolean)
    begin


        IsChanged :=
         (SalesShipmentHeader."Shipping Agent Code" <> xSalesShipmentHeader."Shipping Agent Code") or
         (SalesShipmentHeader."Package Tracking No." <> xSalesShipmentHeader."Package Tracking No.") or
         (SalesShipmentHeader."Shipping Agent Service Code" <> xSalesShipmentHeader."Shipping Agent Service Code") or
            (SalesShipmentHeader."Shipping Temperature" <> xSalesShipmentHeader."Shipping Temperature") or
               (SalesShipmentHeader."Shipping Quality Control" <> xSalesShipmentHeader."Shipping Quality Control");

    end;





    /*
    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromItemLedgerEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemLedgerEntry(var ItemTrackingSetup: Record "Item Tracking Setup"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ItemTrackingSetup."Expiration Date" := ItemLedgerEntry."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterCopyTrackingFromItemTrackingSetup', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemTrackingSetup(var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup")
    begin
        TrackingSpecification."Expiration Date" := ItemTrackingSetup."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromTrackingSpec(var ItemTrackingSetup: Record "Item Tracking Setup"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemTrackingSetup."Expiration Date" := TrackingSpecification."Expiration Date";
    end;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Doc. Management", 'OnAfterAddTempRecordToSet', '', false, false)]
    local procedure OnAfterAddTempRecordToSet(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; var TempItemLedgerEntry2: Record "Item Ledger Entry" temporary; SignFactor: Integer)
    var
        ILE: Record "Item Ledger Entry";
    begin
        //+1.0.0.244
        if TempItemLedgerEntry."Expiration Date" = 0D then begin
            if ILE.Get(TempItemLedgerEntry."Entry No.") then begin
                if ILE."Expiration Date" <> 0D then begin
                    TempItemLedgerEntry."Expiration Date" := ILE."Expiration Date";
                    TempItemLedgerEntry.Modify();
                end;
            end;
        end;
        //-1.0.0.244
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeTestNoItemLedgEntiesExist', '', false, false)]
    local procedure OnBeforeTestNoItemLedgEntiesExist(Item: Record Item; CurrentFieldName: Text[100]; var IsHandled: Boolean)
    var
        InvSetup: Record "Inventory Setup";

    begin
        InvSetup.Get;
        if InvSetup."Allow Item Trac. Code Change" then begin
            IsHandled := true;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnRunOnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header")
    var
        SLines: Record "Sales Line";
        Text50000: Label 'Unit price is zero. Do you want to continue?\n%1 - %2 ';
        Text50001: Label 'Quantity is zero. Do you want to continue?\n%1 - %2 ';
    begin

        SLines.Reset;
        SLines.SetRange("Document Type", SalesHeader."Document Type");
        SLines.SetRange("Document No.", SalesHeader."No.");
        if SLines.FindFirst then begin
            repeat
                if (SLines.Type = SLines.Type::Item) or (SLines.Type = SLines.Type::"G/L Account") then begin
                    if SLines.Quantity <> 0 then begin
                        //SLines.TESTFIELD("Unit Price");
                        if SLines."Unit Price" = 0 then begin
                            if not Confirm(Text50000, false, SLines."No.", SLines.Description) then begin
                                Error('');
                            end;
                        end;
                    end;

                    if SLines."Unit Price" <> 0 then begin
                        //SLines.TESTFIELD(Quantity);
                        if SLines.Quantity = 0 then begin
                            if not Confirm(Text50001, false, SLines."No.", SLines.Description) then begin
                                Error('');
                            end;
                        end;
                    end;
                end;
            until SLines.Next = 0;
        end;
    end;

    //+1.0.0.289
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnInvtToAdjustExistOnBeforeCopyItemToItem', '', false, false)]
    local procedure OnInvtToAdjustExistOnBeforeCopyItemToItem(var Item: Record Item)
    begin
        Item.SetRange("TAL Exclude Item from Adjustme", false); //TAL0.3
    end;
    //-1.0.0.289



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]
    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        Item: Record Item;
        SRSetup: Record "Sales & Receivables Setup";
    begin

        //if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) or (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin
        if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
            if Customer."Mandatory CY Fields" then begin
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetFilter("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter(Quantity, '<>%1', 0);
                if SalesLine.FindSet() then begin

                    SRSetup.Get();
                    SRSetup.TestField("Potatoes Item Category Code");
                    SRSetup.TestField("Fresh Inventory Posting Group");
                    repeat

                        if Item.Get(SalesLine."No.") then begin
                            if Item."Inventory Posting Group" = SRSetup."Fresh Inventory Posting Group" then begin

                                //SalesLine.TestField("Req. Country");
                                SalesLine.TestField("Country/Region of Origin Code");
                                SalesLine.TestField("Product Class");
                                if Item."Item Category Code" = SRSetup."Potatoes Item Category Code" then begin
                                    SalesLine.TestField("Category 9");
                                end;
                            end;


                        end;
                    until SalesLine.Next() = 0;
                end;

            end;
        end;
        //end;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        GLEntry."Register No." := GLRegister."No.";
    end;
}



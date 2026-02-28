/*
TAL0.1 2021/03/23 VC add 2 action to import data 
TAL0.2 2021/11/03 VC add field GlobalGab COC No.
*/
pageextension 50100 CompanyInformationExt extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(Picture)
        {
            field("Demo Company"; "Demo Company")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }

        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = all;
            }
        }

        addafter("VAT Registration No.")
        {
            field("GlobalGab COC No."; "GlobalGab COC No.")
            {
                ApplicationArea = all;
            }
            field("BIO Certification Body"; "BIO Certification Body")
            {
                ApplicationArea = all;
            }
            group(ISO)
            {
                field("ISO Release Date"; "ISO Release Date")
                {
                    ApplicationArea = all;
                }
                field("ISO Version"; "ISO Version")
                {
                    ApplicationArea = all;
                }
                field("ISO Review"; "ISO Review")
                {
                    ApplicationArea = all;
                }
                field("ISO Authorised By"; "ISO Authorised By")
                {
                    ApplicationArea = all;
                }
            }

        }

        addafter("User Experience")
        {
            group(Lidl)
            {
                field("Lidl Rep. No"; "Lidl Rep. No")
                {
                    ApplicationArea = all;
                }
                field("Lidl Rep. Name"; "Lidl Rep. Name")
                {
                    ApplicationArea = all;
                }
                field("Packaging Location GLN"; "Packaging Location GLN")
                {
                    ApplicationArea = all;
                }
                field("Packaging Location Name"; "Packaging Location Name")
                {
                    ApplicationArea = all;
                }
            }


            group(Other)
            {
                field("Web Portal URL"; "Web Portal URL")
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    begin
                        Hyperlink("Web Portal URL");
                    end;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Regional Settings")
        {

            group(LidlSalesQuote)
            {
                caption = 'Lidl Sales Quote';

                action(UpdateShipments)
                {

                    caption = 'Update Shipments';
                    ApplicationArea = All;
                    Visible = true;

                    trigger OnAction()
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.UpdateSalesShipmentLine();
                    end;

                }

                action(ImportIAN)
                {

                    caption = 'Import Lidl IAN';
                    ApplicationArea = All;
                    Visible = true;

                    trigger OnAction()
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.ImportLidlIAN();
                    end;

                }

                action(CreateLidlItemReference)
                {

                    caption = 'Create Lidl Item Reference';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.PopulateLidlItemReference();
                    end;

                }

                action(UpdateSQuoteDescription)
                {

                    caption = 'Update S. Quote Description';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.PopulateSalesQuoteDescription();
                    end;

                }

                action(UpdateSQuoteDescription2)
                {

                    caption = 'Update Missing S. Quote Description';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.PopulateMissingSalesQuoteDescription();
                    end;

                }
            }

            action(UpdateOrderDate)
            {
                ApplicationArea = All;
                Visible = false;
                caption = 'Update Requested Delivery Date';

                trigger OnAction()
                var

                    SalesHeader: Record "Sales Header";
                    DateforWeek1: Record Date;
                    vG_OrderDay: Text;
                begin


                    SalesHeader.RESET;
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
                    if SalesHeader.FindSet() then begin
                        repeat
                            if SalesHeader."Requested Delivery Date" = 0D then begin
                                SalesHeader."Requested Delivery Date" := SalesHeader."Order Date";
                                SalesHeader.Modify();
                            end;

                        /*
                        if DateforWeek1.GET(DateforWeek1."Period Type"::Date, SalesHeader."Order Date") then begin
                            vG_OrderDay := DateforWeek1."Period Name";
                            if vG_OrderDay = 'Monday' then begin
                                SalesHeader.Validate("Order Date", (calcdate('-1D', SalesHeader."Order Date")));

                                SalesHeader.Validate("Document Date", (calcdate('-6D', SalesHeader."Order Date")));
                                SalesHeader.Modify();
                            end;
                        end;
                        */

                        until SalesHeader.Next() = 0;
                    end;

                    Message('Update Completed');

                end;
            }

            action(UpdateCatalogue)
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var
                    SRSetup: Record "Sales & Receivables Setup";
                    SalesLine: Record "Sales Line";

                    NonstockItem: Record "Nonstock Item";
                begin
                    SRSetup.GET;

                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    SalesLine.SetRange("Type", SalesLine.Type::Item);
                    SalesLine.SetFilter("No.", '%1', '');
                    SalesLine.SetFilter("Shelf No.", '<>%1', '');
                    SalesLine.SetFilter("Country/Region of Origin Code", '<>%1', '');
                    if SalesLine.FindSet() then begin

                        //NonstockItem.DeleteAll();
                        repeat
                            clear(NonstockItem);
                            //NonstockItem."Item No." := SalesLine."Shelf No.";
                            NonstockItem.Description := SalesLine.Description;

                            NonstockItem."Shelf No." := SalesLine."Shelf No.";
                            NonstockItem."Country/Region of Origin Code" := SalesLine."Country/Region of Origin Code";
                            NonstockItem."Package Qty" := SalesLine."Package Qty";
                            NonstockItem."Pallet Qty" := SalesLine."Pallet Qty";
                            NonstockItem."Product Class" := SalesLine."Product Class";
                            NonstockItem."Calibration Min." := SalesLine."Calibration Min.";
                            NonstockItem."Calibration Max." := SalesLine."Calibration Max.";
                            NonstockItem."Calibration UOM" := SalesLine."Calibration UOM";
                            NonstockItem."Variety" := SalesLine."Variety";
                            NonstockItem."Additional Information" := SalesLine."Additional Information";
                            NonstockItem."Pressure Min." := SalesLine."Pressure Min.";
                            NonstockItem."Pressure Max." := SalesLine."Pressure Max.";
                            NonstockItem."Brix Min" := SalesLine."Brix Min";


                            NonstockItem."QC 1 Min" := SalesLine."QC 1 Min";
                            NonstockItem."QC 1 Max" := SalesLine."QC 1 Max";
                            NonstockItem."QC 1 Text" := SalesLine."QC 1 Text";
                            NonstockItem."QC 2 Min" := SalesLine."QC 2 Min";
                            NonstockItem."QC 2 Max" := SalesLine."QC 2 Max";
                            NonstockItem."QC 2 Text" := SalesLine."QC 2 Text";
                            NonstockItem."Box Width" := SalesLine."Box Width";
                            NonstockItem."Box Char 1" := SalesLine."Box Char 1";
                            NonstockItem."Box Length" := SalesLine."Box Length";


                            NonstockItem."Box Char 2" := SalesLine."Box Char 2";
                            NonstockItem."Box Height" := SalesLine."Box Height";

                            NonstockItem."Box Changed Date" := SalesLine."Box Changed Date";

                            NonstockItem."Harvest Temp. From" := SalesLine."Harvest Temp. From";
                            NonstockItem."Harvest Temp. To" := SalesLine."Harvest Temp. To";
                            NonstockItem."Freezer Harvest Temp. From" := SalesLine."Freezer Harvest Temp. From";
                            NonstockItem."Freezer Harvest Temp. To" := SalesLine."Freezer Harvest Temp. To";
                            NonstockItem."Transfer Temp. From" := SalesLine."Transfer Temp. From";
                            NonstockItem."Transfer Temp. To" := SalesLine."Transfer Temp. To";
                            NonstockItem.Insert(true);

                        until SalesLine.Next() = 0;
                    end;

                    Message('Insert Completed');

                end;
            }


            action(UpdateQuoteDefaults)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    SRSetup: Record "Sales & Receivables Setup";
                    GLSetup: Record "General Ledger Setup";
                    SalesLine: Record "Sales Line";
                begin
                    SRSetup.GET;
                    GLSetup.GET;

                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    if SalesLine.FindSet() then begin
                        repeat
                            if SalesLine."Currency Code" = '' then begin
                                SalesLine."Currency Code" := GLSetup."LCY Code";
                                SalesLine.Modify();
                            end;

                            if SalesLine."Vendor Name" = '' then begin
                                SalesLine."Vendor Name" := 'FARMER''S FRESH';
                                SalesLine.Modify();
                            end;


                            if SalesLine."Price Previous Week KG" <> 0 then begin
                                SalesLine."Price Previous Week Box" := SalesLine."Price Previous Week KG" * SalesLine."Package Qty";
                                SalesLine.Modify();
                            end;

                            if SalesLine."Price Previous Week PCS" <> 0 then begin
                                SalesLine."Price Previous Week Box" := SalesLine."Price Previous Week PCS" * SalesLine."Package Qty";
                                SalesLine.Modify();
                            end;

                            if SalesLine."Price KG" <> 0 then begin
                                SalesLine."Price Box" := SalesLine."Price KG" * SalesLine."Package Qty";
                                SalesLine.Modify();
                            end;

                            if SalesLine."Price PCS" <> 0 then begin
                                SalesLine."Price Box" := SalesLine."Price PCS" * SalesLine."Package Qty";
                                SalesLine.Modify();
                            end;




                        until SalesLine.Next() = 0;
                    end;

                    Message('Update Completed');

                end;
            }

            action(UpdateCostProfit)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    SRSetup: Record "Sales & Receivables Setup";
                    SalesLine: Record "Sales Line";
                begin
                    SRSetup.GET;

                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    if SalesLine.FindSet() then begin
                        repeat
                            SalesLine."Cost Profit %" := SRSetup."Cost Profit %";
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;

                    Message('Update Completed');

                end;
            }

            action(UpdateCorrectNo)
            {
                ApplicationArea = All;
                Caption = 'Update Correct No.';
                Visible = false;
                trigger OnAction()
                var

                    SalesLine: Record "Sales Line";
                    rL_Item: Record Item;
                    vL_CorrectItemNo: Code[20];

                begin


                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    if SalesLine.FindSet() then begin
                        repeat
                            vL_CorrectItemNo := '';
                            if SalesLine."Shelf No." <> '' then begin
                                rL_Item.RESET;
                                rL_Item.SetFilter("Shelf No.", SalesLine."Shelf No.");
                                rL_Item.SETRANGE("Package Qty", SalesLine."Package Qty");
                                if rL_Item.FindSet() then begin
                                    vL_CorrectItemNo := rL_Item."No.";
                                    if vL_CorrectItemNo <> SalesLine."No." then begin
                                        SalesLine."No." := vL_CorrectItemNo;
                                        if rL_Item."Sales Unit of Measure" <> '' then
                                            SalesLine."Unit of Measure Code" := rL_Item."Sales Unit of Measure"
                                        else
                                            SalesLine."Unit of Measure Code" := rL_Item."Base Unit of Measure";
                                        SalesLine.Modify();
                                    end;
                                end;
                            end;



                        until SalesLine.Next() = 0;
                    end;

                    Message('Update Completed');

                end;
            }

            action(UpdateReportSelections)
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var
                    rL_ReportSelections: Record "Report Selections";
                    rL_SRSetup: Record "Sales & Receivables Setup";
                    rL_JobQeueEntry: Record "Job Queue Entry";
                begin
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"S.Order");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50025);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"S.Shipment");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50070);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"S.Invoice");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50026);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"S.Cr.Memo");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50027);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"S.Work Order");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50006);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"C.Statement");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50061);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"B.Check");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50063);
                        rL_ReportSelections.Modify();
                    end;

                    //purchases
                    //PurchaseOrder 50066
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"P.Order");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50066);
                        rL_ReportSelections.Modify();
                    end;

                    //PurchaseCreditMemo 50067

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"P.Cr.Memo");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50067);
                        rL_ReportSelections.Modify();
                    end;

                    //PurchaseInvoice 50068

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"P.Invoice");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50068);
                        rL_ReportSelections.Modify();
                    end;

                    //PurchaseReceipt 50069


                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"P.Receipt");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50069);
                        rL_ReportSelections.Modify();
                    end;


                    //warehouse/inventory
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::Inv2);
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50087);
                        rL_ReportSelections.Modify();
                    end;
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::Inv3);
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50088);
                        rL_ReportSelections.Modify();
                    end;

                    //production
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::M2);
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50089);
                        rL_ReportSelections.Modify();
                    end;

                    //receipts
                    //62,65
                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"Payment Receipt");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50062);
                        rL_ReportSelections.Modify();
                    end;

                    rL_ReportSelections.RESET;
                    rL_ReportSelections.SetRange(Usage, rL_ReportSelections.Usage::"Vendor Receipt");
                    if rL_ReportSelections.FindSet() then begin
                        rL_ReportSelections.Validate("Report ID", 50065);
                        rL_ReportSelections.Modify();
                    end;





                    rL_SRSetup.GET;
                    rL_SRSetup."EDI Export Dot Net" := false;
                    rL_SRSetup.Modify();


                    rL_JobQeueEntry.RESET;
                    rL_JobQeueEntry.SetRange("Object ID to Run", 1002);
                    if rL_JobQeueEntry.FindSet() then begin
                        rL_JobQeueEntry.Validate("Object ID to Run", 50073);
                        rL_JobQeueEntry.Modify();
                    end;


                    rL_JobQeueEntry.RESET;
                    rL_JobQeueEntry.SetRange("Object ID to Run", 795);
                    if rL_JobQeueEntry.FindSet() then begin
                        rL_JobQeueEntry.Validate("Object ID to Run", 50074);
                        rL_JobQeueEntry.Modify();
                    end;

                    Message('Reports Updated');

                end;
            }

            action(JCCPayByLink)
            {

                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ExecutePaybyLink();
                end;

            }

            action(UpdateQtyConfirmned)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    SalesShipmentLine: Record "Sales Shipment Line";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    OrderQty: Record "Order Qty";
                    txt50000: Label 'Are you sure to Update Order Qty table?';
                    eOrderQtyDocumentType: enum "Order Qty Document Type";
                begin
                    if not Confirm(txt50000, false) then begin
                        exit;
                    end;

                    eOrderQtyDocumentType := eOrderQtyDocumentType::"Sales Order";
                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Qty. Shipped (Base)", 0);
                    SalesLine.SetFilter("Qty. Requested", '<>%1', 0);
                    if SalesLine.FindSet() then begin
                        repeat
                            OrderQty.UpdateQty(SalesLine, eOrderQtyDocumentType);
                        until SalesLine.Next() = 0;
                    end;


                    eOrderQtyDocumentType := eOrderQtyDocumentType::"Sales Shipment";
                    SalesShipmentLine.RESET;
                    SalesShipmentLine.Setfilter("Qty. Requested", '<>%1', 0);
                    if SalesShipmentLine.FindSet() then begin
                        repeat
                            SalesShipmentLine.calcfields("Unit of Measure (Base)");
                            SalesShipmentHeader.GET(SalesShipmentLine."Document No.");
                            OrderQty.RESET;
                            OrderQty.SetRange("Document Type", eOrderQtyDocumentType);
                            OrderQty.SetFilter("Document No.", SalesShipmentLine."Document No.");
                            OrderQty.SetRange("Line No.", SalesShipmentLine."Line No.");
                            if not OrderQty.FindSet() then begin
                                clear(OrderQty);
                                OrderQty."Document Type" := eOrderQtyDocumentType;
                                OrderQty."Document No." := SalesShipmentLine."Document No.";
                                OrderQty."Line No." := SalesShipmentLine."Line No.";
                                OrderQty.Insert();
                            end;

                            OrderQty."Order Date" := SalesShipmentHeader."Order Date";
                            OrderQty."Item No." := SalesShipmentLine."No.";
                            OrderQty."Shelf No." := SalesShipmentLine."Shelf No.";
                            OrderQty."Qty. Requested" := SalesShipmentLine."Qty. Requested";
                            OrderQty."Qty. Confirmed" := SalesShipmentLine."Qty. Confirmed";
                            OrderQty."UOM (Base)" := SalesShipmentLine."Unit of Measure (Base)";
                            OrderQty."Customer No." := SalesShipmentLine."Sell-to Customer No.";
                            OrderQty.Modify();

                        until SalesShipmentLine.Next() = 0;
                    end;

                    Message('Update Completed');
                end;
            }

            //version

            action(UpdateQtyConfirmnedVersion1)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var

                    OrderQty: Record "Order Qty";
                    OrderQtyMod: Record "Order Qty";
                    txt50000: Label 'Are you sure to Update Order Qty table Version?';

                begin
                    if not Confirm(txt50000, false) then begin
                        exit;
                    end;

                    OrderQty.RESET;
                    if OrderQty.FindSet() then begin
                        repeat
                            OrderQty.Rename(OrderQty."Document Type", OrderQty."Document No.", OrderQty."Line No.", 1);

                        /*
                        OrderQtyMod.RESET;
                        OrderQtyMod.SetRange("Document Type", OrderQty."Document Type");
                        OrderQtyMod.SetFilter("Document No.", OrderQty."Document No.");
                        OrderQtyMod.SetRange("Line No.", OrderQty."Line No.");
                        if OrderQtyMod.FindSet() then begin

                            OrderQtyMod."Version No." := 1;
                            OrderQtyMod.Rename()
                        end;
                        */


                        until OrderQty.Next() = 0;
                    end;
                    Message('Update Completed');
                end;
            }

            action(UpdateQtyConfirmnedVersion2)
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var

                    OrderQty: Record "Order Qty";
                    OrderQtyMod: Record "Order Qty";
                    txt50000: Label 'Are you sure to Update Order Qty table Version max?';

                begin
                    if not Confirm(txt50000, false) then begin
                        exit;
                    end;

                    OrderQty.RESET;
                    if OrderQty.FindSet() then begin
                        OrderQty.ModifyAll("Max Version No.", false);
                    end;


                    OrderQty.RESET;
                    if OrderQty.FindSet() then begin
                        Window.OPEN('Record Processing #1###############');
                        WindowTotalCount := OrderQty.Count;
                        WindowLineCount := 0;
                        repeat
                            WindowLineCount += 1;
                            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
                            OrderQty.UpdateMaxVersionNo(OrderQty);

                        until OrderQty.Next() = 0;
                    end;
                    Window.CLOSE();
                    Message('Update Completed');
                end;
            }

            action(ImportHorecaDD)
            {
                caption = 'Import Horeca Delivery Days';
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecDeliveryDays();
                end;

            }

            action(ImportHorecaItems)
            {
                caption = 'Import Horeca Items';
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecItems();
                end;

            }


        }
    }

    var
        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
}
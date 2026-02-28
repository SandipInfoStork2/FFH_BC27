pageextension 50246 SalesQuoteExt extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; "Week No.")
            {
                ApplicationArea = all;

                trigger OnLookup(var Text: Text): Boolean
                var
                    myInt: Integer;
                begin
                    page.Run(page::"Lidl Lot Sample");
                end;
            }
        }

        addafter(SalesLines)
        {
            part(SalesLinesLidl; "Sales Quote Lidl Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = SalesLinesAvailable;
                Enabled = SalesLinesAvailable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

            part(SalesLinesCostingLidl; "S.Q. Lidl Costing Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = SalesLinesAvailable;
                Enabled = SalesLinesAvailable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

            /*
            part(SalesLinesNegotiationLidl; "S.Q. Lidl Negotiation Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = SalesLinesAvailable;
                Enabled = SalesLinesAvailable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            */
        }

        addafter(Status)
        {
            group(PriceDates)
            {
                caption = 'Previous Price Dates';
                /*
                field(vG_PriceStartDate; vG_PriceStartDate)
                {
                    ApplicationArea = all;
                    Caption = 'Price Start Date';
                    Editable = false;
                }

                field(vG_PriceEndDate; vG_PriceEndDate)
                {
                    ApplicationArea = all;
                    Caption = 'Price End Date';
                    Editable = false;
                }
                */

                /*
                field(vG_PriceStartDatePreviousWeek; vG_PriceStartDatePreviousWeek)
                {
                    ApplicationArea = all;
                    Caption = 'Price Start Date Previous Week';
                    Editable = false;
                }
                field(vG_PriceEndDatePreviousWeek; vG_PriceEndDatePreviousWeek)
                {
                    ApplicationArea = all;
                    Caption = 'Price End Date Previous Week';
                    Editable = false;
                }
                */

                field("Price Start Date"; "Price Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Custom: Get Costing Price Previous Week - Start Date';
                }
                field("Price End Date"; "Price End Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Custom: Get Costing Price Previous Week - End Date';
                }


            }

            group(UpdatePriceDates)
            {
                caption = 'Update Price Dates';
                field("Price Update Start Date"; "Price Update Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Custom: Update Prices Previous Week - Start Date';
                }
                field("Price Update End Date"; "Price Update End Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Custom: Update Prices Previous Week - End Date';
                }
            }
        }

        modify("Document Date")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }

        modify("Order Date")
        {
            Visible = false;
            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;

        }
        modify("Due Date")
        {
            Visible = false;
        }

        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }

        moveafter("Document Date"; "Requested Delivery Date")

        //movebefore("Due Date"; "Order Date")

        // moveafter

        /*
 vG_PriceStartDate: Date;
        vG_PriceEndDate: Date;

        vG_PriceStartDatePreviousWeek: Date;
        vG_PriceEndDatePreviousWeek: Date;
        */

        //+1.0.0.219
        modify("Attached Documents")
        {
            Visible = false;
        }

        modify(Control1903720907)
        {
            Visible = false;
        }

        modify(Control1906127307)
        {
            Visible = false;
        }

        modify(Control1905767507)
        {
            Visible = false;
        }
        //-1.0.0.219

    }

    actions
    {
        // Add changes to page actions here

        addbefore(MakeOrder)
        {
            action(ImportLidlHistory)
            {
                ApplicationArea = all;
                Caption = 'Import Lidl History';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";

                    rL_SalesHeader: Record "Sales Header";
                begin
                    CLEAR(rL_SalesHeader);
                    rL_SalesHeader.SETRANGE("Document Type", "Document Type");
                    rL_SalesHeader.SETFILTER("No.", "No.");
                    if rL_SalesHeader.FINDFIRST then begin
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.ImportLidlHistory(rL_SalesHeader);
                    end;


                end;
            }

            action(CalculatePriceDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Price Dates';
                Promoted = true;
                PromotedCategory = Process;
                Image = Calculate;

                trigger OnAction()
                var
                begin
                    TestField("Document Date");
                    TestField("Requested Delivery Date");
                    SQPriceDateCalculation();
                end;
            }

            action(ExportCompPrices)
            {
                ApplicationArea = All;
                caption = 'Export Lidl Quote';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportLidlQuote("No.");
                end;
            }

        }

        modify(CopyDocument)
        {

            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                TestField("Requested Delivery Date");
                TestField("Price Start Date");
                TestField("Price End Date");
            end;

            trigger OnAfterAction()
            var
                vL_DateFilterPrevious4Weeks: Text;
                vL_DateFilterNext4WeeksLastYear: Text;
                PreviousYearDocumentDate: Date;
                PreviousYearEndDate: Date;
                LineSource: Text;
                SRSetup: Record "Sales & Receivables Setup";
            //rL_SalesLine: Record "Sales Line";
            begin
                SRSetup.GET();
                //Check 1
                /*
                rL_SalesLine."Price Previous Week Box" := 0;
                rL_SalesLine."Price Previous Week KG" := 0;
                rL_SalesLine."Price Previous Week PCS" := 0;

                rL_SalesLine."Price Box" := 0;
                rL_SalesLine."Price KG" := 0;
                rL_SalesLine."Price PCS" := 0;
                */
                //rL_SalesLine.RESET;
                //rL_SalesLine.SetRange("Document Type", "Document Type");
                //rL_SalesLine.SetFilter("Document No.", "No.");
                //if not rL_SalesLine.FindSet() then begin

                //Check 2 Last 4 weaks
                if SRSetup."Lidl Copy Quote History" then begin

                    vL_DateFilterPrevious4Weeks := FORMAT(CalcDate('-4W', "Document Date")) + '..' + FORMAT(CalcDate('-1D', "Document Date")); //1.0.0.220
                    LineSource := '-4W ' + vL_DateFilterPrevious4Weeks;
                    addAdditionalLines(vL_DateFilterPrevious4Weeks, LineSource, "Sell-to Customer No.");

                    //check 3 last year next 4 weeks
                    PreviousYearDocumentDate := CalcDate('-1Y', "Document Date");
                    PreviousYearEndDate := CalcDate('+4W', PreviousYearDocumentDate);

                    vL_DateFilterNext4WeeksLastYear := Format(PreviousYearDocumentDate) + '..' + FORMAT(PreviousYearEndDate);
                    LineSource := '+4W ' + vL_DateFilterNext4WeeksLastYear;
                    addAdditionalLines(vL_DateFilterNext4WeeksLastYear, LineSource, "Sell-to Customer No.");
                end;


                //end;





            end;
        }

        addafter(PageInteractionLogEntries)
        {
            action(SalesLinesMinus4W)
            {
                ApplicationArea = All;
                caption = 'Sales Quotes -4W,+4W Last Year';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    rL_SalesLine: Record "Sales Line";
                    vL_DateFilterPrevious4Weeks: Text;
                    vL_DateFilterNext4WeeksLastYear: Text;
                    PreviousYearDocumentDate: Date;
                    PreviousYearEndDate: Date;
                    rL_SalesHeader: Record "Sales Header";

                begin
                    vL_DateFilterPrevious4Weeks := FORMAT(CalcDate('-4W', "Document Date")) + '..' + FORMAT(CalcDate('-1D', "Document Date")); //1.0.0.220

                    PreviousYearDocumentDate := CalcDate('-1Y', "Document Date");
                    PreviousYearEndDate := CalcDate('+4W', PreviousYearDocumentDate);

                    vL_DateFilterNext4WeeksLastYear := Format(PreviousYearDocumentDate) + '..' + FORMAT(PreviousYearEndDate);

                    rL_SalesHeader.RESET;
                    rL_SalesHeader.SetRange("Document Type", "Document Type");
                    rL_SalesHeader.SetFilter("Document Date", vL_DateFilterPrevious4Weeks + '|' + vL_DateFilterNext4WeeksLastYear);
                    rL_SalesHeader.SetFilter("Sell-to Customer No.", "Sell-to Customer No.");
                    if rL_SalesHeader.FindSet() then begin

                    end;
                    page.Run(page::"Sales Quotes", rL_SalesHeader);


                    /*
                    rL_SalesLine.RESET;
                    rL_SalesLine.SetRange("Document Type", "Document Type");
                    rL_SalesLine.SetFilter("Sell-to Customer No.", "Sell-to Customer No.");
                    rL_SalesLine.SetFilter("Posting Date", vL_DateFilterPrevious4Weeks);
                    if rL_SalesLine.FindSet() then begin

                    end;

                    page.Run(page::"Sales Lines", rL_SalesLine);
                    */

                end;
            }


        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActivateFields;

    end;

    trigger OnAfterGetRecord()
    begin
        ActivateFields;
        //vG_PriceStartDate := GetPriceStartDate();
        //vG_PriceEndDate := GetPriceEndDate();
        //vG_PriceStartDatePreviousWeek := GetPriceStartDatePreviousWeek();
        //vG_PriceEndDatePreviousWeek := GetPriceEndDatePreviousWeek();
    end;

    local procedure ActivateFields()
    begin
        SetSalesLinesAvailability();
    end;

    local procedure SetSalesLinesAvailability()
    begin
        SalesLinesAvailable := ("Sell-to Customer No." <> '') OR ("Sell-to Customer Templ. Code" <> '') OR ("Sell-to Contact No." <> '');
    end;


    local procedure addAdditionalLines(pFilter: Text; pLineSource: Text; pSelltoCustomerNo: Code[20])
    var
        rL_SalesHeader: Record "Sales Header";
        rL_SalesLine: Record "Sales Line";
        rL_SalesLineNew: Record "Sales Line";
        rL_SalesLineCurrent: Record "Sales Line";
        vL_LineNo: Integer;
    begin
        //Message(pFilter);
        rL_SalesHeader.RESET;
        rL_SalesHeader.SetRange("Document Type", rL_SalesHeader."Document Type"::Quote);
        rL_SalesHeader.SetFilter("Document Date", pFilter);
        rL_SalesHeader.SetFilter("Sell-to Customer No.", pSelltoCustomerNo);
        if rL_SalesHeader.FindSet() then begin
            repeat
                rL_SalesLine.RESET;
                rL_SalesLine.SetRange("Document Type", rL_SalesHeader."Document Type");
                rL_SalesLine.SetFilter("Document No.", rL_SalesHeader."No.");
                rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                if rL_SalesLine.FindSet() then begin
                    repeat
                        rL_SalesLineCurrent.RESET;
                        rL_SalesLineCurrent.SetRange("Document Type", rL_SalesLineCurrent."Document Type"::Quote);
                        rL_SalesLineCurrent.SetFilter("Document No.", "No.");
                        rL_SalesLineCurrent.SetFilter("No.", rL_SalesLine."No.");
                        if not rL_SalesLineCurrent.FindSet() then begin
                            //add new line

                            vL_LineNo := 0;
                            rL_SalesLineNew.RESET;
                            rL_SalesLineNew.SetRange("Document Type", "Document Type");
                            rL_SalesLineNew.SetFilter("Document No.", "No.");
                            if rL_SalesLineNew.FindLast() then begin
                                vL_LineNo := rL_SalesLineNew."Line No.";
                            end;

                            vL_LineNo += 10000;
                            //SRsetup.GET;
                            //"Cost Profit %" := SRsetup."Cost Profit %";

                            Clear(rL_SalesLineNew);
                            rL_SalesLineNew.Validate("Document Type", "Document Type");
                            rL_SalesLineNew.Validate("Document No.", "No.");
                            rL_SalesLineNew.Validate("Line No.", vL_LineNo);
                            rL_SalesLineNew.SetHideValidationDialog(true);
                            rL_SalesLineNew.Insert(true);

                            rL_SalesLineNew.Type := rL_SalesLineNew.Type::Item;
                            rL_SalesLineNew."Shelf No." := rL_SalesLine."Shelf No.";
                            rL_SalesLineNew."No." := rL_SalesLine."No.";


                            rL_SalesLineNew.Description := rL_SalesLine.Description;
                            rL_SalesLineNew."Line Source" := rL_SalesHeader."External Document No."; //rL_SalesHeader."No." + ' ' + pLineSource;


                            rL_SalesLineNew.validate("Pallet Qty", rL_SalesLine."Pallet Qty");
                            rL_SalesLineNew."Country/Region of Origin Code" := rL_SalesLine."Country/Region of Origin Code";
                            rL_SalesLineNew.validate("Product Class", rL_SalesLine."Product Class");
                            rL_SalesLineNew.validate("Package Qty", rL_SalesLine."Package Qty");
                            rL_SalesLineNew.validate("Calibration Min.", rL_SalesLine."Calibration Min.");
                            rL_SalesLineNew.validate("Calibration Max.", rL_SalesLine."Calibration Max.");
                            rL_SalesLineNew.validate("Calibration UOM", rL_SalesLine."Calibration UOM");
                            rL_SalesLineNew.validate("Variety", rL_SalesLine."Variety");
                            rL_SalesLineNew.validate("Currency Code", rL_SalesLine."Currency Code");
                            rL_SalesLineNew.validate("Price Previous Week Box", rL_SalesLine."Price Previous Week Box");
                            rL_SalesLineNew.validate("Price Previous Week PCS", rL_SalesLine."Price Previous Week PCS");
                            rL_SalesLineNew.validate("Price Previous Week KG", rL_SalesLine."Price Previous Week KG");
                            rL_SalesLineNew.validate("Price Box", rL_SalesLine."Price Box");
                            rL_SalesLineNew.validate("Price PCS", rL_SalesLine."Price PCS");
                            rL_SalesLineNew.validate("Price KG", rL_SalesLine."Price KG");
                            rL_SalesLineNew.validate("Row Index", 0);
                            rL_SalesLineNew.validate("Qty Box Date 1", rL_SalesLine."Qty Box Date 1");
                            rL_SalesLineNew.validate("Qty Box Date 2", rL_SalesLine."Qty Box Date 2");
                            rL_SalesLineNew.validate("Qty Box Date 3", rL_SalesLine."Qty Box Date 3");
                            rL_SalesLineNew.validate("Qty Box Date 4", rL_SalesLine."Qty Box Date 4");
                            rL_SalesLineNew.validate("Qty Box Date 5", rL_SalesLine."Qty Box Date 5");
                            rL_SalesLineNew.validate("Qty Box Date 6", rL_SalesLine."Qty Box Date 6");
                            rL_SalesLineNew.validate("Qty Box Date 7", rL_SalesLine."Qty Box Date 7");
                            rL_SalesLineNew.validate("Qty Box Date 8", rL_SalesLine."Qty Box Date 8");
                            rL_SalesLineNew.validate("Total Qty on Boxes", rL_SalesLine."Total Qty on Boxes");
                            rL_SalesLineNew.validate("Additional Information", rL_SalesLine."Additional Information");
                            rL_SalesLineNew.validate("Pressure Min.", rL_SalesLine."Pressure Min.");
                            rL_SalesLineNew.validate("Pressure Max.", rL_SalesLine."Pressure Max.");
                            rL_SalesLineNew.validate("Brix Min", rL_SalesLine."Brix Min");
                            rL_SalesLineNew.validate("Vendor Name", rL_SalesLine."Vendor Name");
                            rL_SalesLineNew.validate("QC 1 Min", rL_SalesLine."QC 1 Min");
                            rL_SalesLineNew.validate("QC 1 Max", rL_SalesLine."QC 1 Max");
                            rL_SalesLineNew.validate("QC 1 Text", rL_SalesLine."QC 1 Text");
                            rL_SalesLineNew.validate("QC 2 Min", rL_SalesLine."QC 2 Min");
                            rL_SalesLineNew.validate("QC 2 Max", rL_SalesLine."QC 2 Max");
                            rL_SalesLineNew.validate("QC 2 Text", rL_SalesLine."QC 2 Text");
                            rL_SalesLineNew.validate("Box Width", rL_SalesLine."Box Width");
                            rL_SalesLineNew.validate("Box Char 1", rL_SalesLine."Box Char 1");
                            rL_SalesLineNew.validate("Box Length", rL_SalesLine."Box Length");
                            rL_SalesLineNew.validate("Box Char 2", rL_SalesLine."Box Char 2");
                            rL_SalesLineNew.validate("Box Height", rL_SalesLine."Box Height");
                            rL_SalesLineNew.validate("Box Changed Date", rL_SalesLine."Box Changed Date");
                            rL_SalesLineNew.validate("Harvest Temp. From", rL_SalesLine."Harvest Temp. From");
                            rL_SalesLineNew.validate("Harvest Temp. To", rL_SalesLine."Harvest Temp. To");
                            rL_SalesLineNew.validate("Freezer Harvest Temp. From", rL_SalesLine."Freezer Harvest Temp. From");
                            rL_SalesLineNew.validate("Freezer Harvest Temp. To", rL_SalesLine."Freezer Harvest Temp. To");
                            rL_SalesLineNew.validate("Transfer Temp. From", rL_SalesLine."Transfer Temp. From");
                            rL_SalesLineNew.validate("Transfer Temp. To", rL_SalesLine."Transfer Temp. To");
                            rL_SalesLineNew.Modify(true);




                        end;

                    until rL_SalesLine.Next() = 0;
                end;

            until rL_SalesHeader.Next() = 0;
        end;
    end;

    var
        SalesLinesAvailable: Boolean;

    // vG_PriceStartDate: Date;
    //vG_PriceEndDate: Date;

    //vG_PriceStartDatePreviousWeek: Date;
    //vG_PriceEndDatePreviousWeek: Date;
}
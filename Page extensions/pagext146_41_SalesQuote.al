pageextension 50246 SalesQuoteExt extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; Rec."Week No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Week No. field.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    myInt: Integer;
                begin
                    Page.Run(Page::"Lidl Lot Sample");
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
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }

            part(SalesLinesCostingLidl; "S.Q. Lidl Costing Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = SalesLinesAvailable;
                Enabled = SalesLinesAvailable;
                SubPageLink = "Document No." = field("No.");
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
                Caption = 'Previous Price Dates';
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

                field("Price Start Date"; Rec."Price Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Get Costing Price Previous Week - Start Date';
                }
                field("Price End Date"; Rec."Price End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Get Costing Price Previous Week - End Date';
                }


            }

            group(UpdatePriceDates)
            {
                Caption = 'Update Price Dates';
                field("Price Update Start Date"; Rec."Price Update Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Update Prices Previous Week - Start Date';
                }
                field("Price Update End Date"; Rec."Price Update End Date")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Import Lidl History';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Lidl History action.';

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
                ToolTip = 'Executes the Calculate Price Dates action.';

                trigger OnAction()
                var
                begin
                    Rec.TestField("Document Date");
                    Rec.TestField("Requested Delivery Date");
                    Rec.SQPriceDateCalculation();
                end;
            }

            action(ExportCompPrices)
            {
                ApplicationArea = All;
                Caption = 'Export Lidl Quote';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Export Lidl Quote action.';

                trigger OnAction()
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportLidlQuote(Rec."No.");
                end;
            }

        }

        modify(CopyDocument)
        {

            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("Requested Delivery Date");
                Rec.TestField("Price Start Date");
                Rec.TestField("Price End Date");
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
                SRSetup.Get();
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

                    vL_DateFilterPrevious4Weeks := Format(CalcDate('-4W', Rec."Document Date")) + '..' + Format(CalcDate('-1D', Rec."Document Date")); //1.0.0.220
                    LineSource := '-4W ' + vL_DateFilterPrevious4Weeks;
                    addAdditionalLines(vL_DateFilterPrevious4Weeks, LineSource, Rec."Sell-to Customer No.");

                    //check 3 last year next 4 weeks
                    PreviousYearDocumentDate := CalcDate('-1Y', Rec."Document Date");
                    PreviousYearEndDate := CalcDate('+4W', PreviousYearDocumentDate);

                    vL_DateFilterNext4WeeksLastYear := Format(PreviousYearDocumentDate) + '..' + Format(PreviousYearEndDate);
                    LineSource := '+4W ' + vL_DateFilterNext4WeeksLastYear;
                    addAdditionalLines(vL_DateFilterNext4WeeksLastYear, LineSource, Rec."Sell-to Customer No.");
                end;


                //end;





            end;
        }

        addafter(PageInteractionLogEntries)
        {
            action(SalesLinesMinus4W)
            {
                ApplicationArea = All;
                Caption = 'Sales Quotes -4W,+4W Last Year';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Sales Quotes -4W,+4W Last Year action.';

                trigger OnAction()
                var
                    rL_SalesLine: Record "Sales Line";
                    vL_DateFilterPrevious4Weeks: Text;
                    vL_DateFilterNext4WeeksLastYear: Text;
                    PreviousYearDocumentDate: Date;
                    PreviousYearEndDate: Date;
                    rL_SalesHeader: Record "Sales Header";

                begin
                    vL_DateFilterPrevious4Weeks := Format(CalcDate('-4W', Rec."Document Date")) + '..' + Format(CalcDate('-1D', Rec."Document Date")); //1.0.0.220

                    PreviousYearDocumentDate := CalcDate('-1Y', Rec."Document Date");
                    PreviousYearEndDate := CalcDate('+4W', PreviousYearDocumentDate);

                    vL_DateFilterNext4WeeksLastYear := Format(PreviousYearDocumentDate) + '..' + Format(PreviousYearEndDate);

                    rL_SalesHeader.Reset;
                    rL_SalesHeader.SetRange("Document Type", Rec."Document Type");
                    rL_SalesHeader.SetFilter("Document Date", vL_DateFilterPrevious4Weeks + '|' + vL_DateFilterNext4WeeksLastYear);
                    rL_SalesHeader.SetFilter("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    if rL_SalesHeader.FindSet() then begin

                    end;
                    Page.Run(Page::"Sales Quotes", rL_SalesHeader);


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
        SalesLinesAvailable := (Rec."Sell-to Customer No." <> '') or (Rec."Sell-to Customer Templ. Code" <> '') or (Rec."Sell-to Contact No." <> '');
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
        rL_SalesHeader.Reset;
        rL_SalesHeader.SetRange("Document Type", rL_SalesHeader."Document Type"::Quote);
        rL_SalesHeader.SetFilter("Document Date", pFilter);
        rL_SalesHeader.SetFilter("Sell-to Customer No.", pSelltoCustomerNo);
        if rL_SalesHeader.FindSet() then begin
            repeat
                rL_SalesLine.Reset;
                rL_SalesLine.SetRange("Document Type", rL_SalesHeader."Document Type");
                rL_SalesLine.SetFilter("Document No.", rL_SalesHeader."No.");
                rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                if rL_SalesLine.FindSet() then begin
                    repeat
                        rL_SalesLineCurrent.Reset;
                        rL_SalesLineCurrent.SetRange("Document Type", rL_SalesLineCurrent."Document Type"::Quote);
                        rL_SalesLineCurrent.SetFilter("Document No.", Rec."No.");
                        rL_SalesLineCurrent.SetFilter("No.", rL_SalesLine."No.");
                        if not rL_SalesLineCurrent.FindSet() then begin
                            //add new line

                            vL_LineNo := 0;
                            rL_SalesLineNew.Reset;
                            rL_SalesLineNew.SetRange("Document Type", Rec."Document Type");
                            rL_SalesLineNew.SetFilter("Document No.", Rec."No.");
                            if rL_SalesLineNew.FindLast() then begin
                                vL_LineNo := rL_SalesLineNew."Line No.";
                            end;

                            vL_LineNo += 10000;
                            //SRsetup.GET;
                            //"Cost Profit %" := SRsetup."Cost Profit %";

                            Clear(rL_SalesLineNew);
                            rL_SalesLineNew.Validate("Document Type", Rec."Document Type");
                            rL_SalesLineNew.Validate("Document No.", Rec."No.");
                            rL_SalesLineNew.Validate("Line No.", vL_LineNo);
                            rL_SalesLineNew.SetHideValidationDialog(true);
                            rL_SalesLineNew.Insert(true);

                            rL_SalesLineNew.Type := rL_SalesLineNew.Type::Item;
                            rL_SalesLineNew."Shelf No." := rL_SalesLine."Shelf No.";
                            rL_SalesLineNew."No." := rL_SalesLine."No.";


                            rL_SalesLineNew.Description := rL_SalesLine.Description;
                            rL_SalesLineNew."Line Source" := rL_SalesHeader."External Document No."; //rL_SalesHeader."No." + ' ' + pLineSource;


                            rL_SalesLineNew.Validate("Pallet Qty", rL_SalesLine."Pallet Qty");
                            rL_SalesLineNew."Country/Region of Origin Code" := rL_SalesLine."Country/Region of Origin Code";
                            rL_SalesLineNew.Validate("Product Class", rL_SalesLine."Product Class");
                            rL_SalesLineNew.Validate("Package Qty", rL_SalesLine."Package Qty");
                            rL_SalesLineNew.Validate("Calibration Min.", rL_SalesLine."Calibration Min.");
                            rL_SalesLineNew.Validate("Calibration Max.", rL_SalesLine."Calibration Max.");
                            rL_SalesLineNew.Validate("Calibration UOM", rL_SalesLine."Calibration UOM");
                            rL_SalesLineNew.Validate(Variety, rL_SalesLine.Variety);
                            rL_SalesLineNew.Validate("Currency Code", rL_SalesLine."Currency Code");
                            rL_SalesLineNew.Validate("Price Previous Week Box", rL_SalesLine."Price Previous Week Box");
                            rL_SalesLineNew.Validate("Price Previous Week PCS", rL_SalesLine."Price Previous Week PCS");
                            rL_SalesLineNew.Validate("Price Previous Week KG", rL_SalesLine."Price Previous Week KG");
                            rL_SalesLineNew.Validate("Price Box", rL_SalesLine."Price Box");
                            rL_SalesLineNew.Validate("Price PCS", rL_SalesLine."Price PCS");
                            rL_SalesLineNew.Validate("Price KG", rL_SalesLine."Price KG");
                            rL_SalesLineNew.Validate("Row Index", 0);
                            rL_SalesLineNew.Validate("Qty Box Date 1", rL_SalesLine."Qty Box Date 1");
                            rL_SalesLineNew.Validate("Qty Box Date 2", rL_SalesLine."Qty Box Date 2");
                            rL_SalesLineNew.Validate("Qty Box Date 3", rL_SalesLine."Qty Box Date 3");
                            rL_SalesLineNew.Validate("Qty Box Date 4", rL_SalesLine."Qty Box Date 4");
                            rL_SalesLineNew.Validate("Qty Box Date 5", rL_SalesLine."Qty Box Date 5");
                            rL_SalesLineNew.Validate("Qty Box Date 6", rL_SalesLine."Qty Box Date 6");
                            rL_SalesLineNew.Validate("Qty Box Date 7", rL_SalesLine."Qty Box Date 7");
                            rL_SalesLineNew.Validate("Qty Box Date 8", rL_SalesLine."Qty Box Date 8");
                            rL_SalesLineNew.Validate("Total Qty on Boxes", rL_SalesLine."Total Qty on Boxes");
                            rL_SalesLineNew.Validate("Additional Information", rL_SalesLine."Additional Information");
                            rL_SalesLineNew.Validate("Pressure Min.", rL_SalesLine."Pressure Min.");
                            rL_SalesLineNew.Validate("Pressure Max.", rL_SalesLine."Pressure Max.");
                            rL_SalesLineNew.Validate("Brix Min", rL_SalesLine."Brix Min");
                            rL_SalesLineNew.Validate("Vendor Name", rL_SalesLine."Vendor Name");
                            rL_SalesLineNew.Validate("QC 1 Min", rL_SalesLine."QC 1 Min");
                            rL_SalesLineNew.Validate("QC 1 Max", rL_SalesLine."QC 1 Max");
                            rL_SalesLineNew.Validate("QC 1 Text", rL_SalesLine."QC 1 Text");
                            rL_SalesLineNew.Validate("QC 2 Min", rL_SalesLine."QC 2 Min");
                            rL_SalesLineNew.Validate("QC 2 Max", rL_SalesLine."QC 2 Max");
                            rL_SalesLineNew.Validate("QC 2 Text", rL_SalesLine."QC 2 Text");
                            rL_SalesLineNew.Validate("Box Width", rL_SalesLine."Box Width");
                            rL_SalesLineNew.Validate("Box Char 1", rL_SalesLine."Box Char 1");
                            rL_SalesLineNew.Validate("Box Length", rL_SalesLine."Box Length");
                            rL_SalesLineNew.Validate("Box Char 2", rL_SalesLine."Box Char 2");
                            rL_SalesLineNew.Validate("Box Height", rL_SalesLine."Box Height");
                            rL_SalesLineNew.Validate("Box Changed Date", rL_SalesLine."Box Changed Date");
                            rL_SalesLineNew.Validate("Harvest Temp. From", rL_SalesLine."Harvest Temp. From");
                            rL_SalesLineNew.Validate("Harvest Temp. To", rL_SalesLine."Harvest Temp. To");
                            rL_SalesLineNew.Validate("Freezer Harvest Temp. From", rL_SalesLine."Freezer Harvest Temp. From");
                            rL_SalesLineNew.Validate("Freezer Harvest Temp. To", rL_SalesLine."Freezer Harvest Temp. To");
                            rL_SalesLineNew.Validate("Transfer Temp. From", rL_SalesLine."Transfer Temp. From");
                            rL_SalesLineNew.Validate("Transfer Temp. To", rL_SalesLine."Transfer Temp. To");
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
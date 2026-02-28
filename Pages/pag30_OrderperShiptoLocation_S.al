page 50030 "Order per Ship-to Location (S)"
{
    // TAL0.2 2021/12/16 VC review date filters
    // TAL0.3 2021/12/16 VC add reports
    //                     Sales Order Production
    //                     Sales Order Packing
    // 
    // TAL0.4 2022/01/11 VC add report Sales Order Material Requisition

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    RefreshOnActivate = false;
    SaveValues = true;
    SourceTable = "Ship-to Address";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(vG_ShipmentStartDate; vG_ShipmentStartDate)
                {
                    Caption = 'Shipment Start Date';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        FormatDateFilter(true);
                    end;
                }
                field(vG_ShipmentEndDate; vG_ShipmentEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment End Date';

                    trigger OnValidate();
                    begin
                        FormatDateFilter(true);
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';
                    Editable = false;
                }
                field(vG_NoofItems; vG_NoofItems)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Items';
                    Editable = false;
                }
                field(Show; Show)
                {
                    ApplicationArea = All;
                    Caption = 'Show Name';

                    trigger OnValidate();
                    begin
                        ShowTransferToNameOnAfterValid;
                    end;
                }
                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = All;
                    Caption = 'Column Set';
                    Editable = false;
                }
            }
            part(MatrixForm; "Order per Ship-to Loc Lines S")
            {
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control1000000005; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1000000004; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Set")
            {
                ApplicationArea = Suite;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction();
                begin
                    MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Previous);
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Suite;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction();
                begin
                    MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Next);
                end;
            }
            action(ShowFilters)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CurrPage.MatrixForm.PAGE.ShowFilters();
                end;
            }
        }
        area(reporting)
        {
            action("Sales Order Production")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderProduction: Report "Sales Order Production";
                begin
                    //Sales Order Production
                    CLEAR(rL_SalesLine);
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SETFILTER(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FINDSET then;

                    CLEAR(rpt_SalesOrderProduction);
                    rpt_SalesOrderProduction.SETTABLEVIEW(rL_SalesLine);
                    rpt_SalesOrderProduction.USEREQUESTPAGE(true);
                    rpt_SalesOrderProduction.RUN;
                end;
            }
            action("Sales Order Packing")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderPacking: Report "Sales Order Packing";
                begin
                    //
                    CLEAR(rL_SalesLine);
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SETFILTER(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FINDSET then;

                    CLEAR(rpt_SalesOrderPacking);
                    rpt_SalesOrderPacking.SETTABLEVIEW(rL_SalesLine);
                    rpt_SalesOrderPacking.USEREQUESTPAGE(true);
                    rpt_SalesOrderPacking.RUN;
                end;
            }
            action("Sales Order Material Requisition")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderMatReq: Report "Sales Order Mat. Requisition";
                begin
                    //+TAL0.4
                    //Sales Order Production
                    CLEAR(rL_SalesLine);
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SETFILTER(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FINDSET then;

                    CLEAR(rpt_SalesOrderMatReq);
                    rpt_SalesOrderMatReq.SETTABLEVIEW(rL_SalesLine);
                    rpt_SalesOrderMatReq.USEREQUESTPAGE(true);
                    rpt_SalesOrderMatReq.RUN;
                    //-TAL0.4
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        MATRIX_MatrixRecord.SETFILTER("No. of Orders", '<>%1', 0);
        MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::First);

        FormatDateFilter(false);
    end;

    var
        Show: Boolean;
        MATRIX_CaptionRange: Text;
        MATRIX_MatrixRecord: Record "Ship-to Address";
        MatrixRecords: array[52] of Record "Ship-to Address";
        MATRIX_CaptionSet: array[52] of Text[80];
        MATRIX_PKFirstRecInCurrSet: Text;
        MATRIX_CurrentNoOfColumns: Integer;
        MATRIX_SetWanted: Option First,Previous,Same,Next;
        DateFilter: Text[30];
        vG_ShipmentStartDate: Date;
        vG_ShipmentEndDate: Date;
        vG_NoofItems: Integer;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option First,Previous,Same,Next);
    var
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
        CurrentMatrixRecordOrdinal: Integer;
        CaptionField: Integer;
    begin
        CLEAR(MATRIX_CaptionSet);
        CLEAR(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        RecRef.GETTABLE(MATRIX_MatrixRecord);
        RecRef.SETTABLE(MATRIX_MatrixRecord);

        if Show then
            CaptionField := 3
        else
            CaptionField := 2;

        MatrixMgt.GenerateMatrixData(RecRef, SetWanted, ARRAYLEN(MatrixRecords), CaptionField, MATRIX_PKFirstRecInCurrSet, MATRIX_CaptionSet
          , MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);

        if MATRIX_CurrentNoOfColumns > 0 then begin
            MATRIX_MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
            MATRIX_MatrixRecord.FIND;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MATRIX_MatrixRecord);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) or (MATRIX_MatrixRecord.NEXT <> 1);
        end;

        UpdateMatrixSubform;
    end;

    local procedure ShowTransferToNameOnAfterValid();
    begin
        MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Same);
    end;

    local procedure UpdateMatrixSubform();
    begin
        CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet, MatrixRecords, MATRIX_CurrentNoOfColumns, Show, DateFilter);
        //CurrPage.MatrixForm.PAGE.SETRECORD(Rec);
        CurrPage.UPDATE(false);
    end;

    local procedure FormatDateFilter(pShowMessage: Boolean);
    var
        rL_Item: Record Item;
    begin
        DateFilter := FORMAT(vG_ShipmentStartDate);

        if (vG_ShipmentEndDate <> 0D) and (vG_ShipmentStartDate <> 0D) then begin
            if vG_ShipmentEndDate >= vG_ShipmentStartDate then begin
                DateFilter := FORMAT(vG_ShipmentStartDate) + '..' + FORMAT(vG_ShipmentEndDate);
            end;
        end;


        ShowTransferToNameOnAfterValid;
        UpdateMatrixSubform();


        vG_NoofItems := 0;
        CLEAR(rL_Item);
        rL_Item.RESET;
        rL_Item.SETFILTER("Date Filter", DateFilter);
        rL_Item.SETFILTER("Qty. on Sales Order", '<>%1', 0);
        rL_Item.SETFILTER("Global Dimension 2 Code", 'F-CUTS');
        if rL_Item.FINDSET then begin
            vG_NoofItems := rL_Item.COUNT;
        end;

        if (DateFilter = '') and (vG_NoofItems <> 0) and (pShowMessage) then begin
            MESSAGE('Click Refresh');
        end;
    end;
}


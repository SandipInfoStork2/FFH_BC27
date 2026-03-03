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
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(vG_ShipmentStartDate; vG_ShipmentStartDate)
                {
                    Caption = 'Shipment Start Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipment Start Date field.';

                    trigger OnValidate();
                    begin
                        FormatDateFilter(true);
                    end;
                }
                field(vG_ShipmentEndDate; vG_ShipmentEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment End Date';
                    ToolTip = 'Specifies the value of the Shipment End Date field.';

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
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
                field(vG_NoofItems; vG_NoofItems)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Items';
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. of Items field.';
                }
                field(Show; Show)
                {
                    ApplicationArea = All;
                    Caption = 'Show Name';
                    ToolTip = 'Specifies the value of the Show Name field.';

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
                    ToolTip = 'Specifies the value of the Column Set field.';
                }
            }
            part(MatrixForm; "Order per Ship-to Loc Lines S")
            {
                ApplicationArea = All;
            }
        }
        area(FactBoxes)
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
        area(Processing)
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
                ToolTip = 'Executes the ShowFilters action.';

                trigger OnAction();
                begin
                    CurrPage.MatrixForm.Page.ShowFilters();
                end;
            }
        }
        area(Reporting)
        {
            action("Sales Order Production")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Sales Order Production action.';

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderProduction: Report "Sales Order Production";
                begin
                    //Sales Order Production
                    Clear(rL_SalesLine);
                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetFilter(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SetFilter("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FindSet then;

                    Clear(rpt_SalesOrderProduction);
                    rpt_SalesOrderProduction.SetTableView(rL_SalesLine);
                    rpt_SalesOrderProduction.UseRequestPage(true);
                    rpt_SalesOrderProduction.Run;
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
                ToolTip = 'Executes the Sales Order Packing action.';

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderPacking: Report "Sales Order Packing";
                begin
                    //
                    Clear(rL_SalesLine);
                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetFilter(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SetFilter("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FindSet then;

                    Clear(rpt_SalesOrderPacking);
                    rpt_SalesOrderPacking.SetTableView(rL_SalesLine);
                    rpt_SalesOrderPacking.UseRequestPage(true);
                    rpt_SalesOrderPacking.Run;
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
                ToolTip = 'Executes the Sales Order Material Requisition action.';

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                    rpt_SalesOrderMatReq: Report "Sales Order Mat. Requisition";
                begin
                    //+TAL0.4
                    //Sales Order Production
                    Clear(rL_SalesLine);
                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetFilter(rL_SalesLine."Shortcut Dimension 2 Code", 'F-CUTS');
                    if DateFilter <> '' then begin
                        rL_SalesLine.SetFilter("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FindSet then;

                    Clear(rpt_SalesOrderMatReq);
                    rpt_SalesOrderMatReq.SetTableView(rL_SalesLine);
                    rpt_SalesOrderMatReq.UseRequestPage(true);
                    rpt_SalesOrderMatReq.Run;
                    //-TAL0.4
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        MATRIX_MatrixRecord.SetFilter("No. of Orders", '<>%1', 0);
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
        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        RecRef.GetTable(MATRIX_MatrixRecord);
        RecRef.SetTable(MATRIX_MatrixRecord);

        if Show then
            CaptionField := 3
        else
            CaptionField := 2;

        MatrixMgt.GenerateMatrixData(RecRef, SetWanted, ArrayLen(MatrixRecords), CaptionField, MATRIX_PKFirstRecInCurrSet, MATRIX_CaptionSet
          , MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);

        if MATRIX_CurrentNoOfColumns > 0 then begin
            MATRIX_MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
            MATRIX_MatrixRecord.Find;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MATRIX_MatrixRecord);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) or (MATRIX_MatrixRecord.Next <> 1);
        end;

        UpdateMatrixSubform;
    end;

    local procedure ShowTransferToNameOnAfterValid();
    begin
        MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Same);
    end;

    local procedure UpdateMatrixSubform();
    begin
        CurrPage.MatrixForm.Page.Load(MATRIX_CaptionSet, MatrixRecords, MATRIX_CurrentNoOfColumns, Show, DateFilter);
        //CurrPage.MatrixForm.PAGE.SETRECORD(Rec);
        CurrPage.Update(false);
    end;

    local procedure FormatDateFilter(pShowMessage: Boolean);
    var
        rL_Item: Record Item;
    begin
        DateFilter := Format(vG_ShipmentStartDate);

        if (vG_ShipmentEndDate <> 0D) and (vG_ShipmentStartDate <> 0D) then begin
            if vG_ShipmentEndDate >= vG_ShipmentStartDate then begin
                DateFilter := Format(vG_ShipmentStartDate) + '..' + Format(vG_ShipmentEndDate);
            end;
        end;


        ShowTransferToNameOnAfterValid;
        UpdateMatrixSubform();


        vG_NoofItems := 0;
        Clear(rL_Item);
        rL_Item.Reset;
        rL_Item.SetFilter("Date Filter", DateFilter);
        rL_Item.SetFilter("Qty. on Sales Order", '<>%1', 0);
        rL_Item.SetFilter("Global Dimension 2 Code", 'F-CUTS');
        if rL_Item.FindSet then begin
            vG_NoofItems := rL_Item.Count;
        end;

        if (DateFilter = '') and (vG_NoofItems <> 0) and (pShowMessage) then begin
            Message('Click Refresh');
        end;
    end;
}


report 50089 "Prod. Order - Mat.RequisitionF"
{
    // TAL0.1 2021/11/25 VC remove decimals from "Scrap %" change from <0:5> to 0:0
    //                   resize columns to fit item, description, scrab
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep89_50089_ProdOrderMatRequisition.rdlc';

    Caption = 'Prod. Order - Mat. Requisition';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(ProdOrderTableCaptionFilter; TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(Desc_ProdOrder; Description)
            {
            }
            column(SourceNo_ProdOrder; "Source No.")
            {
                IncludeCaption = true;
            }
            column(Status_ProdOrder; Status)
            {
            }
            column(Qty_ProdOrder; Quantity)
            {
                IncludeCaption = true;
            }
            column(Filter_ProdOrder; ProdOrderFilter)
            {
            }
            column(ProdOrderMaterialRqstnCapt; ProdOrderMaterialRqstnCaptLbl)
            {
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                column(ItemNo_ProdOrderComp; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ProdOrderComp; Description)
                {
                    IncludeCaption = true;
                }
                column(Qtyper_ProdOrderComp; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UOMCode_ProdOrderComp; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(RemainingQty_ProdOrderComp; "Remaining Quantity")
                {
                    IncludeCaption = true;
                }
                column(Scrap_ProdOrderComp; "Scrap %")
                {
                    DecimalPlaces = 0 : 0;
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderComp; Format("Due Date"))
                {
                    IncludeCaption = false;
                }
                column(LocationCode_ProdOrderComp; "Location Code")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    ReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");

                    ReservationEntry.SetRange("Source Type", Database::"Prod. Order Component");
                    ReservationEntry.SetRange("Source ID", "Production Order"."No.");
                    ReservationEntry.SetRange("Source Ref. No.", "Line No.");
                    ReservationEntry.SetRange("Source Subtype", Status);
                    ReservationEntry.SetRange("Source Batch Name", '');
                    ReservationEntry.SetRange("Source Prod. Order Line", "Prod. Order Line No.");

                    if ReservationEntry.FindSet then begin
                        RemainingQtyReserved := 0;
                        repeat
                            if ReservationEntry2.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then
                                if (ReservationEntry2."Source Type" = Database::"Prod. Order Line") and
                                   (ReservationEntry2."Source ID" = "Prod. Order Component"."Prod. Order No.")
                                then
                                    RemainingQtyReserved += ReservationEntry2."Quantity (Base)";
                        until ReservationEntry.Next = 0;
                        if "Prod. Order Component"."Remaining Qty. (Base)" = RemainingQtyReserved then
                            CurrReport.Skip;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Remaining Quantity", '<>0');
                end;
            }

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ProdOrderCompDueDateCapt = 'Due Date';
    }

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ProdOrderFilter: Text;
        RemainingQtyReserved: Decimal;
        ProdOrderMaterialRqstnCaptLbl: Label 'Prod. Order - Material Requisition';
        CurrReportPageNoCaptLbl: Label 'Page';
}


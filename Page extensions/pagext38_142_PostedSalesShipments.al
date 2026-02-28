/*
TAL0.1 2018/07/22 VC add field Batch No. 
TAL0.2 2019/09/17 VC add missing logic for Print to print for a specific customer, bill-to customer No. was always blank 
TAL0.3 2020/03/03 VC add fields for delivery
TAL0.4 2021/03/26 VC add fields Total Qty, Total Weight
TAL0.5 2021/04/06 VC add PrintAppendixRecords
*/
pageextension 50138 PostedSalesShipmentsExt extends "Posted Sales Shipments"
{
    layout
    {
        // Add changes to page layout here
        modify("External Document No.")
        {
            Visible = true;
        }
        addafter("Shipment Date")
        {

            field("Batch No."; "Batch No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Order No."; "Order No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Lot No."; "Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = All;
            }
            field("Total Qty (Base)"; "Total Qty (Base)")
            {
                ApplicationArea = All;
            }
            field("Total Weight"; "Total Weight")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 0;
            }
            field("Delivery No."; "Delivery No.")
            {
                ApplicationArea = All;
            }
            field("Delivery Sequence"; "Delivery Sequence")
            {
                ApplicationArea = All;
                BlankZero = true;
            }

            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Posting Date")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Print")
        {
            action("Item Tracking Appendix")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.PrintAppendixRecords(SalesShipmentHeader);
                end;
            }
        }

        addafter("&Navigate")
        {
            group(Delivery)
            {
                action(Action_MoveUpPage)
                {
                    ApplicationArea = All;
                    Caption = 'Move &Up Page';
                    Enabled = AllowMoveUpPage;
                    Image = MoveUp;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Moves up the selected page within the category.';

                    trigger OnAction();
                    begin
                        MovePage(true);
                    end;
                }
                action(Action_MoveDownPage)
                {
                    ApplicationArea = All;
                    Caption = 'Move &Down Page';
                    Enabled = AllowMoveDownPage;
                    Image = MoveDown;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Moves down the selected page within the category.';

                    trigger OnAction();
                    begin
                        MovePage(false);
                    end;
                }
                action(Editable)
                {
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        CurrPage.EDITABLE(true);
                    end;
                }
            }

            action(OrderQty)
            {
                caption = 'Order Qty';
                ApplicationArea = All;
                RunObject = page "Order Qty";
                RunPageLink = "Document No." = field("Order No.");
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //+TAL0.3
        AllowMoveUpPage := "Delivery Sequence" <> 1; //TRUE; //(DataKind = CONST_DK_PAGE) AND NOT IsFirst;
        AllowMoveDownPage := "Delivery Sequence" <> COUNT; //TRUE;//(DataKind = CONST_DK_PAGE) AND NOT IsLast;
        //-TAL0.3
    end;

    local procedure MovePage(_MoveUp: Boolean);
    var
        Rec1: Record "Sales Shipment Header";
        Rec2: Record "Sales Shipment Header";
    begin
        FocusedRec := Rec;

        if _MoveUp then begin
            Rec2.GET("No.");
            NEXT(-1);
            Rec1.GET("No.");
        end
        else begin
            Rec1.GET("No.");
            NEXT(1);
            Rec2.GET("No.");
        end;

        Rec1."Delivery Sequence" += 1;
        Rec1.MODIFY(false);
        Rec2."Delivery Sequence" -= 1;
        Rec2.MODIFY(false);

        RefreshCurrentPage(false);
        //CurrPage.UPDATE(FALSE);
    end;

    local procedure RefreshCurrentPage(_InitialRefresh: Boolean);
    var
        Eof: Boolean;
    begin
        //CheckInitialized;
        //BuildTree;
        SETCURRENTKEY("Delivery No.", "Delivery Sequence");

        if not _InitialRefresh then
            CurrPage.UPDATE(false);

        if FINDFIRST then begin
            if not _InitialRefresh then begin
                Eof := false;
                while (("No." <> FocusedRec."No.")) and not Eof do
                    Eof := NEXT = 0;

                if Eof then
                    FINDFIRST;
            end;
        end;
    end;

    var
        FocusedRec: Record "Sales Shipment Header" temporary;
        [InDataSet]
        AllowMoveUpPage: Boolean;
        [InDataSet]
        AllowMoveDownPage: Boolean;
}
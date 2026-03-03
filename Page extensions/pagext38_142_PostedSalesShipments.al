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

            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
            }
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty (Base)"; Rec."Total Qty (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty (Base) field.';
            }
            field("Total Weight"; Rec."Total Weight")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 0;
                ToolTip = 'Specifies the value of the Total Weight field.';
            }
            field("Delivery No."; Rec."Delivery No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery No. field.';
            }
            field("Delivery Sequence"; Rec."Delivery Sequence")
            {
                ApplicationArea = All;
                BlankZero = true;
                ToolTip = 'Specifies the value of the Delivery Sequence field.';
            }

            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
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
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
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
                    ToolTip = 'Executes the Editable action.';

                    trigger OnAction();
                    begin
                        CurrPage.Editable(true);
                    end;
                }
            }

            action(OrderQty)
            {
                Caption = 'Order Qty';
                ApplicationArea = All;
                RunObject = page "Order Qty";
                RunPageLink = "Document No." = field("Order No.");
                ToolTip = 'Executes the Order Qty action.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //+TAL0.3
        AllowMoveUpPage := Rec."Delivery Sequence" <> 1; //TRUE; //(DataKind = CONST_DK_PAGE) AND NOT IsFirst;
        AllowMoveDownPage := Rec."Delivery Sequence" <> Rec.COUNT; //TRUE;//(DataKind = CONST_DK_PAGE) AND NOT IsLast;
        //-TAL0.3
    end;

    local procedure MovePage(_MoveUp: Boolean);
    var
        Rec1: Record "Sales Shipment Header";
        Rec2: Record "Sales Shipment Header";
    begin
        FocusedRec := Rec;

        if _MoveUp then begin
            Rec2.GET(Rec."No.");
            Rec.NEXT(-1);
            Rec1.GET(Rec."No.");
        end
        else begin
            Rec1.GET(Rec."No.");
            Rec.NEXT(1);
            Rec2.GET(Rec."No.");
        end;

        Rec1."Delivery Sequence" += 1;
        Rec1.Modify(false);
        Rec2."Delivery Sequence" -= 1;
        Rec2.Modify(false);

        RefreshCurrentPage(false);
        //CurrPage.UPDATE(FALSE);
    end;

    local procedure RefreshCurrentPage(_InitialRefresh: Boolean);
    var
        Eof: Boolean;
    begin
        //CheckInitialized;
        //BuildTree;
        Rec.SETCURRENTKEY("Delivery No.", "Delivery Sequence");

        if not _InitialRefresh then
            CurrPage.Update(false);

        if Rec.FINDFIRST then begin
            if not _InitialRefresh then begin
                Eof := false;
                while ((Rec."No." <> FocusedRec."No.")) and not Eof do
                    Eof := Rec.NEXT = 0;

                if Eof then
                    Rec.FINDFIRST;
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
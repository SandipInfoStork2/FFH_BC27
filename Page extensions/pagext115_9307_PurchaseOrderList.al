/*
TAL0.1 2017/12/04 VC add 3 columns to calcualted total Qty
                     add delete invoiced purchase orders
TAL0.2 2019/01/03 VC add Deliver to vendor fields 
TAL0.3 2021/04/06 VC add PrintAppendixRecords
TAL0.4 2021/04/13 VC mark orders with Sundry Grower 
TAL0.5 2021/12/22 VC add action Print Delivery Order (Drop)

*/
pageextension 50215 PurchaseOrderListExt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        modify("Buy-from Vendor Name")
        {
            StyleExpr = StyleTxt;
        }

        addafter("Amount Including VAT")
        {
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = All;
            }
            field("Total Qty Received"; "Total Qty Received")
            {
                ApplicationArea = All;
            }
            field("Total Qty Invoiced"; "Total Qty Invoiced")
            {
                ApplicationArea = All;
            }
            field("Deliver-to Vendor No."; "Deliver-to Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Deliver-to Name"; "Deliver-to Name")
            {
                ApplicationArea = All;
            }
            field("Deliver Address Code"; "Deliver Address Code")
            {
                ApplicationArea = All;
            }
            field(vG_SundryGrowerExists; vG_SundryGrowerExists)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Sundry Grower Exists',
                                ENU = 'Sundry Grower Exists';
                Editable = false;
            }
            field(vG_TrackingRequired; vG_TrackingRequired)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Tracking Required',
                                ENU = 'Tracking Required';
            }
            field(vG_TrackingCompleted; vG_TrackingCompleted)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Tracking Completed',
                                ENU = 'Tracking Completed';
                Editable = false;
            }
        }

        addafter("Document Date")
        {
            field("Expected Receipt Date"; "Expected Receipt Date")
            {
                ApplicationArea = All;
            }
            field("Expected Receipt Time"; "Expected Receipt Time")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print Delivery Order (Drop)")
            {
                ApplicationArea = All;
                Caption = '&Print Delivery Order (Drop)';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction();
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    //+TAL0.5
                    PurchaseHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                    REPORT.RUN(REPORT::"Purchase Delivery Order", true, false, PurchaseHeader);
                    //-TAL0.5
                end;
            }
        }

        addafter(Send)
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
                    vL_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SETSELECTIONFILTER(vL_PurchaseHeader);
                    vL_PurchaseHeader.PrintAppendixRecords(vL_PurchaseHeader);
                end;
            }
        }

        addafter("Send IC Purchase Order")
        {
            action("Delete Invoiced P.O.")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Delete Invoiced Purch. Orders";
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //+TAL0.4
        vG_SundryGrowerExists := cu_GeneralMgt.SundryGrowerExistsPO("No.");
        StyleTxt := '';
        if vG_SundryGrowerExists then begin
            StyleTxt := 'Attention';
        end;
        //-TAL0.4

        vG_TrackingRequired := cu_GeneralMgt.POLotTrackingRequired("No.");
        vG_TrackingCompleted := cu_GeneralMgt.POLotTrackingCompleted("No.");
    end;

    var
        vG_SundryGrowerExists: Boolean;
        cu_GeneralMgt: Codeunit "General Mgt.";
        [InDataSet]
        StyleTxt: Text;
        [InDataSet]
        vG_TrackingCompleted: Boolean;
        [InDataSet]
        vG_TrackingRequired: Boolean;
}
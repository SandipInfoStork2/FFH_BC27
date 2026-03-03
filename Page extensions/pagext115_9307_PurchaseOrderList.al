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
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty Received"; Rec."Total Qty Received")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Received field.';
            }
            field("Total Qty Invoiced"; Rec."Total Qty Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Invoiced field.';
            }
            field("Deliver-to Vendor No."; Rec."Deliver-to Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deliver-to Vendor No. field.';
            }
            field("Deliver-to Name"; Rec."Deliver-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deliver-to Name field.';
            }
            field("Deliver Address Code"; Rec."Deliver Address Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deliver Address Code field.';
            }
            field(vG_SundryGrowerExists; vG_SundryGrowerExists)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Sundry Grower Exists',
                                ENU = 'Sundry Grower Exists';
                Editable = false;
                ToolTip = 'Specifies the value of the vG_SundryGrowerExists field.';
            }
            field(vG_TrackingRequired; vG_TrackingRequired)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Tracking Required',
                                ENU = 'Tracking Required';
                ToolTip = 'Specifies the value of the vG_TrackingRequired field.';
            }
            field(vG_TrackingCompleted; vG_TrackingCompleted)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Tracking Completed',
                                ENU = 'Tracking Completed';
                Editable = false;
                ToolTip = 'Specifies the value of the vG_TrackingCompleted field.';
            }
        }

        addafter("Document Date")
        {
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
            }
            field("Expected Receipt Time"; Rec."Expected Receipt Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expected Receipt Time field.';
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
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    Report.Run(Report::"Purchase Delivery Order", true, false, PurchaseHeader);
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
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    vL_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(vL_PurchaseHeader);
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
                RunObject = report "Delete Invoiced Purch. Orders";
                ToolTip = 'Executes the Delete Invoiced P.O. action.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //+TAL0.4
        vG_SundryGrowerExists := cu_GeneralMgt.SundryGrowerExistsPO(Rec."No.");
        StyleTxt := '';
        if vG_SundryGrowerExists then begin
            StyleTxt := 'Attention';
        end;
        //-TAL0.4

        vG_TrackingRequired := cu_GeneralMgt.POLotTrackingRequired(Rec."No.");
        vG_TrackingCompleted := cu_GeneralMgt.POLotTrackingCompleted(Rec."No.");
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
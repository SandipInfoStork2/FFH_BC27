//+1080
page 50045 "Posted Sales Ship. L.-Update"
{
    Caption = 'Posted Sales Shipment Line - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Sales Shipment Line";
    SourceTableTemporary = true;
    Permissions = TableData "Sales Shipment Line" = rm;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; rG_SalesShipmentHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer Name"; rG_SalesShipmentHeader."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Editable = false;
                    ToolTip = 'Specifies the name of customer at the sell-to address.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field(OldDescription; Rec.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Old Description';
                    ToolTip = 'Custom: Description';
                    Editable = false;
                    Visible = true;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';



                /*
                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Description';
                    ToolTip = 'Custom: Description';
                    Editable = false;
                    Visible = false;
                }
                */

                field(OldQtyRequested; xSalesShipmentLine."Qty. Requested")
                {
                    ApplicationArea = Suite;
                    Caption = 'Old Qty. Requested';
                    ToolTip = 'Custom: Qty. Requested';
                    Editable = false;
                }

                field(QtyRequested; Rec."Qty. Requested")
                {
                    ApplicationArea = Suite;
                    Caption = 'Qty. Requested';
                    ToolTip = 'Custom: Qty. Requested';
                    Editable = true;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        xSalesShipmentLine := Rec;
        rG_SalesShipmentHeader.GET(xSalesShipmentLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_SalesShipmentine: Record "Sales Shipment Line";
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged then begin
                //CODEUNIT.Run(CODEUNIT::"Shipment Header - Edit", Rec);
                rL_SalesShipmentine.GET(Rec."Document No.", Rec."Line No.");
                //rL_SalesShipmentine.Description := Rec.Description;
                rL_SalesShipmentine."Qty. Requested" := Rec."Qty. Requested";
                rL_SalesShipmentine.Modify();
            end;

    end;

    var
        xSalesShipmentLine: Record "Sales Shipment Line";
        rG_SalesShipmentHeader: Record "Sales Shipment Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
          //(Rec."Description" <> xSalesShipmentLine."Description") or
          (Rec."Qty. Requested" <> xSalesShipmentLine."Qty. Requested");

        OnAfterRecordChanged(Rec, xSalesShipmentLine, IsChanged);
    end;

    //[Scope('OnPrem')]
    procedure SetRec(SalesShipmentLine: Record "Sales Shipment Line")
    begin
        Rec := SalesShipmentLine;
        Rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var SalesShipmentLine: Record "Sales Shipment Line"; xSalesShipmentLine: Record "Sales Shipment Line"; var IsChanged: Boolean)
    begin
    end;
}
//-1080


/*
    TAL0.1 2018/07/22 VC add field Batch No. 
    TAL0.2 2021/03/26 VC add fields Total Qty, Total Weight
    TAL0.3 2021/03/27 VC Total Qty (Base), format decimals 0:0 
    TAL0.4 2021/04/06 VC add PrintAppendixRecords
*/

tableextension 50117 SalesShipmentHeaderExt extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here


        field(50011; "Batch No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50014; "Lot No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50015; "Customer Reference No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50016; "Excel Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50099; "Delivery No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Schedule" where(Status = filter(' '));
        }
        field(50100; "Delivery Sequence"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Chain of Custody Tracking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50103; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }

        field(50146; "Shipping Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Shipping Temperature °C';
        }

        field(50147; "Shipping Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50200; "Total Qty"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line".Quantity where("Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }


        field(50201; "Total Weight"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Net Weight" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50202; "Total Qty (Base)"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Quantity (Base)" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }


    }

    keys
    {
        key(key50000; "Delivery No.", "Delivery Sequence")
        {

        }
    }

    fieldgroups
    {

        //addlast(Brick; "Ship-to Code", "Ship-to Name", "Posting Date")
        // {

        // }
    }

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    procedure PrintAppendixRecords(var pSalesShipHeader: Record "Sales Shipment Header");
    var
        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix FFH";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pSalesShipHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetSalesShipment("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pSalesShipHeader.Next = 0;
        end;
    end;

    procedure PrintAppendixRecordsQuality(var pSalesShipHeader: Record "Sales Shipment Header");
    var
        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix Quality";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pSalesShipHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetSalesShipment("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pSalesShipHeader.Next = 0;
        end;
    end;

    procedure SetSecurityFilterOnCustomer(pGlobalCode: Code[10])
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("HORECA Customer No.");
        UserSetup.TestField("HORECA Ship-to Filter");

        FilterGroup(2);
        SetFilter("Sell-to Customer No.", '%1', UserSetup."HORECA Customer No.");

        if pGlobalCode = '' then begin
            SetFilter("Ship-to Code", '%1', UserSetup."HORECA Ship-to Filter");
        end else begin
            SetFilter("Ship-to Code", '%1', pGlobalCode);
        end;
        FilterGroup(0);

    end;

    var
        myInt: Integer;
}
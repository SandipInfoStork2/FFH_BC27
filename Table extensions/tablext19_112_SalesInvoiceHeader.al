/*
TAL0.1 2018/07/22 VC add field Batch No. 
TAL0.2 2020/03/26 VC add field Total Qty,Total Weight,Total Qty (Base)

*/

tableextension 50119 SalesInvoiceHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here

        field(50011; "Batch No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Export DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }

        field(50015; "Customer Reference No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50016; "Excel Order Date"; Date)
        {
            DataClassification = ToBeClassified;
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
            CalcFormula = sum("Sales Invoice Line".Quantity where("Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50201; "Total Weight"; Decimal)
        {
            CalcFormula = sum("Sales Invoice Line"."Net Weight" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50202; "Total Qty (Base)"; Decimal)
        {
            CalcFormula = sum("Sales Invoice Line"."Quantity (Base)" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
    }

    fieldgroups
    {
        addlast(Brick; "Ship-to Code", "Ship-to Name", "Posting Date")
        {

        }
    }

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

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
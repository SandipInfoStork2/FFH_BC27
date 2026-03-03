/*
TAL0.1 2018/07/22 VC add field Batch No. 
TAL0.2 2020/03/26 VC add field Total Qty,Total Weight,Total Qty (Base)

*/

tableextension 50121 SalesCrMemoHeaderExt extends "Sales Cr.Memo Header"
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

        field(50200; "Total Qty"; Decimal)
        {
            CalcFormula = sum("Sales Cr.Memo Line".Quantity where("Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50201; "Total Weight"; Decimal)
        {
            CalcFormula = sum("Sales Cr.Memo Line"."Net Weight" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50202; "Total Qty (Base)"; Decimal)
        {
            CalcFormula = sum("Sales Cr.Memo Line"."Quantity (Base)" where("Document No." = field("No.")));
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

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
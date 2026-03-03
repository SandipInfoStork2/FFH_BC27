/*
TAL0.1 2021/03/26 VC add Field Lot No.

*/

tableextension 50165 ReturnReceiptHeaderExt extends "Return Receipt Header"
{
    fields
    {
        // Add changes to table fields here
        field(50014; "Lot No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50200; "Total Qty"; Decimal)
        {
            CalcFormula = sum("Return Receipt Line".Quantity where("Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50201; "Total Weight"; Decimal)
        {
            CalcFormula = sum("Return Receipt Line"."Net Weight" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50202; "Total Qty (Base)"; Decimal)
        {
            CalcFormula = sum("Return Receipt Line"."Quantity (Base)" where("Document No." = field("No.")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
    }

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
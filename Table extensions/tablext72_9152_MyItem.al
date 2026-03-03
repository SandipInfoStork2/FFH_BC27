/*
TAL0.1 Added Inv Aradipou and Dromolaxia

*/

tableextension 50172 MyItemExt extends "My Item"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Inventory Aradipou - Main"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = const('ARAD-1')));
            Caption = 'Inventory Aradipou - Main';
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
        }
        field(50001; "Inventory Fresh Cut"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = const('ARAD-3')));
            Caption = 'Inventory Fresh Cut';
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
        }
        field(50002; "Inventory Kitchen"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = const('ARAD-4')));
            Caption = 'Inventory Kitchen';
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
        }

        field(50004; "Inventory Potatoes"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = const('ARAD-5')));
            Caption = 'Inventory Potatoes';
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
        }
    }

    var
        myInt: Integer;
}
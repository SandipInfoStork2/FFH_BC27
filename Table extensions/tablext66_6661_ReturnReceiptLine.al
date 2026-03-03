/*
TAL0.1 2019/09/17 VC add field Unit of Measure (Base)
TAL0.2 2019/12/13 VC add function ShowShortcutDimCode
TAL0.3 2021/03/22 VC add fields Total Net Weight
*/

tableextension 50166 ReturnReceiptLineExt extends "Return Receipt Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Unit of Measure (Base)"; Code[10])
        {
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("No.")));
            FieldClass = FlowField;
        }

        field(50012; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(50053; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }

        field(50055; "Req. Country"; Code[10])
        {
            Caption = 'Req. Country';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Country/Region";
        }


        field(50071; "Product Class"; Text[20])
        {
            DataClassification = ToBeClassified;

            Caption = 'Product Class (Κατηγορία)';
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category8));
        }

        field(50072; "Category 9"; Code[20])
        {
            Caption = 'Potatoes District Region';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category9));
        }

    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Total Net Weight" := "Quantity (Base)" * "Net Weight"; //TAL0.1
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    var
        myInt: Integer;
        DimMgt: Codeunit DimensionManagement;

}
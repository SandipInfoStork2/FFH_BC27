/*
18/06/17 TAL0.1 update decimal
              Quantity 0:5 to 0:3
              Quantity (Base) 0:5 to 0:3

              add fields
              Unit of Measure (Base)
              Shelf No.


TAL0.2 2018/06/10 VC add fields
        Packing Group Description

TAL0.3 2019/12/13 VC add function ShowShortcutDimCode
TAL0.4 2020/03/06 VC add field No. of Purchase Entries
TAL0.5 2021/03/22 VC add fields Total Net Weight
TAL0.6 2021/03/26 VC review "Total Net Weight" formula
*/

tableextension 50118 SalesShipmentLineExt extends "Sales Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Unit of Measure (Base)"; Text[10])
        {
            CalcFormula = Lookup(Item."Base Unit of Measure" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }

        /*
        field(50011; "No. of Purchase Entries"; Integer)
        {
            CalcFormula = Count("Chain Of Custody Link" WHERE("Document Type" = FILTER(Shipment), "Document No." = FIELD("Document No."), "Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        */

        field(50012; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }

        field(50050; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Packing Group Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Qty. Requested"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
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

        field(50057; "Qty. Confirmed"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50071; "Product Class"; Text[20])
        {
            DataClassification = ToBeClassified;

            Caption = 'Product Class (Κατηγορία)';
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category8));
        }

        field(50072; "Category 9"; Code[20])
        {
            Caption = 'Potatoes District Region';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category9));
        }


        //TAL 1.0.0.201 >>
        field(50143; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50144; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        //TAL 1.0.0.201 <<

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
    }


    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Total Net Weight" := "Quantity (Base)" * "Net Weight"; //TAL0.5 //TAL0.6
    end;




    var
        myInt: Integer;

}
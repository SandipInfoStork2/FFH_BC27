/*
TAL0.1 2021/03/22 VC add fields Total Net Weight
*/

tableextension 50164 ReturnShipmentLineExt extends "Return Shipment Line"
{
    fields
    {
        // Add changes to table fields here





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

    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Total Net Weight" := "Quantity (Base)" * "Net Weight"; //TAL0.1
    end;

    var
        myInt: Integer;
}
/*

*/
tableextension 50126 PurchInvLine extends "Purch. Inv. Line"
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

        field(50146; "Receiving Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Receiving Temperature °C';
        }

        field(50147; "Receiving Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }

    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Total Net Weight" := "Quantity (Base)" * "Net Weight"; //TAL0.5

    end;

    var
        myInt: Integer;
}
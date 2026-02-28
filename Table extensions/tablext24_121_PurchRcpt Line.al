/*
TAL0.1 2021/03/22 VC add fields Total Net Weight

*/
tableextension 50124 PurchRcptLineExt extends "Purch. Rcpt. Line"
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
        //TAL 1.0.0.201 >>
        field(50013; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50014; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        //TAL 1.0.0.201 <<

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
/*
TAL0.1 2021/03/22 VC add fields Total Net Weight

*/

tableextension 50127 PurchCrMemoLine extends "Purch. Cr. Memo Line"
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

    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Total Net Weight" := Quantity * "Net Weight"; //TAL0.1
    end;

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
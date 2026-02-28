/*
TAL0.1 2019/01/03 VC add Deliver to vendor fields 

*/
tableextension 50125 PurchInvHeaderExt extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Deliver-to Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(50004; "Deliver-to Name"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            var
                Vendor: Record Vendor;
            begin
            end;
        }
        field(50005; "Deliver Address Code"; Code[10])
        {
            DataClassification = ToBeClassified;
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

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
/*
TAL 0.1 29/01/18
*/

tableextension 50157 TransferShipmentHeaderExt extends "Transfer Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Salesperson Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'TAL ANP';
            Editable = false;
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            var
                vl_sp: Record "Transfer Header";
            begin
            end;
        }
        field(50001; "Salesperson Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'TAL ANP';
            Editable = false;
        }
        field(50002; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
    }

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}
/*
table 50003 "Chain Of Custody Link"
{
    // version COC

    DrillDownPageID = "Chain Of Custody Link";
    LookupPageID = "Chain Of Custody Link";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Order,Return Order,Shipment,Posted Return Receipt';
            OptionMembers = "Order","Return Order",Shipment,"Posted Return Receipt";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Purchase Receipt Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("Vendor Posting Group" = FILTER('GROWER'));
        }
        field(50002; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50003; "Grower Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Grower GGN"; Code[14])
        {
            CalcFormula = Lookup(Vendor.GGN WHERE("No." = FIELD("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Vendor GLN"; Code[14])
        {
            CalcFormula = Lookup(Vendor.GLN WHERE("No." = FIELD("Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Purchase Receipt Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
*/


tableextension 50163 ItemTracingBufferExt extends "Item Tracing Buffer"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Reason Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }

        field(50007; "Lot Grower No."; Code[20])
        {
            CalcFormula = Lookup("Lot No. Information"."Grower No." WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
            TableRelation = Grower;
        }
        field(50008; "Grower Name"; Text[50])
        {
            CalcFormula = Lookup(Grower.Name WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = Lookup(Grower.GGN WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Lot Vendor No."; Code[20])
        {
            CalcFormula = Lookup("Lot No. Information"."Vendor No." WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vendor;

            trigger OnValidate();
            var
                rL_Vendor: Record Vendor;
            begin
            end;
        }
        field(50012; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Lot Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Vendor GLN"; Code[14])
        {
            CalcFormula = Lookup(Vendor.GLN WHERE("No." = FIELD("Lot Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Vendor GGN"; Code[14])
        {
            CalcFormula = Lookup(Vendor.GGN WHERE("No." = FIELD("Lot Vendor No.")));
            CaptionML = ELL = 'Vendor GGN',
                        ENU = 'Vendor GGN';
            Editable = false;
            FieldClass = FlowField;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
            end;
        }

        field(50015; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
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
            CalcFormula = lookup("Lot No. Information"."Grower No." where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            FieldClass = FlowField;
            TableRelation = Grower;
        }
        field(50008; "Grower Name"; Text[50])
        {
            CalcFormula = lookup(Grower.Name where("No." = field("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = lookup(Grower.GGN where("No." = field("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Lot Vendor No."; Code[20])
        {
            CalcFormula = lookup("Lot No. Information"."Vendor No." where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
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
            CalcFormula = lookup(Vendor.Name where("No." = field("Lot Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Vendor GLN"; Code[14])
        {
            CalcFormula = lookup(Vendor.GLN where("No." = field("Lot Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Vendor GGN"; Code[14])
        {
            CalcFormula = lookup(Vendor.GGN where("No." = field("Lot Vendor No.")));
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
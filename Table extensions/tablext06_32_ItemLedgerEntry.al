/*
TAL0.1 2021/03/22 VC add fields Total Net Weight, Net weight
TAL0.2 2021/03/27 VC add fields Document Grower Vendor No.,Document Grower Vendor Name
TAL0.3 2021/04/02 VC add field Producer Group Name
//

*/
tableextension 50106 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Reason Code"; Code[10])
        {
            AutoFormatType = 1;
            CalcFormula = lookup("Value Entry"."Reason Code" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
            Caption = 'Reason Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Reason Code";
        }

        field(50006; "Receipt Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Lot Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Grower;
        }
        field(50008; "Grower Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Grower.Name WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;

        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = Lookup(Grower.GGN WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = Lookup(Grower."Category 1" WHERE("No." = FIELD("Lot Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category1));
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
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.GGN WHERE("No." = FIELD("Lot Vendor No.")));
            CaptionML = ELL = 'Vendor GGN',
                        ENU = 'Vendor GGN';
            Editable = false;

            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
            end;
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = Lookup("General Categories".Description WHERE("Table No." = FILTER(23), Type = FILTER(Category1), Code = FIELD("Producer Group")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50054; "Net Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50055; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        /* field(50056; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        } */
        field(50057; "Gen. Prod. Posting Group"; Code[20])
        {
            CalcFormula = Lookup(Item."Gen. Prod. Posting Group" WHERE("No." = FIELD("Item No.")));
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50058; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50059; "Document Lot No."; Code[20])
        {
            CaptionML = ELL = 'Document Lot No.',
                        ENU = 'Document Lot No.';
            DataClassification = ToBeClassified;
        }
        field(50060; "Document Grower Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50061; "Document Grower GGN"; Code[13])
        {
            DataClassification = ToBeClassified;
        }
        field(50062; "Document Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50063; "Document Vendor GGN"; Code[13])
        {
            DataClassification = ToBeClassified;
        }
        field(50064; "Document Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50065; "Document No. Multiple"; Integer)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
        }
        field(50066; "Document Excel Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50067; "Document Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Grower;
        }
        field(50068; "Document Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50069; "Document Grower Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50070; "Document Grower Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50080; "Level 1 Document No. Filter"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50090; "QC Validate COC-GGN Certficate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50091; "QC Visual Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50092; "QC Comments"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(50096; "QC Package Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50097; "QC Label Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //TAL 1.0.0.203 >>
        field(50100; GenBusPostingGroup; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            CalcFormula = lookup("Value Entry"."Gen. Bus. Posting Group" where("Item Ledger Entry No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        //TAL 1.0.0.203 <<

        //+1.0.0.229
        field(50101; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(5404), Type = CONST(Category1));
        }
        //-1.0.0.229

        field(50102; "Lot Receiving Temperature"; Decimal)
        {
            CalcFormula = Lookup("Lot No. Information"."Receiving Temperature Celsius" WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            Editable = false;
            FieldClass = FlowField;

        }
    }

    keys
    {

        key(key30; "Lot Grower No.")
        {
            SumIndexFields = "Total Net Weight"; //"Quantity", 
            //IncludedFields = "Entry Type";
            //, "Source Type", "Posting Date", "Source No."

        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
        rL_Item: Record Item;
    begin
        //+TAL0.1
        IF "Item No." <> '' THEN BEGIN
            IF rL_Item.GET("Item No.") THEN BEGIN
                "Net Weight" := rL_Item."Net Weight";
                "Total Net Weight" := "Net Weight" * Quantity;
            END;
        END;
        //-TAL0.1
    end;

    var
        myInt: Integer;
}
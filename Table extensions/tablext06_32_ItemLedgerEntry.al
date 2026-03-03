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
            CalcFormula = lookup("Value Entry"."Reason Code" where("Item Ledger Entry No." = field("Entry No.")));
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
            CalcFormula = lookup(Grower.Name where("No." = field("Lot Grower No.")));
            Editable = false;

        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = lookup(Grower.GGN where("No." = field("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = lookup(Grower."Category 1" where("No." = field("Lot Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category1));
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
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.GGN where("No." = field("Lot Vendor No.")));
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
            CalcFormula = lookup("General Categories".Description where("Table No." = filter(23), Type = filter(Category1), Code = field("Producer Group")));
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
            CalcFormula = lookup(Item."Gen. Prod. Posting Group" where("No." = field("Item No.")));
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
        field(50092; "QC Comments"; Blob)
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
            TableRelation = "General Categories".Code where("Table No." = const(5404), Type = const(Category1));
        }
        //-1.0.0.229

        field(50102; "Lot Receiving Temperature"; Decimal)
        {
            CalcFormula = lookup("Lot No. Information"."Receiving Temperature Celsius" where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
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
        if "Item No." <> '' then begin
            if rL_Item.Get("Item No.") then begin
                "Net Weight" := rL_Item."Net Weight";
                "Total Net Weight" := "Net Weight" * Quantity;
            end;
        end;
        //-TAL0.1
    end;

    var
        myInt: Integer;
}
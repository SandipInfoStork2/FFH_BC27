table 50004 "Item Grower Vendor"
{
    // version NAVW19.00

    // TAL0.1 2021/03/12 add field Category 1
    //         ItemNo not blank false
    //         add  Category 1 part of the primary key

    CaptionML = ELL = 'Item Grower Vendor',
                ENU = 'Item Grower Vendor';
    LookupPageID = "Grower Item Catalog";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = false;
            TableRelation = Item;
        }
        field(2; "Grower No."; Code[20])
        {
            CaptionML = ELL = 'Grower No.',
                        ENU = 'Grower No.';
            NotBlank = true;
            TableRelation = Grower;

            trigger OnValidate();
            begin
                Vend.GET("Grower No.");
                "Lead Time Calculation" := Vend."Lead Time Calculation";
            end;
        }
        field(6; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50000; "Category 1"; Code[20])
        {
            CaptionML = ELL = 'Grower Product No',
                        ENU = 'Grower Product No';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(50004),
                                                             Type = CONST(Category1));
        }
        field(50001; "Product Name"; Text[100])
        {
            CalcFormula = Lookup("General Categories".Description WHERE("Table No." = FILTER(50004),
                                                                         Type = FILTER(Category1),
                                                                         Code = FIELD("Category 1")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Grower No.", "Item No.", "Variant Code", "Category 1")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Grower No.")
        {
        }
        key(Key3; "Grower No.", "Vendor Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        DeleteItemCrossReference;
    end;

    trigger OnInsert();
    begin
        xRec.INIT;
        UpdateItemCrossReference;
    end;

    trigger OnModify();
    begin
        UpdateItemCrossReference;
    end;

    trigger OnRename();
    begin
        UpdateItemCrossReference;
    end;

    var
        Vend: Record Vendor;
        //ItemCrossReference: Record "Item Cross Reference";
        DistIntegration: Codeunit "Dist. Integration";

    local procedure DeleteItemCrossReference();
    begin
        //IF ItemCrossReference.WRITEPERMISSION THEN
        //  IF ("Vendor No." <> '') AND ("Item No." <> '') THEN
        //    DistIntegration.DeleteItemCrossReference(Rec);
    end;

    local procedure UpdateItemCrossReference();
    begin
        //IF ItemCrossReference.WRITEPERMISSION THEN
        //  IF ("Vendor No." <> '') AND ("Item No." <> '') THEN
        //   DistIntegration.UpdateItemCrossReference(Rec,xRec);
    end;
}


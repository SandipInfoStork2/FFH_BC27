table 50001 "General Categories"
{
    // version TAL.SEPA,COC

    // TAL0.2 2020/03/04 VC add Description 2
    // TAL0.3 2021/04/08 VC delete and rename control

    DrillDownPageID = "General Categories";
    LookupPageID = "General Categories";

    fields
    {
        field(1; "Table No."; Integer)
        {
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; Type; Option)
        {
            OptionMembers = Category1,Category2,Category3,Category4,Category5,Category6,Category7,Category8,,Category9,,Category10,Category11,Category12,Category13,Category14,Category15,Category16,Category17,Category18,Category19,Category20;
        }
        field(3; "Code"; Code[20])
        {
        }
        field(4; Description; Text[100])
        {
        }
        field(7; Cubage; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(8; Height; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                CalcCubage;
            end;
        }
        field(9; Length; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                CalcCubage;
            end;
        }
        field(10; Width; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                CalcCubage;
            end;
        }
        field(50000; "No. 2"; Code[20])
        {
        }
        field(50001; "Palette Qty"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Reference No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50028; "Label Description Line 1"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Label Description Line 2"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Ship-to Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Pallet Qty"; Decimal)
        {
            BlankZero = true;
            Caption = 'Pallet Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 1;
        }
        field(50042; "Package Qty"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2; // DecimalPlaces = 0 : 1; //1.0.0.279
        }
        field(50048; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
            end;
        }
        field(50049; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50112; "Category 3"; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27),
                                                             Type = CONST(Category3));
        }
        field(50113; "Category 4"; Code[20])
        {
            Caption = 'Caliber Min';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27),
                                                             Type = CONST(Category4));
        }
        field(50114; "Category 5"; Code[20])
        {
            Caption = 'Caliber Max';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27),
                                                             Type = CONST(Category5));
        }
        field(50115; "Category 6"; Code[20])
        {
            Caption = 'Caliber UOM';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27),
                                                             Type = CONST(Category6));
        }
        field(50116; "Category 7"; Code[20])
        {
            Caption = 'Variety';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27),
                                                             Type = CONST(Category7));
        }
        field(50207; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50208; "Create Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50209; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50210; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50211; "Print Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Table No.", Type, "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnDelete();
    var
        rL_Grower: Record Grower;
    begin

        //+TAL0.3
        if ("Table No." = 23) and (Type = Type::Category1) and (Code <> '') then begin
            rL_Grower.RESET;
            rL_Grower.SETRANGE("Category 1", Code);
            if rL_Grower.FINDSET then begin
                ERROR(Txt50001, Code, rL_Grower."No.");
            end;

        end;
        //-TAL0.3
    end;

    trigger OnInsert();
    begin

        "Create Date" := CURRENTDATETIME;
        "Created By" := USERID;
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := CURRENTDATETIME;
        "Last Modified By" := USERID;
    end;

    trigger OnRename();
    begin
        //+TAL0.3
        if (Code = '') or (Code = ' ') then begin
            ERROR(Txt50002)
        end;
        //-TAL0.3
    end;

    var
        TypeInt: Integer;
        pr_Dimension: Record "Dimension Value";
        Item: Record Item;
        Txt50000: Label 'You cannot delete "%1"-"%2" because it''s assigned to items!';
        Txt50001: TextConst ELL = 'Cannot Delete Code %1 because it is assigned to growers for example %2', ENU = 'Cannot Delete Code %1 because it is assigned to growers for example %2';
        Txt50002: TextConst ELL = 'Cannot Rename blank Code. Delete the code and create new.', ENU = 'Cannot Rename blank Code. Delete the code and create new.';

    procedure CalcCubage();
    begin
        Cubage := Length * Width * Height;
    end;
}


/*
TAL0.1 2021/03/18 VC add the customer cross reference no,
                     find the item no of lidl customer
TAL0.2 2021/04/02 VC add field Producer Group Name


*/

tableextension 50162 LotNoInformationExt extends "Lot No. Information"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Category 1" = FILTER(<> '')) Grower WHERE("Category 1" = FIELD("Category 1")) ELSE
            IF ("Category 1" = FILTER('')) Grower;

            trigger OnValidate();
            var
                rL_Grower: Record Grower;
                rL_ILE: Record "Item Ledger Entry";
                cu_GeneralMgt: Codeunit "General Mgt.";
            begin
                "Grower Name" := '';
                "Grower GGN" := '';

                IF rL_Grower.GET("Grower No.") THEN BEGIN
                    "Grower Name" := rL_Grower.Name;
                    "Grower GGN" := rL_Grower.GGN;

                    IF rL_Grower."Grower Vendor No." <> '' THEN BEGIN
                        rL_Grower.TESTFIELD("Grower Vendor No.");
                        VALIDATE("Vendor No.", rL_Grower."Grower Vendor No.");
                    END;


                END;
                //Grower Name
                //Grower GGN

                IF "Grower No." <> xRec."Grower No." THEN BEGIN
                    IF ("Lot No." <> '') AND ("Item No." <> '') THEN BEGIN
                        //+1.0.0.48 
                        cu_GeneralMgt.UpdateILE("Item No.", "Lot No.", "Grower No.");
                        //update logic with codeunit
                        /*
                        rL_ILE.RESET;
                        rL_ILE.SETFILTER("Item No.", "Item No.");
                        rL_ILE.SETFILTER("Lot No.", "Lot No.");
                        IF rL_ILE.FINDSET THEN BEGIN
                            REPEAT
                                rL_ILE."Lot Grower No." := "Grower No.";
                                rL_ILE.MODIFY;
                            UNTIL rL_ILE.NEXT = 0;
                        END;
                        */
                        //-1.0.0.48 
                    END;

                END;
            end;
        }
        field(50002; "Grower Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Grower GGN"; Code[14])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Grower GGN Expiry Date"; Date)
        {
            CalcFormula = Lookup(Grower."GGN Expiry Date" WHERE("No." = FIELD("Grower No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate();
            begin

                /*
                IF "Grower GGN Expiry Date">=TODAY THEN BEGIN
                  VALIDATE("Grower Certified",TRUE);
                END ELSE BEGIN
                  VALIDATE("Grower Certified",FALSE);
                END;
                */

            end;
        }
        field(50010; "Category 1"; Code[20])
        {
            Caption = 'Producer Group';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category1));
        }
        field(50011; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;

            trigger OnValidate();
            var
                rL_Vendor: Record Vendor;
            begin
                "Vendor Name" := '';
                "Vendor GLN" := '';
                "Vendor GGN" := '';

                IF rL_Vendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := rL_Vendor.Name;
                    "Vendor GLN" := rL_Vendor.GLN;
                    "Vendor GGN" := rL_Vendor.GGN;
                END;
                //Grower Name
                //Grower GGN
            end;
        }
        field(50012; "Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Vendor GLN"; Code[14])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "Vendor GGN"; Code[13])
        {
            CaptionML = ELL = 'Vendor GGN',
                        ENU = 'Vendor GGN';
            DataClassification = ToBeClassified;
            Editable = false;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
            end;
        }
        field(50020; "Category 2"; Code[20])
        {
            CaptionML = ELL = 'City',
                        ENU = 'City';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(6505), Type = CONST(Category2));
        }
        field(50022; "Category 3"; Code[20])
        {
            CaptionML = ELL = 'Area',
                        ENU = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(6505), Type = CONST(Category3));
        }
        field(50023; "Category 4"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category2));

            trigger OnValidate();
            var
                rL_GeneralCategories: Record "General Categories";
                vL_Pack: Text[100];
                cu_GeneralMgt: Codeunit "General Mgt.";
            begin

                //VALIDATE("Cross-Reference No.","Category 2");

                IF "Category 4" <> '' THEN BEGIN
                    rL_GeneralCategories.RESET;
                    rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                    rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SETFILTER(Code, "Category 4");
                    IF rL_GeneralCategories.FINDSET THEN BEGIN
                        VALIDATE(Description, rL_GeneralCategories."Ship-to Description");
                        VALIDATE("Country/Region Purchased Code", rL_GeneralCategories."Country/Region Purchased Code");
                        VALIDATE("Label Description Line 1", rL_GeneralCategories."Label Description Line 1");
                        VALIDATE("Label Description Line 2", rL_GeneralCategories."Label Description Line 2");

                        VALIDATE("Spec Category 3", rL_GeneralCategories."Category 3");
                        VALIDATE("Spec Category 4", rL_GeneralCategories."Category 4");
                        VALIDATE("Spec Category 5", rL_GeneralCategories."Category 5");
                        VALIDATE("Spec Category 7", rL_GeneralCategories."Category 7");
                        vL_Pack := FORMAT(rL_GeneralCategories."Package Qty") + ' ' + cu_GeneralMgt.Capitalise(FORMAT(rL_GeneralCategories."Unit of Measure"));
                        VALIDATE(Packing, vL_Pack);


                    END;
                END;
            end;
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = Lookup("General Categories".Description WHERE("Table No." = FILTER(23), Type = FILTER(Category1), Code = FIELD("Category 1")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Label Description Line 1"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Label Description Line 2"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
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
        field(50112; "Spec Category 3"; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category3));
        }
        field(50113; "Spec Category 4"; Code[20])
        {
            Caption = 'Caliber Min';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category4));
        }
        field(50114; "Spec Category 5"; Code[20])
        {
            Caption = 'Caliber Max';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category5));
        }
        field(50116; "Spec Category 7"; Code[20])
        {
            Caption = 'Variety';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category7));
        }
        field(50117; Packing; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        //

        field(50119; "Receiving Temperature Celsius"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }
    }


    trigger OnInsert()
    var
        ItemReference: Record "Item Reference";
        //rL_ItemCrossReference: Record "Item Cross Reference";
        rL_ItemCrossReference: Record "Item Reference";
        rL_Customer: Record Customer;
    begin
        rL_Customer.RESET;
        rL_Customer.SETFILTER("Ship-to Warehouse Code", '<>%1', '');
        IF rL_Customer.FINDSET THEN BEGIN
            rL_ItemCrossReference.RESET;
            /* rL_ItemCrossReference.SETFILTER("Item No.", "Item No.");
            rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
            rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", rL_Customer."No.");
            rL_ItemCrossReference.SETRANGE("Discontinue Bar Code", FALSE);
            IF rL_ItemCrossReference.FINDLAST THEN BEGIN
                VALIDATE("Category 4", rL_ItemCrossReference."Cross-Reference No.");
            END; */
            rL_ItemCrossReference.SETFILTER("Item No.", "Item No.");
            rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
            rL_ItemCrossReference.SETFILTER("Reference Type No.", rL_Customer."No.");
            //rL_ItemCrossReference.SETRANGE("Discontinue Bar Code", FALSE); //field remove from table due to not used
            IF rL_ItemCrossReference.FINDLAST THEN BEGIN
                VALIDATE("Category 4", rL_ItemCrossReference."Reference No.");
            END;
        END;

    end;

    procedure SetQCComments(NewQCComments: Text)
    var
        OutStream: OutStream;
    begin
        Clear("QC Comments");
        "QC Comments".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewQCComments);
        Modify;
    end;

    procedure GetQCComments(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("QC Comments");
        "QC Comments".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    var
        myInt: Integer;
}
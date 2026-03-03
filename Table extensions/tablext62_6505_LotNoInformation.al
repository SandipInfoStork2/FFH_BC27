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
            TableRelation = if ("Category 1" = filter(<> '')) Grower where("Category 1" = field("Category 1")) else
            if ("Category 1" = filter('')) Grower;

            trigger OnValidate();
            var
                rL_Grower: Record Grower;
                rL_ILE: Record "Item Ledger Entry";
                cu_GeneralMgt: Codeunit "General Mgt.";
            begin
                "Grower Name" := '';
                "Grower GGN" := '';

                if rL_Grower.Get("Grower No.") then begin
                    "Grower Name" := rL_Grower.Name;
                    "Grower GGN" := rL_Grower.GGN;

                    if rL_Grower."Grower Vendor No." <> '' then begin
                        rL_Grower.TestField("Grower Vendor No.");
                        Validate("Vendor No.", rL_Grower."Grower Vendor No.");
                    end;


                end;
                //Grower Name
                //Grower GGN

                if "Grower No." <> xRec."Grower No." then begin
                    if ("Lot No." <> '') and ("Item No." <> '') then begin
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
                    end;

                end;
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
            CalcFormula = lookup(Grower."GGN Expiry Date" where("No." = field("Grower No.")));
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
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category1));
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

                if rL_Vendor.Get("Vendor No.") then begin
                    "Vendor Name" := rL_Vendor.Name;
                    "Vendor GLN" := rL_Vendor.GLN;
                    "Vendor GGN" := rL_Vendor.GGN;
                end;
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
            TableRelation = "General Categories".Code where("Table No." = const(6505), Type = const(Category2));
        }
        field(50022; "Category 3"; Code[20])
        {
            CaptionML = ELL = 'Area',
                        ENU = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(6505), Type = const(Category3));
        }
        field(50023; "Category 4"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category2));

            trigger OnValidate();
            var
                rL_GeneralCategories: Record "General Categories";
                vL_Pack: Text[100];
                cu_GeneralMgt: Codeunit "General Mgt.";
            begin

                //VALIDATE("Cross-Reference No.","Category 2");

                if "Category 4" <> '' then begin
                    rL_GeneralCategories.Reset;
                    rL_GeneralCategories.SetRange("Table No.", Database::Item);
                    rL_GeneralCategories.SetRange(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SetFilter(Code, "Category 4");
                    if rL_GeneralCategories.FindSet then begin
                        Validate(Description, rL_GeneralCategories."Ship-to Description");
                        Validate("Country/Region Purchased Code", rL_GeneralCategories."Country/Region Purchased Code");
                        Validate("Label Description Line 1", rL_GeneralCategories."Label Description Line 1");
                        Validate("Label Description Line 2", rL_GeneralCategories."Label Description Line 2");

                        Validate("Spec Category 3", rL_GeneralCategories."Category 3");
                        Validate("Spec Category 4", rL_GeneralCategories."Category 4");
                        Validate("Spec Category 5", rL_GeneralCategories."Category 5");
                        Validate("Spec Category 7", rL_GeneralCategories."Category 7");
                        vL_Pack := Format(rL_GeneralCategories."Package Qty") + ' ' + cu_GeneralMgt.Capitalise(Format(rL_GeneralCategories."Unit of Measure"));
                        Validate(Packing, vL_Pack);


                    end;
                end;
            end;
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = lookup("General Categories".Description where("Table No." = filter(23), Type = filter(Category1), Code = field("Category 1")));
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
        field(50092; "QC Comments"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Spec Category 3"; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category3));
        }
        field(50113; "Spec Category 4"; Code[20])
        {
            Caption = 'Caliber Min';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category4));
        }
        field(50114; "Spec Category 5"; Code[20])
        {
            Caption = 'Caliber Max';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category5));
        }
        field(50116; "Spec Category 7"; Code[20])
        {
            Caption = 'Variety';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category7));
        }
        field(50117; Packing; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
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
        rL_Customer.Reset;
        rL_Customer.SetFilter("Ship-to Warehouse Code", '<>%1', '');
        if rL_Customer.FindSet then begin
            rL_ItemCrossReference.Reset;
            /* rL_ItemCrossReference.SETFILTER("Item No.", "Item No.");
            rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
            rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", rL_Customer."No.");
            rL_ItemCrossReference.SETRANGE("Discontinue Bar Code", FALSE);
            IF rL_ItemCrossReference.FINDLAST THEN BEGIN
                VALIDATE("Category 4", rL_ItemCrossReference."Cross-Reference No.");
            END; */
            rL_ItemCrossReference.SetFilter("Item No.", "Item No.");
            rL_ItemCrossReference.SetRange("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
            rL_ItemCrossReference.SetFilter("Reference Type No.", rL_Customer."No.");
            //rL_ItemCrossReference.SETRANGE("Discontinue Bar Code", FALSE); //field remove from table due to not used
            if rL_ItemCrossReference.FindLast then begin
                Validate("Category 4", rL_ItemCrossReference."Reference No.");
            end;
        end;

    end;

    procedure SetQCComments(NewQCComments: Text)
    var
        OutStream: OutStream;
    begin
        Clear("QC Comments");
        "QC Comments".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewQCComments);
        Modify;
    end;

    procedure GetQCComments(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("QC Comments");
        "QC Comments".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    var
        myInt: Integer;
}
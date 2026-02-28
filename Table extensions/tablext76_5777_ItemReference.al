tableextension 50176 ItemReferenceExt extends "Item Reference"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
            DataClassification = ToBeClassified;
        }

        field(50001; "S. Quote Description"; Text[50])
        {
            Caption = 'S. Quote Description';
            DataClassification = ToBeClassified;
        }

        field(50002; "Package Qty"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 2; //DecimalPlaces = 0 : 1; //1.0.0.279
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Package Qty" where("No." = field("Item No.")));
        }

        field(50003; Discontinued; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(50011; "Category 2"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category2));

            trigger OnValidate();
            var
                rL_GeneralCategories: Record "General Categories";
            begin

                VALIDATE("Reference No.", "Category 2");

                IF "Category 2" <> '' THEN BEGIN
                    rL_GeneralCategories.RESET;
                    rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                    rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SETFILTER(Code, "Category 2");
                    IF rL_GeneralCategories.FINDSET THEN BEGIN
                        VALIDATE(Description, rL_GeneralCategories.Description);
                        VALIDATE("Description 2", rL_GeneralCategories."Description 2");
                    END;
                END;
            end;
        }

        field(50012; "Family Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(5777), Type = CONST(Category1));
        }

        field(50013; "EAN"; Text[100])
        {
            caption = 'Barcode';
            DataClassification = ToBeClassified;
        }

        field(50014; "Package"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50015; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }

        field(50016; "Item Description 2 (GR)"; Text[50])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Description 2" where("No." = field("Item No.")));
        }
    }

    var
        myInt: Integer;
}
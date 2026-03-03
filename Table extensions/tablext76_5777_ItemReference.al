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
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category2));

            trigger OnValidate();
            var
                rL_GeneralCategories: Record "General Categories";
            begin

                Validate("Reference No.", "Category 2");

                if "Category 2" <> '' then begin
                    rL_GeneralCategories.Reset;
                    rL_GeneralCategories.SetRange("Table No.", Database::Item);
                    rL_GeneralCategories.SetRange(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SetFilter(Code, "Category 2");
                    if rL_GeneralCategories.FindSet then begin
                        Validate(Description, rL_GeneralCategories.Description);
                        Validate("Description 2", rL_GeneralCategories."Description 2");
                    end;
                end;
            end;
        }

        field(50012; "Family Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(5777), Type = const(Category1));
        }

        field(50013; EAN; Text[100])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
        }

        field(50014; Package; Text[50])
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
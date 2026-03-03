/*
TAL0.1 2020/03/04 VC add Description 2

*/

// Item Cross Reference moved to Item Reference and same page available

/* tableextension 50155 ItemCrossReferenceExt extends "Item Cross Reference"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
            DataClassification = ToBeClassified;
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

                VALIDATE("Cross-Reference No.", "Category 2");

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
    }

    var
        myInt: Integer;
} */
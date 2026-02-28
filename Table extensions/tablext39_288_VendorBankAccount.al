tableextension 50139 VendorBankAccountExt extends "Vendor Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Reference Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = FILTER(288), Type = FILTER(Category1));

            trigger OnValidate();
            var
                rL_GeneralCategory: Record "General Categories";
            begin

                IF "Reference Code" <> '' THEN BEGIN
                    rL_GeneralCategory.RESET;
                    rL_GeneralCategory.SETRANGE("Table No.", 288);
                    rL_GeneralCategory.SETRANGE(Type, rL_GeneralCategory.Type::Category1);
                    rL_GeneralCategory.SETFILTER(Code, "Reference Code");
                    IF rL_GeneralCategory.FINDSET THEN BEGIN
                        Name := rL_GeneralCategory.Description;
                        "SWIFT Code" := rL_GeneralCategory."Reference No.";
                        "Country/Region Code" := rL_GeneralCategory."Country Code";
                    END;
                END;
            end;
        }
        field(50009; "Intermediary Bank Swift Code"; Code[11])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Sorting Code"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "R Correspondent Swift Code"; Code[11])
        {
            Caption = 'Receivers Correspondent Swift Code';
            DataClassification = ToBeClassified;
        }
        field(50012; "R Correspondent Bank Name"; Text[35])
        {
            Caption = 'Receivers Correspondent Bank Name';
            DataClassification = ToBeClassified;
        }
        field(50013; "R Correspondent Address 1"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 1';
            DataClassification = ToBeClassified;
        }
        field(50014; "R Correspondent Address 2"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 2';
            DataClassification = ToBeClassified;
        }
        field(50015; "R Correspondent Address 3"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 3';
            DataClassification = ToBeClassified;
        }
        field(50021; "Thrd R Institution Swift Code"; Code[11])
        {
            Caption = 'Third Reimbursement Institution Swift Code';
            DataClassification = ToBeClassified;
        }
        field(50022; "Thrd R Institution Bank Name"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Bank Name';
            DataClassification = ToBeClassified;
        }
        field(50023; "Thr R Institution RC Address 1"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 1';
            DataClassification = ToBeClassified;
        }
        field(50024; "Thr R Institution RC Address 2"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 2';
            DataClassification = ToBeClassified;
        }
        field(50025; "Thr R Institution RC Address 3"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 3';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
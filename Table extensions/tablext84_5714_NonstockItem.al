tableextension 50184 NonstockItemExt extends "Nonstock Item"
{
    fields
    {
        // Add changes to table fields here

        field(50050; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

            end;
        }

        field(50053; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }
        field(50054; "Package Qty"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2; //DecimalPlaces = 0 : 1; //1.0.0.279
            //Editable = false;
        }

        field(50070; "Pallet Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Περιεχ.Παλ.';
        }

        field(50071; "Product Class"; Text[20])
        {
            DataClassification = ToBeClassified;

            Caption = 'Κατηγορία';
        }

        field(50073; "Calibration Min."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Καλιμπράζ Ελαχ.';
        }

        field(50074; "Calibration Max."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Καλιμπράζ Μεγ.';
        }

        field(50075; "Calibration UOM"; Enum "Calibration UOM")
        {
            DataClassification = ToBeClassified;
            Caption = 'Καλιμπράζ 47';
        }

        field(50076; Variety; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ποικιλία';
        }

        field(50093; "Additional Information"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετες πληροφορίες';
        }

        field(50094; "Pressure Min."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πίεση kg/cm² Ελαχ.';
            DecimalPlaces = 0 : 5;
        }

        field(50095; "Pressure Max."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πίεση kg/cm² Μεγ.';
            DecimalPlaces = 0 : 5;
        }

        field(50096; "Brix Min"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Brix σε ° Ελαχ.';
            DecimalPlaces = 0 : 5;
        }

        field(50098; "QC 1 Min"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ.';
            DecimalPlaces = 0 : 5;
        }

        field(50099; "QC 1 Max"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ.';
            DecimalPlaces = 0 : 5;
        }

        field(50100; "QC 1 Text"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον.';
        }

        field(50101; "QC 2 Min"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ.';
            DecimalPlaces = 0 : 5;
        }

        field(50102; "QC 2 Max"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ.';
            DecimalPlaces = 0 : 5;
        }

        field(50103; "QC 2 Text"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον.';
        }


        field(50104; "Box Width"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Κιβώτιο / Στάντζα Πλάτος σε cm';
            DecimalPlaces = 0 : 5;
        }

        field(50105; "Box Char 1"; Text[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Κιβώτιο / Στάντζα X';
        }


        field(50106; "Box Length"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Κιβώτιο / Στάντζα Μήκος σε cm';
            DecimalPlaces = 0 : 5;
        }

        field(50107; "Box Char 2"; Text[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Κιβώτιο / Στάντζα X';
        }
        field(50108; "Box Height"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Κιβώτιο / Στάντζα Ύψος σε cm';
        }

        field(50109; "Box Changed Date"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου';
        }

        field(50110; "Harvest Temp. From"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Θερμοκρασία συγκομιδής σε Cº Από';
        }

        field(50111; "Harvest Temp. To"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Θερμοκρασία συγκομιδής σε Cº Έως';
        }

        field(50112; "Freezer Harvest Temp. From"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Από';
        }

        field(50113; "Freezer Harvest Temp. To"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Έως';
        }

        field(50114; "Transfer Temp. From"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Από';
        }

        field(50116; "Transfer Temp. To"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Caption = 'παράδοση στις αποθ.Lidl σε Cº Έως';
        }



    }

    var
        myInt: Integer;
}
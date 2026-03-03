pageextension 50257 CatalogItemListExt extends "Catalog Item List"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Description)
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }

        addafter(Description)
        {
            field("Pallet Qty"; Rec."Pallet Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Περιεχ.Παλ. field.';
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Caption = 'Προέλευση';
                ToolTip = 'Specifies the value of the Προέλευση field.';
            }

            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κατηγορία field.';
            }
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                Caption = 'Κιβώτιο -  Περιεχόμενο';
                ToolTip = 'Specifies the value of the Κιβώτιο -  Περιεχόμενο field.';

            }
            field("Calibration Min."; Rec."Calibration Min.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Καλιμπράζ Ελαχ. field.';
            }
            field("Calibration Max."; Rec."Calibration Max.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Καλιμπράζ Μεγ. field.';
            }
            field("Calibration UOM"; Rec."Calibration UOM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Καλιμπράζ 47 field.';
            }
            field(Variety; Rec.Variety)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ποικιλία field.';
            }
            field("Additional Information"; Rec."Additional Information")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετες πληροφορίες field.';
            }
            field("Pressure Min."; Rec."Pressure Min.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πίεση kg/cm² Ελαχ. field.';
            }
            field("Pressure Max."; Rec."Pressure Max.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πίεση kg/cm² Μεγ. field.';
            }
            field("Brix Min"; Rec."Brix Min")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Brix σε ° Ελαχ. field.';
            }

            field("QC 1 Min"; Rec."QC 1 Min")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
            }
            field("QC 1 Max"; Rec."QC 1 Max")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
            }
            field("QC 1 Text"; Rec."QC 1 Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
            }

            field("QC 2 Min"; Rec."QC 2 Min")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ. field.';
            }
            field("QC 2 Max"; Rec."QC 2 Max")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ. field.';
            }
            field("QC 2 Text"; Rec."QC 2 Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον. field.';
            }
            field("Box Width"; Rec."Box Width")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Πλάτος σε cm field.';
            }
            field("Box Char 1"; Rec."Box Char 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
            }
            field("Box Length"; Rec."Box Length")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Μήκος σε cm field.';
            }
            field("Box Char 2"; Rec."Box Char 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα X field.';
            }
            field("Box Height"; Rec."Box Height")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Κιβώτιο / Στάντζα Ύψος σε cm field.';
            }
            field("Box Changed Date"; Rec."Box Changed Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου field.';

            }
            field("Harvest Temp. From"; Rec."Harvest Temp. From")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Από field.';
            }
            field("Harvest Temp. To"; Rec."Harvest Temp. To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Θερμοκρασία συγκομιδής σε Cº Έως field.';
            }

            field("Freezer Harvest Temp. From"; Rec."Freezer Harvest Temp. From")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Από field.';
            }
            field("Freezer Harvest Temp. To"; Rec."Freezer Harvest Temp. To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Έως field.';
            }
            field("Transfer Temp. From"; Rec."Transfer Temp. From")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Από field.';
            }
            field("Transfer Temp. To"; Rec."Transfer Temp. To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the παράδοση στις αποθ.Lidl σε Cº Έως field.';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
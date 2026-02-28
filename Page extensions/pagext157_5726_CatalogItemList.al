pageextension 50257 CatalogItemListExt extends "Catalog Item List"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Description)
        {
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }

        addafter(Description)
        {
            field("Pallet Qty"; "Pallet Qty")
            {
                ApplicationArea = all;
            }
            field("Country/Region of Origin Code"; "Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Caption = 'Προέλευση';
            }

            field("Product Class"; "Product Class")
            {
                ApplicationArea = all;
            }
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
                Caption = 'Κιβώτιο -  Περιεχόμενο';

            }
            field("Calibration Min."; "Calibration Min.")
            {
                ApplicationArea = all;
            }
            field("Calibration Max."; "Calibration Max.")
            {
                ApplicationArea = all;
            }
            field("Calibration UOM"; "Calibration UOM")
            {
                ApplicationArea = all;
            }
            field(Variety; Variety)
            {
                ApplicationArea = all;
            }
            field("Additional Information"; "Additional Information")
            {
                ApplicationArea = all;
            }
            field("Pressure Min."; "Pressure Min.")
            {
                ApplicationArea = all;
            }
            field("Pressure Max."; "Pressure Max.")
            {
                ApplicationArea = all;
            }
            field("Brix Min"; "Brix Min")
            {
                ApplicationArea = all;
            }

            field("QC 1 Min"; "QC 1 Min")
            {
                ApplicationArea = all;
            }
            field("QC 1 Max"; "QC 1 Max")
            {
                ApplicationArea = all;
            }
            field("QC 1 Text"; "QC 1 Text")
            {
                ApplicationArea = all;
            }

            field("QC 2 Min"; "QC 2 Min")
            {
                ApplicationArea = all;
            }
            field("QC 2 Max"; "QC 2 Max")
            {
                ApplicationArea = all;
            }
            field("QC 2 Text"; "QC 2 Text")
            {
                ApplicationArea = all;
            }
            field("Box Width"; "Box Width")
            {
                ApplicationArea = all;
            }
            field("Box Char 1"; "Box Char 1")
            {
                ApplicationArea = all;
            }
            field("Box Length"; "Box Length")
            {
                ApplicationArea = all;
            }
            field("Box Char 2"; "Box Char 2")
            {
                ApplicationArea = all;
            }
            field("Box Height"; "Box Height")
            {
                ApplicationArea = all;
            }
            field("Box Changed Date"; "Box Changed Date")
            {
                ApplicationArea = all;

            }
            field("Harvest Temp. From"; "Harvest Temp. From")
            {
                ApplicationArea = all;
            }
            field("Harvest Temp. To"; "Harvest Temp. To")
            {
                ApplicationArea = all;
            }

            field("Freezer Harvest Temp. From"; "Freezer Harvest Temp. From")
            {
                ApplicationArea = all;
            }
            field("Freezer Harvest Temp. To"; "Freezer Harvest Temp. To")
            {
                ApplicationArea = all;
            }
            field("Transfer Temp. From"; "Transfer Temp. From")
            {
                ApplicationArea = all;
            }
            field("Transfer Temp. To"; "Transfer Temp. To")
            {
                ApplicationArea = all;
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
/*
18/06/17 TAL0.1 add fields
         Unit of Measure (Base)
         Shelf No.

         update decimal    
         Quantity (Base) 0:5 to0:3

TAL0.2 2018/01/10 VC add fields 
  Created By 
  Create Date
  Last Modified By
  Last Modified Date

TAL0.3 2018/06/10 VC add fields
        Packing Group Description
TAL0.4 2020/03/04 VC add fields 
                    Grower No.
                    Vendor No.
                    Grower Name
                    Grower GGN
                    Vendor Name
                    Vendor GLN
TAL0.5 2020/03/04 VC find Vendor No. and Grower No. from last purchase  
TAL0.6 2020/03/06 VC add field No. of Purchase Entries
TAL0.7 2021/03/10 VC comment logic for custom grower from bom 
TAL0.8 2021/03/22 VC add fields Total Net Weight
TAL0.9 2021/12/14 VC add field Ship-to Code for Matrix
*/

tableextension 50108 SalesLineExt extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                "Total Net Weight" := "Quantity (Base)" * "Net Weight";
            end;
        }

        //+1.0.0.113
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                rL_SalesLine: Record "Sales Line";
                Text50005: Label 'Item %1 has already been entered on Line No. %2. Do you want to continue?';
            begin
                if (Type = Type::Item) and ("No." <> '') and ("Document Type" = "Document Type"::Quote) then begin
                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange("Document Type", "Document Type");
                    rL_SalesLine.SetFilter("Document No.", "Document No.");
                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SetFilter("No.", "No.");
                    if rL_SalesLine.FindSet then begin
                        if rL_SalesLine.Count > 0 then begin //PART OF THE key not yet committed
                            if not Confirm(Text50005, false, "No.", Format(rL_SalesLine."Line No.")) then begin
                                Error('');
                                //commit;
                                //Delete();
                                //exit;
                            end;

                            //MESSAGE(STRSUBSTNO(Text50005, "No.", FORMAT(rL_SalesLine."Line No.")));
                        end;
                    end;
                end;

                if (Type = Type::Item) and ("No." <> '') and ("Document Type" = "Document Type"::Quote) then begin
                    //if "Sell-to Customer No." = 'CUST00032' then begin
                    //    "Currency Code" := 'EUR';
                    //end;
                end;
            end;

        }
        //-1.0.0.113
        field(50000; "Unit of Measure (Base)"; Code[10])
        {
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Create Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50010; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        /*
        field(50011; "No. of Purchase Entries"; Integer)
        {
            CalcFormula = Count("Chain Of Custody Link" WHERE("Document Type" = FILTER(Order), "Document No." = FIELD("Document No."), "Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        */

        field(50012; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(50017; "Week No."; Integer)
        {

            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Week No." where("Document Type" = field("Document Type"),
            "No." = field("Document No.")));
        }

        field(50018; "Document Date"; Date)
        {

            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Document Date" where("Document Type" = field("Document Type"),
            "No." = field("Document No.")));
        }

        field(50019; "Excel Confirm Write"; Boolean)
        {
            DataClassification = ToBeClassified;
        }



        field(50050; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //ask user to fill item reference
                //if "Document Type" = "Document Type"::Quote then begin
                //    CopyLastSettings();
                //end;
            end;
        }
        field(50051; "Packing Group Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50052; "Qty. Requested"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                OrderQty: Record "Order Qty";
                eOrderQtyDocumentType: Enum "Order Qty Document Type";
            begin
                eOrderQtyDocumentType := eOrderQtyDocumentType::"Sales Order";
                OrderQty.UpdateQty(Rec, eOrderQtyDocumentType);
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
            DecimalPlaces = 0 : 2; // DecimalPlaces = 0 : 1; //1.0.0.279
            //Editable = false;

            trigger OnValidate()
            var
                rL_Item: Record Item;
            begin
                "Price Box" := 0;
                "Price Previous Week Box" := 0;

                if "Document Type" = "Document Type"::Quote then begin
                    if rL_Item.Get("No.") then;

                    if "Package Qty" <> 0 then begin
                        if rL_Item."Category 1" = 'LOSE' then begin
                            "Price Box" := "Price KG" * "Package Qty";
                            "Price Previous Week Box" := "Price Previous Week KG" * "Package Qty";
                        end else begin


                            "Price Box" := "Price PCS" * "Package Qty";
                            "Price Previous Week Box" := "Price Previous Week PCS" * "Package Qty";
                        end;
                    end;
                end;
            end;
        }
        field(50055; "Req. Country"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //if "Country/Region of Origin Code" = '' then begin
                //Validate("Country/Region of Origin Code", "Req. Country");
                "Country/Region of Origin Code" := "Req. Country";
                //end;

            end;
        }
        field(50056; "Ship-to Code"; Code[10])
        {
            CalcFormula = lookup("Sales Header"."Ship-to Code" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'Ship-to Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate();
            var
                ShipToAddr: Record "Ship-to Address";
            begin
            end;
        }

        field(50057; "Qty. Confirmed"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                pOrderQty: Record "Order Qty";
                eOrderQtyDocumentType: Enum "Order Qty Document Type";
            begin
                eOrderQtyDocumentType := eOrderQtyDocumentType::"Sales Order";
                pOrderQty.UpdateQty(Rec, eOrderQtyDocumentType);
            end;
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

            Caption = 'Product Class (Κατηγορία)';
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category8));
        }

        field(50072; "Category 9"; Code[20])
        {
            Caption = 'Potatoes District Region';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category9));
        }

        /*
        field(50072; "Box Qty"; Decimal) use package qty field
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        */

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

        field(50077; "Price Previous Week Box"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

            Caption = 'Τιμές προηγούμενης Εβδομάδας ανά  Κιβ.';
        }

        field(50078; "Price Previous Week PCS"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Τιμές προηγούμενης Εβδομάδας ανά τεμ/συσκ';
        }
        field(50079; "Price Previous Week KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Τιμές προηγούμενης Εβδομάδας  ανά kg';

            trigger OnValidate()
            var
                rL_Item: Record Item;
            begin

                "Price Previous Week Box" := 0;
                if rL_Item.Get("No.") then begin
                    "Price Previous Week Box" := "Price Previous Week KG" * "Package Qty";
                end;
            end;
        }

        field(50080; "Price Box"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Τιμές ανά Κιβ.';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

            trigger OnValidate()

            var
                rL_Item: Record Item;
            begin
                //CalculateCostOfferPlusGP();
                CalculateCostValuation();
                CalculateSalesProfitPerc();

                //"Price Box" := 0;
                //if rL_Item.GET("No.") then begin
                //    "Price Box" := "Price PCS" * "Package Qty";
                //end;
            end;

        }

        field(50081; "Price PCS"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Τιμές ανά τεμ/συσκ';

            trigger OnValidate()
            var

            begin
                //CalculateCostOfferPlusGP();
                CalculateCostValuation();
                CalculateSalesProfitPerc();

                "Price Box" := 0;
                //if rL_Item.GET("No.") then begin
                "Price Box" := "Price PCS" * "Package Qty";
                //end;
            end;
        }

        field(50082; "Price KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Τιμές ανά kg';

            trigger OnValidate()
            var

            begin
                //CalculateCostOfferPlusGP();
                CalculateCostValuation();
                CalculateSalesProfitPerc();

                "Price Box" := 0;
                //if rL_Item.GET("No.") then begin
                "Price Box" := "Price KG" * "Package Qty";
                //end;
            end;
        }

        field(50083; "Row Index"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ποσότητα ανά σειρά';
        }

        field(50084; "Qty Box Date 1"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 1 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50085; "Qty Box Date 2"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 2 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50086; "Qty Box Date 3"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 3 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50087; "Qty Box Date 4"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 4 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50088; "Qty Box Date 5"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 5 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }
        field(50089; "Qty Box Date 6"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 6 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50090; "Qty Box Date 7"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 7 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50091; "Qty Box Date 8"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date 8 Ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                CalculateTotalQty();
            end;
        }

        field(50092; "Total Qty on Boxes"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Συνολική ποσότητα σε κιβώτια';
            DecimalPlaces = 0 : 5;
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

        field(50097; "Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Επωνυμία';
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

        field(50117; Checked; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50118; Confirmed; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50119; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50120; "Line Source"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50121; "Cost kg/stk"; Decimal)
        {

            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 5;
            Caption = 'kg/stk';

            trigger OnValidate()
            begin
                CalculateKG_PC();
            end;
        }
        field(50122; "Cost KG/PC"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'KG/PC';

            trigger OnValidate()
            begin
                CalculateCost();
            end;
        }

        field(50123; "Cost Carton"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'Carton >0.10';
            trigger OnValidate()
            begin
                CalculateCost();
            end;
        }

        field(50124; "Cost Cup"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'Κουπάκι';
            BlankZero = true;
            trigger OnValidate()
            begin
                CalculateCost();
            end;
        }

        field(50125; "Cost Other"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'Film/Labels/Net';
            BlankZero = true;
            trigger OnValidate()
            begin
                CalculateCost();
            end;
        }

        field(50126; "Cost Offer"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'COST';

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CalculateCostOfferPlusGP();
            end;

        }

        field(50127; "Cost Offer+GP"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'COST+GP';

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CalculateCostValuation();
            end;


        }


        field(50128; "Cost Valuation"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'Selling Price - (Cost + GP)';
        }


        field(50129; "Cost YAM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'ΥΑΜ';
        }

        field(50130; "Cost YS"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'ΥΣ';
        }

        field(50131; "Cost YL"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'ΥΛ';
        }

        field(50132; "Cost Per KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            Caption = 'Cost Per KG';

            trigger OnValidate()
            var
                CompItem: Record Item;
                Item: Record Item;
                ProductionBOMHeader: Record "Production BOM Header";
                ProductionBOMLine: Record "Production BOM Line";
                SRSetup: Record "Sales & Receivables Setup";
                CompItemCost: Decimal;
                ItemCategory: Record "Item Category";
                CostOtherFixed: Decimal;
            begin
                GetSalesHeaderCustom();



                //"Cost kg/stk"
                SRSetup.Get;
                if "Cost Profit %" = 0 then begin
                    "Cost Profit %" := SRSetup."Cost Profit %";
                end;


                if not Item.Get("No.") then begin
                    exit;
                end;
                Item.TestField("Production BOM No.");

                //Item."Package Qty"
                Item.TestField("Package Qty");
                TestField("Package Qty");

                if Item."Production BOM No." <> '' then begin
                    if not ProductionBOMHeader.Get(Item."Production BOM No.") then begin
                        exit;
                    end;

                    ProductionBOMLine.Reset;
                    ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
                    ProductionBOMLine.SetFilter("No.", 'RFV*');
                    ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
                    ProductionBOMLine.SetFilter("Quantity per", '<>%1', 0);
                    if ProductionBOMLine.FindSet() then begin
                        ProductionBOMLine.TestField("Quantity per");
                        //+1.0.0.156
                        if not "Manual kg/stk" then begin
                            "Cost kg/stk" := ProductionBOMLine."Quantity per" / "Package Qty";
                        end;
                        //-1.0.0.156
                    end;
                    CalculateKG_PC();

                    if not "Manual Cost Carton" then begin
                        "Cost Carton" := 0;

                        //Cartons
                        //Carton Category Filter 
                        ProductionBOMLine.Reset;
                        ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
                        ProductionBOMLine.SetFilter("No.", '<>RFV*');
                        ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
                        //'CARTONS'
                        ProductionBOMLine.SetFilter("Item Category Code", SRSetup."Carton Category Filter");
                        ProductionBOMLine.SetFilter("Quantity per", '<>%1', 0);
                        if ProductionBOMLine.FindSet() then begin
                            if ProductionBOMLine.FindSet() then begin
                                repeat
                                    CompItemCost := 0;
                                    CompItem.Get(ProductionBOMLine."No.");

                                    case SRSetup."Costing Cost Field" of
                                        SRSetup."Costing Cost Field"::"Unit Cost":
                                            begin
                                                CompItemCost := CompItem."Unit Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Direct Cost":
                                            begin
                                                CompItemCost := CompItem."Last Direct Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Landed Unit Cost":
                                            begin
                                                CompItemCost := CompItem.GetLandedCost();
                                            end;
                                    end;
                                    "Cost Carton" += Round((CompItemCost / "Package Qty") * ProductionBOMLine."Quantity per", Currency."Amount Rounding Precision", '>');
                                until ProductionBOMLine.Next() = 0;
                            end;

                        end;
                        //"Cost Carton" := ;
                    end;

                    //cups
                    if not "Manual Cost Cup" then begin
                        "Cost Cup" := 0;

                        //Cup Category Filter
                        ProductionBOMLine.Reset;
                        ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
                        ProductionBOMLine.SetFilter("No.", '<>RFV*');
                        //'CUPLID|PBAGS|PPUNNET|PUNNETS|TRAYS'
                        ProductionBOMLine.SetFilter("Item Category Code", SRSetup."Cup Category Filter");
                        ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
                        ProductionBOMLine.SetFilter("Quantity per", '<>%1', 0);
                        if ProductionBOMLine.FindSet() then begin
                            if ProductionBOMLine.FindSet() then begin
                                repeat
                                    CompItemCost := 0;
                                    CompItem.Get(ProductionBOMLine."No.");
                                    case SRSetup."Costing Cost Field" of
                                        SRSetup."Costing Cost Field"::"Unit Cost":
                                            begin
                                                CompItemCost := CompItem."Unit Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Direct Cost":
                                            begin
                                                CompItemCost := CompItem."Last Direct Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Landed Unit Cost":
                                            begin
                                                CompItemCost := CompItem.GetLandedCost();
                                            end;
                                    end;
                                    "Cost Cup" += Round((CompItemCost / "Package Qty") * ProductionBOMLine."Quantity per", Currency."Amount Rounding Precision", '>');
                                until ProductionBOMLine.Next() = 0;
                            end;

                        end;
                        //"cost cup" := ;
                    end;

                    //other 
                    if not "Manual Cost Cup" then begin


                        "Cost Other" := 0;
                        //Other Category Filter
                        ProductionBOMLine.Reset;
                        ProductionBOMLine.SetFilter("Production BOM No.", ProductionBOMHeader."No.");
                        ProductionBOMLine.SetFilter("No.", '<>RFV*');
                        //'<>CARTONS&<>CUPLID&<>PBAGS&<>PPUNNET&<>PUNNETS&<>TRAYS'
                        ProductionBOMLine.SetFilter("Item Category Code", SRSetup."Other Category Filter");
                        ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
                        ProductionBOMLine.SetFilter("Quantity per", '<>%1', 0);
                        if ProductionBOMLine.FindSet() then begin
                            if ProductionBOMLine.FindSet() then begin
                                repeat
                                    CompItemCost := 0;
                                    CompItem.Get(ProductionBOMLine."No.");
                                    case SRSetup."Costing Cost Field" of
                                        SRSetup."Costing Cost Field"::"Unit Cost":
                                            begin
                                                CompItemCost := CompItem."Unit Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Direct Cost":
                                            begin
                                                CompItemCost := CompItem."Last Direct Cost";
                                            end;

                                        SRSetup."Costing Cost Field"::"Last Landed Unit Cost":
                                            begin
                                                CompItemCost := CompItem.GetLandedCost();
                                            end;
                                    end;

                                    ProductionBOMLine.CalcFields("Item Category Code");
                                    CostOtherFixed := 0;
                                    ItemCategory.Reset;
                                    ItemCategory.SetFilter(Code, SRSetup."FILM Category Filter");
                                    if ItemCategory.FindSet() then begin
                                        repeat
                                            if ProductionBOMLine."Item Category Code" = ItemCategory.Code then begin
                                                CostOtherFixed := SRSetup."FILM Cost";
                                            end;
                                        until ItemCategory.Next() = 0;
                                    end;

                                    if CostOtherFixed <> 0 then begin
                                        "Cost Other" += CostOtherFixed;
                                    end else begin
                                        "Cost Other" += Round((CompItemCost / "Package Qty") * ProductionBOMLine."Quantity per", Currency."Amount Rounding Precision", '>');
                                    end;


                                until ProductionBOMLine.Next() = 0;
                            end;

                        end;
                    end;
                    //"Cost Other" := Round("Cost Other", Currency."Amount Rounding Precision", '>');

                    CalculateCost();
                    CalculateSalesProfitPerc();
                end else begin
                    CalculateCost();
                    CalculateSalesProfitPerc();
                    CalculateKG_PC();
                end;

            end;
        }

        field(50133; "Cost Profit %"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CalculateCostOfferPlusGP();
            end;
        }

        field(50134; "Cost YAM Comment"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ΥΑΜ Comment';
        }

        field(50135; "Cost YS Comment"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ΥΣ Comment';
        }

        field(50136; "Cost YL Comment"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'ΥΛ Comment';
        }

        field(50137; "Sales Profit %"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
            BlankZero = true;
        }

        field(50138; "Category 1"; Code[20])
        {
            Caption = 'Packing Group';
            //DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category1));
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Category 1" where("No." = field("No.")));
        }

        field(50139; "Manual Cost Carton"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Carton >0.10';
        }

        field(50140; "Manual Cost Cup"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Κουπάκι';
        }

        field(50141; "Manual Cost Other"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Film/Labels/Net';
        }

        field(50142; "Manual kg/stk"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual kg/stk';
        }
        //TAL 1.0.0.201 >>
        field(50143; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50144; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        //TAL 1.0.0.201 <<

        field(50145; "New Order Qty"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(50146; "Shipping Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Shipping Temperature °C';
        }

        field(50147; "Shipping Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }


    }

    //+1.0.0.258
    fieldgroups
    {
        addlast(Brick; "Unit of Measure", "Quantity (Base)", "Unit of Measure (Base)") //, "Description 2"
        {

        }
    }
    //-1.0.0.258

    trigger OnInsert()
    var
        SRsetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        rL_SalesHeader: Record "Sales Header";
    begin
        GLSetup.Get();
        //+TAL0.2
        "Created By" := UserId;
        "Create Date" := CurrentDateTime;
        //-TAL0.2

        SRsetup.Get;
        if "Document Type" = "Document Type"::Quote then begin
            "Cost Profit %" := SRsetup."Cost Profit %";
            "Currency Code" := GLSetup."LCY Code";
            "Vendor Name" := 'FARMER''S FRESH';
        end;

        if "Document Type" = "Document Type"::Order then begin
            rL_SalesHeader.Reset;
            rL_SalesHeader.SetRange("Document Type", "Document Type");
            rL_SalesHeader.SetFilter("No.", "Document No.");
            if rL_SalesHeader.FindSet() then begin
                if SRsetup."Mand. S.O. Req. Delivery Date" then begin
                    rL_SalesHeader.TestField("Location Code");
                    rL_SalesHeader.TestField("Requested Delivery Date");
                end;
            end;
        end;
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        UpdateAmendDate; //TAL0.2
    end;

    trigger OnBeforeDelete()
    var
        OrderQty: Record "Order Qty";
    begin
        //OrderQty.DeleteOrderQty(xRec);
    end;

    //+1.0.0.204
    trigger OnDelete()
    var
        cu_GeneralMgt: Codeunit "General Mgt.";
        OrderQty: Record "Order Qty";
    begin
        //clear(cu_GeneralMgt);
        //cu_GeneralMgt.UpdateDeletedSOLine(Rec);

        OrderQty.DeleteOrderQty(xRec);
    end;
    //-1.0.0.204

    procedure UpdateAmendDate()
    var
        myInt: Integer;
    begin
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
    end;



    procedure UpdateUnitPriceByFieldCustom(CalledByFieldNo: Integer)
    var

        PriceCalculation: Interface "Price Calculation";
        SalesHeader: Record "Sales Header";
        PriceType: Enum "Price Type";
    begin
        // if not IsPriceCalcCalledByField(CalledByFieldNo) then
        //     exit;
        SalesHeader.Get("Document Type", "Document No.");
        TestField("Qty. per Unit of Measure");

        case Type of
            Type::"G/L Account",
            Type::Item,
            Type::Resource:
                begin

                    GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
                    if not ("Copied From Posted Doc." and IsCreditDocType()) then begin
                        PriceCalculation.ApplyDiscount();
                        ApplyPrice(CalledByFieldNo, PriceCalculation);
                    end;

                end;
        end;



        Validate("Unit Price");

        ClearFieldCausedPriceCalculation();

    end;

    procedure GetItemFromShelfNo()
    var
        rL_Item: Record Item;
    begin
        /*

        rL_Item.RESET;
        rL_Item.SETFILTER("Shelf No.", Colmn4_ItemNo);
        rL_Item.SETRANGE("Package Qty", Colmn11_PackageQty);
        if not rL_Item.FINDSET then begin
            ERROR('Item not found: Shelf No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
        end;
        */

        if "Document Type" <> "Document Type"::Quote then begin
            TestField(Type, Type::Item);
        end;

        if "Shelf No." <> '' then begin
            rL_Item.Reset;
            rL_Item.SetFilter("Shelf No.", "Shelf No.");
            rL_Item.SetRange("Package Qty", "Package Qty");
            if rL_Item.FindSet() then begin
                Validate("No.", rL_Item."No.");
            end;


        end;

    end;

    local procedure CalculateTotalQty()
    var
        myInt: Integer;
    begin
        "Total Qty on Boxes" := "Qty Box Date 1" +
                                "Qty Box Date 2" +
                                "Qty Box Date 3" +
                                "Qty Box Date 4" +
                                "Qty Box Date 5" +
                                "Qty Box Date 6" +
                                "Qty Box Date 7" +
                                "Qty Box Date 8";
    end;

    local procedure CalculateKG_PC()
    var
        myInt: Integer;
    begin
        "Cost KG/PC" := "Cost Per KG" * "Cost kg/stk";
        GetSalesHeaderCustom();
        "Cost KG/PC" := Round("Cost KG/PC", Currency."Amount Rounding Precision");
        Validate("Cost KG/PC");
    end;

    local procedure CalculateCost()
    var
        myInt: Integer;
    begin
        "Cost Offer" := "Cost KG/PC" + "Cost Carton" + "Cost Cup" + "Cost Other";
        CalculateCostOfferPlusGP();
    end;

    local procedure CalculateCostOfferPlusGP()
    var
        SRsetup: Record "Sales & Receivables Setup";
    begin
        SRsetup.Get;
        if "Cost Profit %" = 0 then begin
            "Cost Profit %" := SRsetup."Cost Profit %";
        end;

        "Cost Offer+GP" := "Cost Offer" * "Cost Profit %";
        GetSalesHeaderCustom();

        //Message(Currency.Code);
        "Cost Offer+GP" := Round("Cost Offer+GP", Currency."Amount Rounding Precision");
        CalculateCostValuation();
        CalculateSalesProfitPerc();
    end;

    local procedure CalculateCostValuation()
    var
        myInt: Integer;
    begin
        if "Price Box" <> 0 then begin

            "Cost Valuation" := ("Price Box") - "Cost Offer+GP";
        end;

        if "Price KG" <> 0 then begin

            "Cost Valuation" := ("Price KG") - "Cost Offer+GP";
        end;

        if "Price PCS" <> 0 then begin

            "Cost Valuation" := ("Price PCS") - "Cost Offer+GP";
        end;




    end;

    procedure GetSalesHeaderCustom()
    begin
        GetSalesHeaderCustom(SalesHeader, Currency);
    end;

    procedure GetSalesHeaderCustom(var OutSalesHeader: Record "Sales Header"; var OutCurrency: Record Currency)
    var
        IsHandled: Boolean;
    begin

        TestField("Document No.");
        if ("Document Type" <> SalesHeader."Document Type") or ("Document No." <> SalesHeader."No.") then begin
            SalesHeader.Get("Document Type", "Document No.");
            if SalesHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                SalesHeader.TestField("Currency Factor");
                Currency.Get(SalesHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;


        OutSalesHeader := SalesHeader;
        OutCurrency := Currency;
    end;

    procedure CopyLastSettings()
    var
        rL_SalesLine: Record "Sales Line";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        if "Pallet Qty" <> 0 then begin
            exit;
        end;
        rL_SalesLine.Reset;
        rL_SalesLine.SetRange("Document Type", "Document Type"::Quote);
        rL_SalesLine.SetRange(Type, Type::Item);
        rL_SalesLine.SetFilter("No.", "No.");
        rL_SalesLine.SetFilter("Shelf No.", "Shelf No.");
        rL_SalesLine.SetFilter("Document No.", '<>%1', "Document No.");
        if rL_SalesLine.FindLast() then begin

            Validate("Pallet Qty", rL_SalesLine."Pallet Qty");
            "Country/Region of Origin Code" := rL_SalesLine."Country/Region of Origin Code";
            Validate("Product Class", rL_SalesLine."Product Class");
            //validate("Package Qty", rL_SalesLine."Package Qty");
            Validate("Calibration Min.", rL_SalesLine."Calibration Min.");
            Validate("Calibration Max.", rL_SalesLine."Calibration Max.");
            Validate("Calibration UOM", rL_SalesLine."Calibration UOM");
            Validate(Variety, rL_SalesLine.Variety);
            Validate("Currency Code", GLSetup."LCY Code"); // rL_SalesLine."Currency Code"
            //validate("Price Previous Week Box", rL_SalesLine."Price Previous Week Box");
            //validate("Price Previous Week PCS", rL_SalesLine."Price Previous Week PCS");
            //validate("Price Previous Week KG", rL_SalesLine."Price Previous Week KG");
            //validate("Price Box", rL_SalesLine."Price Box");
            //validate("Price PCS", rL_SalesLine."Price PCS");
            //validate("Price KG", rL_SalesLine."Price KG");
            CalculateCostingSalesPrice();
            Validate("Row Index", 0);
            /*
            validate("Qty Box Date 1", rL_SalesLine."Qty Box Date 1");
            validate("Qty Box Date 2", rL_SalesLine."Qty Box Date 2");
            validate("Qty Box Date 3", rL_SalesLine."Qty Box Date 3");
            validate("Qty Box Date 4", rL_SalesLine."Qty Box Date 4");
            validate("Qty Box Date 5", rL_SalesLine."Qty Box Date 5");
            validate("Qty Box Date 6", rL_SalesLine."Qty Box Date 6");
            validate("Qty Box Date 7", rL_SalesLine."Qty Box Date 7");
            validate("Qty Box Date 8", rL_SalesLine."Qty Box Date 8");
            */
            Validate("Total Qty on Boxes", rL_SalesLine."Total Qty on Boxes");
            Validate("Additional Information", rL_SalesLine."Additional Information");
            Validate("Pressure Min.", rL_SalesLine."Pressure Min.");
            Validate("Pressure Max.", rL_SalesLine."Pressure Max.");
            Validate("Brix Min", rL_SalesLine."Brix Min");
            Validate("Vendor Name", rL_SalesLine."Vendor Name");
            Validate("QC 1 Min", rL_SalesLine."QC 1 Min");
            Validate("QC 1 Max", rL_SalesLine."QC 1 Max");
            Validate("QC 1 Text", rL_SalesLine."QC 1 Text");
            Validate("QC 2 Min", rL_SalesLine."QC 2 Min");
            Validate("QC 2 Max", rL_SalesLine."QC 2 Max");
            Validate("QC 2 Text", rL_SalesLine."QC 2 Text");
            Validate("Box Width", rL_SalesLine."Box Width");
            Validate("Box Char 1", rL_SalesLine."Box Char 1");
            Validate("Box Length", rL_SalesLine."Box Length");
            Validate("Box Char 2", rL_SalesLine."Box Char 2");
            Validate("Box Height", rL_SalesLine."Box Height");
            Validate("Box Changed Date", rL_SalesLine."Box Changed Date");
            Validate("Harvest Temp. From", rL_SalesLine."Harvest Temp. From");
            Validate("Harvest Temp. To", rL_SalesLine."Harvest Temp. To");
            Validate("Freezer Harvest Temp. From", rL_SalesLine."Freezer Harvest Temp. From");
            Validate("Freezer Harvest Temp. To", rL_SalesLine."Freezer Harvest Temp. To");
            Validate("Transfer Temp. From", rL_SalesLine."Transfer Temp. From");
            Validate("Transfer Temp. To", rL_SalesLine."Transfer Temp. To");

            //cost
            Validate("Cost Per KG", rL_SalesLine."Cost Per KG");
            CalculateSalesProfitPerc();

        end;

    end;

    local procedure CalculateSalesProfitPerc()
    var
        myInt: Integer;
    begin
        "Sales Profit %" := 0;

        if "Cost Offer" <> 0 then begin
            if "Price PCS" <> 0 then begin
                "Sales Profit %" := (("Price PCS" - "Cost Offer") / "Cost Offer") * 100;
            end;

            if "Price KG" <> 0 then begin
                "Sales Profit %" := (("Price KG" - "Cost Offer") / "Cost Offer") * 100;
            end;
        end;

        GetSalesHeaderCustom();
        "Sales Profit %" := Round("Sales Profit %", Currency."Amount Rounding Precision");

    end;


    //CostingPrice
    /*
    procedure CostingPriceExists(): Boolean
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
    begin
        SalesHeader.get("Document Type", "Document No.");

        vL_StartDate := SalesHeader.GetPriceStartDate();
        vL_EndDate := SalesHeader.GetPriceEndDate();

        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
        SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));
        SalesPrice.SetRange("Item No.", "No.");
        if SalesPrice.FindSet() then begin
            exit(true);
        end;

        exit(False);

    end;
    */

    /*
    procedure GetCostingPrice(): Decimal
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
    begin
        SalesHeader.get("Document Type", "Document No.");

        vL_StartDate := SalesHeader.GetPriceStartDate();
        vL_EndDate := SalesHeader.GetPriceEndDate();

        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
        SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));
        SalesPrice.SetRange("Item No.", "No.");
        if SalesPrice.FindSet() then begin
            exit(SalesPrice."Unit Price");
        end;

        exit(0);

    end;
    */

    //PreviousWeek
    procedure CostingPriceExistsPreviousWeek(): Boolean
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
    begin
        SalesHeader.Get("Document Type", "Document No.");
        //SalesHeader.testfield("Price Start Date");
        //SalesHeader.testfield("Price End Date");

        vL_StartDate := SalesHeader."Price Start Date";  //SalesHeader.GetPriceStartDatePreviousWeek();
        vL_EndDate := SalesHeader."Price End Date"; //SalesHeader.GetPriceEndDatePreviousWeek();

        SalesPrice.Reset;
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
        SalesPrice.SetRange("Item No.", "No.");

        //SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));
        SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_EndDate);
        SalesPrice.SetRange("Starting Date", 0D, vL_EndDate);
        if not SalesPrice.FindLast() then begin
            SalesPrice.Reset;
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
            SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
            SalesPrice.SetRange("Item No.", "No.");
            SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_StartDate);
            SalesPrice.SetRange("Starting Date", 0D, vL_StartDate);
        end;

        if SalesPrice.FindLast() then begin
            exit(true);
        end;
        exit(false);

    end;

    procedure GetCostingPricePreviousWeek(): Decimal
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
    begin
        SalesHeader.Get("Document Type", "Document No.");

        SalesHeader.TestField("Price Start Date");
        SalesHeader.TestField("Price End Date");

        vL_StartDate := SalesHeader."Price Start Date"; // SalesHeader.GetPriceStartDatePreviousWeek();
        vL_EndDate := SalesHeader."Price End Date"; //SalesHeader.GetPriceEndDatePreviousWeek();

        SalesPrice.Reset;
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
        SalesPrice.SetRange("Item No.", "No.");
        //SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        //SETRANGE("Starting Date",0D,StartingDate);
        //SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));


        SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_EndDate);
        SalesPrice.SetRange("Starting Date", 0D, vL_EndDate);
        if not SalesPrice.FindLast() then begin
            SalesPrice.Reset;
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
            SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
            SalesPrice.SetRange("Item No.", "No.");
            SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_StartDate);
            SalesPrice.SetRange("Starting Date", 0D, vL_StartDate);
        end;

        if SalesPrice.FindLast() then begin
            exit(SalesPrice."Unit Price");
        end;

        exit(0);

    end;


    procedure GetCostingPriceUpdate(): Decimal
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
    begin
        SalesHeader.Get("Document Type", "Document No.");

        SalesHeader.TestField("Price Update Start Date");
        SalesHeader.TestField("Price Update End Date");

        vL_StartDate := SalesHeader."Price Update Start Date"; // SalesHeader.GetPriceStartDatePreviousWeek();
        vL_EndDate := SalesHeader."Price Update End Date"; //SalesHeader.GetPriceEndDatePreviousWeek();

        SalesPrice.Reset;
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
        SalesPrice.SetRange("Item No.", "No.");
        //SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        //SETRANGE("Starting Date",0D,StartingDate);
        //SalesPrice.SetFilter("Starting Date", FORMAT(vL_StartDate) + '..' + FORMAT(vL_EndDate));

        SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_EndDate);
        SalesPrice.SetRange("Starting Date", 0D, vL_EndDate);
        if not SalesPrice.FindLast() then begin
            SalesPrice.Reset;
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
            SalesPrice.SetFilter("Sales Code", "Bill-to Customer No.");
            SalesPrice.SetRange("Item No.", "No.");
            SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, vL_StartDate);
            SalesPrice.SetRange("Starting Date", 0D, vL_StartDate);
        end;

        if SalesPrice.FindLast() then begin
            exit(SalesPrice."Unit Price");
        end;

        exit(0);

    end;


    local procedure CalculateCostingSalesPrice()
    var
        rL_Item: Record Item;
    begin
        if "Document Type" <> "Document Type"::Quote then begin
            exit;
        end;

        if Type <> Type::Item then begin
            exit;
        end;

        if "No." = '' then begin
            exit;
        end;

        if rL_Item.Get("No.") then begin
            if rL_Item."Category 1" = '' then begin
                exit;
            end;

            rL_Item.TestField("Package Qty");


            "Price Previous Week Box" := 0;
            "Price Previous Week KG" := 0;
            "Price Previous Week PCS" := 0;

            "Price Box" := 0;
            "Price KG" := 0;
            "Price PCS" := 0;

            //rL_Item."Package Qty"
            if "Package Qty" <> 0 then begin
                if rL_Item."Category 1" = 'LOSE' then begin

                    "Price KG" := GetCostingPricePreviousWeek(); //GetCostingPrice();
                    "Price Previous Week KG" := GetCostingPricePreviousWeek();

                    "Price Box" := "Price KG" * "Package Qty";
                    "Price Previous Week Box" := "Price Previous Week KG" * "Package Qty";
                end else begin
                    "Price PCS" := GetCostingPricePreviousWeek(); //GetCostingPrice();
                    "Price Previous Week PCS" := GetCostingPricePreviousWeek();

                    "Price Box" := "Price PCS" * "Package Qty";
                    "Price Previous Week Box" := "Price Previous Week PCS" * "Package Qty";
                end;
            end;
        end;

    end;



    procedure SelectMultipleItemsPFV()
    var
        ItemListPage: Page "Item List";
        SelectionFilter: Text;
    begin


        if IsCreditDocType() then
            SelectionFilter := ItemListPage.SelectActiveItems()
        else
            SelectionFilter := ItemListPage.SelectActiveItemsForSalePFV();
        if SelectionFilter <> '' then
            AddItemsPFV(SelectionFilter);


    end;

    local procedure AddItemsPFV(SelectionFilter: Text)
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin

        InitNewLine(SalesLine);
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then
            repeat
                AddItem(SalesLine, Item."No.");
            until Item.Next() = 0;
    end;


    var
        myInt: Integer;

        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
}
/*
TAL0.3 2018/06/10 VC add fields
        Package Qty
        Category 1-3
        Packing Group Description

TAL0.4 2019/05/03 VC add Max Unit Cost Field 
TAL0.5 2020/03/03 VC review Ship-to Categories
TAL0.6 2020/03/04 VC Validate Shelf No. add Categories
TAL0.7 2020/04/08 VC set item tracking code according to setup
TAL0.8 2020/04/09 VC round decimals in custom fields 
                   Consumption (Qty.)
                   Output (Qty.)
                   Sales (Qty.) ILE
                   Positive Adjmt. (Qty.) ILE
                   Negative Adjmt. (Qty.) ILE
TAL0.9 2021/10/26 VC add column Transfer (Qty.) ILE
TAL0.10 2021/12/14 VC add Qty. Out on Sales Order
*/

tableextension 50105 ItemExt extends Item
{
    fields
    {
        // Add changes to table fields here

        modify("Description 2")
        {
            caption = 'Description 2 (GR)';
        }

        modify("Shelf No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                rL_GeneralCategories: Record "General Categories";
            begin

                //+TAL0.6
                IF "Shelf No." <> '' THEN BEGIN
                    rL_GeneralCategories.RESET;
                    rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                    rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SETFILTER(Code, "Shelf No.");
                    IF rL_GeneralCategories.FINDSET THEN BEGIN
                        VALIDATE("Category 2", "Shelf No.");
                    END;
                END;
                //-TAL0.6
            end;
        }
        field(50001; "Extended Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Package Qty"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2; //DecimalPlaces = 0 : 1 //1.0.0.279
        }

        field(50003; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50010; "Category 1"; Code[20])
        {
            Caption = 'Packing Group';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category1));
        }
        field(50011; "Category 2"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category2));
        }
        field(50012; "Category 3"; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category3));
        }
        field(50013; "Category 4"; Code[20])
        {
            Caption = 'Caliber Min';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category4));
        }
        field(50014; "Category 5"; Code[20])
        {
            Caption = 'Caliber Max';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category5));
        }
        field(50015; "Category 6"; Code[20])
        {
            Caption = 'Caliber UOM';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category6));
        }
        field(50016; "Category 7"; Code[20])
        {
            Caption = 'Variety';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category7));
        }

        //+1.0.0.291
        field(50017; "Category 8"; Code[20])
        {
            Caption = 'Product Class (Κατηγορία)';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category8));
            // ToolTip = 'Κατηγορία';
        }

        field(50018; "Category 9"; Code[20])
        {
            Caption = 'Potatoes District Region';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category9));
        }
        //-1.0.0.291

        field(50019; "Category 10"; Code[20])
        {
            Caption = 'Category 10';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category10));
        }

        field(50020; "Packing Group Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("General Categories".Description WHERE("Table No." = CONST(27), Type = CONST(Category1), Code = FIELD("Category 1")));
            Editable = false;

        }
        field(50021; "Max Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            MinValue = 0;
        }

        field(50022; "No. of Sales Quotes"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Line" WHERE("Document Type" = CONST(Quote),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No.")
                                                                            ));
            Caption = 'No. of Sales Quotes';
            Editable = false;
            FieldClass = FlowField;

        }
        field(50030; "Ship-to Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Ship-to Product Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("General Categories"."Description 2" WHERE("Table No." = FILTER(27), Type = FILTER(Category2), Code = FIELD("Category 2")));
            Editable = false;

        }
        field(50032; "Pallet Qty"; Decimal)
        {
            BlankZero = true;
            Caption = 'Pallet Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 1;
        }
        field(50033; "Consumption (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Consumption), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Consumption (Qty.)',
                        ENU = 'Consumption (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50034; "Output (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Output), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Output (Qty.)',
                        ENU = 'Output (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50035; "Purchases (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Purchase), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Purchases (Qty.) ILE',
                        ENU = 'Purchases (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50036; "Sales (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Sale), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Sales (Qty.) ILE',
                        ENU = 'Sales (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50037; "Positive Adjmt. (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST("Positive Adjmt."), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Positive Adjmt. (Qty.) ILE',
                        ENU = 'Positive Adjmt. (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50038; "Negative Adjmt. (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST("Negative Adjmt."), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Negative Adjmt. (Qty.) ILE',
                        ENU = 'Negative Adjmt. (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50039; "Transfer (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Transfer), "Item No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Posting Date" = FIELD("Date Filter"), "Lot No." = FIELD("Lot No. Filter"), "Serial No." = FIELD("Serial No. Filter")));
            CaptionML = ELL = 'Transfer (Qty.) ILE',
                        ENU = 'Transfer (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }



        field(50040; "Category 11"; Code[20])
        {
            Caption = 'Category 11';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category11));
        }

        field(50041; "Category 12"; Code[20])
        {
            Caption = 'Category 12';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category12));
        }

        field(50042; "Category 13"; Code[20])
        {
            Caption = 'Category 13';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category13));
        }

        field(50043; "Category 14"; Code[20])
        {
            Caption = 'Category 14';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category14));
        }


        field(50044; "Category 15"; Code[20])
        {
            Caption = 'Category 15';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category15));
        }

        field(50045; "Category 16"; Code[20])
        {
            Caption = 'Category 16';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category16));
        }

        field(50046; "Category 17"; Code[20])
        {
            Caption = 'Category 17';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category17));
        }

        field(50047; "Category 18"; Code[20])
        {
            Caption = 'Category 18';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category18));
        }

        field(50048; "Category 19"; Code[20])
        {
            Caption = 'Category 19';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category19));
        }

        field(50049; "Category 20"; Code[20])
        {
            Caption = 'Category 20';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(27), Type = CONST(Category20));
        }



        field(50050; "Qty. Out on Sales Order"; Decimal)
        {
            FieldClass = FlowField;
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Filter"), "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Qty. Oustanding on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;

        }

        field(50051; "Closed Storage Life"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }

        field(50052; "Fridge Storage Life"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }

        field(50053; "Freezer Storage Life"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }

        //+1.0.0.232
        field(50054; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(5404), Type = CONST(Category1));
        }
        //-1.0.0.232

        field(50055; "Allow Modulus"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //+1.0.0.289
        field(50103; "TAL Exclude Item from Adjustme"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exclude Item from Adjustmet';
        }
        //-1.0.0.289



    }

    trigger OnInsert()
    var
        myInt: Integer;
        rL_NoSeries: Record "No. Series";
        rL_SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        //+TAL0.2
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.2

        VALIDATE("Category 3", 'I'); //TAL0.5 

        //+TAL0.7
        IF rL_NoSeries.GET("No. Series") THEN BEGIN
            IF rL_NoSeries."Item Tracking" THEN BEGIN
                rL_SalesRecSetup.GET;
                VALIDATE("Item Tracking Code", rL_SalesRecSetup."Default Item Tracking Code");
                VALIDATE("Lot Nos.", rL_SalesRecSetup."Default Lot Nos.");
            END;
        END;
        //-TAL0.7

    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        //+TAL0.2
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.2
    end;


    procedure GetLandedCost() LastLandedUnitCost: Decimal;
    var
        rL_LastILE: Record "Item Ledger Entry";
    begin
        LastLandedUnitCost := 0;
        rL_LastILE.RESET;
        rL_LastILE.SetRange("Entry Type", rL_LastILE."Entry Type"::Purchase);
        rL_LastILE.SetRange("Document Type", rL_LastILE."Document Type"::"Purchase Receipt");
        rL_LastILE.SetFilter("Item No.", "No.");
        if rL_LastILE.FindLast() then begin
            rL_LastILE.calcfields("Cost Amount (Actual)", "Cost Amount (Expected)");
            LastLandedUnitCost := (rL_LastILE."Cost Amount (Actual)" + rL_LastILE."Cost Amount (Expected)") / rL_LastILE.Quantity;
            LastLandedUnitCost := ROUND(LastLandedUnitCost, 0.01, '=');
        end;
    end;

    procedure DrillDownLandedCost()
    var
        rL_LastILE: Record "Item Ledger Entry";
    begin
        rL_LastILE.RESET;
        rL_LastILE.SetRange("Entry Type", rL_LastILE."Entry Type"::Purchase);
        rL_LastILE.SetRange("Document Type", rL_LastILE."Document Type"::"Purchase Receipt");
        rL_LastILE.SetFilter("Item No.", "No.");
        if rL_LastILE.FindLast() then begin

        end;
        Page.Run(page::"Item Ledger Entries", rL_LastILE);
    end;

    var
        myInt: Integer;
}
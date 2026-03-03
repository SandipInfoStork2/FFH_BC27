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
            Caption = 'Description 2 (GR)';
        }

        modify("Shelf No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                rL_GeneralCategories: Record "General Categories";
            begin

                //+TAL0.6
                if "Shelf No." <> '' then begin
                    rL_GeneralCategories.Reset;
                    rL_GeneralCategories.SetRange("Table No.", Database::Item);
                    rL_GeneralCategories.SetRange(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.SetFilter(Code, "Shelf No.");
                    if rL_GeneralCategories.FindSet then begin
                        Validate("Category 2", "Shelf No.");
                    end;
                end;
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
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category1));
        }
        field(50011; "Category 2"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category2));
        }
        field(50012; "Category 3"; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category3));
        }
        field(50013; "Category 4"; Code[20])
        {
            Caption = 'Caliber Min';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category4));
        }
        field(50014; "Category 5"; Code[20])
        {
            Caption = 'Caliber Max';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category5));
        }
        field(50015; "Category 6"; Code[20])
        {
            Caption = 'Caliber UOM';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category6));
        }
        field(50016; "Category 7"; Code[20])
        {
            Caption = 'Variety';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category7));
        }

        //+1.0.0.291
        field(50017; "Category 8"; Code[20])
        {
            Caption = 'Product Class (Κατηγορία)';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category8));
            // ToolTip = 'Κατηγορία';
        }

        field(50018; "Category 9"; Code[20])
        {
            Caption = 'Potatoes District Region';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category9));
        }
        //-1.0.0.291

        field(50019; "Category 10"; Code[20])
        {
            Caption = 'Category 10';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category10));
        }

        field(50020; "Packing Group Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("General Categories".Description where("Table No." = const(27), Type = const(Category1), Code = field("Category 1")));
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
            AccessByPermission = tabledata "Sales Shipment Header" = R;
            CalcFormula = count("Sales Line" where("Document Type" = const(Quote),
                                                                            Type = const(Item),
                                                                            "No." = field("No.")
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
            CalcFormula = lookup("General Categories"."Description 2" where("Table No." = filter(27), Type = filter(Category2), Code = field("Category 2")));
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
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const(Consumption), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Consumption (Qty.)',
                        ENU = 'Consumption (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50034; "Output (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const(Output), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Output (Qty.)',
                        ENU = 'Output (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50035; "Purchases (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const(Purchase), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Purchases (Qty.) ILE',
                        ENU = 'Purchases (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50036; "Sales (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const(Sale), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Sales (Qty.) ILE',
                        ENU = 'Sales (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50037; "Positive Adjmt. (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const("Positive Adjmt."), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Positive Adjmt. (Qty.) ILE',
                        ENU = 'Positive Adjmt. (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50038; "Negative Adjmt. (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const("Negative Adjmt."), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Negative Adjmt. (Qty.) ILE',
                        ENU = 'Negative Adjmt. (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(50039; "Transfer (Qty.) ILE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Entry Type" = const(Transfer), "Item No." = field("No."), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Posting Date" = field("Date Filter"), "Lot No." = field("Lot No. Filter"), "Serial No." = field("Serial No. Filter")));
            CaptionML = ELL = 'Transfer (Qty.) ILE',
                        ENU = 'Transfer (Qty.) ILE';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }



        field(50040; "Category 11"; Code[20])
        {
            Caption = 'Category 11';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category11));
        }

        field(50041; "Category 12"; Code[20])
        {
            Caption = 'Category 12';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category12));
        }

        field(50042; "Category 13"; Code[20])
        {
            Caption = 'Category 13';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category13));
        }

        field(50043; "Category 14"; Code[20])
        {
            Caption = 'Category 14';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category14));
        }


        field(50044; "Category 15"; Code[20])
        {
            Caption = 'Category 15';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category15));
        }

        field(50045; "Category 16"; Code[20])
        {
            Caption = 'Category 16';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category16));
        }

        field(50046; "Category 17"; Code[20])
        {
            Caption = 'Category 17';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category17));
        }

        field(50047; "Category 18"; Code[20])
        {
            Caption = 'Category 18';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category18));
        }

        field(50048; "Category 19"; Code[20])
        {
            Caption = 'Category 19';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category19));
        }

        field(50049; "Category 20"; Code[20])
        {
            Caption = 'Category 20';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category20));
        }



        field(50050; "Qty. Out on Sales Order"; Decimal)
        {
            FieldClass = FlowField;
            AccessByPermission = tabledata "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const(Order), Type = const(Item), "No." = field("No."), "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"), "Location Code" = field("Location Filter"), "Drop Shipment" = field("Drop Shipment Filter"), "Variant Code" = field("Variant Filter"), "Shipment Date" = field("Date Filter")));
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
            TableRelation = "General Categories".Code where("Table No." = const(5404), Type = const(Category1));
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
        if "No." = '' then begin
            Error('Blank No is not allowed');
        end;
        //-TAL0.2

        Validate("Category 3", 'I'); //TAL0.5 

        //+TAL0.7
        if rL_NoSeries.Get("No. Series") then begin
            if rL_NoSeries."Item Tracking" then begin
                rL_SalesRecSetup.Get;
                Validate("Item Tracking Code", rL_SalesRecSetup."Default Item Tracking Code");
                Validate("Lot Nos.", rL_SalesRecSetup."Default Lot Nos.");
            end;
        end;
        //-TAL0.7

    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        //+TAL0.2
        if "No." = '' then begin
            Error('Blank No is not allowed');
        end;
        //-TAL0.2
    end;


    procedure GetLandedCost() LastLandedUnitCost: Decimal;
    var
        rL_LastILE: Record "Item Ledger Entry";
    begin
        LastLandedUnitCost := 0;
        rL_LastILE.Reset;
        rL_LastILE.SetRange("Entry Type", rL_LastILE."Entry Type"::Purchase);
        rL_LastILE.SetRange("Document Type", rL_LastILE."Document Type"::"Purchase Receipt");
        rL_LastILE.SetFilter("Item No.", "No.");
        if rL_LastILE.FindLast() then begin
            rL_LastILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
            LastLandedUnitCost := (rL_LastILE."Cost Amount (Actual)" + rL_LastILE."Cost Amount (Expected)") / rL_LastILE.Quantity;
            LastLandedUnitCost := Round(LastLandedUnitCost, 0.01, '=');
        end;
    end;

    procedure DrillDownLandedCost()
    var
        rL_LastILE: Record "Item Ledger Entry";
    begin
        rL_LastILE.Reset;
        rL_LastILE.SetRange("Entry Type", rL_LastILE."Entry Type"::Purchase);
        rL_LastILE.SetRange("Document Type", rL_LastILE."Document Type"::"Purchase Receipt");
        rL_LastILE.SetFilter("Item No.", "No.");
        if rL_LastILE.FindLast() then begin

        end;
        Page.Run(Page::"Item Ledger Entries", rL_LastILE);
    end;

    var
        myInt: Integer;
}
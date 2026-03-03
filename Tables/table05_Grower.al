table 50005 Grower
{
    // TAL0.2 2021/03/27 VC rename field Purchases (PKG) to Purchases (PCS/KG)
    // TAL0.3 2021/04/02 VC add field Producer Group Name
    // TAL0.4 2021/11/16 VC add field Country of Destination

    DrillDownPageId = "Grower List";
    LookupPageId = "Grower List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.Get;
                    NoSeries.TestManual(PurchSetup."Grower Nos.");
                    //NoSeriesMgt.TestManual(PurchSetup."Grower Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = ToBeClassified;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Mobile Phone No."; Text[30])
        {
            CaptionML = ELL = 'Mobile Phone No.',
                        ENU = 'Mobile Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(64; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        /*
        field(71; "Purchases (Qty.)"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Purchase),
                                                                  "Source Type" = FILTER(Vendor),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Lot Grower No." = FIELD("No.")));
            Caption = 'Purchases (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(72; "Sales (Qty.)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Sale),
                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                   "Lot No." = FIELD("Lot No. Filter"),
                                                                    "Lot Grower No." = FIELD("No."),
                                                                   "Source No." = FIELD("Customer No. Filter")));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Purchases (PCS/KG)"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry"."Total Net Weight" WHERE("Entry Type" = CONST(Purchase),
                                                                    "Source Type" = FILTER(Vendor),
                                                                    "Posting Date" = FIELD("Date Filter"),
                                                                    "Lot No." = FIELD("Lot No. Filter"),
                                                                      "Lot Grower No." = FIELD("No.")));
            CaptionML = ELL = 'Purchases (PCS/KG)',
                        ENU = 'Purchases (PCS/KG)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        field(74; "Sales (KG)"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = - Sum("Item Ledger Entry"."Total Net Weight" WHERE("Entry Type" = CONST(Sale),
                                                                     "Posting Date" = FIELD("Date Filter"),
                                                                     "Lot No." = FIELD("Lot No. Filter"),
                                                                      "Lot Grower No." = FIELD("No."),
                                                                     "Source No." = FIELD("Customer No. Filter")));
            CaptionML = ELL = 'Sales (KG)',
                        ENU = 'Sales (KG)';
            DecimalPlaces = 0 : 0;
            Editable = false;

        }
        */
        field(90; GLN; Code[13])
        {
            Caption = 'GLN';
            DataClassification = ToBeClassified;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                if GLN <> '' then
                    GLNCalculator.AssertValidCheckDigit13(GLN);
            end;
        }
        field(91; "Country of Destination"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6503; "Lot No. Filter"; Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(50001; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50002; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50003; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50006; "Grower Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50008; GGN; Code[14])
        {
            Caption = 'GGN';
            DataClassification = ToBeClassified;
            Description = 'Global GAP Number';
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                //IF GGN <> '' THEN
                //  GLNCalculator.AssertValidCheckDigit13(GGN);
            end;
        }
        field(50009; TC; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Category 1"; Code[20])
        {
            Caption = 'Producer Group';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category1));
        }
        field(50011; "Category 2"; Code[20])
        {
            CaptionML = ELL = 'GLOBALG.A.P. Option',
                        ENU = 'GLOBALG.A.P. Option';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category2));
        }
        field(50012; "Category 3"; Code[20])
        {
            CaptionML = ELL = 'Status GRASP',
                        ENU = 'Status GRASP ';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category3));
        }
        field(50013; "Category 4"; Code[20])
        {
            CaptionML = ELL = 'Status LIDL supply chain',
                        ENU = 'Status LIDL supply chain';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category4));
        }
        field(50014; "Category 5"; Code[20])
        {
            CaptionML = ELL = 'Grower',
                        ENU = 'Grower';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category5));
        }
        field(50015; "Category 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category6));
        }
        field(50020; "GGN Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if "GGN Expiry Date" >= Today then begin
                    Validate("Grower Certified", true);
                end else begin
                    Validate("Grower Certified", false);
                end;
            end;
        }
        field(50021; "No. of Products"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Item Grower Vendor" where("Grower No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; Comments; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Grower Vendor GLN"; Code[13])
        {
            CalcFormula = lookup(Vendor.GLN where("No." = field("Grower Vendor No.")));
            CaptionML = ELL = 'Grower Vendor GLN',
                        ENU = 'Grower Vendor GLN';
            Editable = false;
            FieldClass = FlowField;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                if GLN <> '' then
                    GLNCalculator.AssertValidCheckDigit13(GLN);
            end;
        }
        field(50024; "Grower Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Grower Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vendor;
        }
        field(50025; "Grower Vendor GGN"; Code[14])
        {
            CalcFormula = lookup(Vendor.GGN where("No." = field("Grower Vendor No.")));
            CaptionML = ELL = 'Grower Vendor GGN',
                        ENU = 'Grower Vendor GGN';
            Editable = false;
            FieldClass = FlowField;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                if GLN <> '' then
                    GLNCalculator.AssertValidCheckDigit13(GLN);
            end;
        }
        field(50026; "Grower Certified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = lookup("General Categories".Description where("Table No." = filter(23),
                                                                         Type = filter(Category1),
                                                                         Code = field("Category 1")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Customer No. Filter"; Code[20])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }



        field(50029; "GRASP Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50030; "Status Biodiversity"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category3));
        }

        field(50031; "Biodiversity Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50032; "Status SPRING"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23),
                                                             Type = const(Category3));
        }

        field(50033; "SPRING Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Name)
        {
        }
        key(Key3; GGN)
        {
        }
        key(Key4; "Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, GGN, "GGN Expiry Date")
        {
        }
    }

    trigger OnDelete();
    var
        rL_ItemGrowerVendor: Record "Item Grower Vendor";
    begin

        rL_ItemGrowerVendor.SetRange("Grower No.", "No.");
        rL_ItemGrowerVendor.DeleteAll;
    end;

    trigger OnInsert();
    begin
        if "No." = '' then begin
            PurchSetup.Get;
            "No." := NoSeries.GetNextNo(PurchSetup."Grower Nos.", 0D);
            //NoSeriesMgt.InitSeries(PurchSetup."Grower Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Creation Date" := CurrentDateTime;
        "Created By" := UserId;
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
    end;

    procedure GetPurchasesQty(): Decimal
    var
        myInt: Integer;
        rL_ILE: Record "Item Ledger Entry";
        vL_TotalQty: Decimal;
    begin
        vL_TotalQty := 0;

        //if "No." = 'GRO005' then begin
        //vL_TotalQty := 0;
        //Message(Getfilter("Date Filter"));
        //end;

        rL_ILE.Reset;
        rL_ILE.SetCurrentKey("Entry Type", "Source Type", "Lot Grower No.", "Posting Date", "Source No.");
        rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Purchase);
        rL_ILE.SetRange("Source Type", rL_ILE."Source Type"::Vendor);

        if GetFilter("Date Filter") <> '' then begin
            rL_ILE.SetFilter("Posting Date", GetFilter("Date Filter"));
        end;

        if "Lot No. Filter" <> '' then begin
            rL_ILE.SetFilter("Lot No.", "Lot No. Filter");
        end;

        rL_ILE.SetFilter("Lot Grower No.", "No.");
        if rL_ILE.FindSet() then begin
            rL_ILE.CalcSums(Quantity);
            //repeat
            //   vL_TotalQty += rL_ILE.Quantity;
            //until rL_ILE.Next() = 0;
        end;
        vL_TotalQty := rL_ILE.Quantity;
        exit(vL_TotalQty);

    end;

    procedure GetPurchasesTotalNetWeight(): Decimal
    var
        myInt: Integer;
        rL_ILE: Record "Item Ledger Entry";
        vL_TotalQty: Decimal;
    begin
        vL_TotalQty := 0;

        rL_ILE.Reset;
        rL_ILE.SetCurrentKey("Entry Type", "Source Type", "Lot Grower No.", "Posting Date", "Source No.");
        rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Purchase);
        rL_ILE.SetRange("Source Type", rL_ILE."Source Type"::Vendor);

        if GetFilter("Date Filter") <> '' then begin
            rL_ILE.SetFilter("Posting Date", GetFilter("Date Filter"));
        end;

        if "Lot No. Filter" <> '' then begin
            rL_ILE.SetFilter("Lot No.", "Lot No. Filter");
        end;

        rL_ILE.SetFilter("Lot Grower No.", "No.");
        if rL_ILE.FindSet() then begin
            rL_ILE.CalcSums("Total Net Weight");
        end;
        vL_TotalQty := rL_ILE."Total Net Weight";
        exit(vL_TotalQty);

    end;

    //sales
    procedure GetSalesQty(): Decimal
    var
        myInt: Integer;
        rL_ILE: Record "Item Ledger Entry";
        vL_TotalQty: Decimal;
    begin
        vL_TotalQty := 0;

        rL_ILE.Reset;
        rL_ILE.SetCurrentKey("Entry Type", "Source Type", "Lot Grower No.", "Posting Date", "Source No.");
        rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Sale);

        if GetFilter("Date Filter") <> '' then begin
            rL_ILE.SetFilter("Posting Date", GetFilter("Date Filter"));
        end;

        if "Lot No. Filter" <> '' then begin
            rL_ILE.SetFilter("Lot No.", "Lot No. Filter");
        end;

        rL_ILE.SetFilter("Lot Grower No.", "No.");

        if ("Customer No. Filter" <> '') then begin
            rL_ILE.SetFilter("Source No.", "Customer No. Filter");
        end;

        if rL_ILE.FindSet() then begin
            rL_ILE.CalcSums(Quantity);
        end;
        vL_TotalQty := rL_ILE.Quantity;
        exit(vL_TotalQty);

    end;

    procedure GetSalesTotalNetWeight(): Decimal
    var
        myInt: Integer;
        rL_ILE: Record "Item Ledger Entry";
        vL_TotalQty: Decimal;
    begin
        vL_TotalQty := 0;

        rL_ILE.Reset;
        rL_ILE.SetCurrentKey("Entry Type", "Source Type", "Lot Grower No.", "Posting Date", "Source No.");
        rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Sale);

        if GetFilter("Date Filter") <> '' then begin
            rL_ILE.SetFilter("Posting Date", GetFilter("Date Filter"));
        end;

        if "Lot No. Filter" <> '' then begin
            rL_ILE.SetFilter("Lot No.", "Lot No. Filter");
        end;

        rL_ILE.SetFilter("Lot Grower No.", "No.");

        if ("Customer No. Filter" <> '') then begin
            rL_ILE.SetFilter("Source No.", "Customer No. Filter");
        end;

        if rL_ILE.FindSet() then begin
            rL_ILE.CalcSums("Total Net Weight");
        end;
        vL_TotalQty := rL_ILE."Total Net Weight";
        exit(vL_TotalQty);

    end;






    local procedure MyProcedure()
    var
        myInt: Integer;
    begin

    end;



    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
}


tableextension 50104 VendorExt extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50000; Customer; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50001; "Print Statements"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Last Statement No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Salesperson Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "No. of Released Prod. Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Production Order" WHERE("Vendor No." = FIELD("No."), Status = FILTER(Released)));
            Editable = false;

        }
        field(50005; "No. of Finished Prod. Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Production Order" WHERE("Vendor No." = FIELD("No."), Status = FILTER(Finished)));
            Editable = false;

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
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category1));
        }
        field(50011; "Category 2"; Code[20])
        {
            CaptionML = ELL = 'GLOBALG.A.P. Option',
                        ENU = 'GLOBALG.A.P. Option';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category2));
        }
        field(50012; "Category 3"; Code[20])
        {
            CaptionML = ELL = 'Status GRASP',
                        ENU = 'Status GRASP ';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category3));
        }
        field(50013; "Category 4"; Code[20])
        {
            CaptionML = ELL = 'Status LIDL supply chain',
                        ENU = 'Status LIDL supply chain';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category4));
        }
        field(50014; "Category 5"; Code[20])
        {
            CaptionML = ELL = 'Grower',
                        ENU = 'Grower';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category5));
        }
        field(50015; "Category 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category6));
        }
        field(50020; "GGN Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "GGN Expiry Date" >= TODAY THEN BEGIN
                    VALIDATE("Grower Certified", TRUE);
                END ELSE BEGIN
                    VALIDATE("Grower Certified", FALSE);
                END;
            end;
        }
        field(50022; Comments; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Grower Certified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {

    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.1
    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.1
    end;

    var
        myInt: Integer;
}
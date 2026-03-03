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
            CalcFormula = count("Production Order" where("Vendor No." = field("No."), Status = filter(Released)));
            Editable = false;

        }
        field(50005; "No. of Finished Prod. Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Production Order" where("Vendor No." = field("No."), Status = filter(Finished)));
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
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category1));
        }
        field(50011; "Category 2"; Code[20])
        {
            CaptionML = ELL = 'GLOBALG.A.P. Option',
                        ENU = 'GLOBALG.A.P. Option';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category2));
        }
        field(50012; "Category 3"; Code[20])
        {
            CaptionML = ELL = 'Status GRASP',
                        ENU = 'Status GRASP ';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category3));
        }
        field(50013; "Category 4"; Code[20])
        {
            CaptionML = ELL = 'Status LIDL supply chain',
                        ENU = 'Status LIDL supply chain';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category4));
        }
        field(50014; "Category 5"; Code[20])
        {
            CaptionML = ELL = 'Grower',
                        ENU = 'Grower';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category5));
        }
        field(50015; "Category 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category6));
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
        if "No." = '' then begin
            Error('Blank No is not allowed');
        end;
        //-TAL0.1
    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        if "No." = '' then begin
            Error('Blank No is not allowed');
        end;
        //-TAL0.1
    end;

    var
        myInt: Integer;
}
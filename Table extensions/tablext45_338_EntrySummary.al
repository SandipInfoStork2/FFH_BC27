tableextension 50145 EntrySummaryExt extends "Entry Summary"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Grower No."; Code[20])
        {
            CalcFormula = Lookup("Lot No. Information"."Grower No." WHERE("Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
            TableRelation = Vendor WHERE("Vendor Posting Group" = FILTER('GROWER'));
        }
        field(50003; "Grower Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Grower GGN"; Code[14])
        {
            CalcFormula = Lookup(Vendor.GGN WHERE("No." = FIELD("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = Lookup(Vendor."Category 1" WHERE("No." = FIELD("Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category1));
        }
    }

    var
        myInt: Integer;
}
tableextension 50145 EntrySummaryExt extends "Entry Summary"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Grower No."; Code[20])
        {
            CalcFormula = lookup("Lot No. Information"."Grower No." where("Lot No." = field("Lot No.")));
            FieldClass = FlowField;
            TableRelation = Vendor where("Vendor Posting Group" = filter('GROWER'));
        }
        field(50003; "Grower Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Grower GGN"; Code[14])
        {
            CalcFormula = lookup(Vendor.GGN where("No." = field("Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = lookup(Vendor."Category 1" where("No." = field("Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category1));
        }
    }

    var
        myInt: Integer;
}
/*
TAL0.1 2021/04/02 VC add field Producer Group Name

*/
tableextension 50144 ReservationEntryExt extends "Reservation Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50007; "Lot Grower No."; Code[20])
        {
            CalcFormula = Lookup("Lot No. Information"."Grower No." WHERE("Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Grower;
        }
        field(50008; "Grower Name"; Text[50])
        {
            CalcFormula = Lookup(Grower.Name WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = Lookup(Grower.GGN WHERE("No." = FIELD("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = Lookup(Grower."Category 1" WHERE("No." = FIELD("Lot Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(23), Type = CONST(Category1));
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = Lookup("General Categories".Description WHERE("Table No." = FILTER(23), Type = FILTER(Category1), Code = FIELD("Producer Group")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
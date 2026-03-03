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
            CalcFormula = lookup("Lot No. Information"."Grower No." where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Grower;
        }
        field(50008; "Grower Name"; Text[50])
        {
            CalcFormula = lookup(Grower.Name where("No." = field("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Grower GGN"; Code[14])
        {
            CalcFormula = lookup(Grower.GGN where("No." = field("Lot Grower No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Producer Group"; Code[20])
        {
            CalcFormula = lookup(Grower."Category 1" where("No." = field("Lot Grower No.")));
            Caption = 'Producer Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "General Categories".Code where("Table No." = const(23), Type = const(Category1));
        }
        field(50027; "Producer Group Name"; Text[100])
        {
            CalcFormula = lookup("General Categories".Description where("Table No." = filter(23), Type = filter(Category1), Code = field("Producer Group")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
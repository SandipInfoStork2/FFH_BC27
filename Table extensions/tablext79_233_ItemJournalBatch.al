tableextension 50179 ItemJournalBatchExt extends "Item Journal Batch"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Def. Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Default Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50001; "Def. Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Default Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50002; "Profit Center"; Code[20])
        {
            Caption = 'Profit Center';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }
    }

    var
        myInt: Integer;
}
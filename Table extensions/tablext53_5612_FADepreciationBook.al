tableextension 50153 FADepreciationBookExt extends "FA Depreciation Book"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "No. FA Acquisitions"; Integer)
        {
            CalcFormula = Count("FA Ledger Entry" WHERE("FA No." = FIELD("FA No."), "FA Posting Type" = FILTER("Acquisition Cost"), Reversed = FILTER(false), "FA Posting Category" = FILTER(' '), "Document Type" = FILTER(Invoice)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "No. FA Depreciations"; Integer)
        {
            CalcFormula = Count("FA Ledger Entry" WHERE("FA No." = FIELD("FA No."), "FA Posting Type" = FILTER(Depreciation), Reversed = FILTER(false), "FA Posting Date" = FIELD("Depreciation Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "No. FA Disposals"; Integer)
        {
            CalcFormula = Count("FA Ledger Entry" WHERE("FA No." = FIELD("FA No."), "FA Posting Type" = FILTER("Proceeds on Disposal"), Reversed = FILTER(false), "FA Posting Date" = FIELD("Disposal Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Depreciation Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50004; "Disposal Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
    }

    var
        myInt: Integer;
}
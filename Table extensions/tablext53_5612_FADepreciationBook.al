tableextension 50153 FADepreciationBookExt extends "FA Depreciation Book"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "No. FA Acquisitions"; Integer)
        {
            CalcFormula = count("FA Ledger Entry" where("FA No." = field("FA No."), "FA Posting Type" = filter("Acquisition Cost"), Reversed = filter(false), "FA Posting Category" = filter(' '), "Document Type" = filter(Invoice)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "No. FA Depreciations"; Integer)
        {
            CalcFormula = count("FA Ledger Entry" where("FA No." = field("FA No."), "FA Posting Type" = filter(Depreciation), Reversed = filter(false), "FA Posting Date" = field("Depreciation Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "No. FA Disposals"; Integer)
        {
            CalcFormula = count("FA Ledger Entry" where("FA No." = field("FA No."), "FA Posting Type" = filter("Proceeds on Disposal"), Reversed = filter(false), "FA Posting Date" = field("Disposal Date Filter")));
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
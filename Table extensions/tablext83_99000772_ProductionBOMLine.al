tableextension 50183 ProductionBOMLineExt extends "Production BOM Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("No.")));

        }

        field(50001; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("No.")));
        }

        field(50002; "Last Direct Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Last Direct Cost';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Last Direct Cost" where("No." = field("No.")));
        }
    }

    procedure DrillDownLandedCost()
    var
        rL_LastILE: Record "Item Ledger Entry";
    begin
        rL_LastILE.Reset;
        rL_LastILE.SetRange("Entry Type", rL_LastILE."Entry Type"::Purchase);
        rL_LastILE.SetRange("Document Type", rL_LastILE."Document Type"::"Purchase Receipt");
        rL_LastILE.SetFilter("Item No.", "No.");
        if rL_LastILE.FindLast() then begin

        end;
        Page.Run(Page::"Item Ledger Entries", rL_LastILE);
    end;

    var
        myInt: Integer;
}
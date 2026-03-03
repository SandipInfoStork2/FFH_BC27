tableextension 50160 InventoryPostingSetup extends "Inventory Posting Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Location Name"; Text[100])
        {
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
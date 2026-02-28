pageextension 50172 ProductionJournalExt extends "Production Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Variant Code")
        {
            Visible = true;
        }
        moveafter("Entry Type"; "Operation No.")

        moveafter("Operation No."; "Variant Code")

        moveafter("Variant Code"; Type)

        moveafter(Type; "No.")

        moveafter("No."; "Posting Date")

        modify("Location Code")
        {
            Visible = true;
        }
        moveafter(Description; "Location Code")

        moveafter("Location Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; ShortcutDimCode5)
        modify("Unit of Measure Code")
        {
            Visible = true;
        }

        moveafter(ShortcutDimCode5; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Output Quantity")
        //moveafter("Output Quantity";)

        //+1.0.0.229
        addafter(ShortcutDimCode8)
        {
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        //-1.0.0.229






    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
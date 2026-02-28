pageextension 50251 ItemJournalBatchesExt extends "Item Journal Batches"
{
    layout
    {
        // Add changes to page layout here
        addafter("Reason Code")
        {
            field("Def. Gen. Bus. Posting Group"; "Def. Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }

            //inherited from item card
            field("Def. Gen. Prod. Posting Group"; "Def. Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Profit Center"; "Profit Center")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
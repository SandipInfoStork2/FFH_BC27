pageextension 50251 ItemJournalBatchesExt extends "Item Journal Batches"
{
    layout
    {
        // Add changes to page layout here
        addafter("Reason Code")
        {
            field("Def. Gen. Bus. Posting Group"; Rec."Def. Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Default Gen. Bus. Posting Group field.';
            }

            //inherited from item card
            field("Def. Gen. Prod. Posting Group"; Rec."Def. Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Default Gen. Prod. Posting Group field.';
            }
            field("Profit Center"; Rec."Profit Center")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Profit Center field.';
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
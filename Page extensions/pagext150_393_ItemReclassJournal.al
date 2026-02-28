pageextension 50250 ItemReclassJournalExt extends "Item Reclass. Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Reason Code")
        {
            Visible = true;
            ShowMandatory = true;
        }

        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }


    }

    actions
    {
        // Add changes to page actions here
        addafter("Get Bin Content")
        {
            action("Get Expiring Items")
            {
                ApplicationArea = all;

                trigger OnAction();
                var
                    ItemJnlLine: Record "Item Journal Line";
                    ExpiringItems: Report "Expiring Items";
                begin

                    ItemJnlLine.COPY(Rec);
                    CLEAR(ExpiringItems);
                    ExpiringItems.SetItemJnl(ItemJnlLine);
                    ExpiringItems.RUNMODAL;
                    CurrPage.UPDATE(false);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
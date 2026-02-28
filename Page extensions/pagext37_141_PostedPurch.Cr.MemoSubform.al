/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50137 PostedPurchCrMemoSubformExt extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Description 2")
        {
            Visible = true;
        }

        modify("Net Weight")
        {
            Visible = true;
        }

        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
            }
        }
        */
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = all;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;

                trigger OnAction();
                begin
                    ShowItemTrackingLines;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
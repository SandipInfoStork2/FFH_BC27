/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50122 PurchCrMemoSubformExt extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
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
            action("Item &Tracking Lines2")
            {
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Executes the Item &Tracking Lines action.';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.OpenItemTrackingLines;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
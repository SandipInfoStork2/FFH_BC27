/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50133 PostedPurchaseRcptSubformExt extends "Posted Purchase Rcpt. Subform"
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

        //TAL 1.0.0.201 >>
        addafter("Location Code")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
        }
        //TAL 1.0.0.201 <<

        addafter("ShortcutDimCode[8]")
        {
            field("Receiving Temperature"; Rec."Receiving Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
            }
            field("Receiving Quality Control"; Rec."Receiving Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving Quality Control field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;
                ToolTip = 'Executes the Item &Tracking Entries action.';

                trigger OnAction();
                begin
                    Rec.ShowItemTrackingLines;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
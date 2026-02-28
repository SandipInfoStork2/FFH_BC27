/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50195 PostedReturnShipmentSubformExt extends "Posted Return Shipment Subform"
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
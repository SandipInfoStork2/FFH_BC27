/*
TAL0.1 2021/04/02 VC add field Producer Group Name

*/
pageextension 50188 PostedItemTrackingLinesExt extends "Posted Item Tracking Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Serial No.")
        {
            Visible = false;
        }

        addafter(Quantity)
        {
            field("Producer Group"; "Producer Group")
            {
                ApplicationArea = All;
            }
            field("Producer Group Name"; "Producer Group Name")
            {
                ApplicationArea = All;
            }
            field("Lot Grower No."; "Lot Grower No.")
            {
                ApplicationArea = All;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = All;
            }
            field("Grower GGN"; "Grower GGN")
            {
                ApplicationArea = All;
            }
            field("Lot Vendor No."; "Lot Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor GLN"; "Vendor GLN")
            {
                ApplicationArea = All;
            }
            field("Vendor GGN"; "Vendor GGN")
            {
                ApplicationArea = All;
            }

            field("Lot Receiving Temperature"; "Lot Receiving Temperature")
            {
                ApplicationArea = All;
            }
        }

        moveafter("Lot No.";"Expiration Date")
    }

    actions
    {
        // Add changes to page actions here
        addlast(Navigation)
        {
            action("Item Tracing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                //RunObject = Page "Item Tracing";
                ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';

                //SetItemFilters
                trigger OnAction()
                var
                    myInt: Integer;
                    pItemTracing: Page "Item Tracing";

                begin
                    Clear(pItemTracing);
                    pItemTracing.SetLotFilter("Lot No.");
                    pItemTracing.Run();

                end;
            }
        }


    }

    var
        myInt: Integer;
}
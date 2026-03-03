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
            field("Producer Group"; Rec."Producer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group field.';
            }
            field("Producer Group Name"; Rec."Producer Group Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group Name field.';
            }
            field("Lot Grower No."; Rec."Lot Grower No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower GGN field.';
            }
            field("Lot Vendor No."; Rec."Lot Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Vendor GLN"; Rec."Vendor GLN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GLN field.';
            }
            field("Vendor GGN"; Rec."Vendor GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GGN field.';
            }

            field("Lot Receiving Temperature"; Rec."Lot Receiving Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Receiving Temperature field.';
            }
        }

        moveafter("Lot No."; "Expiration Date")
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
                    pItemTracing.SetLotFilter(Rec."Lot No.");
                    pItemTracing.Run();

                end;
            }
        }


    }

    var
        myInt: Integer;
}
/*
TAL0.1 2021/04/02 VC add field Producer Group Name

*/
pageextension 50187 ItemTrackingLinesExt extends "Item Tracking Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Serial No.")
        {
            Visible = false;
        }
        modify("Expiration Date")
        {
            Visible = true;
        }

        addafter("Lot No.")
        {
            field("No. of Component Growers"; "No. of Component Growers")
            {
                ApplicationArea = All;
            }
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
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter(FunctionsSupply)
        {

            action("Item Card")
            {
                ApplicationArea = All;
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");

                trigger OnAction()
                begin

                end;
            }


            action(CalculateFridgeExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Fridge Expiration Date';
                Image = CalculateCalendar;

                trigger OnAction()
                var
                    rl_Item: Record Item;
                begin
                    rl_Item.GET("Item No.");
                    rl_Item.TestField("Fridge Storage Life");
                    "New Expiration Date" := CalcDate('+' + FORMAT(rl_Item."Fridge Storage Life"), WorkDate())
                end;
            }

            action(CalculateFreezerExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Freezer Expiration Date';
                Image = CalculateCalendar;

                trigger OnAction()
                var
                    rl_Item: Record Item;
                begin
                    rl_Item.GET("Item No.");
                    rl_Item.TestField("Freezer Storage Life");
                    "New Expiration Date" := CalcDate('+' + FORMAT(rl_Item."Freezer Storage Life"), WorkDate())
                end;
            }
        }

    }

    var
        myInt: Integer;
}
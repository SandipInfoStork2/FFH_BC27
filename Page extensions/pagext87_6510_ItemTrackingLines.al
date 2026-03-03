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
            field("No. of Component Growers"; Rec."No. of Component Growers")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Component Growers field.';
            }
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
                ToolTip = 'Executes the Item Card action.';

                trigger OnAction()
                begin

                end;
            }


            action(CalculateFridgeExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Fridge Expiration Date';
                Image = CalculateCalendar;
                ToolTip = 'Executes the Calculate Fridge Expiration Date action.';

                trigger OnAction()
                var
                    rl_Item: Record Item;
                begin
                    rl_Item.GET(Rec."Item No.");
                    rl_Item.TestField("Fridge Storage Life");
                    Rec."New Expiration Date" := CalcDate('+' + Format(rl_Item."Fridge Storage Life"), WorkDate())
                end;
            }

            action(CalculateFreezerExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Freezer Expiration Date';
                Image = CalculateCalendar;
                ToolTip = 'Executes the Calculate Freezer Expiration Date action.';

                trigger OnAction()
                var
                    rl_Item: Record Item;
                begin
                    rl_Item.GET(Rec."Item No.");
                    rl_Item.TestField("Freezer Storage Life");
                    Rec."New Expiration Date" := CalcDate('+' + Format(rl_Item."Freezer Storage Life"), WorkDate())
                end;
            }
        }

    }

    var
        myInt: Integer;
}
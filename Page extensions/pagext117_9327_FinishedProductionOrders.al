/*
TAL0.1 2018/03/15 VC delete No
TAL0.2 2018/07/25 VC add No. Carton Lines
TAL0.3 2022/01/10 VC add Field  
          Created By
          Client Computer Name
          Creation Date
*/
pageextension 50217 FinishedProductionOrdersExt extends "Finished Production Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bin Code")
        {
            field("No. Carton Lines"; Rec."No. Carton Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. Carton Lines field.';
            }
            field("Νο. Prod. Order Line"; Rec."Νο. Prod. Order Line")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Νο. Prod. Order Line field.';
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which you created the production order.';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.';
            }
            field("Client Computer Name"; Rec."Client Computer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Client Computer Name field.';
            }

            //+1.0.0.229
            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Agent field.';
            }
            //-1.0.0.229
        }

        modify("Location Code")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}
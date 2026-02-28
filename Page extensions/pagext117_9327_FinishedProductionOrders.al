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
            field("No. Carton Lines"; "No. Carton Lines")
            {
                ApplicationArea = All;
            }
            field("Νο. Prod. Order Line"; "Νο. Prod. Order Line")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; "Creation Date")
            {
                ApplicationArea = All;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = All;
            }
            field("Client Computer Name"; "Client Computer Name")
            {
                ApplicationArea = All;
            }

            //+1.0.0.229
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
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
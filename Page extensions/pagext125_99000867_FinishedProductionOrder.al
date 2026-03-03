/*
TAL0.1 2018/03/15 VC delete No
TAL0.2 2022/01/10 VC add Field  
          Created By
          Client Computer Name
          Creation Date

*/
pageextension 50225 FinishedProductionOrderExt extends "Finished Production Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
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

            //1.0.0.229
        }
    }

    actions
    {
        // Add changes to page actions here
        /*
        addafter("Co&mments_Promoted")
        {
           
            actionref("Pg_Promoted"; "Production Order - Comp. and Routing")
            {

            }
        }
        */




        //+1.0.0.240
        addafter("Co&mments")
        {
            action("Production Order - Comp. and Routing")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Production Order - Comp. and Routing';
                Image = "Report";
                //RunObject = Report "Prod. Order Comp. and Routing";
                ToolTip = 'View information about components and operations in production orders. For released production orders, the report shows the remaining quantity if parts of the quantity have been posted as output.';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    myInt: Integer;
                    ProductionOrder: Record "Production Order";

                begin
                    ProductionOrder := Rec;
                    CurrPage.SetSelectionFilter(ProductionOrder);
                    Report.Run(Report::"Prod. Order Comp. and Routing", true, false, ProductionOrder);
                end;
            }
        }
        //-1.0.0.240
    }

    var
        myInt: Integer;
}
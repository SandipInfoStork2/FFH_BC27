pageextension 50206 SOProcessorActivitiesExt extends "SO Processor Activities"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Exchange Service")
        {
            cuegroup(PO)
            {
                Caption = 'Purchase Orders';
                field("Not Invoiced"; "Not Invoiced")
                {
                    ApplicationArea = all;
                    DrillDownPageID = "Purchase Order List";
                }
                //+1.0.0.286
                field("Not Invoiced ARAD-3"; "Not Invoiced ARAD-3")
                {
                    ApplicationArea = all;
                    DrillDownPageID = "Purchase Order List";
                }
                field("Not Invoiced ARAD-4"; "Not Invoiced ARAD-4")
                {
                    ApplicationArea = all;
                    DrillDownPageID = "Purchase Order List";
                }
                //-1.0.0.286

                field("Purchase Orders"; "Purchase Orders")
                {
                    ApplicationArea = all;
                    DrillDownPageID = "Purchase Order List";
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}
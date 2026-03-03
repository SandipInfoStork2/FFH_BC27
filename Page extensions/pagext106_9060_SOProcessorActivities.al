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
                field("Not Invoiced"; Rec."Not Invoiced")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Not Invoiced field.';
                }
                //+1.0.0.286
                field("Not Invoiced ARAD-3"; Rec."Not Invoiced ARAD-3")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Not Invoiced ARAD-3 field.';
                }
                field("Not Invoiced ARAD-4"; Rec."Not Invoiced ARAD-4")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Not Invoiced ARAD-4 field.';
                }
                //-1.0.0.286

                field("Purchase Orders"; Rec."Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Purchase Orders field.';
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
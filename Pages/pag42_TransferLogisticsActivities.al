page 50042 "Transfer Logistics Activities"
{
    Caption = 'Transfer Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Basic Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {

            //Aradipou - Main
            //Fresh Cut
            //Kitchen
            //Potatoes


            cuegroup("Aradipou - Main")
            {
                field("From Aradipou - Main Orders"; Rec."From Aradipou - Main Orders")
                {
                    Caption = 'Ship';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Ship field.';
                }
                field("To Aradipou - Main Orders"; Rec."To Aradipou - Main Orders")
                {
                    Caption = 'Receive';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Receive field.';
                }
            }
            cuegroup("Fresh Cut")
            {
                field("From Fresh Cut Orders"; Rec."From Fresh Cut Orders")
                {
                    Caption = 'Ship';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Ship field.';
                }
                field("To Fresh Cut Orders"; Rec."To Fresh Cut Orders")
                {
                    Caption = 'Receive';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Receive field.';
                }
            }
            cuegroup(Kitchen)
            {
                field("From Kitchen Orders"; Rec."From Kitchen Orders")
                {
                    Caption = 'Ship';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Ship field.';
                }
                field("To Kitchen Orders"; Rec."To Kitchen Orders")
                {
                    Caption = 'Receive';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Receive field.';
                }
            }
            cuegroup(Potatoes)
            {
                field("From Potatoes Orders"; Rec."From Potatoes Orders")
                {
                    Caption = 'Ship';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Ship field.';
                }
                field("To Potatoes Orders"; Rec."To Potatoes Orders")
                {
                    Caption = 'Receive';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Receive field.';
                }
            }

            cuegroup("Pre Follow-up")
            {
                Caption = 'Pre Ship/Receipt Follow-up on Transfer Orders';
                Visible = false;

                field("Open Transfer Orders"; Rec."Open Transfer Orders")
                {
                    Caption = 'Transfer Order Open';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Transfer Order Open field.';
                }
                field("Upcoming Ship. Transfer Orders"; Rec."Upcoming Ship. Transfer Orders")
                {
                    Caption = 'Upcoming Shipments';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Upcoming Shipments field.';
                }
                field("Upcoming Rec. Transfer Orders"; Rec."Upcoming Rec. Transfer Orders")
                {
                    Caption = 'Upcoming Receipts';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Upcoming Receipts field.';
                }
            }
            cuegroup("Post Follow-up")
            {
                Caption = 'Post Ship/Receipt Follow-up on Transfer Orders';
                Visible = false;
                field("Outstanding Ship. T.O."; Rec."Outstanding Ship. T.O.")
                {
                    Caption = 'Outstanding Shipments';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Outstanding Shipments field.';
                }
                field("Outstanding Receipt. T.O."; Rec."Outstanding Receipt. T.O.")
                {
                    Caption = 'Outstanding Receipts';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Outstanding Receipts field.';
                }


                actions
                {
                    action("New Transfer Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Transfer Order';
                        RunObject = page "Transfer Order";
                        RunPageMode = Create;
                        ToolTip = 'Move items from one warehouse location to another.';
                    }
                }
            }




            cuegroup("Count")
            {
                field("Count Transfer Orders"; Rec."Count Transfer Orders")
                {
                    Caption = 'Transfer Orders';
                    ApplicationArea = All;
                    DrillDownPageId = "Transfer Orders";
                    ToolTip = 'Specifies the value of the Transfer Orders field.';
                }
            }

        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRange("Date Filter", 0D, WorkDate);
        Rec.SetRange("Date Filter2", WorkDate, WorkDate);
        Rec.SetFilter("Date Filter3", '>=%1', WorkDate);
        Rec.SetRange("User ID Filter", UserId);

        LocationCode := WhseWMSCue.GetEmployeeLocation(UserId);
        Rec.SetFilter("Location Filter", LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        UserTaskManagement: Codeunit "User Task Management";
        LocationCode: Text[1024];
}

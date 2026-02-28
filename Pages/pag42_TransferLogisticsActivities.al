page 50042 "Transfer Logistics Activities"
{
    Caption = 'Transfer Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Basic Cue";

    layout
    {
        area(content)
        {

            //Aradipou - Main
            //Fresh Cut
            //Kitchen
            //Potatoes


            cuegroup("Aradipou - Main")
            {
                field("From Aradipou - Main Orders"; "From Aradipou - Main Orders")
                {
                    caption = 'Ship';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("To Aradipou - Main Orders"; "To Aradipou - Main Orders")
                {
                    caption = 'Receive';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }
            cuegroup("Fresh Cut")
            {
                field("From Fresh Cut Orders"; "From Fresh Cut Orders")
                {
                    caption = 'Ship';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("To Fresh Cut Orders"; "To Fresh Cut Orders")
                {
                    caption = 'Receive';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }
            cuegroup("Kitchen")
            {
                field("From Kitchen Orders"; "From Kitchen Orders")
                {
                    caption = 'Ship';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("To Kitchen Orders"; "To Kitchen Orders")
                {
                    caption = 'Receive';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }
            cuegroup("Potatoes")
            {
                field("From Potatoes Orders"; "From Potatoes Orders")
                {
                    caption = 'Ship';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("To Potatoes Orders"; "To Potatoes Orders")
                {
                    caption = 'Receive';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }

            cuegroup("Pre Follow-up")
            {
                Caption = 'Pre Ship/Receipt Follow-up on Transfer Orders';
                Visible = false;

                field("Open Transfer Orders"; "Open Transfer Orders")
                {
                    Caption = 'Transfer Order Open';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("Upcoming Ship. Transfer Orders"; "Upcoming Ship. Transfer Orders")
                {
                    Caption = 'Upcoming Shipments';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("Upcoming Rec. Transfer Orders"; "Upcoming Rec. Transfer Orders")
                {
                    Caption = 'Upcoming Receipts';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }
            cuegroup("Post Follow-up")
            {
                Caption = 'Post Ship/Receipt Follow-up on Transfer Orders';
                Visible = false;
                field("Outstanding Ship. T.O."; "Outstanding Ship. T.O.")
                {
                    Caption = 'Outstanding Shipments';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
                field("Outstanding Receipt. T.O."; "Outstanding Receipt. T.O.")
                {
                    Caption = 'Outstanding Receipts';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }


                actions
                {
                    action("New Transfer Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Transfer Order';
                        RunObject = Page "Transfer Order";
                        RunPageMode = Create;
                        ToolTip = 'Move items from one warehouse location to another.';
                    }
                }
            }




            cuegroup("Count")
            {
                field("Count Transfer Orders"; "Count Transfer Orders")
                {
                    Caption = 'Transfer Orders';
                    ApplicationArea = all;
                    DrillDownPageId = "Transfer Orders";
                }
            }

        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetRange("Date Filter", 0D, WorkDate);
        SetRange("Date Filter2", WorkDate, WorkDate);
        SetFilter("Date Filter3", '>=%1', WorkDate);
        SetRange("User ID Filter", UserId);

        LocationCode := WhseWMSCue.GetEmployeeLocation(UserId);
        SetFilter("Location Filter", LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        UserTaskManagement: Codeunit "User Task Management";
        LocationCode: Text[1024];
}

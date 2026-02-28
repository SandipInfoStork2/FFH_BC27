page 50039 "SO Logistics Activities"
{
    Caption = 'Sales Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Cue";

    layout
    {
        area(content)
        {
            cuegroup("Location")
            {
                Caption = 'Ship Today';
                field("Aradipou - Main Orders"; "Aradipou - Main Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                }

                field("Fresh Cut Orders"; "Fresh Cut Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                }
                field("Kitchen Orders"; "Kitchen Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                }

                field("Potatoes Orders"; "Potatoes Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                }

            }
            cuegroup("For Release")
            {
                Caption = 'Pre Shipment Follow-up on Sales Orders';

                field("Sales Orders - Open"; "Sales Orders - Open")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are not fully posted.';
                }

                field("Upcoming Orders"; "Upcoming Orders")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of upcoming orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {

                    action("New Sales Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Order';
                        RunObject = Page "Sales Order";
                        RunPageMode = Create;
                        ToolTip = 'Create a new sales order for items or services that require partial posting.';
                    }
                }
            }

            cuegroup("Post Shipment Follow-up")
            {
                Caption = 'Post Shipment Follow-up';
                field(OutstandingOrders; "Outstanding Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Outstanding Sales Orders';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of outstanding sales orders that are displayed in the sales Cue on the Role Center.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Outstanding Sales Orders"));
                    end;
                }
            }
            /*
            cuegroup("Sales Orders Released Not Shipped")
            {
                Caption = 'Sales Orders Released Not Shipped';
                field(ReadyToShip; "Ready to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ready To Ship';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents that are ready to ship.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Ready to Ship"));
                    end;
                }
                field(PartiallyShipped; "Partially Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Partially Shipped';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents that are partially shipped.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Partially Shipped"));
                    end;
                }
                field(DelayedOrders; Delayed)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delayed';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents where your delivery is delayed.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo(Delayed));
                    end;
                }
                field("Average Days Delayed"; "Average Days Delayed")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 1;
                    Image = Calendar;
                    ToolTip = 'Specifies the number of days that your order deliveries are delayed on average.';
                }

                actions
                {
                    action(Navigate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Find entries...';
                        RunObject = Page Navigate;
                        ShortCutKey = 'Shift+Ctrl+I';
                        ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                    }
                }
            }
            */

            cuegroup("Sales Orders - Authorize for Payment")
            {
                Caption = 'Sales Orders - Authorize for Payment';
                field(NotInvoiced; "Sales Orders Not Invoiced")
                {
                    ApplicationArea = Suite;
                    Caption = 'Shipped, Not Invoiced';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies Shipped orders that are not invoiced. The orders are displayed in the Sales Cue on the Logistics role center.';

                    //trigger OnDrillDown()
                    //begin
                    //    ShowOrders(FieldNo("Sales Orders Not Invoiced"));
                    //end;
                }
                field(PartiallyInvoiced; "S.O. Partially Invoiced")
                {
                    ApplicationArea = Suite;
                    Caption = 'Partially Invoiced';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of partially invoiced orders that are displayed in the Sales Cue on the Role Center.';

                    //trigger OnDrillDown()
                    //begin
                    //ShowOrders(FieldNo("S.O. Partially Invoiced"));
                    //end;
                }
            }

            cuegroup("Count")
            {
                field("Count Sales Orders"; "Count Sales Orders")
                {
                    Caption = 'Sales Orders';
                    ApplicationArea = all;
                    DrillDownPageId = "Sales Order List";
                }
            }

            cuegroup(Invoices)
            {
                Caption = 'Invoices';
                field("Sales Invoices"; "Sales Invoices")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Sales Invoice List";
                }

            }
            cuegroup(Returns)
            {
                Caption = 'Returns';
                field("Sales Return Orders - Open"; "Sales Return Orders - Open")
                {
                    ApplicationArea = SalesReturnOrder;
                    DrillDownPageID = "Sales Return Order List";
                    ToolTip = 'Specifies the number of sales return orders documents that are displayed in the Sales Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Sales Credit Memos - Open"; "Sales Credit Memos - Open")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Credit Memos";
                    ToolTip = 'Specifies the number of sales credit memos that are not yet posted.';
                }

                actions
                {
                    action("New Sales Return Order")
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'New Sales Return Order';
                        RunObject = Page "Sales Return Order";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund that requires inventory handling by creating a new sales return order.';
                    }
                    action("New Sales Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page "Sales Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund by creating a new sales credit memo.';
                    }
                }
            }



            usercontrol(SATAsyncLoader; SatisfactionSurveyAsync)
            {
                ApplicationArea = Basic, Suite;
                trigger ResponseReceived(Status: Integer; Response: Text)
                var
                    SatisfactionSurveyMgt: Codeunit "Satisfaction Survey Mgt.";
                begin
                    SatisfactionSurveyMgt.TryShowSurvey(Status, Response);
                end;

                trigger ControlAddInReady();
                begin
                    IsAddInReady := true;
                    CheckIfSurveyEnabled();
                end;
            }


        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial;
    end;

    trigger OnAfterGetRecord()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
    begin
        CalculateCueFieldValues;
        ShowDocumentsPendingDodExchService := false;
        if DocExchServiceSetup.Get then
            ShowDocumentsPendingDodExchService := DocExchServiceSetup.Enabled;
    end;

    trigger OnOpenPage()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetRespCenterFilter;
        SetRange("Date Filter", 0D, WorkDate - 1);
        SetFilter("Date Filter2", '>=%1', WorkDate);
        SetFilter("Date Filter3", '=%1', WorkDate);
        SetRange("User ID Filter", UserId);

        RoleCenterNotificationMgt.ShowNotifications;
        ConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent;

        if PageNotifier.IsAvailable then begin
            PageNotifier := PageNotifier.Create;
            PageNotifier.NotifyPageReady;
        end;
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
        UserTaskManagement: Codeunit "User Task Management";
        [RunOnClient]
        [WithEvents]
        PageNotifier: DotNet PageNotifier;
        ShowDocumentsPendingDodExchService: Boolean;
        IsAddInReady: Boolean;
        IsPageReady: Boolean;

    local procedure CalculateCueFieldValues()
    begin
        if FieldActive("Average Days Delayed") then
            "Average Days Delayed" := CalculateAverageDaysDelayed;

        if FieldActive("Ready to Ship") then
            "Ready to Ship" := CountOrders(FieldNo("Ready to Ship"));

        if FieldActive("Partially Shipped") then
            "Partially Shipped" := CountOrders(FieldNo("Partially Shipped"));

        if FieldActive(Delayed) then
            Delayed := CountOrders(FieldNo(Delayed));
    end;

    trigger PageNotifier::PageReady()
    begin
        IsPageReady := true;
        CheckIfSurveyEnabled();
    end;

    local procedure CheckIfSurveyEnabled()
    var
        SatisfactionSurveyMgt: Codeunit "Satisfaction Survey Mgt.";
        CheckUrl: Text;
    begin
        if not IsAddInReady then
            exit;
        if not IsPageReady then
            exit;
        if not SatisfactionSurveyMgt.DeactivateSurvey() then
            exit;
        if not SatisfactionSurveyMgt.TryGetCheckUrl(CheckUrl) then
            exit;
        CurrPage.SATAsyncLoader.SendRequest(CheckUrl, SatisfactionSurveyMgt.GetRequestTimeoutAsync());
    end;


}


page 50040 "Purchase Logistics Activities"
{
    Caption = 'Purchase Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Purchase Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {

            cuegroup(Location)
            {
                Caption = 'Receive Today';
                field("Aradipou - Main Orders"; Rec."Aradipou - Main Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Aradipou - Main Purch. Orders field.';
                }

                field("Fresh Cut Orders"; Rec."Fresh Cut Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Fresh Cut Purch. Orders field.';
                }
                field("Kitchen Orders"; Rec."Kitchen Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Kitchen Purch. Orders field.';
                }

                field("Potatoes Orders"; Rec."Potatoes Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Potatoes Purch. Orders field.';
                }

            }
            cuegroup("Pre-arrival Follow-up on Purchase Orders")
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';
                field("To Send or Confirm"; Rec."To Send or Confirm")
                {
                    Caption = 'Purchase Order Open';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the number of documents to send or confirm that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Total Upcoming Orders"; Rec."Total Upcoming Orders")
                {
                    Caption = 'Total Upcoming Orders';
                    ApplicationArea = Suite;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the number of upcoming orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Purchase Quote")
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Purchase Quote';
                        RunObject = page "Purchase Quote";
                        RunPageMode = Create;
                        ToolTip = 'Prepare a request for quote';
                    }
                    action("New Purchase Order")
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Purchase Order';
                        RunObject = page "Purchase Order";
                        RunPageMode = Create;
                        ToolTip = 'Purchase goods or services from a vendor.';
                    }
                    action("Edit Purchase Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Edit Purchase Journal';
                        RunObject = page "Purchase Journal";
                        ToolTip = 'Post purchase invoices in a purchase journal that may already contain journal lines.';
                    }
                }
            }
            cuegroup("Post Arrival Follow-up")
            {
                Caption = 'Post Arrival Follow-up';
                field(OutstandingOrders; Rec."Outstanding Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Outstanding Purchase Orders';
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the number of outstanding purchase orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo("Outstanding Purchase Orders"));
                    end;
                }
                field("Purchase Return Orders - All"; Rec."Purchase Return Orders - All")
                {
                    ApplicationArea = PurchReturnOrder;
                    DrillDownPageId = "Purchase Return Order List";
                    ToolTip = 'Specifies the number of purchase return orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action(Navigate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Find entries...';
                        RunObject = page Navigate;
                        ShortcutKey = 'Shift+Ctrl+I';
                        ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                    }
                    action("New Purchase Return Order")
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'New Purchase Return Order';
                        RunObject = page "Purchase Return Order";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund that requires inventory handling by creating a new purchase return order.';
                    }
                }
            }



            cuegroup("Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field(NotInvoiced; Rec."Not Invoiced")
                {
                    ApplicationArea = Suite;
                    Caption = 'Received, Not Invoiced';
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies received orders that are not invoiced. The orders are displayed in the Purchase Cue on the Purchasing Agent role center, and filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo("Not Invoiced"));
                    end;
                }
                field(PartiallyInvoiced; Rec."Partially Invoiced")
                {
                    ApplicationArea = Suite;
                    Caption = 'Partially Invoiced';
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the number of partially invoiced orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo("Partially Invoiced"));
                    end;
                }
            }

            cuegroup("Purchase Documents")
            {
                Caption = 'Count';
                field("Count Orders"; Rec."Count Orders")
                {
                    Caption = 'Orders';
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the value of the Orders field.';
                }
                field("Count Return Orders"; Rec."Count Return Orders")
                {
                    Caption = 'Return Orders';
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Return Order List";
                    ToolTip = 'Specifies the value of the Return Orders field.';
                }
            }


        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRespCenterFilter;
        Rec.SetFilter("Date Filter", '>=%1', WorkDate);
        Rec.SetFilter("Date Filter2", '=%1', WorkDate);
        Rec.SetRange("User ID Filter", UserId);
    end;

    var
        UserTaskManagement: Codeunit "User Task Management";

    local procedure CalculateCueFieldValues()
    begin
        if Rec.FieldActive("Outstanding Purchase Orders") then
            Rec."Outstanding Purchase Orders" := Rec.CountOrders(Rec.FieldNo("Outstanding Purchase Orders"));

        if Rec.FieldActive("Not Invoiced") then
            Rec."Not Invoiced" := Rec.CountOrders(Rec.FieldNo("Not Invoiced"));

        if Rec.FieldActive("Partially Invoiced") then
            Rec."Partially Invoiced" := Rec.CountOrders(Rec.FieldNo("Partially Invoiced"));
    end;
}

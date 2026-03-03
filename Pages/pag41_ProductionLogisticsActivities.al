page 50041 "Prod. Logistics Activities"
{
    Caption = 'Production Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Manufacturing Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
#if not CLEAN18
            cuegroup("Intelligent Cloud")
            {
                Caption = 'Intelligent Cloud';
                Visible = false;
                ObsoleteTag = '18.0';
                ObsoleteReason = 'Intelligent Cloud Insights is discontinued.';
                ObsoleteState = Pending;

                actions
                {
                    action("Learn More")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Learn More';
                        Image = TileInfo;
                        RunPageMode = View;
                        ToolTip = ' Learn more about the Intelligent Cloud and how it can help your business.';
                        Visible = false;
                        ObsoleteTag = '18.0';
                        ObsoleteReason = 'Intelligent Cloud Insights is discontinued.';
                        ObsoleteState = Pending;

                        trigger OnAction()
                        var
                            IntelligentCloudManagement: Codeunit "Intelligent Cloud Management";
                        begin
                            //HyperLink(IntelligentCloudManagement.GetIntelligentCloudLearnMoreUrl);
                            HyperLink('https://go.microsoft.com/fwlink/?linkid=2009848&clcid=0x409');
                        end;
                    }
                    action("Intelligent Cloud Insights")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Intelligent Cloud Insights';
                        Image = TileCloud;
                        RunPageMode = View;
                        ToolTip = 'View your Intelligent Cloud insights.';
                        Visible = false;
                        ObsoleteTag = '18.0';
                        ObsoleteReason = 'Intelligent Cloud Insights is discontinued.';
                        ObsoleteState = Pending;

                        trigger OnAction()
                        var
                            IntelligentCloudManagement: Codeunit "Intelligent Cloud Management";
                        begin
                            HyperLink(GetIntelligentCloudInsightsUrl);
                        end;
                    }
                }
            }
#endif

            cuegroup(Location)
            {
                Caption = 'Released Production Orders';
                field("Aradipou - Main Orders"; Rec."Aradipou - Main Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Released Production Orders";
                    ToolTip = 'Specifies the value of the Aradipou - Main Rel. Production Orders field.';
                }

                field("Fresh Cut Orders"; Rec."Fresh Cut Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Released Production Orders";
                    ToolTip = 'Specifies the value of the Fresh Cut Rel. Production Orders field.';
                }
                field("Kitchen Orders"; Rec."Kitchen Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Released Production Orders";
                    ToolTip = 'Specifies the value of the Kitchen Rel. Production Orders field.';
                }

                field("Potatoes Orders"; Rec."Potatoes Orders")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Released Production Orders";
                    ToolTip = 'Specifies the value of the Potatoes Rel. Production Orders field.';
                }

            }
            cuegroup("Production Orders")
            {
                Caption = 'Production Orders';
                field("Simulated Prod. Orders"; Rec."Simulated Prod. Orders")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Simulated Production Orders";
                    ToolTip = 'Specifies the number of simulated production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Planned Prod. Orders - All"; Rec."Planned Prod. Orders - All")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Planned Production Orders";
                    ToolTip = 'Specifies the number of planned production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Firm Plan. Prod. Orders - All"; Rec."Firm Plan. Prod. Orders - All")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Firm Planned Prod. Orders";
                    ToolTip = 'Specifies the number of firm planned production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Released Prod. Orders - All"; Rec."Released Prod. Orders - All")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Released Production Orders";
                    ToolTip = 'Specifies the number of released production orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Change Production Order Status")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Change Production Order Status';
                        RunObject = page "Change Production Order Status";
                        ToolTip = 'Change the production order to another status, such as Released.';
                    }
                    action("New Production Order")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Production Order';
                        RunObject = page "Planned Production Order";
                        RunPageMode = Create;
                        ToolTip = 'Prepare to produce an end item. ';
                    }
                    action(Navigate)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Find entries...';
                        RunObject = page Navigate;
                        ShortcutKey = 'Shift+Ctrl+I';
                        ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                    }
                }
            }
            cuegroup("Planning - Operations")
            {
                Caption = 'Planning - Operations';
                field("Purchase Orders"; Rec."Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'My Purchase Orders';
                    DrillDown = true;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the number of purchase orders that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Purchase Order")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Purchase Order';
                        RunObject = page "Purchase Order";
                        RunPageMode = Create;
                        ToolTip = 'Purchase goods or services from a vendor.';
                    }
                    action("Edit Planning Worksheet")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Edit Planning Worksheet';
                        RunObject = page "Planning Worksheet";
                        ToolTip = 'Plan supply orders automatically to fulfill new demand.';
                    }
                    action("Edit Subcontracting Worksheet")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Edit Subcontracting Worksheet';
                        RunObject = page "Subcontracting Worksheet";
                        ToolTip = 'Plan outsourcing of operation on released production orders.';
                    }
                }
            }
            cuegroup(Design)
            {
                Caption = 'Design';
                field("Prod. BOMs under Development"; Rec."Prod. BOMs under Development")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Production BOM List";
                    ToolTip = 'Specifies the number of production BOMs that are under development that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Routings under Development"; Rec."Routings under Development")
                {
                    ApplicationArea = Manufacturing;
                    DrillDownPageId = "Routing List";
                    ToolTip = 'Specifies the routings under development that are displayed in the Manufacturing Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Item")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Item';
                        RunObject = page "Item Card";
                        RunPageMode = Create;
                        ToolTip = 'Create an item card based on the stockkeeping unit.';
                    }
                    action("New Production BOM")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Production BOM';
                        RunObject = page "Production BOM";
                        RunPageMode = Create;
                        ToolTip = 'Create a bill of material that defines the components in a produced item.';
                    }
                    action("New Routing")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Routing';
                        RunObject = page Routing;
                        RunPageMode = Create;
                        ToolTip = 'Create a routing that defines the operations required to produce an end item.';
                    }
                }
            }
            cuegroup("My User Tasks")
            {
                Caption = 'My User Tasks';
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced with User Tasks Activities part';
                ObsoleteTag = '17.0';
                field("UserTaskManagement.GetMyPendingUserTasksCount"; UserTaskManagement.GetMyPendingUserTasksCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending User Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you or to a group that you are a member of.';
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced with User Tasks Activities part';
                    ObsoleteTag = '17.0';

                    trigger OnDrillDown()
                    var
                        UserTaskList: Page "User Task List";
                    begin
                        UserTaskList.SetPageToShowMyPendingUserTasks;
                        UserTaskList.Run;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
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

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRange("User ID Filter", UserId);

        ShowIntelligentCloud := not EnvironmentInfo.IsSaaS;
    end;

    procedure GetIntelligentCloudInsightsUrl(): Text
    var
        BaseUrl: Text;
        ParameterUrl: Text;
        NoDomainUrl: Text;
    begin
        BaseUrl := GetUrl(CLIENTTYPE::Web);
        ParameterUrl := GetUrl(CLIENTTYPE::Web, CompanyName, OBJECTTYPE::Page, 4013);
        NoDomainUrl := DelChr(ParameterUrl, '<', BaseUrl);

        exit(StrSubstNo('https://businesscentral.dynamics.com/%1', NoDomainUrl));
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
        EnvironmentInfo: Codeunit "Environment Information";
        UserTaskManagement: Codeunit "User Task Management";
        ShowIntelligentCloud: Boolean;
}

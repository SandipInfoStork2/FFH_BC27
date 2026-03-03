page 50064 "Report Selection - Extra"
{
    ApplicationArea = Service;
    Caption = 'Report Selection - Extra';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                ApplicationArea = All;
                Caption = 'Usage';
                OptionCaption = 'Payment Receipt,Vendor Receipt';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sequence number for the report.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the object ID of the report.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    LookupPageId = Objects;
                    ToolTip = 'Specifies the display name of the report.';
                }
                field("Use for Email Body"; Rec."Use for Email Body")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that summarized information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the related document will be attached to the email.';
                }
                field("Email Body Layout Code"; Rec."Email Body Layout Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the email body layout that is used.';
                    Visible = true;
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the email body layout that is used.';

                    trigger OnDrillDown()
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
                            Rec.Validate("Email Body Layout Code", CustomReportLayout.Code);
                    end;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord;
    end;

    trigger OnOpenPage()
    begin
        InitUsageFilter();
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option "Payment Receipt","Vendor Receipt";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
            if Rec.Modify then;
        Rec.FilterGroup(2);
        case ReportUsage2 of

            ReportUsage2::"Payment Receipt":
                Rec.SetRange(Usage, Rec.Usage::"Payment Receipt");

            ReportUsage2::"Vendor Receipt":
                Rec.SetRange(Usage, Rec.Usage::"Vendor Receipt");
        end;
        Rec.FilterGroup(0);
        CurrPage.Update;
    end;

    local procedure InitUsageFilter()
    var
        DummyReportSelections: Record "Report Selections";
    begin
        if Rec.GetFilter(Usage) <> '' then begin
            if Evaluate(DummyReportSelections.Usage, Rec.GetFilter(Usage)) then
                case DummyReportSelections.Usage of

                    Rec.Usage::"Payment Receipt":
                        ReportUsage2 := ReportUsage2::"Payment Receipt";

                    Rec.Usage::"Vendor Receipt":
                        ReportUsage2 := ReportUsage2::"Vendor Receipt";
                end;
            Rec.SetRange(Usage);
        end;
    end;
}


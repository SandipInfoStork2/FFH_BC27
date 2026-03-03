pageextension 50236 SalesAnalysisReportExt extends "Sales Analysis Report"
{
    layout
    {
        // Add changes to page layout here
        addafter(CurrentSourceTypeNoFilter)
        {
            field("Date Filter"; Rec."Date Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date Filter field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print Landscape")
            {
                Caption = 'Print Landscape';
                Image = Print;
                ToolTip = 'Print the information in the window. A print request window opens where you can specify what to include on the print-out.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    AnalysisReportLandscape: Report "Analysis Report-Landscape";
                    DateFilter: Text;
                    ItemBudgetFilter: Text;
                    LocationFilter: Text;
                    Dim1Filter: Text;
                    Dim2Filter: Text;
                    Dim3Filter: Text;
                begin

                    AnalysisReportLandscape.SetParams(Rec.GetRangeMax("Analysis Area"), CurrentReportName, CurrentLineTemplate, CurrentColumnTemplate);
                    DateFilter := Rec.GetFilter("Date Filter");
                    ItemBudgetFilter := Rec.GetFilter("Item Budget Filter");
                    LocationFilter := Rec.GetFilter("Location Filter");
                    Dim1Filter := Rec.GetFilter("Dimension 1 Filter");
                    Dim2Filter := Rec.GetFilter("Dimension 2 Filter");
                    Dim3Filter := Rec.GetFilter("Dimension 3 Filter");
                    AnalysisReportLandscape.SetFilters(
                      DateFilter, ItemBudgetFilter, LocationFilter, Dim1Filter, Dim2Filter, Dim3Filter,
                      CurrentSourceTypeFilter, CurrentSourceTypeNoFilter);
                    AnalysisReportLandscape.Run;
                end;
            }
        }
    }


    var
        CurrentReportName: Code[10];
        CurrentLineTemplate: Code[10];
        CurrentColumnTemplate: Code[10];
        NewCurrentReportName: Code[10];


        CurrentSourceTypeNoFilter: Text;
        CurrentSourceTypeFilter: Enum "Analysis Source Type";
}
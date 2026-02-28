pageextension 50237 PurchaseAnalysisReportExt extends "Purchase Analysis Report"
{
    layout
    {
        // Add changes to page layout here
        addafter(CurrentSourceTypeNoFilter)
        {
            field("Date Filter"; "Date Filter")
            {
                ApplicationArea = All;
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
                    AnalysisReportLandscape.SetParams(GetRangeMax("Analysis Area"), CurrentReportName, CurrentLineTemplate, CurrentColumnTemplate);
                    DateFilter := GetFilter("Date Filter");
                    ItemBudgetFilter := GetFilter("Item Budget Filter");
                    LocationFilter := GetFilter("Location Filter");
                    Dim1Filter := GetFilter("Dimension 1 Filter");
                    Dim2Filter := GetFilter("Dimension 2 Filter");
                    Dim3Filter := GetFilter("Dimension 3 Filter");
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
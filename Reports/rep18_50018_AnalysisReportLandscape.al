report 50018 "Analysis Report-Landscape"
{
    // version NAVW110.0

    // TAL0.1 get vendir nane and code
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep18_50018_AnalysisReportLandscape.rdlc';

    Caption = 'Analysis Report';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(AnalysisLineTemplate; "Analysis Line Template")
        {
            DataItemTableView = SORTING("Analysis Area", Name);
            column(TempName_AnlysLine; Name)
            {
            }
            dataitem(Heading; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(TemplNameAnalysisColumn; AnalysisColumnTemplName)
                {
                }
                column(TempName_Heading; AnalysisLineTemplate.Name)
                {
                }
                column(FiscalStartDate; FORMAT(FiscalStartDate))
                {
                }
                column(PeriodText; PeriodText)
                {
                }
                column(CompanyName; COMPANYNAME)
                {
                }
                column(TodayFormatted; FORMAT(TODAY, 0, 4))
                {
                }
                column(TempDesc_AnlysLine; AnalysisLineTemplate.Description)
                {
                }
                column(ViewCode_ItemAnlys; ItemAnalysisView.Code)
                {
                }
                column(ViewName_ItemAnlys; ItemAnalysisView.Name)
                {
                }
                column(HeaderText; HeaderText)
                {
                }
                column(NoOfRecords; NoOfRecords)
                {
                }
                column(TblCptnAnalysisLineFilter; "Analysis Line".TABLECAPTION + ': ' + AnalysisLineFilter)
                {
                }
                column(AnalysisLineFilter; AnalysisLineFilter)
                {
                }
                column(ReportSetup_ShowAnlys; ShowAnalysisReportSetup)
                {
                }
                column(AnalysisColumnTemplNameCaption; AnalysisColumnTemplNameCaptionLbl)
                {
                }
                column(AnalysisLineTemplateNameCaption; AnalysisLineTemplateNameCaptionLbl)
                {
                }
                column(FiscalStartDateCaption; FiscalStartDateCaptionLbl)
                {
                }
                column(PeriodTextCaption; PeriodTextCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(AnalysisReportCaption; AnalysisReportCaptionLbl)
                {
                }
                column(ItemAnalysisViewCodeCaption; ItemAnalysisViewCodeCaptionLbl)
                {
                }
                column(VendorName; vG_VendorName)
                {
                }
                column(VendorCode; vG_VendorCode)
                {
                }
                dataitem(AnalysisLineSpec; "Analysis Line")
                {
                    DataItemLink = "Analysis Area" = FIELD("Analysis Area"), "Analysis Line Template Name" = FIELD(Name);
                    DataItemLinkReference = AnalysisLineTemplate;
                    DataItemTableView = SORTING("Analysis Area", "Analysis Line Template Name", "Line No.");
                    column(FormatUnderline; FORMAT(Underline))
                    {
                    }
                    column(FormatItalic; FORMAT(Italic))
                    {
                    }
                    column(FormatShowOpposite; FORMAT("Show Opposite Sign"))
                    {
                    }
                    column(FormatNewPage; FORMAT("New Page"))
                    {
                    }
                    column(FormatBold; FORMAT(Bold))
                    {
                    }
                    column(SpecShowOppSign_AnlysLine; "Show Opposite Sign")
                    {
                        IncludeCaption = true;
                    }
                    column(SpecUnderline__AnlysLine; Underline)
                    {
                        IncludeCaption = true;
                    }
                    column(SpecItalic_AnlysLine; Italic)
                    {
                        IncludeCaption = true;
                    }
                    column(SpecBold_AnlysLine; Bold)
                    {
                        IncludeCaption = true;
                    }
                    column(SpecShow_AnlysLine; Show)
                    {
                        IncludeCaption = true;
                    }
                    column(SpecNewPage_AnlysLine; "New Page")
                    {
                        IncludeCaption = true;
                    }
                    column(SpecDesc_AnlysLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(SpecRowRefNo_AnlysLine; "Row Ref. No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ViewDim1Code_ItemAnlys; ItemAnalysisView."Dimension 1 Code")
                    {
                    }
                    column(SpecDim1Total_AnlysLine; "Dimension 1 Totaling")
                    {
                    }
                    column(ASpecbody3View_AnlysLine; "Dimension 1 Totaling" <> '')
                    {
                    }
                    column(ViewDim2Code_ItemAnlys; ItemAnalysisView."Dimension 2 Code")
                    {
                    }
                    column(SpecDim2Total_AnlysLine; "Dimension 2 Totaling")
                    {
                    }
                    column(Specbody4View_AnlysLine; "Dimension 2 Totaling" <> '')
                    {
                    }
                    column(ViewDim3Code_ItemAnlys; ItemAnalysisView."Dimension 3 Code")
                    {
                    }
                    column(SpecDim3Total_AnlysLine; "Dimension 3 Totaling")
                    {
                    }
                    column(Specbody5View_AnlysLine; "Dimension 3 Totaling" <> '')
                    {
                    }
                    column(SpecTmplName_AnlysLine; "Analysis Line Template Name")
                    {
                    }
                    column(ItemAnalysisViewDimension1CodeCaption; ItemAnalysisViewDimension1CodeCaptionLbl)
                    {
                    }

                    trigger OnPreDataItem();
                    begin
                        if not ShowAnalysisReportSetup then
                            CurrReport.BREAK;
                    end;
                }
                dataitem(PageBreak; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    trigger OnAfterGetRecord();
                    begin
                        CurrReport.NEWPAGE;
                        NoOfRecords := NoOfRecords + 1;
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not ShowAnalysisReportSetup then
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Analysis Line"; "Analysis Line")
                {
                    DataItemLink = "Analysis Area" = FIELD("Analysis Area"), "Analysis Line Template Name" = FIELD(Name);
                    DataItemLinkReference = AnalysisLineTemplate;
                    DataItemTableView = SORTING("Analysis Area", "Analysis Line Template Name", "Line No.");
                    column(Header1; Header[1])
                    {
                    }
                    column(Header2; Header[2])
                    {
                    }
                    column(Header3; Header[3])
                    {
                    }
                    column(Header4; Header[4])
                    {
                    }
                    column(Header5; Header[5])
                    {
                    }
                    column(Header6; Header[6])
                    {
                    }
                    column(Header7; Header[7])
                    {
                    }
                    column(Header8; Header[8])
                    {
                    }
                    column(Header9; Header[9])
                    {
                    }
                    column(Header10; Header[10])
                    {
                    }
                    column(Header11; Header[11])
                    {
                    }
                    column(Header12; Header[12])
                    {
                    }
                    column(Header13; Header[13])
                    {
                    }
                    column(RoundingHeader13; RoundingHeader[13])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader12; RoundingHeader[12])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader11; RoundingHeader[11])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader10; RoundingHeader[10])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader9; RoundingHeader[9])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader8; RoundingHeader[8])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader7; RoundingHeader[7])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader6; RoundingHeader[6])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader5; RoundingHeader[5])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader4; RoundingHeader[4])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader3; RoundingHeader[3])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader2; RoundingHeader[2])
                    {
                        AutoCalcField = false;
                    }
                    column(RoundingHeader1; RoundingHeader[1])
                    {
                        AutoCalcField = false;
                    }
                    column(Hdr2View_AnlysLine; HasRounding)
                    {
                    }
                    column(Body8View_AnlysLine; (NoOfCols <= 1) and Underline)
                    {
                    }
                    column(Body9View_AnlysLine; (NoOfCols = 2) and Underline)
                    {
                    }
                    column(Body10View_AnlysLine; (NoOfCols = 3) and Underline)
                    {
                    }
                    column(Body11View_AnlysLine; (NoOfCols = 4) and Underline)
                    {
                    }
                    column(Body12View_AnlysLine; (NoOfCols = 5) and Underline)
                    {
                    }
                    column(Body13View_AnlysLine; (NoOfCols = 6) and Underline)
                    {
                    }
                    column(Body14View_AnlysLine; (NoOfCols = 7) and Underline)
                    {
                    }
                    column(Body15View_AnlysLine; (NoOfCols = 8) and Underline)
                    {
                    }
                    column(Body16View_AnlysLine; (NoOfCols = 9) and Underline)
                    {
                    }
                    column(Body17View_AnlysLine; (NoOfCols = 10) and Underline)
                    {
                    }
                    column(Body18View_AnlysLine; (NoOfCols = 11) and Underline)
                    {
                    }
                    column(Body19View_AnlysLine; (NoOfCols = 12) and Underline)
                    {
                    }
                    column(Body20View_AnlysLine; (NoOfCols = 13) and Underline)
                    {
                    }
                    column(NewPage; "New Page")
                    {
                    }
                    column(ColumnValuesAsText13; ColumnValuesAsText[13])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText12; ColumnValuesAsText[12])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText11; ColumnValuesAsText[11])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText10; ColumnValuesAsText[10])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText9; ColumnValuesAsText[9])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText8; ColumnValuesAsText[8])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText7; ColumnValuesAsText[7])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText6; ColumnValuesAsText[6])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText5; ColumnValuesAsText[5])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText4; ColumnValuesAsText[4])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText3; ColumnValuesAsText[3])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText2; ColumnValuesAsText[2])
                    {
                        AutoCalcField = false;
                    }
                    column(ColumnValuesAsText1; ColumnValuesAsText[1])
                    {
                        AutoCalcField = false;
                    }
                    column(Desc_AnlysLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(RowRefNo_AnlysLine; "Row Ref. No.")
                    {
                    }
                    column(RowRefNo_AnlysLineCaption; FIELDCAPTION("Row Ref. No."))
                    {
                    }
                    column(Body4View_AnlysLine; ShowLine(false, false))
                    {
                    }
                    column(Body5View_AnlysLine; ShowLine(true, false))
                    {
                    }
                    column(Body6View_AnlysLine; ShowLine(false, true))
                    {
                    }
                    column(Body7View_AnlysLine; ShowLine(true, true))
                    {
                    }
                    column(TemplateName_AnlysLine; "Analysis Line Template Name")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        for i := 1 to MaxColumnsDisplayed do begin
                            ColumnValuesDisplayed[i] := 0;
                            ColumnValuesAsText[i] := '';
                        end;
                        CalcColumns;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETFILTER("Date Filter", DateFilter);
                        SETFILTER("Item Budget Filter", ItemBudgetFilter);
                        SETFILTER("Location Filter", LocationFilter);
                        SETFILTER("Dimension 1 Filter", Dim1Filter);
                        SETFILTER("Dimension 2 Filter", Dim2Filter);
                        SETFILTER("Dimension 3 Filter", Dim3Filter);
                        if SourceTypeFilter <> SourceTypeFilter::" " then
                            SETRANGE("Source Type Filter", SourceTypeFilter);
                        SETFILTER("Source No. Filter", SourceNoFilter);
                    end;
                }

                trigger OnPreDataItem();
                begin
                    NoOfRecords := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CurrReport.PAGENO := 1;
                GLSetup.GET;
                if "Item Analysis View Code" <> '' then
                    ItemAnalysisView.GET(AnalysisArea, "Item Analysis View Code")
                else begin
                    ItemAnalysisView.INIT;
                    ItemAnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                    ItemAnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
                end;

                if GLSetup."LCY Code" <> '' then
                    HeaderText := STRSUBSTNO(Text003, GLSetup."LCY Code")
                else
                    HeaderText := '';

                //TAL0.1
                if (SourceTypeFilter = SourceTypeFilter::Vendor) then begin
                    if SourceNoFilter <> '' then begin
                        vG_Vendor.SETRANGE("No.", SourceNoFilter);
                        if vG_Vendor.FINDSET then begin
                            vG_VendorName := vG_Vendor.Name;
                            vG_VendorCode := vG_Vendor."No.";
                        end;
                    end;
                end;
                //TAL0.1
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Analysis Area", AnalysisArea);
                SETRANGE(Name, AnalysisLineTemplateName);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Layout")
                    {
                        Caption = 'Layout';
                        field(AnalysisArea; AnalysisArea)
                        {
                            Caption = 'Analysis Area';
                            OptionCaption = 'Sales,Purchase,Inventory';
                            ToolTip = 'Specifies is the analysis template is set up in the Sales, Purchasing, or Inventory application area.';

                            trigger OnValidate();
                            begin
                                AnalysisReportName := '';
                                AnalysisLineTemplateName := '';
                                AnalysisColumnTemplName := '';
                                Dim1Filter := '';
                                Dim2Filter := '';
                                Dim3Filter := '';
                            end;
                        }
                        field(AnalysisReportName; AnalysisReportName)
                        {
                            Caption = 'Analysis Report Name';
                            ToolTip = 'Specifies the report for which analysis figures are shown.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                if AnalysisReportManagement.LookupAnalysisReportName(AnalysisArea, AnalysisReportName) then begin
                                    Text := AnalysisReportName;
                                    exit(true);
                                end;
                            end;

                            trigger OnValidate();
                            begin
                                "Analysis Line".SETRANGE("Analysis Area", AnalysisArea);
                                AnalysisReportManagement.CheckReportName(AnalysisReportName, "Analysis Line");

                                if AnalysisReportNameRec.GET(AnalysisArea, AnalysisReportName) then begin
                                    if AnalysisReportNameRec."Analysis Line Template Name" <> '' then
                                        AnalysisLineTemplateName := AnalysisReportNameRec."Analysis Line Template Name";
                                    if AnalysisReportNameRec."Analysis Column Template Name" <> '' then
                                        AnalysisColumnTemplName := AnalysisReportNameRec."Analysis Column Template Name";
                                end;

                                ValidateAnalysisLineTemplate;
                            end;
                        }
                        field(AnalysisLineName; AnalysisLineTemplateName)
                        {
                            Caption = 'Analysis Line Name';
                            ToolTip = 'Specifies the line for which analysis figures are shown.';

                            trigger OnLookup(var Text: Text): Boolean;
                            var
                                TmpAnalysisLineTemplate: Record "Analysis Line Template";
                            begin
                                TmpAnalysisLineTemplate.FILTERGROUP := 2;
                                TmpAnalysisLineTemplate.SETRANGE("Analysis Area", AnalysisArea);
                                TmpAnalysisLineTemplate.FILTERGROUP := 0;
                                if PAGE.RUNMODAL(0, TmpAnalysisLineTemplate) = ACTION::LookupOK then begin
                                    Text := TmpAnalysisLineTemplate.Name;
                                    exit(true);
                                end;
                            end;

                            trigger OnValidate();
                            begin
                                "Analysis Line".SETRANGE("Analysis Area", AnalysisArea);
                                AnalysisReportManagement.CheckAnalysisLineTemplName(AnalysisLineTemplateName, "Analysis Line");

                                ValidateAnalysisLineTemplate;
                            end;
                        }
                        field(AnalysisColumnName; AnalysisColumnTemplName)
                        {
                            Caption = 'Analysis Column Name';
                            ToolTip = 'Specifies the column for which analysis figures are shown.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                AnalysisReportManagement.LookupAnalysisColumnName(AnalysisArea, AnalysisColumnTemplName);
                            end;

                            trigger OnValidate();
                            begin
                                AnalysisReportManagement.GetColumnTemplate(AnalysisArea, AnalysisColumnTemplName);
                            end;
                        }
                    }
                    group(Filters)
                    {
                        Caption = 'Filters';
                        field(DateFilter; DateFilter)
                        {
                            Caption = 'Date Filter';
                            ToolTip = 'Specifies the period for which the analysis report will show figures based on item ledger entries, value entries, and analysis view entries.';

                            trigger OnValidate();
                            begin
                                "Analysis Line".SETFILTER("Date Filter", DateFilter);
                                DateFilter := "Analysis Line".GETFILTER("Date Filter");
                            end;
                        }
                        field(ItemBudgetFilter; ItemBudgetFilter)
                        {
                            Caption = 'Item Budget Filter';
                            ToolTip = 'Specifies the item budget(s) for which analysis figures are shown.';

                            trigger OnLookup(var Text: Text): Boolean;
                            var
                                ItemBudgetName: Record "Item Budget Name";
                            begin
                                ItemBudgetName.SETRANGE("Analysis Area", AnalysisArea);
                                if PAGE.RUNMODAL(0, ItemBudgetName) = ACTION::LookupOK then begin
                                    Text := ItemBudgetName.Name;
                                    exit(true);
                                end;
                            end;

                            trigger OnValidate();
                            begin
                                "Analysis Line".SETFILTER("Item Budget Filter", ItemBudgetFilter);
                                ItemBudgetFilter := "Analysis Line".GETFILTER("Item Budget Filter");
                            end;
                        }
                        field(SourceTypeFilter; SourceTypeFilter)
                        {
                            Caption = 'Source Type Filter';
                            OptionCaption = ' ,Customer,Vendor,Item';
                            ToolTip = 'Specifies if figures in the analysis report are filtered by item number, customer number, or vendor number.';

                            trigger OnValidate();
                            begin
                                SourceNoFilter := '';
                            end;
                        }
                        field(SourceNoFilter; SourceNoFilter)
                        {
                            Caption = 'Source No. Filter';
                            ToolTip = 'Specifies the item, customer, or vendor numbers that figures in the analysis report are filtered by.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                AnalysisReportManagement.LookupSourceNo("Analysis Line", SourceTypeFilter, SourceNoFilter);
                            end;
                        }
                    }
                    group("Dimension Filters")
                    {
                        Caption = 'Dimension Filters';
                        field(Dim1Filter; Dim1Filter)
                        {
                            CaptionClass = FormGetCaptionClass(1);
                            Caption = 'Dimension 1 Filter';
                            Enabled = Dim1FilterEnable;
                            ToolTip = 'Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 1 for the analysis view selected in the Analysis View Code field.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                exit(FormLookUpDimFilter(ItemAnalysisView."Dimension 1 Code", Text));
                            end;
                        }
                        field(Dim2Filter; Dim2Filter)
                        {
                            CaptionClass = FormGetCaptionClass(2);
                            Caption = 'Dimension 2 Filter';
                            Enabled = Dim2FilterEnable;
                            ToolTip = 'Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 2 for the analysis view selected in the Analysis View Code field.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                exit(FormLookUpDimFilter(ItemAnalysisView."Dimension 2 Code", Text));
                            end;
                        }
                        field(Dim3Filter; Dim3Filter)
                        {
                            CaptionClass = FormGetCaptionClass(3);
                            Caption = 'Dimension 3 Filter';
                            Enabled = Dim3FilterEnable;
                            ToolTip = 'Specifies a filter for dimension values within a dimension. The filter uses the dimension you have defined as dimension 3 for the analysis view selected in the Analysis View Code field.';

                            trigger OnLookup(var Text: Text): Boolean;
                            begin
                                exit(FormLookUpDimFilter(ItemAnalysisView."Dimension 3 Code", Text));
                            end;
                        }
                    }
                    group(Show)
                    {
                        Caption = 'Show';
                        field(ShowError; ShowError)
                        {
                            Caption = 'Show Error';
                            OptionCaption = 'None,Division by Zero,Period Error,Both';
                            ToolTip = 'Specifies if the report shows error information.';
                        }
                        field(ShowAnalysisReportSetup; ShowAnalysisReportSetup)
                        {
                            Caption = 'Show Analysis Report Setup';
                            MultiLine = true;
                            ToolTip = 'Specifies if the actual report with the amounts will be preceded by one or more pages that describe the analysis report setup. That is, the first pages of the report show the lines that have been defined in the Analysis Report window.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            Dim3FilterEnable := true;
            Dim2FilterEnable := true;
            Dim1FilterEnable := true;
        end;

        trigger OnOpenPage();
        begin
            GLSetup.GET;
            if UseHiddenFilters then begin
                AnalysisArea := AnalysisAreaHidden;
                AnalysisReportName := AnalysisReportNameHidden;
                AnalysisLineTemplateName := AnalysisLineTemplateNameHidden;
                AnalysisColumnTemplName := AnalysisColumnTemplNameHidden;
            end;

            if AnalysisLineTemplateName <> '' then
                if not AnalysisLineTemplate.GET(AnalysisArea, AnalysisLineTemplateName) then
                    AnalysisLineTemplateName := '';
            if AnalysisLineTemplateName = '' then begin
                AnalysisLineTemplate.SETRANGE("Analysis Area", AnalysisArea);
                if AnalysisLineTemplate.FIND('-') then
                    AnalysisLineTemplateName := AnalysisLineTemplate.Name;
            end;

            if AnalysisLineTemplate."Item Analysis View Code" <> '' then
                ItemAnalysisView.GET(AnalysisArea, AnalysisLineTemplate."Item Analysis View Code")
            else begin
                ItemAnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                ItemAnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
            end;
            Dim1FilterEnable := ItemAnalysisView."Dimension 1 Code" <> '';
            Dim2FilterEnable := ItemAnalysisView."Dimension 2 Code" <> '';
            Dim3FilterEnable := ItemAnalysisView."Dimension 3 Code" <> '';

            if UseHiddenFilters then begin
                DateFilter := DateFilterHidden;
                ItemBudgetFilter := ItemBudgetFilterHidden;
                LocationFilter := LocationFilterHidden;
                Dim1Filter := Dim1FilterHidden;
                Dim2Filter := Dim2FilterHidden;
                Dim3Filter := Dim3FilterHidden;
                SourceTypeFilter := SourceTypeFilterHidden;
                SourceNoFilter := SourceNoFilterHidden;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        InitAnalysisLine;
    end;

    var
        Text000: Label '(Thousands)';
        Text001: Label '(Millions)';
        Text002: Label '* ERROR *';
        Text003: Label 'All amounts are in %1.';
        AnalysisColumnTmp: Record "Analysis Column" temporary;
        AnalysisReportNameRec: Record "Analysis Report Name";
        ItemAnalysisView: Record "Item Analysis View";
        GLSetup: Record "General Ledger Setup";
        AnalysisReportManagement: Codeunit "Analysis Report Management";
        MatrixMgt: Codeunit "Matrix Management";
        AnalysisArea: Enum "Analysis Area Type";
        AnalysisAreaHidden: Enum "Analysis Area Type";
        AnalysisReportName: Code[10];
        AnalysisReportNameHidden: Code[10];
        AnalysisLineTemplateName: Code[10];
        AnalysisLineTemplateNameHidden: Code[10];
        AnalysisColumnTemplName: Code[10];
        AnalysisColumnTemplNameHidden: Code[10];
        SourceTypeFilter: Option " ",Customer,Vendor,Item;
        SourceTypeFilterHidden: Option " ",Customer,Vendor,Item;
        SourceNoFilter: Text;
        SourceNoFilterHidden: Text;
        EndDate: Date;
        ShowError: Option "None","Division by Zero","Period Error",Both;
        DateFilter: Text;
        UseHiddenFilters: Boolean;
        DateFilterHidden: Text;
        ItemBudgetFilter: Text;
        ItemBudgetFilterHidden: Text;
        LocationFilter: Text;
        LocationFilterHidden: Text;
        Dim1Filter: Text;
        Dim1FilterHidden: Text;
        Dim2Filter: Text;
        Dim2FilterHidden: Text;
        Dim3Filter: Text;
        Dim3FilterHidden: Text;
        FiscalStartDate: Date;
        ColumnValuesDisplayed: array[13] of Decimal;
        ColumnValuesAsText: array[13] of Text[30];
        PeriodText: Text;
        AnalysisLineFilter: Text;
        Header: array[13] of Text[50];
        RoundingHeader: array[13] of Text[30];
        HasRounding: Boolean;
        i: Integer;
        MaxColumnsDisplayed: Integer;
        NoOfCols: Integer;
        ShowAnalysisReportSetup: Boolean;
        HeaderText: Text[100];
        Text004: Label 'Not Available';
        Text005: Label '1,6,,Dimension %1 Filter';
        NoOfRecords: Integer;
        [InDataSet]
        Dim1FilterEnable: Boolean;
        [InDataSet]
        Dim2FilterEnable: Boolean;
        [InDataSet]
        Dim3FilterEnable: Boolean;
        AnalysisColumnTemplNameCaptionLbl: Label 'Analysis Column';
        AnalysisLineTemplateNameCaptionLbl: Label 'Analysis Line';
        FiscalStartDateCaptionLbl: Label 'Fiscal Start Date';
        PeriodTextCaptionLbl: Label 'Period';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AnalysisReportCaptionLbl: Label 'Analysis Report';
        ItemAnalysisViewCodeCaptionLbl: Label 'Analysis View';
        ItemAnalysisViewDimension1CodeCaptionLbl: Label 'Dimension Code';
        vG_VendorName: Text;
        vG_VendorCode: Code[10];
        vG_Vendor: Record Vendor;

    procedure InitAnalysisLine();
    begin
        AnalysisLineTemplate.SETRANGE("Analysis Area", AnalysisArea);
        AnalysisLineTemplate.SETRANGE(Name, AnalysisLineTemplateName);
        "Analysis Line".FILTERGROUP := 2;
        "Analysis Line".SETRANGE("Analysis Area", AnalysisArea);
        "Analysis Line".FILTERGROUP := 0;
        "Analysis Line".SETFILTER(Show, '<>%1', "Analysis Line".Show::No);
        "Analysis Line".SETFILTER("Date Filter", DateFilter);
        "Analysis Line".SETFILTER("Item Budget Filter", ItemBudgetFilter);
        "Analysis Line".SETFILTER("Location Filter", LocationFilter);
        "Analysis Line".SETFILTER("Dimension 1 Filter", Dim1Filter);
        "Analysis Line".SETFILTER("Dimension 2 Filter", Dim2Filter);
        "Analysis Line".SETFILTER("Dimension 3 Filter", Dim3Filter);
        if SourceTypeFilter <> SourceTypeFilter::" " then
            "Analysis Line".SETRANGE("Source Type Filter", SourceTypeFilter);
        "Analysis Line".SETFILTER("Source No. Filter", SourceNoFilter);

        EndDate := "Analysis Line".GETRANGEMAX("Date Filter");
        //FiscalStartDate := AnalysisReportManagement.FindFiscalYear(EndDate);
        //FiscalStartDate:=AnalysisReportManagement.g

        MaxColumnsDisplayed := ARRAYLEN(ColumnValuesDisplayed);
        AnalysisLineFilter := "Analysis Line".GETFILTERS;
        PeriodText := "Analysis Line".GETFILTER("Date Filter");
        HasRounding := false;
        NoOfCols := 0;
        AnalysisReportManagement.CopyColumnsToTemp("Analysis Line", AnalysisColumnTemplName, AnalysisColumnTmp);
        with AnalysisColumnTmp do begin
            i := 0;
            if FIND('-') then begin
                repeat
                    if Show <> Show::Never then begin
                        i := i + 1;
                        if i <= MaxColumnsDisplayed then begin
                            Header[i] := "Column Header";
                            RoundingHeader[i] := '';
                            if "Rounding Factor" in ["Rounding Factor"::"1000", "Rounding Factor"::"1000000"] then begin
                                HasRounding := true;
                                case "Rounding Factor" of
                                    "Rounding Factor"::"1000":
                                        RoundingHeader[i] := Text000;
                                    "Rounding Factor"::"1000000":
                                        RoundingHeader[i] := Text001;
                                end;
                            end;
                        end;
                    end;
                    NoOfCols := NoOfCols + 1;
                until (i >= MaxColumnsDisplayed) or (NEXT = 0);
                MaxColumnsDisplayed := i;
            end;
        end;
    end;

    procedure SetParams(NewAnalysisArea: Option Sales,Purchase,Inventory; NewReportName: Code[10]; NewLineTemplateName: Code[10]; NewColumnTemplateName: Code[10]);
    begin
        UseHiddenFilters := true;
        AnalysisAreaHidden := NewAnalysisArea;
        AnalysisReportNameHidden := NewReportName;
        AnalysisLineTemplateNameHidden := NewLineTemplateName;
        AnalysisColumnTemplNameHidden := NewColumnTemplateName;
    end;

    procedure SetFilters(NewDateFilter: Text; NewItemBudgetFilter: Text; NewLocationFilter: Text; NewDim1Filter: Text; NewDim2Filter: Text; NewDim3Filter: Text; NewSourceTypeFilter: Option " ",Customer,Vendor,Item; NewSourceNoFilter: Text);
    begin
        DateFilterHidden := NewDateFilter;
        ItemBudgetFilterHidden := NewItemBudgetFilter;
        LocationFilterHidden := NewLocationFilter;
        Dim1FilterHidden := NewDim1Filter;
        Dim2FilterHidden := NewDim2Filter;
        Dim3FilterHidden := NewDim3Filter;
        SourceTypeFilterHidden := NewSourceTypeFilter;
        SourceNoFilterHidden := NewSourceNoFilter;
    end;

    local procedure CalcColumns(): Boolean;
    var
        NonZero: Boolean;
    begin
        NonZero := false;
        with AnalysisColumnTmp do begin
            SETRANGE("Analysis Column Template", AnalysisColumnTemplName);
            i := 0;
            if FIND('-') then
                repeat
                    if Show <> Show::Never then begin
                        i := i + 1;
                        ColumnValuesDisplayed[i] :=
                          AnalysisReportManagement.CalcCell("Analysis Line", AnalysisColumnTmp, false);
                        if AnalysisReportManagement.GetDivisionError then
                            if ShowError in [ShowError::"Division by Zero", ShowError::Both] then
                                ColumnValuesAsText[i] := Text002
                            else
                                ColumnValuesAsText[i] := ''
                        else
                            if AnalysisReportManagement.GetPeriodError then
                                if ShowError in [ShowError::"Period Error", ShowError::Both] then
                                    ColumnValuesAsText[i] := Text004
                                else
                                    ColumnValuesAsText[i] := ''
                            else begin
                                NonZero := NonZero or (ColumnValuesDisplayed[i] <> 0);
                                ColumnValuesAsText[i] :=
                                  MatrixMgt.FormatAmount(ColumnValuesDisplayed[i], "Rounding Factor", false);
                                /* ColumnValuesAsText[i] :=
                                  MatrixMgt.FormatValue(ColumnValuesDisplayed[i], "Rounding Factor", false); */
                            end;
                    end;
                until (i >= MaxColumnsDisplayed) or (NEXT = 0);
        end;
        exit(NonZero);
    end;

    local procedure ShowLine(Bold: Boolean; Italic: Boolean): Boolean;
    var
        NonZero: Boolean;
    begin
        if "Analysis Line".Show = "Analysis Line".Show::No then
            exit(false);
        if "Analysis Line".Bold <> Bold then
            exit(false);
        if "Analysis Line".Italic <> Italic then
            exit(false);
        NonZero := CalcColumns;
        if "Analysis Line".Show = "Analysis Line".Show::"If Any Column Not Zero" then
            exit(NonZero);
        exit(true);
    end;

    local procedure ValidateAnalysisLineTemplate();
    begin
        if AnalysisLineTemplate.GET(AnalysisArea, AnalysisLineTemplateName) then begin
            if AnalysisLineTemplate."Default Column Template Name" <> '' then
                AnalysisColumnTemplName := AnalysisLineTemplate."Default Column Template Name";
            if AnalysisLineTemplate."Item Analysis View Code" <> '' then
                ItemAnalysisView.GET(AnalysisArea, AnalysisLineTemplate."Item Analysis View Code")
            else begin
                CLEAR(ItemAnalysisView);
                ItemAnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                ItemAnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
            end;
        end;
    end;

    local procedure FormLookUpDimFilter(Dim: Code[20]; var Text: Text): Boolean;
    var
        DimVal: Record "Dimension Value";
        DimValList: Page "Dimension Value List";
    begin
        if Dim = '' then
            exit(false);
        DimValList.LOOKUPMODE(true);
        DimVal.SETRANGE("Dimension Code", Dim);
        DimValList.SETTABLEVIEW(DimVal);
        if DimValList.RUNMODAL = ACTION::LookupOK then begin
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            exit(true);
        end;
        exit(false);
    end;

    local procedure FormGetCaptionClass(DimNo: Integer): Text[250];
    begin
        case DimNo of
            1:
                begin
                    if ItemAnalysisView."Dimension 1 Code" <> '' then
                        exit('1,6,' + ItemAnalysisView."Dimension 1 Code");
                    exit(STRSUBSTNO(Text005, DimNo));
                end;
            2:
                begin
                    if ItemAnalysisView."Dimension 2 Code" <> '' then
                        exit('1,6,' + ItemAnalysisView."Dimension 2 Code");
                    exit(STRSUBSTNO(Text005, DimNo));
                end;
            3:
                begin
                    if ItemAnalysisView."Dimension 3 Code" <> '' then
                        exit('1,6,' + ItemAnalysisView."Dimension 3 Code");
                    exit(STRSUBSTNO(Text005, DimNo));
                end;
        end;
    end;
}


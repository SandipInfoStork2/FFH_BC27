report 50075 "Boxes Statement Summary"
{
    // version ELY-47

    // //
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep75_50075_BoxesStatementSummary.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Boxes Statement Summary/Detail';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    //AdditionalSearchTerms = 'BOX Inventory Transaction details';


    dataset
    {

        //dataitem(Location; Location)

        dataitem(LocationInt; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));
            //column(LocationCode; Location.Code)
            // {
            // }

            column(CompanyAddr1; CompanyAddr[1])
            {
            }

            column(CompanyAddr2; CompanyAddr[2])
            {
            }

            column(CompanyAddr3; CompanyAddr[3])
            {
            }

            column(CompanyAddr4; CompanyAddr[4])
            {
            }

            column(CompanyAddr5; CompanyAddr[5])
            {
            }

            column(CompanyAddr6; CompanyAddr[6])
            {
            }

            column(CompanyInfoGlobalGabCOCNo; CompanyInfo."GlobalGab COC No.")
            {
            }
            column(CompanyInfoBIOCertificationBody; CompanyInfo."BIO Certification Body")
            {

            }

            column(Addr1; Addr[1])
            {
            }

            column(Addr2; Addr[2])
            {
            }

            column(Addr3; Addr[3])
            {
            }

            column(Addr4; Addr[4])
            {
            }

            column(Addr5; Addr[5])
            {
            }

            column(Addr6; Addr[6])
            {
            }

            column(LocationOB; vG_LocationOB)
            {
            }



            column(CustomerGroupDimensionCode; vG_CustomerGroupDimensionCode)
            {
            }

            column(CustomerGroupDimensionName; vG_CustomerGroupDimensionName)
            {
            }

            column(ReportCaption; ReportCaption)
            {
            }


            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Source Type", "Source No.", "Item No."); //"Entry Type", Nonstock, 
                RequestFilterFields = "Source Type", "Source No.", "Posting Date", "Shortcut Dimension 5 Code", "Item Category Code", "Item No.";  // "Gen. Prod. Posting Group", 
                                                                                                                                                   //DataItemLink = "Location Code" = field(Code);

                column(SourceType; "Source Type")
                {
                }

                column(SourceNo; "Source No.")
                {
                }

                column(vG_SourceName; vG_SourceName)
                {
                }

                column(Showdetails; Showdetails)
                {
                }
                column(CompName; CompanyName)
                {
                }
                column(itemfilter; itemfilter)
                {
                }
                column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
                {
                }

                column(itemdesc; itemdesc)
                {
                }

                column(PostingDate_ItemLedgerEntry; Format("Item Ledger Entry"."Posting Date"))
                {
                }
                column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
                {
                }

                column(DocumentType_ItemLedgerEntry; "Item Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
                {
                }

                column(Dim5_CustGroup_ItemLedgerEntry; "Item Ledger Entry"."Shortcut Dimension 5 Code")
                {
                }

                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }

                column(InventoryStartBalance; vG_StartBalance)
                {
                    DecimalPlaces = 0 : 5;
                }

                column(InventoryEndBalance; vG_EndBalance)
                {
                    DecimalPlaces = 0 : 5;
                }


                column(LastTransDate; Format(LastTransDate))
                {

                }

                column(LedgerEntryPostingStartDate; Format(LedgerEntryPostingStartDate))
                {

                }

                column(PrintLine; vG_PrintLine)
                {

                }

                column(OpeningBalancePeriod; OpeningBalancePeriod)
                {

                }

                column(MovementPeriod; MovementPeriod)
                {

                }




                //PostingDate_ItemLedgerEntry
                //DocumentNo_ItemLedgerEntry
                //Quantity_ItemLedgerEntry





                trigger OnPreDataItem()
                var
                    //vL_PostingDateFilter: Text;
                    Text50000: Label 'Please enter Posting Date filter';
                    Text50001: Label 'Posting Date Start Date cannot be les than Initial Posting Start Date';
                    SameStartPeriod: Boolean;
                begin
                    //SetFilter("Posting Date", '>= %1', LedgerEntryPostingStartDate);

                    // ILEFilters := "Item Ledger Entry".GetFilters();
                    if Format("Item Ledger Entry".GetFilter("Posting Date")) = '' then begin
                        Error(Text50000);
                    end;

                    vG_StartDate := "Item Ledger Entry".GetRangeMin("Posting Date");

                    if vG_StartDate = LedgerEntryPostingStartDate then begin
                        SameStartPeriod := true;
                    end;

                    if vG_StartDate < LedgerEntryPostingStartDate then begin
                        Error(Text50001);
                    end;
                    vG_StartDate := CalcDate('-1D', vG_StartDate);
                    vG_EndDate := "Item Ledger Entry".GetRangeMax("Posting Date");



                    //Message(format("Item Ledger Entry".Count()));
                    if SameStartPeriod then begin
                        OpeningBalancePeriod := 'Same Start Date. No Opening Balance';
                    end else begin
                        OpeningBalancePeriod := Format(LedgerEntryPostingStartDate) + '..' + Format(vG_StartDate);
                    end;

                    MovementPeriod := Format("Item Ledger Entry".GetFilter("Posting Date"));
                end;

                trigger OnAfterGetRecord();
                var
                    Customer: Record Customer;
                    Vendor: Record Vendor;
                    LastILE: Record "Item Ledger Entry";
                    ILEStart: Record "Item Ledger Entry";
                    ILEEnd: Record "Item Ledger Entry";
                begin
                    Clear(item);
                    itemdesc := '';
                    if item.Get("Item No.") then begin
                        itemdesc := item.Description;
                    end;


                    vG_SourceName := '';
                    case "Source Type" of
                        "Source Type"::Customer:
                            begin
                                if Customer.Get("Source No.") then begin
                                    vG_SourceName := Customer.Name;
                                end;
                            end;

                        "Source Type"::Vendor:
                            begin
                                if Vendor.Get("Source No.") then begin
                                    vG_SourceName := Vendor.Name;
                                end;
                            end;
                    end;

                    LastTransDate := 0D;
                    LastILE.Reset;
                    LastILE.SetCurrentKey("Source Type", "Source No.", "Shortcut Dimension 5 Code", "Item No.", "Posting Date");
                    LastILE.SetRange("Source Type", "Item Ledger Entry"."Source Type");
                    LastILE.SetFilter("Source No.", "Item Ledger Entry"."Source No.");
                    LastILE.SetFilter("Shortcut Dimension 5 Code", "Item Ledger Entry"."Shortcut Dimension 5 Code");
                    LastILE.SetFilter("Item Category Code", "Item Ledger Entry"."Item Category Code");
                    ILEStart.SetFilter("Posting Date", '>=%1', LedgerEntryPostingStartDate);
                    //LastILE.SetRange("Posting Date", "Item Ledger Entry"."Posting Date");
                    LastILE.SetFilter("Item No.", "Item Ledger Entry"."Item No.");
                    if LastILE.FindLast() then begin
                        LastTransDate := LastILE."Posting Date";
                    end;



                    vG_StartBalance := 0;
                    vG_EndBalance := 0;
                    ILEStart.Reset;
                    ILEStart.SetCurrentKey("Source Type", "Source No.", "Shortcut Dimension 5 Code", "Item No.", "Posting Date");
                    ILEStart.SetRange("Source Type", "Item Ledger Entry"."Source Type");
                    ILEStart.SetFilter("Source No.", "Item Ledger Entry"."Source No.");
                    ILEStart.SetFilter("Shortcut Dimension 5 Code", "Item Ledger Entry"."Shortcut Dimension 5 Code");
                    ILEStart.SetFilter("Item Category Code", "Item Ledger Entry"."Item Category Code");
                    //ILEStart.SetFilter("Posting Date", '<%1', vG_StartDate);
                    ILEStart.SetRange("Posting Date", LedgerEntryPostingStartDate, vG_StartDate);
                    ILEStart.SetFilter("Item No.", "Item Ledger Entry"."Item No.");
                    if ILEStart.FindSet() then begin
                        ILEStart.CalcSums(Quantity);
                        vG_StartBalance := ILEStart.Quantity;
                    end;

                    ILEEnd.Reset;
                    ILEEnd.SetCurrentKey("Source Type", "Source No.", "Shortcut Dimension 5 Code", "Item No.", "Posting Date");
                    ILEEnd.SetRange("Source Type", "Item Ledger Entry"."Source Type");
                    ILEEnd.SetFilter("Source No.", "Item Ledger Entry"."Source No.");
                    ILEEnd.SetFilter("Shortcut Dimension 5 Code", "Item Ledger Entry"."Shortcut Dimension 5 Code");
                    ILEEnd.SetFilter("Item Category Code", "Item Ledger Entry"."Item Category Code");
                    //ILEEnd.SetFilter("Posting Date", '..%1', vG_EndDate);
                    ILEEnd.SetRange("Posting Date", LedgerEntryPostingStartDate, vG_EndDate);
                    ILEEnd.SetFilter("Item No.", "Item Ledger Entry"."Item No.");
                    if ILEEnd.FindSet() then begin
                        ILEEnd.CalcSums(Quantity);
                        vG_EndBalance := ILEEnd.Quantity;
                    end;


                    if PrintToExcel then
                        MakeExcelDataBody;
                end;
            }


            trigger OnPreDataItem()
            begin
                Clear(Addr);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
            end;

            trigger OnAfterGetRecord()
            var
                rL_ILE: Record "Item Ledger Entry";
            begin

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {

            area(Content)
            {




                group(Options)
                {
                    Caption = 'Options';

                    field(LedgerEntryStartCountDate; LedgerEntryPostingStartDate)
                    {
                        Caption = 'Posting Start Date';
                        ToolTip = 'Report will filter Posting Date >= Posting Start Date';
                        ApplicationArea = All;
                        Visible = true;
                    }



                    field(Showdetails; Showdetails)
                    {
                        Caption = 'Show Details';
                        ApplicationArea = All;
                        Visible = true;
                        ToolTip = 'Specifies the value of the Show Details field.';
                    }

                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Print to Excel field.';
                    }
                }

            }

        }

        actions
        {
        }



        trigger OnOpenPage();
        begin
            //vG_GenProdPostingGroup := 'ST-PACKMAT';

        end;

        trigger OnInit()
        var
            myInt: Integer;
        begin

        end;
    }

    labels
    {
    }

    trigger OnInitReport();

    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        //Showdetails := true;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);


        SRSetup.Get();
        LedgerEntryPostingStartDate := SRSetup."Box Stmt Start Date";

    end;

    trigger OnPreReport();
    begin
        itemfilter := "Item Ledger Entry".GetFilters();

        if PrintToExcel then
            MakeExcelInfo;


        if Showdetails then begin
            ReportCaption := Text004;
        end else begin
            ReportCaption := Text003;
        end;
    end;

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelbook;
    end;


    local procedure CheckLocation1()
    var
        vL_Location: Record Location;
    begin
        if vL_Location.Get(vG_LocationCode1) then begin
            vG_LocationExists1 := true;
        end else begin
            vG_LocationExists1 := false;
        end;
    end;

    local procedure CheckLocation2()
    var
        vL_Location: Record Location;
    begin
        if vL_Location.Get(vG_LocationCode2) then begin
            vG_LocationExists2 := true;
        end else begin
            vG_LocationExists2 := false;
        end;
    end;

    local procedure LookupCustomer()
    var
        Customer: Record Customer;
        pCustomerList: Page "Customer List";
    begin
        if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then begin
            vG_SourceNo2 := Customer."No.";
            vG_SourceName2 := Customer.Name;
            vG_LocationCode2 := DelChr(vG_SourceNo2, '=', 'UST'); //DelChr('UST', '=', vG_SourceNo)
            CheckLocation2();
            vG_CustomerGroupDimensionCode := '';
            vG_CustomerGroupDimensionName := '';
        end;
    end;

    local procedure LookupVendor()
    var
        Vendor: Record Vendor;
        pVendorList: Page "Vendor List";
    begin
        if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then begin
            vG_SourceNo1 := Vendor."No.";
            vG_SourceName1 := Vendor.Name;
            vG_LocationCode1 := DelChr(vG_SourceNo1, '=', 'END');
            CheckLocation1();
        end;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn('Source Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Source No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Source Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Posting Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Entry Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document Type', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customergroup', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Description', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Quantity', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Start Balance', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('End Balance', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Last Transation Date', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

    end;

    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        BlankFiller := PadStr(' ', MaxStrLen(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Item Ledger Entry"."Source Type", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Source No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(vG_SourceName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn("Item Ledger Entry"."Posting Date", false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Item Ledger Entry"."Entry Type", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Document Type", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Shortcut Dimension 5 Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry"."Item No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(itemdesc, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Item Ledger Entry".Quantity, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(vG_StartBalance, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(vG_EndBalance, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(LastTransDate, false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
    end;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;

        ExcelBuf.AddInfoColumn(Format(Text001), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyName, false, false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        /*
       ExcelBuf.AddInfoColumn(FORMAT(Text007), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn(FORMAT(Text001), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.NewRow;
       ExcelBuf.AddInfoColumn(FORMAT(Text006), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn(REPORT::"Trial Balance", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
       ExcelBuf.NewRow;
       ExcelBuf.AddInfoColumn(FORMAT(Text008), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.NewRow;
       ExcelBuf.AddInfoColumn(FORMAT(Text009), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
       ExcelBuf.NewRow;
       ExcelBuf.AddInfoColumn(FORMAT(Text010), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("No."), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.NewRow;
       ExcelBuf.AddInfoColumn(FORMAT(Text011), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("Date Filter"), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
       */
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;


    procedure CreateExcelbook()
    begin
        //BoxStatement.xlsx
        //ExcelBuf.CreateBookAndOpenExcel('', Text002, Text001, CompanyName, UserId);
        ExcelBuf.CreateNewBook(Text002);
        ExcelBuf.WriteSheet(Text002, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        Error('');
    end;


    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        itemfilter: Text;
        ile: Record "Item Ledger Entry";
        Showdetails: Boolean;
        itemdesc: Text;
        item: Record Item;



        vG_StartBalance: Decimal;
        vG_EndBalance: Decimal;

        CompanyInfo: Record "Company Information";

        FormatAddr: Codeunit "Format Address";

        CompanyAddr: array[8] of Text;

        rG_Customer: Record Customer;

        rG_Vendor: Record Vendor;

        rG_Location1: Record Location;

        Addr: array[8] of Text;
        cu_GeneralMgt: Codeunit "General Mgt.";

        rG_ItemBudgetBuffer: Record "Item Budget Buffer" temporary;

        vG_LocationOB: Boolean;

        vG_StartBalanceNoMovement: Decimal;

        vG_GenProdPostingGroup: Code[20];


        vG_ItemDescNoMovement: Text;

        //vG_SourceType: Enum "Analysis Source Type";// "Source Type";

        vG_SourceNo1: Code[20];

        vG_SourceName1: Text;

        vG_SourceNo2: Code[20];

        vG_SourceName2: Text;

        vG_LocationCode1: Code[20];

        vG_LocationExists1: Boolean;

        vG_LocationCode2: Code[20];

        vG_LocationExists2: Boolean;

        vG_CustomerGroupDimensionCode: Code[20];
        vG_CustomerGroupDimensionName: Text;

        vG_PrintLine: Boolean;

        vG_OldItemNo: Code[20];
        vG_CalcBalances: Boolean;

        vG_OldItemNo2: Code[20];
        vG_CalcBalances2: Boolean;



        vG_ShowBoxStatementCode: Boolean;

        vG_SourceName: Text;

        LastTransDate: Date;

        vG_StartDate: Date;
        vG_EndDate: Date;

        LedgerEntryPostingStartDate: Date;

        PrintToExcel: Boolean;

        ExcelBuf: Record "Excel Buffer" temporary;

        Text001: Label 'Box Statement';
        Text002: Label 'Data';

        Text003: Label 'Boxes Statement Summary';
        Text004: Label 'Boxes Statement Detail';

        ReportCaption: Text;
        OpeningBalancePeriod: Text;
        MovementPeriod: Text;


    // ILEFilters: Text;


}


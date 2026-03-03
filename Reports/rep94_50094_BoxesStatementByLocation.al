report 50094 "Boxes Statement By Location"
{
    // version ELY-47

    // //
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep94_50094_BoxesStatementByLocation.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Boxes Statement By Location';
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

            column(StartDate; Format(vG_StartDate))
            {
            }

            column(EndDate; Format(vG_EndDate))
            {
            }

            column(LocationOB; vG_LocationOB)
            {
            }

            column(SourceNo; vG_SourceNo1 + ' ' + vG_SourceNo2)
            {
            }


            column(CustomerGroupDimensionCode; vG_CustomerGroupDimensionCode)
            {
            }

            column(CustomerGroupDimensionName; vG_CustomerGroupDimensionName)
            {
            }




            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Item No.", "Posting Date"); //"Entry Type", Nonstock, 
                RequestFilterFields = "Entry Type", "Item No.";//, "Source Type", "Source No.", "Shortcut Dimension 5 Code"; // "Gen. Prod. Posting Group", 
                //DataItemLink = "Location Code" = field(Code);
                column(Showdetails; Showdetails)
                {
                }
                column(CompName; CompanyName)
                {
                }
                column(itemdesc; itemdesc)
                {
                }
                column(itemfilter; itemfilter)
                {
                }
                column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
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

                column(PrintLine; vG_PrintLine)
                {

                }




                trigger OnPreDataItem()
                var
                //vL_PostingDateFilter: Text;

                begin

                    //vL_PostingDateFilter := "Item Ledger Entry".GetFilter("Posting Date");
                    //:= GetRangeMin("Item Ledger Entry"."Posting Date");
                    //:= GetRangeMax("Item Ledger Entry"."Posting Date");
                    // Message(Format(vG_StartDate) + '-' + Format(vG_EndDate));

                    //SetFilter("Gen. Prod. Posting Group", vG_GenProdPostingGroup);
                    SetFilter("Item Category Code", vG_ItemCategoryCodeFilter);
                    //SetRange("Posting Date", vG_StartDate, vG_EndDate);

                    if vG_CustomerGroupDimensionCode <> '' then begin
                        SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                    end;

                    if (vG_LocationExists1 = false) and (vG_LocationExists2 = false) then begin
                        if (vG_SourceNo1 <> '') and (vG_SourceNo2 = '') then begin
                            SetRange("Source Type", "Source Type"::Vendor);
                            SetFilter("Source No.", vG_SourceNo1);
                        end;
                    end;
                end;

                trigger OnAfterGetRecord();
                var
                    ILEStart: Record "Item Ledger Entry";
                    ILEEnd: Record "Item Ledger Entry";

                begin

                    item.Get("Item No.");
                    itemdesc := item.Description;

                    vG_StartBalance := 0;
                    vG_EndBalance := 0;
                    vG_PrintLine := false;

                    vG_CalcBalances := false;
                    vG_CalcBalances2 := false;


                    if (
                            ((vG_SourceNo1 = "Item Ledger Entry"."Source No.") and (vG_SourceNo1 <> '')) or
                            ((vG_SourceNo2 = "Item Ledger Entry"."Source No.") and (vG_SourceNo2 <> '')) or
                                ((vG_LocationCode1 = "Item Ledger Entry"."Location Code") and (vG_LocationCode1 <> '')) or
                                    ((vG_LocationCode2 = "Item Ledger Entry"."Location Code") and (vG_LocationCode2 <> ''))
                        ) then begin


                        //CalcBalances for the Header //print line = false
                        if vG_OldItemNo <> "Item Ledger Entry"."Item No." then begin
                            vG_CalcBalances := true;
                        end;
                        vG_OldItemNo := "Item Ledger Entry"."Item No.";

                        if ("Posting Date" >= vG_StartDate) and ("Posting Date" <= vG_EndDate) then begin
                            vG_PrintLine := true;

                            //calc balances when print line  = true
                            if vG_OldItemNo2 <> "Item Ledger Entry"."Item No." then begin
                                vG_CalcBalances2 := true;
                            end;
                            vG_OldItemNo2 := "Item Ledger Entry"."Item No.";
                        end;

                        if vG_CalcBalances or vG_CalcBalances2 then begin
                            //Start Balance
                            ILEStart.Reset;
                            ILEStart.SetFilter("Posting Date", '<%1', vG_StartDate);
                            ILEStart.SetFilter("Item No.", "Item Ledger Entry"."Item No.");

                            /*
                            if "Source No." = '' then begin
                                //ILEStart.SetFilter("Location Code", "Item Ledger Entry"."Location Code");

                                if (vG_LocationCode1 <> '') and (vG_LocationCode2 <> '') then begin
                                    ILEStart.SetFilter("Location Code", '%1|%2', vG_LocationCode1, vG_LocationCode2);
                                end else
                                    if (vG_LocationCode1 <> '') then begin
                                        ILEStart.SetFilter("Location Code", vG_LocationCode1);
                                    end else
                                        if (vG_LocationCode2 <> '') then begin
                                            ILEStart.SetFilter("Location Code", vG_LocationCode2);
                                        end;
                            end else begin
                                //ILEStart.SetRange("Source Type", "Item Ledger Entry"."Source Type");
                                //ILEStart.SetFilter("Source No.", "Item Ledger Entry"."Source No.");

                                if (vG_SourceNo1 <> '') and (vG_SourceNo2 <> '') then begin
                                    ILEStart.SetFilter("Source No.", '%1|%2', vG_SourceNo1, vG_SourceNo2);
                                end else
                                    if (vG_SourceNo1 <> '') then begin
                                        ILEStart.SetFilter("Source No.", vG_SourceNo1);
                                    end else
                                        if (vG_SourceNo2 <> '') then begin
                                            ILEStart.SetFilter("Source No.", vG_SourceNo2);
                                        end;
                            end;
                            */

                            //ILEStart.SetFilter("Gen. Prod. Posting Group", "Item Ledger Entry"."Gen. Prod. Posting Group");
                            ILEStart.SetFilter("Item Category Code", "Item Ledger Entry"."Item Category Code");
                            if vG_CustomerGroupDimensionCode <> '' then begin
                                ILEStart.SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                            end;
                            if ILEStart.FindSet() then begin
                                //ILEStart.CalcSums(Quantity);
                                repeat

                                    if (
                                        ((vG_SourceNo1 = ILEStart."Source No.") and (vG_SourceNo1 <> '')) or
                                        ((vG_SourceNo2 = ILEStart."Source No.") and (vG_SourceNo2 <> '')) or
                                        ((vG_LocationCode1 = ILEStart."Location Code") and (vG_LocationCode1 <> '')) or
                                        ((vG_LocationCode2 = ILEStart."Location Code") and (vG_LocationCode2 <> ''))
                                        ) then begin
                                        vG_StartBalance += ILEStart.Quantity;
                                    end;

                                until ILEStart.Next() = 0;
                            end;

                            //End Balance
                            ILEEnd.Reset;
                            ILEEnd.SetFilter("Posting Date", '..%1', vG_EndDate);// <=
                            ILEEnd.SetFilter("Item No.", "Item Ledger Entry"."Item No.");

                            /*
                            if "Source No." = '' then begin
                                //ILEEnd.SetFilter("Location Code", "Item Ledger Entry"."Location Code");
                                if (vG_LocationCode1 <> '') and (vG_LocationCode2 <> '') then begin
                                    ILEEnd.SetFilter("Location Code", '%1|%2', vG_LocationCode1, vG_LocationCode2);
                                end else
                                    if (vG_LocationCode1 <> '') then begin
                                        ILEEnd.SetFilter("Location Code", vG_LocationCode1);
                                    end else
                                        if (vG_LocationCode2 <> '') then begin
                                            ILEEnd.SetFilter("Location Code", vG_LocationCode2);
                                        end;
                            end else begin
                                //ILEEnd.SetRange("Source Type", "Item Ledger Entry"."Source Type");
                                // ILEEnd.SetFilter("Source No.", "Item Ledger Entry"."Source No.");
                                if (vG_SourceNo1 <> '') and (vG_SourceNo2 <> '') then begin
                                    ILEEnd.SetFilter("Source No.", '%1|%2', vG_SourceNo1, vG_SourceNo2);
                                end else
                                    if (vG_SourceNo1 <> '') then begin
                                        ILEEnd.SetFilter("Source No.", vG_SourceNo1);
                                    end else
                                        if (vG_SourceNo2 <> '') then begin
                                            ILEEnd.SetFilter("Source No.", vG_SourceNo2);
                                        end;
                            end;
                            */

                            //ILEEnd.SetFilter("Gen. Prod. Posting Group", "Item Ledger Entry"."Gen. Prod. Posting Group");
                            ILEEnd.SetFilter("Item Category Code", "Item Ledger Entry"."Item Category Code");
                            if vG_CustomerGroupDimensionCode <> '' then begin
                                ILEEnd.SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                            end;
                            if ILEEnd.FindSet() then begin
                                //ILEEnd.CalcSums(Quantity);
                                repeat
                                    if (
                                           ((vG_SourceNo1 = ILEEnd."Source No.") and (vG_SourceNo1 <> '')) or
                                           ((vG_SourceNo2 = ILEEnd."Source No.") and (vG_SourceNo2 <> '')) or
                                           ((vG_LocationCode1 = ILEEnd."Location Code") and (vG_LocationCode1 <> '')) or
                                           ((vG_LocationCode2 = ILEEnd."Location Code") and (vG_LocationCode2 <> ''))
                                           ) then begin
                                        vG_EndBalance += ILEEnd.Quantity;
                                    end;

                                until ILEEnd.Next() = 0;
                            end;

                        end;//end calcBalances



                    end else begin
                        CurrReport.Skip();
                    end;

                end;
            }

            /*
            dataitem(Buffer_OB; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(Buffer_ItemNoOB; rG_ItemBudgetBuffer."Item No.")
                {

                }

                column(Buffer_ItemDescOB; vG_ItemDescNoMovement)
                {

                }



                column(Buffer_StartBalanceNoMovement; vG_StartBalanceNoMovement)
                {
                    DecimalPlaces = 0 : 5;
                }



                trigger OnPreDataItem()
                begin
                    if vG_LocationOB = false then begin
                        CurrReport.Break();
                    end;

                    rG_ItemBudgetBuffer.RESET;
                end;

                trigger OnAfterGetRecord()
                var
                    ILEStart: Record "Item Ledger Entry";
                    Item: Record Item;
                begin
                    if Number = 1 then begin
                        if not rG_ItemBudgetBuffer.Find('-') then
                            CurrReport.Break();
                    end else
                        if rG_ItemBudgetBuffer.Next() = 0 then
                            CurrReport.Break();


                    //get the opening Balance
                    vG_StartBalanceNoMovement := 0;

                    ILEStart.RESET;
                    ILEStart.SetFilter("Posting Date", '<%1', vG_StartDate);
                    ILEStart.SetFilter("Item No.", rG_ItemBudgetBuffer."Item No.");

                    if (vG_LocationCode1 <> '') and (vG_LocationCode2 <> '') then begin
                        ILEStart.SetFilter("Location Code", '%1|%2', vG_LocationCode1, vG_LocationCode2);
                    end else
                        if (vG_LocationCode1 <> '') then begin
                            ILEStart.SetFilter("Location Code", vG_LocationCode1);

                        end else
                            if (vG_LocationCode2 <> '') then begin
                                ILEStart.SetFilter("Location Code", vG_LocationCode2);
                            end;


                    ILEStart.SetFilter("Gen. Prod. Posting Group", vG_GenProdPostingGroup);
                    if vG_CustomerGroupDimensionCode <> '' then begin
                        ILEStart.SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                    end;
                    if ILEStart.FindSet() then begin
                        ILEStart.CalcSums(Quantity);
                        vG_StartBalanceNoMovement := ILEStart.Quantity;
                    end;

                    Item.GET(rG_ItemBudgetBuffer."Item No.");
                    vG_ItemDescNoMovement := Item.Description;

                    // Message(Location.Code + ' ' + FORMAT(rG_ItemBudgetBuffer."Item No.") + ' OB: ' + Format(vG_StartBalanceNoMovement));
                end;
            }
            */

            trigger OnPreDataItem()
            begin
                Clear(Addr);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                if rG_Customer.Get(vG_SourceNo2) then begin //Location.Code Getfilter("Location Code")
                    FormatAddr.Customer(Addr, rG_Customer);
                end;

                if rG_Vendor.Get(vG_SourceNo1) then begin //Location.Code Getfilter("Location Code")
                    FormatAddr.Vendor(Addr, rG_Vendor);
                end;

                // if rG_Location.Get(vG_LocationCode) then begin //Location.Code Getfilter("Location Code")
                //     cu_GeneralMgt.LocationAddress(Addr, rG_Location);
                //end;


            end;

            trigger OnAfterGetRecord()
            var
                rL_ILE: Record "Item Ledger Entry";
            begin

                /*
                vG_LocationOB := false;
                Clear(rG_ItemBudgetBuffer);
                rG_ItemBudgetBuffer.DeleteAll();
                Clear(rL_ILE);

                rL_ILE.RESET;
                rL_ILE.SetFilter("Location Code", vG_LocationCode1);
                rL_ILE.SetFilter("Gen. Prod. Posting Group", vG_GenProdPostingGroup);
                if not rL_ILE.FindSet() then begin
                    //CurrReport.Skip();

                    rL_ILE.RESET;
                    if (vG_LocationCode1 <> '') and (vG_LocationCode2 <> '') then begin
                        rL_ILE.SetFilter("Location Code", '%1|%2', vG_LocationCode1, vG_LocationCode2);
                    end else
                        if (vG_LocationCode1 <> '') then begin
                            rL_ILE.SetFilter("Location Code", vG_LocationCode1);
                        end else
                            if (vG_LocationCode2 <> '') then begin
                                rL_ILE.SetFilter("Location Code", vG_LocationCode2);
                            end;

                    rL_ILE.SetRange("Posting Date", vG_StartDate, vG_EndDate);
                    rL_ILE.SetFilter("Gen. Prod. Posting Group", vG_GenProdPostingGroup);
                    if vG_CustomerGroupDimensionCode <> '' then begin
                        rL_ILE.SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                    end;
                    if not rL_ILE.FindSet() then begin
                        //Opening Balance Records

                        rL_ILE.RESET;
                        if (vG_LocationCode1 <> '') and (vG_LocationCode2 <> '') then begin
                            rL_ILE.SetFilter("Location Code", '%1|%2', vG_LocationCode1, vG_LocationCode2);
                        end else
                            if (vG_LocationCode1 <> '') then begin
                                rL_ILE.SetFilter("Location Code", vG_LocationCode1);

                            end else
                                if (vG_LocationCode2 <> '') then begin
                                    rL_ILE.SetFilter("Location Code", vG_LocationCode2);
                                end;


                        rL_ILE.SetFilter("Posting Date", '<%1', vG_StartDate);
                        rL_ILE.SetFilter("Gen. Prod. Posting Group", vG_GenProdPostingGroup);
                        if vG_CustomerGroupDimensionCode <> '' then begin
                            rL_ILE.SetFilter("Shortcut Dimension 5 Code", vG_CustomerGroupDimensionCode);
                        end;
                        if rL_ILE.FindSet() then begin
                            vG_LocationOB := true;
                            repeat

                                rG_ItemBudgetBuffer.RESET;
                                rG_ItemBudgetBuffer.SetFilter("Item No.", rL_ILE."Item No.");
                                if not rG_ItemBudgetBuffer.FindSet() then begin
                                    clear(rG_ItemBudgetBuffer);
                                    rG_ItemBudgetBuffer."Item No." := rL_ILE."Item No.";
                                    rG_ItemBudgetBuffer.Insert();
                                end;

                            until rL_ILE.Next() = 0;
                            //add the unique items

                            //Message(Location.Code + ' ' + FORMAT(rG_ItemBudgetBuffer.Count));
                        end;


                    end;
                end;
                */




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
                field(Showdetails; Showdetails)
                {
                    Caption = 'Show Details';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Show Details field.';
                }

                group(Options)
                {
                    Caption = 'Options';




                    field(GenProdPostingGroup; vG_GenProdPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Gen. Prod. Posting Group';
                        TableRelation = "Gen. Product Posting Group";
                        Visible = false;
                        ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            GenProductPostingGroup: Record "Gen. Product Posting Group";
                        begin
                            if Page.RunModal(Page::"Gen. Business Posting Groups", GenProductPostingGroup) = Action::LookupOK then begin
                                vG_GenProdPostingGroup := GenProductPostingGroup.Code;
                            end;
                        end;
                    }

                    field(ItemCategoryCodeFilter; vG_ItemCategoryCodeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Category Code';
                        //TableRelation = "Item Category";
                        Visible = true;
                        ToolTip = 'Specifies the value of the Item Category Code field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemCategory: Record "Item Category";
                            pItemCategories: Page "Item Categories";
                        begin
                            Clear(vG_ItemCategoryCodeFilter);
                            Clear(pItemCategories);
                            pItemCategories.SetTableView(ItemCategory);
                            pItemCategories.LookupMode(true);
                            if pItemCategories.RunModal = Action::LookupOK then begin
                                vG_ItemCategoryCodeFilter := pItemCategories.GetSelectionFilter();
                                //Message(vG_ItemCategoryCodeFilter);
                            end;
                        end;
                    }
                    field(StartDate; vG_StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the value of the Start Date field.';
                    }
                    field(EndDate; vG_EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                    }

                    group(Source)
                    {
                        Caption = 'VENDOR CRITERIA:';


                        /*
                        field("Source Type"; vG_SourceType)
                        {
                            Caption = 'Source Type';

                            trigger OnValidate()
                            begin
                                vG_SourceNo := '';
                                vG_SourceName := '';
                                vG_LocationCode := '';
                                vG_LocationExists := false;
                            end;
                        }
                        */

                        field("Source No.1"; vG_SourceNo1)
                        {
                            Caption = 'Vendor No.';
                            Visible = vG_ShowBoxStatementCode;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Vendor No. field.';

                            trigger OnValidate()
                            var
                                Customer: Record Customer;
                                Vendor: Record Vendor;
                            begin
                                //case vG_SourceType of
                                //vG_SourceType::Customer:
                                //    begin
                                //        if Customer.GET(vG_SourceNo) then begin
                                //            vG_SourceNo := Customer."No.";
                                //            vG_SourceName := Customer.Name;
                                //            vG_LocationCode := DELCHR(vG_SourceNo, '=', 'UST'); //DelChr('UST', '=', vG_SourceNo)
                                //            CheckLocation();
                                //       end;
                                //   end;

                                //vG_SourceType::Vendor:
                                // begin
                                if Vendor.Get(vG_SourceNo1) then begin
                                    vG_SourceNo1 := Vendor."No.";
                                    vG_SourceName1 := Vendor.Name;
                                    vG_LocationCode1 := DelChr(vG_SourceNo1, '=', 'END');
                                    CheckLocation1();
                                end;
                                //end;
                                //end;
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupVendor();
                            end;

                        }

                        field(SourceName1; vG_SourceName1)
                        {
                            Caption = 'Vendor Name';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Vendor Name field.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupVendor();
                            end;

                            trigger OnValidate()
                            var
                                myInt: Integer;
                            begin
                                if vG_SourceName1 = '' then begin
                                    InitialiseVendor();
                                end;
                            end;
                        }

                        field(LocationCode1; vG_LocationCode1)
                        {
                            Caption = 'Vendor Location Code';
                            Visible = vG_ShowBoxStatementCode;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Vendor Location Code field.';
                        }

                        field(LocationExists1; vG_LocationExists1)
                        {
                            Caption = 'Vendor Location Exists';
                            Visible = vG_ShowBoxStatementCode;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Vendor Location Exists field.';
                        }
                    }


                    //2
                    group(Source2)
                    {
                        Caption = 'CUSTOMER CRITERIA:';



                        /*
                        field("Source Type2"; vG_SourceType2)
                        {
                            Caption = 'Source Type';

                            trigger OnValidate()
                            begin
                                vG_SourceNo2 := '';
                                vG_SourceName2 := '';

                            end;
                        }
                        */

                        field("Source No."; vG_SourceNo2)
                        {
                            Caption = 'Customer No.';
                            Visible = vG_ShowBoxStatementCode;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer No. field.';

                            trigger OnValidate()
                            var
                                Customer: Record Customer;
                            begin
                                if Customer.Get(vG_SourceNo2) then begin
                                    vG_SourceNo2 := Customer."No.";
                                    vG_SourceName2 := Customer.Name;
                                    vG_LocationCode2 := DelChr(vG_SourceNo2, '=', 'UST'); //DelChr('UST', '=', vG_SourceNo)
                                    CheckLocation2();
                                    vG_CustomerGroupDimensionCode := '';
                                    vG_CustomerGroupDimensionName := '';
                                end;
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupCustomer();
                            end;
                        }

                        field(SourceName; vG_SourceName2)
                        {
                            Caption = 'Customer Name';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer Name field.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupCustomer();
                            end;

                            trigger OnValidate()
                            var
                                myInt: Integer;
                            begin
                                if vG_SourceName2 = '' then begin
                                    InitialiseCustomer();
                                end;
                            end;
                        }





                        field(CustomerGroupDimensionCode; vG_CustomerGroupDimensionCode)
                        {
                            Caption = 'Customer Group Dimension Code';
                            Visible = vG_ShowBoxStatementCode;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer Group Dimension Code field.';

                            trigger OnLookup(var Text: Text): Boolean
                            var

                                DimensionValue: Record "Dimension Value";
                            begin
                                DimensionValue.Reset;
                                DimensionValue.SetRange("Global Dimension No.", 5);
                                if DimensionValue.FindSet() then;

                                if Page.RunModal(Page::"Dimension Values", DimensionValue) = Action::LookupOK then begin
                                    vG_CustomerGroupDimensionCode := DimensionValue.Code;
                                    vG_CustomerGroupDimensionName := DimensionValue.Name;

                                end;
                            end;

                            trigger OnValidate()
                            var
                                DimensionValue: Record "Dimension Value";
                            begin
                                vG_CustomerGroupDimensionName := '';
                                if vG_CustomerGroupDimensionCode <> '' then begin
                                    DimensionValue.Reset;
                                    DimensionValue.SetRange("Global Dimension No.", 5);
                                    DimensionValue.SetFilter(Code, vG_CustomerGroupDimensionCode);
                                    if DimensionValue.FindSet() then begin
                                        vG_CustomerGroupDimensionName := DimensionValue.Name;
                                    end;
                                end;

                            end;

                        }

                        field(CustomerGroupDimensionName; vG_CustomerGroupDimensionName)
                        {
                            Caption = 'Customer Branch';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer Branch field.';
                            trigger OnLookup(var Text: Text): Boolean
                            var
                                DimensionValue: Record "Dimension Value";
                            begin
                                DimensionValue.Reset;
                                DimensionValue.SetRange("Global Dimension No.", 5);
                                if DimensionValue.FindSet() then;

                                if Page.RunModal(Page::"Dimension Values", DimensionValue) = Action::LookupOK then begin
                                    vG_CustomerGroupDimensionCode := DimensionValue.Code;
                                    vG_CustomerGroupDimensionName := DimensionValue.Name;

                                end;
                            end;

                            trigger OnValidate()
                            var
                                myInt: Integer;
                            begin
                                if vG_CustomerGroupDimensionName = '' then begin
                                    initialiseDimension();
                                end;
                            end;
                        }

                        field(LocationCode2; vG_LocationCode2)
                        {
                            Caption = 'Customer Location Code';
                            Visible = vG_ShowBoxStatementCustomerLocation;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer Location Code field.';
                        }

                        field(LocationExists2; vG_LocationExists2)
                        {
                            Caption = 'Customer Location Exists';
                            Visible = vG_ShowBoxStatementCustomerLocation;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Customer Location Exists field.';
                        }
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

            SRSetup.Get;
            vG_ShowBoxStatementCode := SRSetup."Box Statement Codes";

            vG_ShowBoxStatementCustomerLocation := SRSetup."Box Stmt Show Cust. Location";



        end;

        trigger OnInit()
        var
            myInt: Integer;
        begin
            InitialiseCustomer();
            InitialiseVendor();
            initialiseDimension();
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        Showdetails := true;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        SRSetup.Get;
        vG_ItemCategoryCodeFilter := SRSetup."Box Stmt Item Category Filter";//  'CARTONS|PLBOX';vvvv
    end;

    trigger OnPreReport();
    begin
        itemfilter := "Item Ledger Entry".GetFilters;
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

    local procedure InitialiseVendor()
    begin
        vG_SourceNo1 := '';
        vG_LocationCode1 := '';
        vG_SourceName1 := '';
        vG_LocationExists1 := false;
    end;


    local procedure InitialiseCustomer()
    begin
        vG_SourceNo2 := '';
        vG_SourceName2 := '';
        vG_LocationCode2 := '';
        vG_LocationExists2 := false;
    end;

    local procedure initialiseDimension()
    begin
        vG_CustomerGroupDimensionCode := '';
        vG_CustomerGroupDimensionName := '';
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        itemfilter: Text;
        ile: Record "Item Ledger Entry";
        Showdetails: Boolean;
        itemdesc: Text;
        item: Record Item;

        vG_StartDate: Date;
        vG_EndDate: Date;

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
        vG_ItemCategoryCodeFilter: Text;

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

        SRSetup: Record "Sales & Receivables Setup";

        vG_ShowBoxStatementCode: Boolean;
        vG_ShowBoxStatementCustomerLocation: Boolean;


}


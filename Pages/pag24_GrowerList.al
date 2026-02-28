page 50024 "Grower List"
{
    // TAL0.1 2021/04/02 VC add field Producer Group Name
    // TAL0.2 2021/04/08 VC add action Item Analysis
    // TAL0.3 2021/11/16 VC add field Country of Destination

    CardPageID = "Grower Card";
    Editable = false;
    PageType = List;
    SourceTable = Grower;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Name)
                {
                    ApplicationArea = all;
                }
                field(GGN; GGN)
                {
                    ApplicationArea = all;
                }
                field("Country of Destination"; "Country of Destination")
                {
                    ApplicationArea = all;
                }
                field(GLN; GLN)
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Grower Vendor No."; "Grower Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Grower Vendor Name"; "Grower Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Grower Vendor GGN"; "Grower Vendor GGN")
                {
                    ApplicationArea = all;
                }
                field("Grower Vendor GLN"; "Grower Vendor GLN")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Grower Certified"; "Grower Certified")
                {
                    ApplicationArea = all;
                }
                field("GGN Expiry Date"; "GGN Expiry Date")
                {
                    ApplicationArea = all;
                }
                field("Category 2"; "Category 2")
                {
                    ApplicationArea = all;
                }

                field("Category 4"; "Category 4")
                {
                    ApplicationArea = all;
                }
                field("No. of Products"; "No. of Products")
                {
                    ApplicationArea = all;
                    DrillDownPageID = "Grower Item Catalog";
                }
                field(Comments; Comments)
                {
                    ApplicationArea = all;
                }
                field("Category 1"; "Category 1")
                {
                    ApplicationArea = all;
                }
                field("Producer Group Name"; "Producer Group Name")
                {
                    ApplicationArea = all;
                }
                field(TC; TC)
                {
                    ApplicationArea = all;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = all;
                }
                /*
                field("Purchases (Qty.)"; GetPurchasesQty())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }

                field("Purchases (PCS/KG)"; GetPurchasesTotalNetWeight())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;

                    trigger OnDrillDown();
                    begin
                        ShowPurchaseItemEntries(false);
                    end;
                }

                field("Sales (Qty.)"; GetSalesQty())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;
                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }
                field("Sales (KG)"; GetSalesTotalNetWeight())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 0;
                    BlankZero = true;
                    trigger OnDrillDown();
                    begin
                        ShowItemEntries(true);
                    end;
                }
                */

                /*
                field("Purchases (Qty.)"; "Purchases (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Purchases (PCS/KG)"; "Purchases (PCS/KG)")
                {
                    ApplicationArea = all;
                }
                field("Sales (Qty.)"; "Sales (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Sales (KG)"; "Sales (KG)")
                {
                    ApplicationArea = all;
                }
                */

                field("Category 3"; "Category 3")
                {
                    ApplicationArea = all;
                }
                field("GRASP Expiry Date"; "GRASP Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Status Biodiversity"; "Status Biodiversity")
                {
                    ApplicationArea = All;
                }

                field("Biodiversity Expiry Date"; "Biodiversity Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Status SPRING"; "Status SPRING")
                {
                    ApplicationArea = All;
                }
                field("SPRING Expiry Date"; "SPRING Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = all;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = all;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000022; Links)
            {
                ApplicationArea = all;
            }
            systempart(Control1000000021; Notes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Grower Certification Validity")
            {
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Grower Certification Validity";
            }
            action("Update Grower Certified")
            {
                ApplicationArea = all;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Update Grower Certified";
            }
            action("Items Per Customer Sales")
            {
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Items Per Customer Sales";
            }
            action("Item Sales Qty/Customer period")
            {
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Item Sales Qty/Customer period";
            }
            action("Item Sales Det/Customer period")
            {
                ApplicationArea = all;
                CaptionML = ELL = 'Item Sales Detailed/Customer period',
                            ENU = 'Item Sales Detailed/Customer period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Item Sales Det/Customer period";
            }
            action("Items Per Vendor Purchases")
            {
                ApplicationArea = all;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Items Per Vendor Purchases";
            }
            action("Item Analysis")
            {
                ApplicationArea = all;
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Item Analysis";
            }
        }
        area(navigation)
        {
            group(Grower)
            {
                action("Page Vendor Gr. Item Catalog")
                {
                    ApplicationArea = all;
                    Caption = 'Grower Items';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Grower Item Catalog";
                    RunPageLink = "Grower No." = FIELD("No.");
                    RunPageView = SORTING("Grower No.");
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                action("T&urnover")
                {
                    ApplicationArea = all;
                    Caption = 'T&urnover';
                    Image = Turnover;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Grower Turnover";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action("Item Tracing")
            {
                ApplicationArea = all;
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = Page "Item Tracing";
            }
        }
    }

    trigger OnOpenPage();
    var
        vL_StartYear: Date;
    begin

        vL_StartYear := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));

        SETFILTER("Date Filter", '>=%1', vL_StartYear);
    end;

    local procedure ShowItemEntries(ShowSales: Boolean);
    begin
        //SetDateFilter;
        ItemLedgEntry.RESET;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETCURRENTKEY("Entry Type", "Document Grower No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", "No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SETFILTER("Posting Date", GETFILTER("Date Filter"));




        if ShowSales then begin
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
            if GETFILTER("Customer No. Filter") <> '' then begin
                ItemLedgEntry.SETFILTER("Source No.", GETFILTER("Customer No. Filter"));
            end;
        end else begin
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);

        end;
        PAGE.RUN(0, ItemLedgEntry);
    end;

    local procedure ShowPurchaseItemEntries(ShowSales: Boolean);
    begin
        //SetDateFilter;
        ItemLedgEntry.RESET;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SETCURRENTKEY("Entry Type", "Source Type", "Source No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", "No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SETRANGE("Source Type", ItemLedgEntry."Source Type"::Vendor);
        //ItemLedgEntry.SETFILTER("Source No.",Grower."Grower Vendor No.");
        ItemLedgEntry.SETFILTER("Posting Date", GETFILTER("Date Filter"));
        if ShowSales then
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale)
        else
            ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
        PAGE.RUN(0, ItemLedgEntry);
    end;

    var
        ItemLedgEntry: Record "Item Ledger Entry";

}


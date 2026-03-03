page 50024 "Grower List"
{
    // TAL0.1 2021/04/02 VC add field Producer Group Name
    // TAL0.2 2021/04/08 VC add action Item Analysis
    // TAL0.3 2021/11/16 VC add field Country of Destination

    CardPageId = "Grower Card";
    Editable = false;
    PageType = List;
    SourceTable = Grower;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(GGN; Rec.GGN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN field.';
                }
                field("Country of Destination"; Rec."Country of Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country of Destination field.';
                }
                field(GLN; Rec.GLN)
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GLN field.';
                }
                field("Grower Vendor No."; Rec."Grower Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor No. field.';
                }
                field("Grower Vendor Name"; Rec."Grower Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor Name field.';
                }
                field("Grower Vendor GGN"; Rec."Grower Vendor GGN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor GGN field.';
                }
                field("Grower Vendor GLN"; Rec."Grower Vendor GLN")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Grower Vendor GLN field.';
                }
                field("Grower Certified"; Rec."Grower Certified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Certified field.';
                }
                field("GGN Expiry Date"; Rec."GGN Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN Expiry Date field.';
                }
                field("Category 2"; Rec."Category 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 2 field.';
                }

                field("Category 4"; Rec."Category 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 4 field.';
                }
                field("No. of Products"; Rec."No. of Products")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Grower Item Catalog";
                    ToolTip = 'Specifies the value of the No. of Products field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field("Category 1"; Rec."Category 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Producer Group field.';
                }
                field("Producer Group Name"; Rec."Producer Group Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Producer Group Name field.';
                }
                field(TC; Rec.TC)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TC field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
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

                field("Category 3"; Rec."Category 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 3 field.';
                }
                field("GRASP Expiry Date"; Rec."GRASP Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GRASP Expiry Date field.';
                }

                field("Status Biodiversity"; Rec."Status Biodiversity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Biodiversity field.';
                }

                field("Biodiversity Expiry Date"; Rec."Biodiversity Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Biodiversity Expiry Date field.';
                }

                field("Status SPRING"; Rec."Status SPRING")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status SPRING field.';
                }
                field("SPRING Expiry Date"; Rec."SPRING Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SPRING Expiry Date field.';
                }

                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000022; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1000000021; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Grower Certification Validity")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = report "Grower Certification Validity";
                ToolTip = 'Executes the Grower Certification Validity action.';
            }
            action("Update Grower Certified")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Update Grower Certified";
                ToolTip = 'Executes the Update Grower Certified action.';
            }
            action("Items Per Customer Sales")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Items Per Customer Sales";
                ToolTip = 'Executes the Items Per Customer Sales action.';
            }
            action("Item Sales Qty/Customer period")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Item Sales Qty/Customer period";
                ToolTip = 'Executes the Item Sales Qty/Customer period action.';
            }
            action("Item Sales Det/Customer period")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Item Sales Detailed/Customer period',
                            ENU = 'Item Sales Detailed/Customer period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Item Sales Det/Customer period";
                ToolTip = 'Executes the Item Sales Det/Customer period action.';
            }
            action("Items Per Vendor Purchases")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "Items Per Vendor Purchases";
                ToolTip = 'Executes the Items Per Vendor Purchases action.';
            }
            action("Item Analysis")
            {
                ApplicationArea = All;
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = page "Item Analysis";
                ToolTip = 'Executes the Item Analysis action.';
            }
        }
        area(Navigation)
        {
            group(Grower)
            {
                action("Page Vendor Gr. Item Catalog")
                {
                    ApplicationArea = All;
                    Caption = 'Grower Items';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = page "Grower Item Catalog";
                    RunPageLink = "Grower No." = field("No.");
                    RunPageView = sorting("Grower No.");
                    ToolTip = 'Executes the Grower Items action.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                action("T&urnover")
                {
                    ApplicationArea = All;
                    Caption = 'T&urnover';
                    Image = Turnover;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Grower Turnover";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the T&urnover action.';
                }
            }
        }
        area(Processing)
        {
            action("Item Tracing")
            {
                ApplicationArea = All;
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = page "Item Tracing";
                ToolTip = 'Executes the Item Tracing action.';
            }
        }
    }

    trigger OnOpenPage();
    var
        vL_StartYear: Date;
    begin

        vL_StartYear := DMY2Date(1, 1, Date2DMY(WorkDate, 3));

        Rec.SETFILTER("Date Filter", '>=%1', vL_StartYear);
    end;

    local procedure ShowItemEntries(ShowSales: Boolean);
    begin
        //SetDateFilter;
        ItemLedgEntry.Reset;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SetCurrentKey("Entry Type", "Document Grower No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", Rec."No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SETFILTER("Posting Date", Rec.GETFILTER("Date Filter"));




        if ShowSales then begin
            ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Sale);
            if Rec.GETFILTER("Customer No. Filter") <> '' then begin
                ItemLedgEntry.SETFILTER("Source No.", Rec.GETFILTER("Customer No. Filter"));
            end;
        end else begin
            ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Purchase);

        end;
        Page.Run(0, ItemLedgEntry);
    end;

    local procedure ShowPurchaseItemEntries(ShowSales: Boolean);
    begin
        //SetDateFilter;
        ItemLedgEntry.Reset;
        //ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SetCurrentKey("Entry Type", "Source Type", "Source No.", "Posting Date");
        ItemLedgEntry.SETRANGE(ItemLedgEntry."Lot Grower No.", Rec."No.");
        //ItemLedgEntry.SETRANGE(ItemLedgEntry."Document Grower No.",Grower."No.");
        ItemLedgEntry.SetRange("Source Type", ItemLedgEntry."Source Type"::Vendor);
        //ItemLedgEntry.SETFILTER("Source No.",Grower."Grower Vendor No.");
        ItemLedgEntry.SETFILTER("Posting Date", Rec.GETFILTER("Date Filter"));
        if ShowSales then
            ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Sale)
        else
            ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
        Page.Run(0, ItemLedgEntry);
    end;

    var
        ItemLedgEntry: Record "Item Ledger Entry";

}


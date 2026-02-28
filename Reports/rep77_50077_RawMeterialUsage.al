report 50077 "Raw Material Usage"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;


    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {

            RequestFilterFields = "Posting Date", "Location Code", "Entry Type", "Item No.";

            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }

            column(ILE_Filter; ItemLedgerEntryFilter)
            {
            }

            column(ReportDate; format(Today))
            {

            }

            column(EntryNo; "Entry No.")
            {

            }

            column(Posting_Date; FORMAT("Posting Date"))
            {

            }

            column(Item_No_; "Item No.")
            {

            }

            column(ItemDesc; rG_ItemDesc.Description)
            {

            }

            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {

            }

            column(Source_No_; "Source No.")
            {

            }

            column(SourceItemDesc; rG_SourceItemDesc.Description)
            {

            }
            column(SourceUOM; vG_SourceUOM)
            {

            }

            column(FinishedQty; vG_FinishedQty)
            {
                DecimalPlaces = 0 : 5;
            }

            column(Quantity; Quantity * -1)
            {
                DecimalPlaces = 0 : 2;
            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

            end;

            trigger OnAfterGetRecord()
            var
                ProdOrderLine: Record "Prod. Order Line";
            begin

                clear(rG_ItemDesc);
                clear(rG_SourceItemDesc);

                if rG_ItemDesc.GET("Item No.") then;

                if rG_SourceItemDesc.get("Source No.") then;

                vG_SourceUOM := '';
                vG_FinishedQty := 0;
                ProdOrderLine.RESET;
                ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Finished);
                ProdOrderLine.SetFilter("Prod. Order No.", "Document No.");
                ProdOrderLine.SetFilter("Item No.", "Source No.");
                if ProdOrderLine.FindSet() then begin
                    vG_SourceUOM := ProdOrderLine."Unit of Measure Code";

                    vG_FinishedQty := ProdOrderLine."Finished Quantity";
                end;


            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            /*
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }
                }
            }
            */
        }

        actions
        {
            area(processing)
            {/*

                action(ActionName)
                {
                    ApplicationArea = All;

                }

                */
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Caption = 'rep77_50077_RawMaterialUsage';
            Type = RDLC;
            LayoutFile = './Layouts/rep77_50077_RawMaterialUsage.rdlc';
            //RDLCLayout = './Layouts/rep78_50078_InventoryPostingTest.rdlc';

        }
    }


    trigger OnPreReport()
    begin
        ItemLedgerEntryFilter := "Item Ledger Entry".GetFilters;

    end;

    var
        ItemLedgerEntryFilter: Text;

        rG_ItemDesc: Record Item;
        rG_SourceItemDesc: Record Item;

        vG_SourceUOM: Code[20];

        vG_FinishedQty: Decimal;

}
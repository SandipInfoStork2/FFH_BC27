report 50015 "Quality Control Prod. Order"
{
    // TAL0.1 2021/11/10 VC design report QC
    // // System.Environment.NewLine
    // 
    // TAL0.2 2022/01/21 VC requestion from Andreas Zintilas to add Arad-5 ARAD-1|ARAD-5
    RDLCLayout = './Layouts/rep15_50015_QualityControlProdOrder.rdlc';

    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), "Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
            RequestFilterFields = "Posting Date", "Location Code", "Global Dimension 2 Code";
            column(EntryNo_ItemLedgerEntry; "Item Ledger Entry"."Entry No.")
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(SourceNo_ItemLedgerEntry; "Item Ledger Entry"."Source No.")
            {
            }
            column(Quantity_ItemLedgerEntry; vG_Qty)
            {
            }
            column(UnitofMeasureCode_ItemLedgerEntry; "Item Ledger Entry"."Unit of Measure Code")
            {
            }
            column(PostingDate_ItemLedgerEntry; Format("Item Ledger Entry"."Posting Date"))
            {
            }
            column(ItemDescription_ILE; rG_Item.Description)
            {
            }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            {
            }
            column(No_ProductionOrder; rG_ProductionOrder."No.")
            {
            }
            column(ItemDesciprion_ProductionOrder; rG_ProductionOrder.Description)
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
            column(RawGrowerName; "Item Ledger Entry"."Grower Name")
            {
            }
            column(RawPostingDate; Format(rG_RawPostingDate))
            {
            }
            column(ISOReleaseDate; vG_ISOReleaseDate)
            {
            }
            column(ISOVersion; CompanyInfo."ISO Version")
            {
            }
            column(ISOAuthorisedBy; CompanyInfo."ISO Authorised By")
            {
            }
            column(ISOReview; CompanyInfo."ISO Review")
            {
            }

            trigger OnAfterGetRecord();
            var
                ItemApplnEntry: Record "Item Application Entry";
            begin

                "Item Ledger Entry".CalcFields("Item Ledger Entry"."Grower Name");

                //rG_ProductionOrder.GET(rG_ProductionOrder.Status::Finished, "Item Ledger Entry"."Document No.");
                rG_Item.Get("Item No.");

                if LogoOutput then begin
                    Clear(CompanyInfo.Picture);
                end else begin
                    LogoOutput := true;
                end;



                rG_RawGrowerName := '';
                rG_RawPostingDate := 0D;


                ItemApplnEntry.Reset;
                ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Outbound Item Entry No.", "Item Ledger Entry"."Entry No.");
                ItemApplnEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                ItemApplnEntry.SetRange("Cost Application", true);
                if ItemApplnEntry.Find('-') then
                    repeat
                        rG_ILE2.Get(ItemApplnEntry."Inbound Item Entry No.");
                        rG_RawPostingDate := rG_ILE2."Posting Date";
                    //MESSAGE(ItemApplnEntry);
                    //InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity);
                    until ItemApplnEntry.Next = 0;


                /*
                rG_ILE2.RESET;
                rG_ILE2.SETRANGE("Entry Type",rG_ILE2."Entry Type"::Consumption);
                rG_ILE2.SETFILTER("Document No.","Item Ledger Entry"."Document No.");
                rG_ILE2.SETRANGE("Posting Date","Item Ledger Entry"."Posting Date");
                rG_ILE2.SETFILTER("Gen. Prod. Posting Group",'ST-FRVEG');
                IF rG_ILE2.FINDSET THEN BEGIN
                  //find raw material receipt
                   ItemApplnEntry.RESET;
                  ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
                  ItemApplnEntry.SETRANGE("Outbound Item Entry No.",rG_ILE2."Entry No.");
                  ItemApplnEntry.SETRANGE("Item Ledger Entry No.",rG_ILE2."Entry No.");
                  ItemApplnEntry.SETRANGE("Cost Application",TRUE);
                  IF ItemApplnEntry.FINDFIRST THEN BEGIN
                    rG_ILEPurchase.GET(ItemApplnEntry."Inbound Item Entry No.");
                    rG_ILEPurchase.CALCFIELDS("Grower Name");
                
                    rG_RawGrowerName:=rG_ILEPurchase."Grower Name";
                    rG_RawPostingDate:=rG_ILEPurchase."Posting Date";
                
                  END;
                    //REPEAT
                      //InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity);
                    //UNTIL ItemApplnEntry.NEXT = 0;
                
                END;
                */

                vG_Qty := Round("Item Ledger Entry".Quantity / "Item Ledger Entry"."Qty. per Unit of Measure", 1);
                vG_Qty := Abs(vG_Qty);

                if vG_Qty = 0 then begin
                    CurrReport.Skip();
                end;
                /*
                vG_Qty:=0;
                CLEAR(rG_SalesShipmentLine);
                rG_SalesShipmentLine.RESET;
                rG_SalesShipmentLine.SETRANGE("Document No.","Item Ledger Entry"."Document No.");
                rG_SalesShipmentLine.SETRANGE("Line No.","Item Ledger Entry"."Document Line No.");
                IF rG_SalesShipmentLine.FINDSET THEN BEGIN
                  vG_Qty:=rG_SalesShipmentLine.Quantity;
                END;
                */

            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);

                vG_ISOReleaseDate := Format(CompanyInfo."ISO Release Date", 0, '<Closing><Day,2>/<Month,2>/<Year4>');

                "Item Ledger Entry".SetCurrentKey("Posting Date", "Grower Name", "Item No.");
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
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        LogoOutput := false;
    end;

    var
        rG_Item: Record Item;
        CompanyInfo: Record "Company Information";
        LogoOutput: Boolean;
        rG_ProductionOrder: Record "Production Order";
        rG_ILE2: Record "Item Ledger Entry";
        rG_ILEPurchase: Record "Item Ledger Entry";
        rG_RawGrowerName: Text;
        rG_RawPostingDate: Date;
        vG_ISOReleaseDate: Text;
        vG_Qty: Decimal;
        rG_SalesShipmentLine: Record "Sales Shipment Line";
}


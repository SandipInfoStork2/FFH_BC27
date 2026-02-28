report 50017 "Quality Control Purc. Rcpt"
{
    // TAL0.1 2021/11/10 VC design report QC
    // TAL0.2 2021/11/30 VC copy of report 50014
    // 
    // ="V: " & Fields!VendorName_ILE.Value &
    // "<br><b>G: "  & Fields!Name_Grower.Value  & "</b>"
    // 
    // =Fields!GGN_Grower.Value & System.Environment.NewLine &
    // Fields!GGNExpireDate_Grower.Value
    // 
    // 
    // =Fields!PO_OrderNo_PurchaseReceiptHeader.Value & System.Environment.NewLine &
    // Fields!DocumentNo_ItemLedgerEntry.Value
    // 
    // 
    // TAL0.3 2022/01/21 VC requestion from Andreas Zintilas to add Arad-5 ARAD-1|ARAD-5
    RDLCLayout = './Layouts/rep17_50017_QualityControlPurcRcpt.rdlc';

    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = CONST(Purchase), "Document Type" = CONST("Purchase Receipt"), "Gen. Prod. Posting Group" = FILTER('ST-FRVEG'), "Location Code" = FILTER('ARAD-1|ARAD-5'), Quantity = FILTER(> 0));
            RequestFilterFields = "Posting Date";
            column(EntryNo_ItemLedgerEntry; "Item Ledger Entry"."Entry No.")
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(SourceNo_ItemLedgerEntry; "Item Ledger Entry"."Source No.")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(UnitofMeasureCode_ItemLedgerEntry; "Item Ledger Entry"."Unit of Measure Code")
            {
            }
            column(PostingDate_ItemLedgerEntry; FORMAT("Item Ledger Entry"."Posting Date"))
            {
            }
            column(VendorName_ILE; rG_Vendor.Name)
            {
            }
            column(ItemDescription_ILE; rG_Item.Description)
            {
            }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            {
            }
            column(Name_Grower; rG_Grower.Name)
            {
            }
            column(GGN_Grower; rG_Grower.GGN)
            {
            }
            column(GGNExpireDate_Grower; FORMAT(rG_Grower."GGN Expiry Date"))
            {
            }
            column(PO_OrderNo_PurchaseReceiptHeader; rG_PurchRcptHeader."Order No.")
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
            begin

                rG_Vendor.GET("Source No.");
                rG_Item.GET("Item No.");

                if LogoOutput then begin
                    CLEAR(CompanyInfo.Picture);
                end else begin
                    LogoOutput := true;
                end;


                CLEAR(rG_Grower);
                if rG_Grower.GET("Item Ledger Entry"."Lot Grower No.") then;

                rG_PurchRcptHeader.GET("Item Ledger Entry"."Document No.");
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);


                vG_ISOReleaseDate := FORMAT(CompanyInfo."ISO Release Date", 0, '<Closing><Day,2>/<Month,2>/<Year4>');
                "Item Ledger Entry".SETCURRENTKEY("Posting Date", "Source Type", "Source No.", "Lot Grower No.", "Item No.");
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
        rG_Vendor: Record Vendor;
        rG_Item: Record Item;
        CompanyInfo: Record "Company Information";
        LogoOutput: Boolean;
        rG_Grower: Record Grower;
        rG_PurchRcptHeader: Record "Purch. Rcpt. Header";
        vG_ISOReleaseDate: Text;
}


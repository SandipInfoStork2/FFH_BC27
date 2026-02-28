report 50097 "LOT Per Item"
{
    // version JG

    // TAL0.1 2018/01/11 VC review report
    // //
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep97_50097_LOTPerItem.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(Print_Date____FORMAT_TODAY_; 'Print Date: ' + FORMAT(Today))
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Page___FORMAT_CurrReport_PAGENO_; 'Page ' + FORMAT(CurrReport.PAGENO))
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item_Sales_Per_LOT_No_Caption; Item_Sales_Per_LOT_No_CaptionLbl)
            {
            }
            column(Item_No___Caption; Item_No___CaptionLbl)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Lot No.") ORDER(Ascending);// WHERE("Entry Type" = FILTER(Sale | "Negative Adjmt." | Purchase | "Positive Adjmt."));
                RequestFilterFields = "Lot No.";
                column(Item_Ledger_Entry__Lot_No__; "Lot No.")
                {
                }
                column(OpeningBalance; OpeningBalance)
                {
                }
                column(Quantity; -Quantity)
                {
                }
                column(Item_Ledger_Entry__Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(Item_Ledger_Entry__Item_Ledger_Entry___Entry_Type_; "Item Ledger Entry"."Entry Type")
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(Item_Ledger_Entry__Item_Ledger_Entry__Description; Description)
                {
                }
                column(SourceName; SourceName)
                {
                }
                column(LOTQtyTotal; LOTQtyTotal)
                {
                }
                column(ItemInventory; ItemInventory)
                {
                }
                column(LOT_No___Caption; LOT_No___CaptionLbl)
                {
                }
                column(Item_Ledger_Entry__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
                {
                }
                column(Entry_TypeCaption; Entry_TypeCaptionLbl)
                {
                }
                column(Document_No_Caption; Document_No_CaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(Customer_Vendor_NameCaption; Customer_Vendor_NameCaptionLbl)
                {
                }
                column(Opening_Balance__Caption; Opening_Balance__CaptionLbl)
                {
                }
                column(LOT_No__Totals__Caption; LOT_No__Totals__CaptionLbl)
                {
                }
                column(Inventory__Caption; Inventory__CaptionLbl)
                {
                }
                column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Item_Ledger_Entry_Item_No_; "Item No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    vG_Counter += 1;
                    if vG_Counter = 1 then begin
                        ItemLedgerEntry.INIT;
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Lot No.");
                        ItemLedgerEntry.ASCENDING;
                        ItemLedgerEntry.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                        ItemLedgerEntry.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                        //for opening Balance
                        ItemLedgerEntry.SETFILTER("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::Purchase,
                                                                       ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                        if ItemLedgerEntry.FIND('-') then begin
                            OpeningBalance := ItemLedgerEntry.Quantity;
                            StartingEntryNo := ItemLedgerEntry."Entry No.";
                        end else begin
                            OpeningBalance := 0;
                            StartingEntryNo := 0;
                        end;
                    end;

                    //Body

                    if "Item Ledger Entry"."Entry No." <> StartingEntryNo then begin
                        SourceName := '';
                        if "Item Ledger Entry"."Source Type" = "Item Ledger Entry"."Source Type"::Customer then begin
                            Customer.INIT;
                            Customer.RESET;
                            if Customer.GET("Item Ledger Entry"."Source No.") then
                                SourceName := Customer.Name;
                        end else
                            if "Item Ledger Entry"."Source Type" = "Item Ledger Entry"."Source Type"::Vendor then begin
                                Vendor.INIT;
                                Vendor.RESET;
                                if Vendor.GET("Item Ledger Entry"."Source No.") then
                                    SourceName := Vendor.Name;
                            end;

                        ValueEntry.INIT;
                        ValueEntry.RESET;
                        ValueEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                        ValueEntry.SETRANGE("Expected Cost", false);
                        if ValueEntry.FIND('-') then
                            DocumentNo := ValueEntry."Document No."
                        else
                            DocumentNo := "Item Ledger Entry"."Document No.";

                        LOTQtyTotal -= "Item Ledger Entry".Quantity;

                        //CurrReport.SHOWOUTPUT(TRUE);
                    end else begin
                        CurrReport.SKIP;
                        // CurrReport.SHOWOUTPUT(FALSE);
                    end;

                    ItemInventory := OpeningBalance - LOTQtyTotal;
                end;

                trigger OnPreDataItem();
                begin

                    vG_Counter := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                OpeningBalance := 0;

                LOTQtyTotal := 0;
                ItemInventory := 0;
            end;

            trigger OnPreDataItem();
            begin
                Company.GET;
                CurrReport.NEWPAGEPERRECORD(ChangePagePerItem);
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
                    field(ChangePagePerItem; ChangePagePerItem)
                    {
                        Caption = 'Change Page Per Item';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Company: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        DocumentNo: Code[20];
        OpeningBalance: Decimal;
        ItemInventory: Decimal;
        ChangePagePerItem: Boolean;
        SourceName: Text[50];
        StartingEntryNo: Integer;
        LOTQtyTotal: Decimal;
        Item_Sales_Per_LOT_No_CaptionLbl: Label 'Item Entries Per LOT No.';
        Item_No___CaptionLbl: Label 'Item No. :';
        LOT_No___CaptionLbl: Label 'LOT No. :';
        Entry_TypeCaptionLbl: Label 'Entry Type';
        Document_No_CaptionLbl: Label 'Document No.';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        Customer_Vendor_NameCaptionLbl: Label 'Customer/Vendor Name';
        Opening_Balance__CaptionLbl: Label 'Opening Balance :';
        LOT_No__Totals__CaptionLbl: Label 'LOT No. Totals :';
        Inventory__CaptionLbl: Label 'Inventory :';
        vG_Counter: Integer;
}


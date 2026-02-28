report 50064 "Item Register - Quantity FFH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep64_50064_ItemRegisterQuantity.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Item Register - Quantity';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Register"; "Item Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ItemRegFilterCopyText; TableCaption + ': ' + ItemRegFilter)
            {
            }
            column(ItemRegFilter; ItemRegFilter)
            {
            }
            column(No_ItemRegister; "No.")
            {
            }
            column(ItemRegQtyCaption; ItemRegQtyCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
            {
            }
            column(No_ItemRegisterCaption; No_ItemRegisterCaptionLbl)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(PostingDate_ItemLedgEntry; Format("Posting Date"))
                {
                }
                column(EntryType_ItemLedgEntry; "Entry Type")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ItemLedgEntry; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription; ItemDescription)
                {
                }
                column(Quantity_ItemLedgEntry; Quantity)
                {
                    IncludeCaption = true;
                    DecimalPlaces = 0 : 4;//TAL 1.0.0.109
                }
                column(EntryNo_ItemLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(DocNo_ItemLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }

                column(LocationCode_ItemLedgEntry; "Item Ledger Entry"."Location Code")
                {
                    IncludeCaption = true;
                }

                column(UOM_ItemLedgEntry; "Item Ledger Entry"."Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                // //TAL 1.0.0.89 >>
                column(GenBusPostingGroupCaption; GenBusPostingGroupLbl)
                {
                }
                column(GenBusPostingGroupCode; vG_GenBusPostingGroupCode)
                {
                }
                // column(GLAccountName; vG_GLAccountName)
                // {
                // }
                //TAL 1.0.0.89 <<

                trigger OnAfterGetRecord()
                begin
                    ItemDescription := Description;
                    if ItemDescription = '' then begin
                        if not Item.Get("Item No.") then
                            Item.Init;
                        ItemDescription := Item.Description;
                    end;

                    //TAL 1.0.0.189 >>
                    vG_GenBusPostingGroupCode := '';
                    // vG_GenBusPostingGroupName := '';
                    rG_ValueEntry.Reset();
                    rG_ValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");

                    if rG_ValueEntry.FindSet() then begin
                        vG_GenBusPostingGroupCode := rG_ValueEntry."Gen. Bus. Posting Group";

                        // rG_GenBusinesPostingGroup.Reset();
                        // rG_GenBusinesPostingGroup.SetRange(Code, rG_ValueEntry."Gen. Bus. Posting Group");
                        // if rG_GenBusinesPostingGroup.FindSet() then
                        //     vG_GenBusPostingGroupName := ' - ' + rG_GenBusinesPostingGroup.Description;

                    end;
                    //TAL 1.0.0.189 <<
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "Item Register"."From Entry No.", "Item Register"."To Entry No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemRegFilter := "Item Register".GetFilters;
    end;

    var
        //TAL 1.0.0.189 >>
        rG_ValueEntry: Record "Value Entry";
        rG_GenBusinesPostingGroup: Record "Gen. Business Posting Group";
        vG_GenBusPostingGroupCode: Code[20];
        vG_GenBusPostingGroupName: Text[100];
        rG_GLEntry: Record "G/L Entry";
        GenBusPostingGroupLbl: Label 'Gen. Bus. Posting Group';
        //TAL 1.0.0.189 <<
        Item: Record Item;
        ItemRegFilter: Text;
        ItemDescription: Text[100];
        ItemRegQtyCaptionLbl: Label 'Item Register - Quantity';
        CurrReportPageNoCaptionLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        ItemDescriptionCaptionLbl: Label 'Description';
        No_ItemRegisterCaptionLbl: Label 'Register No.';
}


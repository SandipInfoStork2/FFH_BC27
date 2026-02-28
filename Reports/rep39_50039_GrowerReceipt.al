report 50039 "Grower Receipt"
{
    // TAL0.1 2021/04/02 VC remove logo,
    //                      rename report caption
    //                      add GGN caption
    //                      change doc date caption
    //                      use document date
    // 
    // TAL0.2 2021/04/02 VC add Purchase receipt No. , Order No.
    // TAL0.3 2021/04/02 VC show producer if printed
    // TAL0.3 2021/04/13 VC show the item base unit of measure
    // TAL0.4 2021/04/27 VC add the filter for blank link plastic bags
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep39_50039_GrowerReceipt.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(ILE_DocumentNo; "Item Ledger Entry"."Document No.")
            {
            }
            column(ILE_ReceiptDocNo; "Item Ledger Entry"."Receipt Doc. No.")
            {
            }
            column(ILE_ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(ILE_ItemDescription; "Item Ledger Entry"."Item Description")
            {
            }
            column(ILE_LotNo; "Item Ledger Entry"."Lot No.")
            {
            }
            column(ILE_LotGrowerNo; "Item Ledger Entry"."Lot Grower No.")
            {
            }
            column(ILE_GrowerName; "Item Ledger Entry"."Grower Name")
            {
            }
            column(ILE_GrowerGGN; "Item Ledger Entry"."Grower GGN")
            {
            }
            column(ILE_Qty; "Item Ledger Entry".Quantity)
            {
                DecimalPlaces = 0 : 0;
            }
            column(ILE_UOM; rG_Item."Base Unit of Measure")
            {
            }
            column(ILE_ProducerGroupName; vG_ProducerGroupName)
            {
            }
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
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(ILE_DocumentDate; FORMAT("Item Ledger Entry"."Document Date"))
            {
            }
            column(ILE_POOrderNo; vG_OrderNo)
            {
            }
            column(ILE_POReceiptNo; vG_ReceiptNo)
            {
            }

            trigger OnAfterGetRecord();
            begin
                //CALCFIELDS("Lot Grower No.");
                CALCFIELDS("Grower Name");
                CALCFIELDS("Grower GGN");
                vG_ProducerGroupName := '';
                rG_Item.GET("Item Ledger Entry"."Item No."); //TAL0.3
                rL_Grower.GET("Item Ledger Entry"."Lot Grower No.");

                if rL_Grower."Category 1" <> '' then begin
                    rG_GeneralCategories.RESET;
                    rG_GeneralCategories.SETRANGE("Table No.", DATABASE::Vendor);
                    rG_GeneralCategories.SETRANGE(Type, rG_GeneralCategories.Type::Category1);
                    rG_GeneralCategories.SETFILTER(Code, rL_Grower."Category 1");
                    rG_GeneralCategories.SETRANGE("Print Receipt", true); //TAL0.3
                    if rG_GeneralCategories.FINDSET then begin
                        vG_ProducerGroupName := rG_GeneralCategories.Description;
                    end;

                end;

                //+TAL0.2
                rG_PurchRcptHeader.GET("Item Ledger Entry"."Document No.");
                vG_OrderNo := rG_PurchRcptHeader."Order No.";
                vG_ReceiptNo := DELCHR("Item Ledger Entry"."Document No.", '=', 'PREC-');
                //-TAL0.2
            end;

            trigger OnPreDataItem();
            var
                vL_DocNoFilter: Code[20];
                vL_DocTypeFilter: Text;
                rL_ILE2: Record "Item Ledger Entry";
            begin
                "Item Ledger Entry".SETFILTER("Lot Grower No.", '<>%1', ''); //TAL0.4

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                FormatAddr.GetCompanyAddr('', RespCenter, CompanyInfo, CompanyAddr);

                vL_DocNoFilter := '';
                vL_DocTypeFilter := '';
                if "Item Ledger Entry".GETFILTER("Document No.") <> '' then begin
                    vL_DocNoFilter := "Item Ledger Entry".GETFILTER("Document No.")
                end;

                if "Item Ledger Entry".GETFILTER("Document Type") <> '' then begin
                    vL_DocTypeFilter := "Item Ledger Entry".GETFILTER("Document Type");
                end;

                if (vL_DocNoFilter = '') or (vL_DocTypeFilter = '') then begin
                    ERROR('Filter not set correct');
                end;

                rL_ILE2.RESET;
                rL_ILE2.SETRANGE("Document Type", rL_ILE2."Document Type"::"Purchase Receipt");
                rL_ILE2.SETFILTER("Document No.", vL_DocNoFilter);
                rL_ILE2.SETFILTER("Receipt Doc. No.", '%1', '');
                rL_ILE2.SETFILTER("Lot Grower No.", '<>%1', ''); //TAL0.4 //to exclude the blank
                if rL_ILE2.FINDSET then begin
                    cu_GeneralMgt.GrowerReceiptNos(rL_ILE2."Document No.");
                end;
            end;
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

    var
        rL_Grower: Record Grower;
        vG_ProducerGroupName: Text;
        rG_GeneralCategories: Record "General Categories";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        CompanyAddr: array[8] of Text[50];
        RespCenter: Record "Responsibility Center";
        vG_ReceiptNo: Code[20];
        vG_OrderNo: Code[20];
        rG_PurchRcptHeader: Record "Purch. Rcpt. Header";
        cu_GeneralMgt: Codeunit "General Mgt.";
        rG_Item: Record Item;
}


report 50007 "Deltia Apostolis - Paralavis"
{
    // TAL0.1 2019/06/12 VC in case the description 2 and the external description is blank use the description
    // TAL0.2 2019/06/12 VC sort by Production Order No, Item No., Line No.
    // TAL0.3 2019/11/07 ANP Changed TAL0.2 sorting to Line. No
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep07_50007_DeltiaApostolisParalavis.rdlc';


    dataset
    {
        dataitem("Requisition Line"; "Requisition Line")
        {
            RequestFilterFields = "Worksheet Template Name", "Journal Batch Name";
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(VendAddr1; VendAddr[1])
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(VendAddr2; VendAddr[2])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(VendAddr3; VendAddr[3])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(VendAddr4; VendAddr[4])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(VendAddr5; VendAddr[5])
            {
            }
            column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
            {
            }
            column(VendAddr6; VendAddr[6])
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
            {
            }
            column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
            {
            }
            column(BankName_CompanyInfo; CompanyInfo."Bank Name")
            {
            }
            column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
            {
            }
            column(No1_Vend; Vendor."No.")
            {
            }
            column(TodayFormatted; FORMAT(TODAY, 0, 4))
            {
            }
            column(VendAddr7; VendAddr[7])
            {
            }
            column(VendAddr8; VendAddr[8])
            {
            }
            column(CompanyAddr7; CompanyAddr[7])
            {
            }
            column(CompanyAddr8; CompanyAddr[8])
            {
            }
            column(HeadingText; HeadingText)
            {
            }
            column(HeadingText2; HeadingText2)
            {
            }
            column(ProdOrderNoRef_RequisitionLine; "Requisition Line"."Prod. Order No. Ref")
            {
            }
            column(Quantity_RequisitionLine; "Requisition Line".Quantity)
            {
            }
            column(Description_RequisitionLine; "Requisition Line".Description)
            {
            }
            column(Description2_RequisitionLine; vG_Description2) // "Requisition Line"."Description 2"
            {
            }
            column(ExtendedDescription_RequisitionLine; "Requisition Line"."Extended Description")
            {
            }
            column(Type_RequisitionLine; "Requisition Line".Type)
            {
            }
            column(No_RequisitionLine; "Requisition Line"."No.")
            {
            }
            column(WorksheetTemplateName_RequisitionLine; "Requisition Line"."Worksheet Template Name")
            {
            }
            column(JournalBatchName_RequisitionLine; "Requisition Line"."Journal Batch Name")
            {
            }
            column(LineNo_RequisitionLine; "Requisition Line"."Line No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                vG_Description2 := "Requisition Line"."Description 2";
                if ("Requisition Line"."Description 2" = '') or ("Requisition Line"."Extended Description" = '') then begin
                    //"Requisition Line"."Description 2" := copystr("Requisition Line".Description, 1, 50);
                    vG_Description2 := "Requisition Line".Description;
                end;
            end;

            trigger OnPreDataItem();
            begin

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                rL_RequisitionWkshName.GET(vG_WorksheetName, vG_JournalBatchName);

                Vendor.GET(rL_RequisitionWkshName."Vendor No.");
                FormatAddr.Vendor(VendAddr, Vendor);

                if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound then begin
                    HeadingText := Text50001;
                    HeadingText2 := Text50003;

                end else
                    if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound then begin
                        HeadingText := Text50000;
                        HeadingText2 := Text50002;
                    end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Actions")
                {
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            "Requisition Line".SETFILTER("Worksheet Template Name", vG_WorksheetName);
            "Requisition Line".SETFILTER("Journal Batch Name", vG_JournalBatchName);
        end;
    }

    labels
    {
    }

    var
        vG_WorksheetName: Code[10];
        vG_JournalBatchName: Code[10];
        CompanyInfo: Record "Company Information";
        VendAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        Vendor: Record Vendor;
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
        Text50000: Label 'ΔΕΛΤΙΟ ΑΠΟΣΤΟΛΗΣ ΥΛΙΚΩΝ';
        Text50001: Label 'ΔΕΛΤΙΟ ΠΑΡΑΛΑΒΗΣ ΥΛΙΚΩΝ';
        HeadingText: Text;
        Text50002: TextConst ELL = 'ΠΑΡΑΔΩΣΗ ΣΤΟΝ:', ENU = 'ΠΑΡΑΔΩΣΗ ΣΤΟΝ:';
        Text50003: TextConst ELL = 'ΠΑΡΑΛΑΒΗ ΑΠΟ:', ENU = 'ΠΑΡΑΛΑΒΗ ΑΠΟ:';
        HeadingText2: Text;

        vG_Description2: Text;

    procedure SetFilters(pWorksheetName: Code[10]; pJournalBatchName: Code[10]);
    begin
        vG_WorksheetName := pWorksheetName;
        vG_JournalBatchName := pJournalBatchName;
    end;
}


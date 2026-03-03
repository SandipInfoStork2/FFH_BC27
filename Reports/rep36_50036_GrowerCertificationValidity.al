report 50036 "Grower Certification Validity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep36_50036_GrowerCertificationValidity.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Grower; Grower)
        {
            RequestFilterFields = "No.", GGN, "GGN Expiry Date", "Grower Certified";
            column(No_Vendor; Grower."No.")
            {
            }
            column(Name_Vendor; Grower.Name)
            {
            }
            column(GrowerCertified_Vendor; Format(Grower."Grower Certified"))
            {
            }
            column(GGNExpiryDate_Vendor; Format(Grower."GGN Expiry Date"))
            {
            }
            column(GGN_Vendor; Grower.GGN)
            {
            }
            column(PhoneNo_Vendor; Grower."Phone No.")
            {
            }
            column(COMPANYNAME; rL_CompanyInfo.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CountryofDestination_Grower; Grower."Country of Destination")
            {
            }

            trigger OnPreDataItem();
            begin
                Grower.SetCurrentKey("GGN Expiry Date", Name);
                Grower.SetAscending("GGN Expiry Date", false);

                //Grower.SETFILTER("Category 5",'YES');
                Grower.SetFilter(Name, '<>%1', '');

                rL_CompanyInfo.Get;
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
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        rL_CompanyInfo: Record "Company Information";
}


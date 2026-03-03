report 50001 "Simple Boxes Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep01_50001_SimpleBoxesReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header Addon"; "Purchase Header Addon")
        {
            RequestFilterFields = "No.";
            column(BuyfromVendorNo_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeaderAddon; "Purchase Header Addon"."No.")
            {
            }
            column(PaytoVendorNo_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to City")
            {
            }
            column(PaytoContact_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Contact")
            {
            }
            column(YourReference_PurchaseHeaderAddon; "Purchase Header Addon"."Your Reference")
            {
            }
            column(ShiptoCode_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to City")
            {
            }
            column(ShiptoContact_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Contact")
            {
            }
            column(OrderDate_PurchaseHeaderAddon; "Purchase Header Addon"."Order Date")
            {
            }
            column(PostingDate_PurchaseHeaderAddon; "Purchase Header Addon"."Posting Date")
            {
            }
            column(ExpectedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon"."Expected Receipt Date")
            {
            }
            column(PostingDescription_PurchaseHeaderAddon; "Purchase Header Addon"."Posting Description")
            {
            }
            column(PaymentTermsCode_PurchaseHeaderAddon; "Purchase Header Addon"."Payment Terms Code")
            {
            }
            column(DueDate_PurchaseHeaderAddon; "Purchase Header Addon"."Due Date")
            {
            }
            column(ShipmentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon"."Shipment Method Code")
            {
            }
            column(LocationCode_PurchaseHeaderAddon; "Purchase Header Addon"."Location Code")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeaderAddon; "Purchase Header Addon"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeaderAddon; "Purchase Header Addon"."Shortcut Dimension 2 Code")
            {
            }
            column(VendorPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon"."Vendor Posting Group")
            {
            }
            column(PurchaserCode_PurchaseHeaderAddon; "Purchase Header Addon"."Purchaser Code")
            {
            }
            column(OrderClass_PurchaseHeaderAddon; "Purchase Header Addon"."Order Class")
            {
            }
            column(Comment_PurchaseHeaderAddon; "Purchase Header Addon".Comment)
            {
            }
            column(NoPrinted_PurchaseHeaderAddon; "Purchase Header Addon"."No. Printed")
            {
            }
            column(OnHold_PurchaseHeaderAddon; "Purchase Header Addon"."On Hold")
            {
            }
            column(SelltoCustomerNo_PurchaseHeaderAddon; "Purchase Header Addon"."Sell-to Customer No.")
            {
            }
            column(ReasonCode_PurchaseHeaderAddon; "Purchase Header Addon"."Reason Code")
            {
            }
            column(GenBusPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon"."Gen. Bus. Posting Group")
            {
            }
            column(BuyfromVendorName_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Address")
            {
            }
            column(BuyfromAddress2_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from City")
            {
            }
            column(BuyfromContact_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Contact")
            {
            }
            column(PaytoPostCode_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Post Code")
            {
            }
            column(PaytoCounty_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to County")
            {
            }
            column(PaytoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Country/Region Code")
            {
            }
            column(BuyfromPostCode_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Post Code")
            {
            }
            column(BuyfromCounty_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from County")
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon"."Buy-from Country/Region Code")
            {
            }
            column(ShiptoPostCode_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon"."Ship-to Country/Region Code")
            {
            }
            column(BalAccountType_PurchaseHeaderAddon; "Purchase Header Addon"."Bal. Account Type")
            {
            }
            column(DocumentDate_PurchaseHeaderAddon; "Purchase Header Addon"."Document Date")
            {
            }
            column(Area_PurchaseHeaderAddon; "Purchase Header Addon".Area)
            {
            }
            column(TransactionSpecification_PurchaseHeaderAddon; "Purchase Header Addon"."Transaction Specification")
            {
            }
            column(PaymentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon"."Payment Method Code")
            {
            }
            column(PaytoContactNo_PurchaseHeaderAddon; "Purchase Header Addon"."Pay-to Contact No.")
            {
            }
            column(ResponsibilityCenter_PurchaseHeaderAddon; "Purchase Header Addon"."Responsibility Center")
            {
            }
            column(PostingfromWhseRef_PurchaseHeaderAddon; "Purchase Header Addon"."Posting from Whse. Ref.")
            {
            }
            column(LocationFilter_PurchaseHeaderAddon; "Purchase Header Addon"."Location Filter")
            {
            }
            column(RequestedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon"."Requested Receipt Date")
            {
            }
            column(PromisedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon"."Promised Receipt Date")
            {
            }
            column(DateFilter_PurchaseHeaderAddon; "Purchase Header Addon"."Date Filter")
            {
            }
            column(VendorAuthorizationNo_PurchaseHeaderAddon; "Purchase Header Addon"."Vendor Authorization No.")
            {
            }
            column(Ship_PurchaseHeaderAddon; "Purchase Header Addon".Ship)
            {
            }
            dataitem("Purchase Line Addon"; "Purchase Line Addon")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                column(LineNo_PurchaseLineAddon; "Purchase Line Addon"."Line No.")
                {
                }
                column(Type_PurchaseLineAddon; "Purchase Line Addon".Type)
                {
                }
                column(No_PurchaseLineAddon; "Purchase Line Addon"."No.")
                {
                }
                column(LocationCode_PurchaseLineAddon; "Purchase Line Addon"."Location Code")
                {
                }
                column(Description_PurchaseLineAddon; "Purchase Line Addon".Description)
                {
                }
                column(UnitofMeasure_PurchaseLineAddon; "Purchase Line Addon"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLineAddon; "Purchase Line Addon".Quantity)
                {
                }
                column(VariantCode_PurchaseLineAddon; "Purchase Line Addon"."Variant Code")
                {
                }
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
}


report 50003 "Simple Boxes Posted Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep03_50003_SimpleBoxesPostedReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header Addon Posted"; "Purchase Header Addon Posted")
        {
            RequestFilterFields = "No.";
            column(BuyfromVendorNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeaderAddon; "Purchase Header Addon Posted"."No.")
            {
            }
            column(PaytoVendorNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to City")
            {
            }
            column(PaytoContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Contact")
            {
            }
            column(YourReference_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Your Reference")
            {
            }
            column(ShiptoCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to City")
            {
            }
            column(ShiptoContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Contact")
            {
            }
            column(OrderDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Order Date")
            {
            }
            column(PostingDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting Date")
            {
            }
            column(ExpectedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Expected Receipt Date")
            {
            }
            column(PostingDescription_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting Description")
            {
            }
            column(PaymentTermsCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Payment Terms Code")
            {
            }
            column(DueDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Due Date")
            {
            }
            column(ShipmentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shipment Method Code")
            {
            }
            column(LocationCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Location Code")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Shortcut Dimension 2 Code")
            {
            }
            column(VendorPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Vendor Posting Group")
            {
            }
            column(PurchaserCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Purchaser Code")
            {
            }
            column(OrderClass_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Order Class")
            {
            }
            column(Comment_PurchaseHeaderAddon; "Purchase Header Addon Posted".Comment)
            {
            }
            column(NoPrinted_PurchaseHeaderAddon; "Purchase Header Addon Posted"."No. Printed")
            {
            }
            column(OnHold_PurchaseHeaderAddon; "Purchase Header Addon Posted"."On Hold")
            {
            }
            column(SelltoCustomerNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Sell-to Customer No.")
            {
            }
            column(ReasonCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Reason Code")
            {
            }
            column(GenBusPostingGroup_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Gen. Bus. Posting Group")
            {
            }
            column(BuyfromVendorName_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Address")
            {
            }
            column(BuyfromAddress2_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from City")
            {
            }
            column(BuyfromContact_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Contact")
            {
            }
            column(PaytoPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Post Code")
            {
            }
            column(PaytoCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to County")
            {
            }
            column(PaytoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Country/Region Code")
            {
            }
            column(BuyfromPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Post Code")
            {
            }
            column(BuyfromCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from County")
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Buy-from Country/Region Code")
            {
            }
            column(ShiptoPostCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Ship-to Country/Region Code")
            {
            }
            column(BalAccountType_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Bal. Account Type")
            {
            }
            column(DocumentDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Document Date")
            {
            }
            column(Area_PurchaseHeaderAddon; "Purchase Header Addon Posted".Area)
            {
            }
            column(TransactionSpecification_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Transaction Specification")
            {
            }
            column(PaymentMethodCode_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Payment Method Code")
            {
            }
            column(PaytoContactNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Pay-to Contact No.")
            {
            }
            column(ResponsibilityCenter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Responsibility Center")
            {
            }
            column(PostingfromWhseRef_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Posting from Whse. Ref.")
            {
            }
            column(LocationFilter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Location Filter")
            {
            }
            column(RequestedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Requested Receipt Date")
            {
            }
            column(PromisedReceiptDate_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Promised Receipt Date")
            {
            }
            column(DateFilter_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Date Filter")
            {
            }
            column(VendorAuthorizationNo_PurchaseHeaderAddon; "Purchase Header Addon Posted"."Vendor Authorization No.")
            {
            }
            column(Ship_PurchaseHeaderAddon; "Purchase Header Addon Posted".Ship)
            {
            }
            dataitem("Purchase Line Addon Posted"; "Purchase Line Addon Posted")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                column(LineNo_PurchaseLineAddon; "Purchase Line Addon Posted"."Line No.")
                {
                }
                column(Type_PurchaseLineAddon; "Purchase Line Addon Posted".Type)
                {
                }
                column(No_PurchaseLineAddon; "Purchase Line Addon Posted"."No.")
                {
                }
                column(LocationCode_PurchaseLineAddon; "Purchase Line Addon Posted"."Location Code")
                {
                }
                column(Description_PurchaseLineAddon; "Purchase Line Addon Posted".Description)
                {
                }
                column(UnitofMeasure_PurchaseLineAddon; "Purchase Line Addon Posted"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLineAddon; "Purchase Line Addon Posted".Quantity)
                {
                }
                column(VariantCode_PurchaseLineAddon; "Purchase Line Addon Posted"."Variant Code")
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


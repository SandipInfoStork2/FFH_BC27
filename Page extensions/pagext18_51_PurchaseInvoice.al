/*
TAL0.1 2017/12/07 VC design Pay-to Name

*/
pageextension 50118 PurchaseInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Pay-to Name2"; "Pay-to Name")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Name';
                //Editable = PayToOptions = PayToOptions::"Another Vendor";
                Enabled = PayToOptions = PayToOptions::"Another Vendor";
                //Importance = Promoted;
                NotBlank = true;
                ToolTip = 'Specifies the name of the vendor sending the invoice.';

                trigger OnValidate()
                var
                    ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                begin
                    if GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                        if "Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                            SetRange("Pay-to Vendor No.");

                    CurrPage.SaveRecord;
                    //if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                    //    PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);

                    CurrPage.Update(false);
                end;
            }
        }

        modify("Posting Description")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
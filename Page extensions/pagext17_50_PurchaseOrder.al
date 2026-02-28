/*
TAL0.1 2017/12/07 VC design Pay-to Name
TAL0.2 2019/01/03 VC add Deliver to vendor fields 
TAL0.3 2021/04/06 VC add PrintAppendixRecords
TAL0.4 2021/04/09 VC Design field Receiving No.
TAL0.5 2021/12/22 VC add action Print Delivery Order (Drop)

*/

pageextension 50117 PurchaseOrderExt extends "Purchase Order"
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
                //Enabled = PayToOptions = PayToOptions::"Another Vendor";
                Importance = Promoted;
                ToolTip = 'Specifies the name of the vendor sending the invoice.';

                trigger OnValidate()
                begin
                    if GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                        if "Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                            SetRange("Pay-to Vendor No.");

                    CurrPage.Update();
                end;
            }
        }

        addafter("Promised Receipt Date")
        {
            field("Receiving No."; "Receiving No.")
            {
                ApplicationArea = all;
            }
        }


        addbefore(Control94)
        {
            group("Deliver to Vendor")
            {
                Caption = 'Deliver to Vendor';
                field("Deliver-to Vendor No."; "Deliver-to Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Deliver-to Name"; "Deliver-to Name")
                {
                    ApplicationArea = all;
                }
                field("Deliver Address Code"; "Deliver Address Code")
                {
                    ApplicationArea = all;
                }
            }
        }

        modify("Expected Receipt Date")
        {
            ShowMandatory = true;
        }
        addafter("Expected Receipt Date")
        {
            field("Expected Receipt Time"; "Expected Receipt Time")
            {
                ApplicationArea = all;
                //ShowMandatory = true;
            }
        }


        addafter(Status)
        {
            field("Location Code2"; "Location Code")
            {
                ApplicationArea = Location;
                ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                ShowMandatory = true;
            }
            field("Expected Receipt Date2"; "Expected Receipt Date")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Expected Receipt Time2"; "Expected Receipt Time")
            {
                ApplicationArea = all;
                //ShowMandatory = true;
            }
            field("Transfer-from Code"; "Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Code"; "Transfer-to Code")
            {
                ApplicationArea = All;
            }
        }


        addafter(Prepayment)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Receiving Temperature"; "Receiving Temperature")
                {
                    ApplicationArea = all;
                }
                field("Receiving Quality Control"; "Receiving Quality Control")
                {
                    ApplicationArea = all;
                }
            }
        }

    }

    actions
    {
        // Add changes to page actions herea
        addbefore(CalculateInvoiceDiscount)
        {
            action("Create Lots")
            {
                ApplicationArea = all;
                Image = CreateSerialNo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.POCreateLot("No.");
                end;
            }
        }

        addafter("&Print")
        {
            action(PrintDeliveryOrderDrop)
            {
                ApplicationArea = Suite;
                Caption = '&Print Delivery Order (Drop)';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction();
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    //+TAL0.5
                    PurchaseHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                    REPORT.RUN(REPORT::"Purchase Delivery Order", true, false, PurchaseHeader);
                    //-TAL0.5
                end;
            }
            action("Item Tracking Appendix")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    vL_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SETSELECTIONFILTER(vL_PurchaseHeader);
                    vL_PurchaseHeader.PrintAppendixRecords(vL_PurchaseHeader);
                end;
            }
        }

    }

    var
        myInt: Integer;
}
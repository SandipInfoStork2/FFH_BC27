/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
TAL0.2 2018/07/22 VC add field Batch No. 
TAL0.3 2019/09/17 VC add missing logic for Print to print for a specific customer, bill-to customer No. was always blank 
TAL0.4 2020/03/04 VC add Delivery fields, make editable for Deliveries 
TAL0.5 2020/03/06 VC add field Chain of Custody Tracking
TAL0.6 2021/04/06 VC add PrintAppendixRecords
*/
pageextension 50126 PostedSalesShipmentExt extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Batch No."; "Batch No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Lot No."; "Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }

        addafter("Responsibility Center")
        {
            field("Delivery No."; "Delivery No.")
            {
                ApplicationArea = All;
            }
            field("Delivery Sequence"; "Delivery Sequence")
            {
                ApplicationArea = All;
            }
        }

        addafter("External Document No.")
        {
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Delivery Sequence")
        {
            field("Transfer-from Code"; "Transfer-from Code")
            {
                ApplicationArea = All;
                Editable = False;
            }
            field("Transfer-to Code"; "Transfer-to Code")
            {
                ApplicationArea = All;
                Editable = False;
            }
        }

        addafter(Billing)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Shipping Temperature"; "Shipping Temperature")
                {
                    ApplicationArea = all;
                    Editable = False;
                }
                field("Shipping Quality Control"; "Shipping Quality Control")
                {
                    ApplicationArea = all;
                    Editable = False;
                }
            }
        }


    }

    actions
    {
        // Add changes to page actions here

        /*
        addafter("Co&mments_Promoted")
        {
            actionref("Co&mments_Promoted"; "Co&mments")
            {
            }
        }
        */




        addafter(PrintCertificateofSupply)
        {
            action(DeliverySchedule)
            {
                ApplicationArea = All;
                Caption = 'Delivery Schedule';
                RunObject = Page "Delivery Schedule List";
            }

            action(PostedInvtPickList)
            {
                ApplicationArea = All;
                Caption = 'Posted Invt. Pick List';
                RunObject = Page "Posted Invt. Pick List";
                RunPageLink = "Source No." = field("No.");
            }
        }

        addafter("&Print")
        {
            action("Item Tracking Appendix")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.PrintAppendixRecords(SalesShipmentHeader);
                end;
            }

            action("Item Tracking Appendix Quality")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.PrintAppendixRecordsQuality(SalesShipmentHeader);
                end;
            }
        }


        addafter("Co&mments")
        {

            action(Customer)
            {

                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                Image = Customer;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Sell-to Customer No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the customer.';
            }

        }

    }

    var
        myInt: Integer;
}
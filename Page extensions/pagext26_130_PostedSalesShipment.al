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
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }

        }

        addafter("Responsibility Center")
        {
            field("Delivery No."; Rec."Delivery No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery No. field.';
            }
            field("Delivery Sequence"; Rec."Delivery Sequence")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Sequence field.';
            }
        }

        addafter("External Document No.")
        {
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
            }
        }
        addafter("Delivery Sequence")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
        }

        addafter(Billing)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Shipping Temperature"; Rec."Shipping Temperature")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
                }
                field("Shipping Quality Control"; Rec."Shipping Quality Control")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shipping Quality Control field.';
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
                RunObject = page "Delivery Schedule List";
                ToolTip = 'Executes the Delivery Schedule action.';
            }

            action(PostedInvtPickList)
            {
                ApplicationArea = All;
                Caption = 'Posted Invt. Pick List';
                RunObject = page "Posted Invt. Pick List";
                RunPageLink = "Source No." = field("No.");
                ToolTip = 'Executes the Posted Invt. Pick List action.';
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
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
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
                ToolTip = 'Executes the Item Tracking Appendix Quality action.';

                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
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
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Sell-to Customer No.");
                ShortcutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the customer.';
            }

        }

    }

    var
        myInt: Integer;
}
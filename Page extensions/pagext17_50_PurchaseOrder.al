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
            field("Pay-to Name2"; Rec."Pay-to Name")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Name';
                //Editable = PayToOptions = PayToOptions::"Another Vendor";
                //Enabled = PayToOptions = PayToOptions::"Another Vendor";
                Importance = Promoted;
                ToolTip = 'Specifies the name of the vendor sending the invoice.';

                trigger OnValidate()
                begin
                    if Rec.GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                        if Rec."Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                            Rec.SetRange("Pay-to Vendor No.");

                    CurrPage.Update();
                end;
            }
        }

        addafter("Promised Receipt Date")
        {
            field("Receiving No."; Rec."Receiving No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving No. field.';
            }
        }


        addbefore(Control94)
        {
            group("Deliver to Vendor")
            {
                Caption = 'Deliver to Vendor';
                field("Deliver-to Vendor No."; Rec."Deliver-to Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deliver-to Vendor No. field.';
                }
                field("Deliver-to Name"; Rec."Deliver-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deliver-to Name field.';
                }
                field("Deliver Address Code"; Rec."Deliver Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deliver Address Code field.';
                }
            }
        }

        modify("Expected Receipt Date")
        {
            ShowMandatory = true;
        }
        addafter("Expected Receipt Date")
        {
            field("Expected Receipt Time"; Rec."Expected Receipt Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expected Receipt Time field.';
                //ShowMandatory = true;
            }
        }


        addafter(Status)
        {
            field("Location Code2"; Rec."Location Code")
            {
                ApplicationArea = Location;
                ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                ShowMandatory = true;
            }
            field("Expected Receipt Date2"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
            }
            field("Expected Receipt Time2"; Rec."Expected Receipt Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expected Receipt Time field.';
                //ShowMandatory = true;
            }
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
        }


        addafter(Prepayment)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Receiving Temperature"; Rec."Receiving Temperature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
                }
                field("Receiving Quality Control"; Rec."Receiving Quality Control")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receiving Quality Control field.';
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
                ApplicationArea = All;
                Image = CreateSerialNo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Create Lots action.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    //
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.POCreateLot(Rec."No.");
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
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    Report.Run(Report::"Purchase Delivery Order", true, false, PurchaseHeader);
                    //-TAL0.5
                end;
            }
            action("Item Tracking Appendix")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Item Tracking Appendix action.';
                ApplicationArea = All;

                trigger OnAction();
                var
                    vL_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(vL_PurchaseHeader);
                    vL_PurchaseHeader.PrintAppendixRecords(vL_PurchaseHeader);
                end;
            }
        }

    }

    var
        myInt: Integer;
}
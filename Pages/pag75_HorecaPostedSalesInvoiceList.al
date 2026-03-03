page 50075 "Horeca SIH List"
{


    //ApplicationArea = Basic, Suite, Assembly;
    Caption = 'Posted Sales Invoices';
    CardPageId = "Horeca SIH";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Horeca Posted Sales Invoices';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    ApplicationArea = All;
    //UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted invoice number.';
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }



                //field("Requested Delivery Date"; Rec."Requested Delivery Date")
                //{
                //    ApplicationArea = All;
                //}


                field(OnSchedule; OnSchedule)
                {
                    ApplicationArea = All;
                    Caption = 'On Schedule';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Schedule field.';
                }

                /*
                field("Requested Delivery Time"; Rec."Requested Delivery Time")
                {
                    ApplicationArea = All;
                }
                */


                /*
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                */

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }


                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }

                field(UniqueItemsToShip; vG_OrderUniqueItems)
                {
                    ApplicationArea = All;
                    Caption = 'Total SKU';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total SKU field.';
                }


                /*
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                */



                /*
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = All;
                }
                field("Total Qty Shipped"; Rec."Total Qty Shipped")
                {
                    ApplicationArea = All;
                }
                */

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include VAT.';

                    /*
                    trigger OnDrillDown()
                    begin
                        DoDrillDown();
                    end;
                    */
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';

                    /*
                    trigger OnDrillDown()
                    begin
                        DoDrillDown();
                    end;
                    */
                }



            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {


        /*
        area(Processing)
        {
        
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
        */

        area(Processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                //Visible = NOT IsOfficeAddin;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    rptSalesInvoice: Report "Sales - Invoice HORECA";
                begin
                    SalesInvoiceHeader := Rec;
                    //OnBeforePrintRecords(Rec, SalesShptHeader);
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    //SalesShptHeader.PrintRecords(true);

                    Clear(rptSalesInvoice);
                    rptSalesInvoice.SetTableView(SalesInvoiceHeader);
                    rptSalesInvoice.UseRequestPage(false);
                    rptSalesInvoice.Run();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
    begin

    end;

    trigger OnAfterGetRecord()
    var
        cuGeneralMgt: Codeunit "General Mgt.";
    begin
        OnSchedule := cuGeneralMgt.GetScheduleDays(Rec."Sell-to Customer No.", Rec."Ship-to Code");


        GetNetWeight(vG_NetWeight, vG_GrossWeight, vG_OrderUniqueItems);
    end;

    trigger OnInit()
    begin

    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CRMConnectionSetup: Record "CRM Connection Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
    begin
        Rec.SetSecurityFilterOnCustomer(vG_GLOBAL_StoreCode);
        //SetRange("Date Filter", 0D, WorkDate());

        Rec.SetCurrentKey(SystemCreatedAt);
        Rec.Ascending := false;
    end;

    procedure GetNetWeight(var pNetWeight: Decimal; var pGrossWeight: Decimal; var pUniqueItems: Integer): Decimal;
    var
        oldItemNo: Code[20];
        SalesLine: Record "Sales Invoice Line";
    begin
        pNetWeight := 0;
        pGrossWeight := 0;
        pUniqueItems := 0;
        oldItemNo := '';

        //SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.Reset;
        SalesLine.SetCurrentKey("Document No.", "No.");
        SalesLine.SetFilter("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity, '>%1', 0);
        if SalesLine.FindSet then
            repeat
                pNetWeight += SalesLine."Net Weight" * SalesLine.Quantity;
                pGrossWeight += SalesLine."Gross Weight" * SalesLine.Quantity;

                if (oldItemNo <> SalesLine."No.") then begin //and (pNetWeight <> 0)
                    pUniqueItems += 1;
                end;

                oldItemNo := SalesLine."No.";
            until SalesLine.Next = 0;
    end;

    procedure SetGLOBALStoreCode(pGLOBALStoreCode: Code[10])
    var
        myInt: Integer;
    begin
        vG_GLOBAL_StoreCode := pGLOBALStoreCode;
    end;

    var

        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        OnSchedule: Text;
        StatusStyleTxt: Text;
        HorecaStatusStyleTxt: Text;


        rG_Date: Record Date;

        vG_NetWeight: Decimal;
        vG_GrossWeight: Decimal;
        vG_OrderUniqueItems: Integer;

        vG_GLOBAL_StoreCode: Code[10];
}
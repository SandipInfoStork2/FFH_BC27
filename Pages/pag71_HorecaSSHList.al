page 50071 "Horeca SSH List"
{


    //ApplicationArea = Basic, Suite, Assembly;
    Caption = 'Posted Sales Shipments';
    CardPageId = "Horeca SSH";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Horeca Posted Sales Shipments';
    RefreshOnActivate = true;
    SourceTable = "Sales Shipment Header";
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
                    ToolTip = 'Specifies the number of the record.';
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the customer''s additional shipment address.';
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer that you delivered the items to.';
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date for the entry.';
                }



                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }


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
                    ToolTip = 'Specifies the name of customer at the sell-to address.';
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
                    SalesShptHeader: Record "Sales Shipment Header";
                    rptSalesShipment: Report "Sales - Shipment HORECA";
                begin
                    SalesShptHeader := Rec;
                    //OnBeforePrintRecords(Rec, SalesShptHeader);
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    //SalesShptHeader.PrintRecords(true);

                    Clear(rptSalesShipment);
                    rptSalesShipment.SetTableView(SalesShptHeader);
                    rptSalesShipment.UseRequestPage(false);
                    rptSalesShipment.Run();
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
        SalesLine: Record "Sales Shipment Line";
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
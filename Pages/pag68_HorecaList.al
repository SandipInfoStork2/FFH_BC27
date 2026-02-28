page 50068 "Horeca Order List"
{


    //ApplicationArea = Basic, Suite, Assembly;
    Caption = 'Orders';
    CardPageID = "Horeca Order";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    QueryCategory = 'Horeca Order List';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST(Order));
    //UsageCategory = Lists;

    layout
    {

        area(Content)
        {
            /*
            group(header)
            {
                caption = '';
                field(GLOBAL_StoreCode; vG_GLOBAL_StoreCode)
                {
                    caption = 'Store:';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            */

            repeater(GroupName)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + 'Ship-to Code '+ vG_GLOBAL_StoreCode;
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }



                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Name Day of The WeekGR"; vG_NameDayofTheWeekGR)
                {
                    caption = 'Requested Delivery Day Gr';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Name Day of The Week"; vG_NameDayofTheWeek)
                {
                    caption = 'Requested Delivery Day';
                    Editable = false;
                    ApplicationArea = All;
                }

                field(OnSchedule; OnSchedule)
                {
                    ApplicationArea = All;
                    Caption = 'On Schedule';
                    Editable = false;
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

                field(SystemCreatedAt; SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleTxt;
                    Visible = false;
                }

                field("HORECA Status"; "HORECA Status")
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    StyleExpr = HorecaStatusStyleTxt;

                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }

                field(UniqueItemsToShip; vG_OrderUniqueItems)
                {
                    ApplicationArea = All;
                    Caption = 'Total SKU';
                    Editable = false;
                }

                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of amounts, including VAT, on all the lines in the document. This will include invoice discounts.';
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
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Creation)
        {


            action(NewOrder)
            {
                ApplicationArea = All;
                Caption = 'New Order';
                Image = New;
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesHeaderCheck: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    UserSetup: Record "User Setup";
                    ShiptoAddress: Record "Ship-to Address";

                    StandardSalesLine: Record "Standard Sales Line";
                    LineNo: Integer;
                    NextDateCalculated: Boolean;
                    WeekDay: Integer;
                    MinNextDeliveryDate: Date;
                    NextDeliveryDate1: Date;
                    NextDeliveryDate2: Date;
                    TempDate1: Date;
                    TempDate2: Date;
                    Text50000: Label 'Duplicate Order %3 found Ship-to Code: %1 Requested Delivery Date: %2';
                    Text50001: Label 'Store not selected.';
                    Text50002: Label 'Only one order should be at a time. Please update Order %1';
                    pHorecaOrder: Page "Horeca Order";
                begin

                    //check if the order already exists

                    //Message(vG_GLOBAL_StoreCode);


                    NextDeliveryDate1 := 0D;
                    NextDeliveryDate2 := 0D;
                    MinNextDeliveryDate := 0D;

                    UserSetup.GET(UserId);

                    if vG_GLOBAL_StoreCode = '' then begin
                        ShiptoAddress.RESET;
                        //ShiptoAddress.SetCurrentKey("Customer No.",Code, City, Name);
                        ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
                        ShiptoAddress.SetFilter(Code, '%1', UserSetup."HORECA Ship-to Filter");
                        ShiptoAddress.SetRange(Blocked, false);
                        if ShiptoAddress.FindSet() then begin
                            IF PAGE.RUNMODAL(PAGE::"Ship-to Address List", ShiptoAddress) = ACTION::LookupOK THEN BEGIN

                            END ELSE BEGIN
                                EXIT;
                            END;
                        end;

                    end else begin

                        ShiptoAddress.RESET;
                        ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
                        ShiptoAddress.SetFilter(Code, '%1', vG_GLOBAL_StoreCode);
                        ShiptoAddress.SetRange(Blocked, false);
                        if ShiptoAddress.FindSet() then begin

                        end;
                    end;

                    if ShiptoAddress.Code = '' then begin
                        Error(Text50001);
                    end;

                    SalesHeaderCheck.RESET;
                    SalesHeaderCheck.SetRange("Document Type", SalesHeaderCheck."Document Type"::Order);
                    SalesHeaderCheck.SetFilter("Sell-to Customer No.", ShiptoAddress."Customer No.");
                    SalesHeaderCheck.SetFilter("Ship-to Code", ShiptoAddress.Code);
                    if SalesHeaderCheck.Count > 0 then begin
                        if SalesHeaderCheck.FindFirst() then begin
                            Error(Text50002, SalesHeaderCheck."No.");
                        end;
                    end;


                    SalesHeader.RESET;
                    SalesHeader.Init();
                    SalesHeader.SetHideValidationDialog(true);
                    SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.Validate("Sell-to Customer No.", ShiptoAddress."Customer No.");
                    SalesHeader.Validate("Ship-to Code", ShiptoAddress.Code);
                    SalesHeader.Validate("External Document No.", ShiptoAddress.Name);
                    SalesHeader.Insert(true);

                    //CALCULATE next Delivery Date
                    SalesHeader."Requested Delivery Date" := CalcDate(UserSetup."HORECA Min. Order Period", WorkDate());
                    SalesHeader.validate("Document Date", SalesHeader."Requested Delivery Date");
                    SalesHeader.validate("Order Date", SalesHeader."Requested Delivery Date");
                    SalesHeader.validate("Shipment Date", SalesHeader."Requested Delivery Date");
                    SalesHeader.validate("Posting Date", SalesHeader."Requested Delivery Date");

                    MinNextDeliveryDate := SalesHeader."Requested Delivery Date";

                    WeekDay := Date2DWY(SalesHeader."Requested Delivery Date", 1);

                    if ShiptoAddress.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then begin
                        if (ShiptoAddress.Monday) then begin
                            NextDeliveryDate1 := CalcDate('WD1', MinNextDeliveryDate);

                            if WeekDay = 1 then begin
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;
                        end;

                        if (ShiptoAddress.Tuesday) then begin
                            NextDeliveryDate1 := CalcDate('WD2', MinNextDeliveryDate);

                            if WeekDay = 2 then begin
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;
                        end;

                        if (ShiptoAddress.Wednesday) then begin
                            NextDeliveryDate1 := CalcDate('WD3', MinNextDeliveryDate);

                            if WeekDay = 3 then begin
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;
                        end;

                        if (ShiptoAddress.Thursday) then begin
                            NextDeliveryDate2 := CalcDate('WD4', MinNextDeliveryDate);
                            if WeekDay = 4 then begin
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;
                        end;

                        if (ShiptoAddress.Friday) then begin
                            NextDeliveryDate2 := CalcDate('WD5', MinNextDeliveryDate);
                            if WeekDay = 5 then begin
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                        end;

                        if (ShiptoAddress.Saturday) then begin
                            NextDeliveryDate2 := CalcDate('WD6', MinNextDeliveryDate);
                            if WeekDay = 6 then begin
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                        end;

                        if (ShiptoAddress.Sunday) then begin
                            NextDeliveryDate2 := CalcDate('WD7', MinNextDeliveryDate);
                            if WeekDay = 7 then begin
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                        end;

                        if NextDeliveryDate1 > NextDeliveryDate2 then begin
                            TempDate1 := NextDeliveryDate1;
                            TempDate2 := NextDeliveryDate2;
                            NextDeliveryDate1 := TempDate2;
                            NextDeliveryDate2 := TempDate1;
                        end;

                        if NextDeliveryDate1 <> 0D then begin
                            SalesHeader.validate("Requested Delivery Date", NextDeliveryDate1);
                            SalesHeader.validate("Document Date", SalesHeader."Requested Delivery Date");
                            SalesHeader.validate("Order Date", SalesHeader."Requested Delivery Date");
                            SalesHeader.validate("Shipment Date", SalesHeader."Requested Delivery Date");
                            SalesHeader.validate("Posting Date", SalesHeader."Requested Delivery Date");
                        end;

                        SalesHeader.Modify(true);


                        //+1.0.0.262
                        //check if order already exists
                        SalesHeaderCheck.RESET;
                        SalesHeaderCheck.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeaderCheck.SetFilter("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                        SalesHeaderCheck.SetFilter("Ship-to Code", SalesHeader."Ship-to Code");
                        SalesHeaderCheck.SetFilter("Requested Delivery Date", '%1', SalesHeader."Requested Delivery Date");
                        if SalesHeaderCheck.Count > 1 then begin
                            if SalesHeaderCheck.FindFirst() then begin
                                Error(Text50000, SalesHeaderCheck."Ship-to Code", SalesHeaderCheck."Requested Delivery Date", SalesHeaderCheck."No.");
                            end;
                        end;
                        //-1.0.0.262


                        StandardSalesLine.RESET;
                        StandardSalesLine.SetFilter("Standard Sales Code", UserSetup."HORECA Items");
                        if StandardSalesLine.FindSet() then begin
                            repeat
                                LineNo += 10000;
                                clear(SalesLine);
                                SalesHeader.SetHideValidationDialog(true);
                                SalesLine.validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                SalesLine.Validate("Line No.", LineNo);
                                SalesLine.Insert(true);

                                SalesLine.Validate(Type, StandardSalesLine.Type);
                                SalesLine.Validate("No.", StandardSalesLine."No.");
                                SalesLine.validate(Description, StandardSalesLine.Description);
                                SalesLine.Modify(true);

                                SalesLine.ValidateShortcutDimCode(5, SalesHeader."Ship-to Code");
                                SalesLine.Modify(true);
                            until StandardSalesLine.Next() = 0;
                        end;

                        //Message(SalesHeader."No.");
                        commit;
                        CurrPage.Update(true);

                        // Page.Run(page::"Horeca Order", SalesHeader);
                        clear(pHorecaOrder);
                        pHorecaOrder.SetGLOBALStoreCode(vG_GLOBAL_StoreCode);
                        pHorecaOrder.SetRecord(SalesHeader);
                        //pHorecaOrder.SetTableView(SalesHeader);
                        //pHorecaOrder.SetSelectionFilter(SalesHeader);
                        pHorecaOrder.Run();

                    end;
                end;
            }
        }
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

        area(processing)
        {
            action("Print Confirmation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Confirmation';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Print an order confirmation. A report request window opens where you can specify what to include on the print-out.';
                //Visible = NOT IsOfficeAddin;
                PromotedOnly = true;
                Promoted = true;
                //PromotedCategory = Report;

                trigger OnAction()
                var
                    //rpt50025: Report "Order Confirmation - KP";

                    rptOrderConfirmation: Report "Order Confirmation HORECA";
                    salesHeader: Record "Sales Header";
                begin
                    salesHeader := Rec;
                    CurrPage.SetSelectionFilter(salesHeader);

                    clear(rptOrderConfirmation);
                    rptOrderConfirmation.SetTableView(salesHeader);
                    rptOrderConfirmation.UseRequestPage(false);
                    rptOrderConfirmation.Run();
                    //DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                end;
            }
        }
        area(Navigation)
        {
            /*
            //shipments not used
            action(SSHHistory)
            {
                ApplicationArea = All;
                Caption = 'History';
                Image = History;

                trigger OnAction()
                var
                    

                    SSH: Record "Sales Shipment Header";
                    UserSetup: Record "User Setup";
                    pHorecaSSHList: page "Horeca SSH List";
                begin
                    UserSetup.GET(UserId);
                    UserSetup.TestField("HORECA Customer No.");
                    UserSetup.TestField("HORECA Ship-to Filter");


                    //Message(vG_GLOBAL_StoreCode);
                    SSH.Reset();
                    SSH.FilterGroup(2);
                    SSH.SetFilter("Sell-to Customer No.", '%1', UserSetup."HORECA Customer No.");

                    if vG_GLOBAL_StoreCode = '' then begin
                        SSH.SetFilter("Ship-to Code", '%1', UserSetup."HORECA Ship-to Filter");
                    end else begin
                        SSH.SetFilter("Ship-to Code", '%1', vG_GLOBAL_StoreCode);
                    end;
                    SSH.FilterGroup(0);
                    //Page.Run(Page::"Horeca SSH List", SSH);

                    clear(pHorecaSSHList);
                    pHorecaSSHList.SetGLOBALStoreCode(vG_GLOBAL_StoreCode);
                    pHorecaSSHList.SetTableView(SSH);
                    pHorecaSSHList.Run();
                end;


            }
            */

            action(SIHHistory)
            {
                ApplicationArea = All;
                Caption = 'History';
                Image = History;
                PromotedOnly = true;
                Promoted = true;

                trigger OnAction()
                var


                    SIH: Record "Sales Invoice Header";
                    UserSetup: Record "User Setup";
                    pHorecaSIHList: page "Horeca SIH List";
                begin
                    UserSetup.GET(UserId);
                    UserSetup.TestField("HORECA Customer No.");
                    UserSetup.TestField("HORECA Ship-to Filter");


                    //Message(vG_GLOBAL_StoreCode);
                    SIH.Reset();
                    SIH.FilterGroup(2);
                    SIH.SetFilter("Sell-to Customer No.", '%1', UserSetup."HORECA Customer No.");

                    if vG_GLOBAL_StoreCode = '' then begin
                        SIH.SetFilter("Ship-to Code", '%1', UserSetup."HORECA Ship-to Filter");
                    end else begin
                        SIH.SetFilter("Ship-to Code", '%1', vG_GLOBAL_StoreCode);
                    end;
                    SIH.FilterGroup(0);
                    //Page.Run(Page::"Horeca SSH List", SSH);

                    clear(pHorecaSIHList);
                    pHorecaSIHList.SetGLOBALStoreCode(vG_GLOBAL_StoreCode);
                    pHorecaSIHList.SetTableView(SIH);
                    pHorecaSIHList.Run();
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
        OnSchedule := cuGeneralMgt.GetScheduleDays("Sell-to Customer No.", "Ship-to Code");

        StatusStyleTxt := GetStatusStyleText();
        HorecaStatusStyleTxt := GetHorecaStatusStyleText();

        vG_NameDayofTheWeek := '';
        vG_NameDayofTheWeekGr := '';
        if "Requested Delivery Date" <> 0D then begin
            rG_Date.GET(rG_Date."Period Type"::Date, "Requested Delivery Date");
            vG_NameDayofTheWeek := rG_Date."Period Name";

            case vG_NameDayofTheWeek of

                //1
                'Monday':
                    begin
                        vG_NameDayofTheWeekGR := 'Δευτέρα';
                    end;

                //2
                'Tuesday':
                    begin
                        vG_NameDayofTheWeekGR := 'Τρίτη';
                    end;
                //3
                'Wednesday':
                    begin
                        vG_NameDayofTheWeekGR := 'Τετάρτη';
                    end;

                //4
                'Thursday':
                    begin
                        vG_NameDayofTheWeekGR := 'Πέμπτη';
                    end;

                //5
                'Friday':
                    begin
                        vG_NameDayofTheWeekGR := 'Παρασκευή';
                    end;

                //6
                'Saturday':
                    begin
                        vG_NameDayofTheWeekGR := 'Σάββατο';
                    end;

                //7
                'Sunday':
                    begin
                        vG_NameDayofTheWeekGR := 'Κυριακή';
                    end;
            end;
        end;

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
        pHORECAPasswordDialog: page "HORECA Password Dialog";
        storepassword: Text;
        Text50000: Label 'Password not specified';
        Text50001: Label 'Store not found.';
        ShiptoAddress: Record "Ship-to Address";
        UserSetup: Record "User Setup";
    begin

        clear(pHORECAPasswordDialog);
        pHORECAPasswordDialog.RunModal();
        storepassword := pHORECAPasswordDialog.GetPasswordValue();
        if storepassword = '' then begin
            Error(Text50000);
        end;

        //Message(storepassword);

        UserSetup.GET(UserId);
        UserSetup.TestField("HORECA Customer No.");
        UserSetup.TestField("HORECA Ship-to Filter");

        ShiptoAddress.RESET;
        ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
        //ShiptoAddress.SetFilter(Code, '%1', Rec."HORECA Ship-to Filter");
        ShiptoAddress.SetFilter("Shop Password", '%1', storepassword);
        ShiptoAddress.SetRange(Blocked, false);
        if ShiptoAddress.FindSet() then begin
            //PAGE.RUN(PAGE::"Ship-to Address List", ShiptoAddress);
        end else begin
            Error(Text50001);
        end;

        vG_GLOBAL_StoreCode := ShiptoAddress.Code;
        //Message(vG_GLOBAL_StoreCode);


        Rec.SetSecurityFilterOnCustomer(vG_GLOBAL_StoreCode);
        SetRange("Date Filter", 0D, WorkDate());

        Rec.SetCurrentKey(SystemCreatedAt);
        Rec.Ascending := false;
    end;

    procedure GetNetWeight(var pNetWeight: Decimal; var pGrossWeight: Decimal; var pUniqueItems: Integer): Decimal;
    var
        oldItemNo: Code[20];
        SalesLine: Record "Sales Line";
    begin
        pNetWeight := 0;
        pGrossWeight := 0;
        pUniqueItems := 0;
        oldItemNo := '';

        //SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Document Type", "Document No.", "No.");
        SalesLine.SetRange("Document Type", rec."Document Type");
        SalesLine.SetFilter("Document No.", Rec."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity, '>%1', 0);
        if SalesLine.FINDSET then
            repeat
                pNetWeight += SalesLine."Net Weight" * SalesLine.Quantity;
                pGrossWeight += SalesLine."Gross Weight" * SalesLine.Quantity;

                if (oldItemNo <> SalesLine."No.") then begin //and (pNetWeight <> 0)
                    pUniqueItems += 1;
                end;

                oldItemNo := SalesLine."No.";
            until SalesLine.NEXT = 0;
    end;

    var

        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        OnSchedule: Text;
        StatusStyleTxt: Text;
        HorecaStatusStyleTxt: Text;

        vG_NameDayofTheWeek: Text;
        vG_NameDayofTheWeekGR: Text;
        rG_Date: Record Date;

        vG_NetWeight: Decimal;
        vG_GrossWeight: Decimal;
        vG_OrderUniqueItems: Integer;
        vG_GLOBAL_StoreCode: Code[10];
}
page 50069 "Horeca Order"
{

    Caption = 'Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    InsertAllowed = false;
    //DeleteAllowed = true;

    Permissions = TableData "Sales Line" = rmd; //1.0.0.79

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                /*
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                */

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StatusStyleTxt;
                    Visible = false;
                }

                field("HORECA Status"; "HORECA Status")
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    StyleExpr = HorecaStatusStyleTxt;
                    Editable = false;

                }

                group(grpDate)
                {
                    caption = '';

                    field(SystemCreatedAt; SystemCreatedAt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }

                    /*
                    field("Document Date"; Rec."Document Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    */

                    field(OnSchedule; OnSchedule)
                    {
                        ApplicationArea = All;
                        Caption = 'On Schedule';
                        Editable = false;
                    }

                    /*
                    field("MinNextDeliveryDate"; MinNextDeliveryDate)
                    {
                        caption = 'Min. Next Delivery Date';
                        Editable = false;
                    }
                    */

                    field("NextDeliveryDate1"; NextDeliveryDate1)
                    {
                        caption = 'Next Delivery Date 1';
                        Editable = false;
                    }

                    field("NextDeliveryDate2"; NextDeliveryDate2)
                    {
                        caption = 'Next Delivery Date 2';
                        Editable = false;
                    }

                    field("Requested Delivery Date"; Rec."Requested Delivery Date")
                    {
                        ApplicationArea = All;

                        //+1.0.0.262
                        trigger OnValidate()
                        var
                            SalesHeaderCheck: Record "Sales Header";
                            Text50000: Label 'Duplicate Order %3 found Ship-to Code: %1 Requested Delivery Date: %2';
                            Text50002: Label 'Only one order should be at a time. Please update Order %1';
                        begin

                            SalesHeaderCheck.RESET;
                            SalesHeaderCheck.SetRange("Document Type", Rec."Document Type"::Order);
                            SalesHeaderCheck.SetFilter("Sell-to Customer No.", Rec."Sell-to Customer No.");
                            SalesHeaderCheck.SetFilter("Ship-to Code", Rec."Ship-to Code");
                            if SalesHeaderCheck.Count > 1 then begin
                                if SalesHeaderCheck.FindFirst() then begin
                                    Error(Text50002, SalesHeaderCheck."No.");
                                end;
                            end;


                            SalesHeaderCheck.RESET;
                            SalesHeaderCheck.SetRange("Document Type", Rec."Document Type"::Order);
                            SalesHeaderCheck.SetFilter("Sell-to Customer No.", Rec."Sell-to Customer No.");
                            SalesHeaderCheck.SetFilter("Ship-to Code", Rec."Ship-to Code");
                            SalesHeaderCheck.SetFilter("Requested Delivery Date", '%1', Rec."Requested Delivery Date");
                            if SalesHeaderCheck.Count > 1 then begin
                                if SalesHeaderCheck.FindFirst() then begin
                                    Error(Text50000, SalesHeaderCheck."Ship-to Code", SalesHeaderCheck."Requested Delivery Date", SalesHeaderCheck."No.");
                                end;
                            end;
                        end;
                        //-1.0.0.262

                    }
                    /*
                    field("Requested Delivery Time"; Rec."Requested Delivery Time")
                    {
                        ApplicationArea = All;
                    }
                    */

                }

                group("Work Description")
                {
                    Caption = 'Comments';
                    field(WorkDescription; WorkDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Order Comments';

                        trigger OnValidate()
                        begin
                            SetWorkDescription(WorkDescription);
                        end;
                    }
                }

            }

            part(HorecaLines; "Horeca Order Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = IsSalesLinesEditable;
                Enabled = IsSalesLinesEditable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {

        area(Processing)
        {
            action("Print Confirmation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Confirmation';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Print a sales order confirmation.';
                //Visible = NOT IsOfficeHost;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
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

    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //if DocNoVisible then
        //    CheckCreditMaxBeforeInsert();

        if ("Sell-to Customer No." = '') and (GetFilter("Sell-to Customer No.") <> '') then
            CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)

    var
        UserSetup: Record "User Setup";
        ShiptoAddress: Record "Ship-to Address";
    begin
        xRec.Init();

        UserSetup.GET(UserId);
        "Sell-to Customer No." := UserSetup."HORECA Customer No.";



        if (not DocNoVisible) and ("No." = '') then
            SetSellToCustomerFromFilter();
        //Message('select List');

        //pop up the ship to address list
        ShiptoAddress.RESET;
        //ShiptoAddress.SetCurrentKey("Customer No.",Code, City, Name);
        ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
        ShiptoAddress.SetFilter(Code, '%1', UserSetup."HORECA Ship-to Filter");
        if ShiptoAddress.FindSet() then begin

            IF PAGE.RUNMODAL(PAGE::"Ship-to Address List", ShiptoAddress) = ACTION::LookupOK THEN BEGIN
                Validate("Ship-to Code", ShiptoAddress.Code);
            END ELSE BEGIN
                EXIT;
            END;

        end;
    end;

    trigger OnOpenPage()
    var
    begin
        Rec.SetSecurityFilterOnCustomer(vG_GLOBAL_StoreCode);

        SetRange("Date Filter", 0D, WorkDate());

        SetDocNoVisible();
    end;

    trigger OnAfterGetRecord()
    var
        cuGeneralMgt: Codeunit "General Mgt.";
        userSetup: Record "User Setup";
        ShiptoAddress: Record "Ship-to Address";
        WeekDay: Integer;
        TempDate1: Date;
        TempDate2: Date;
    begin
        WorkDescription := GetWorkDescription();
        OnSchedule := cuGeneralMgt.GetScheduleDays("Sell-to Customer No.", "Ship-to Code");


        NextDeliveryDate1 := 0D;
        NextDeliveryDate2 := 0D;
        MinNextDeliveryDate := 0D;

        if userSetup.get(UserId) then begin
            if userSetup."HORECA Customer No." <> '' then begin
                userSetup.TestField("HORECA Min. Order Period");

                MinNextDeliveryDate := calcdate(userSetup."HORECA Min. Order Period", WorkDate());

                //find the next 7 days
                WeekDay := Date2DWY(MinNextDeliveryDate, 1);

                //WD4	The next 4th day of a week (Thursday)
                //WD4

                if ShiptoAddress.GET("Sell-to Customer No.", "Ship-to Code") then begin
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


                end;
            end;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesHeader: Record "Sales Header";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
    begin
        if GuiAllowed() then begin
            IsSalesLinesEditable := Rec.SalesLinesEditable();
            StatusStyleTxt := GetStatusStyleText();
            HorecaStatusStyleTxt := GetHorecaStatusStyleText();
        end;
    end;

    trigger OnModifyRecord(): Boolean;
    var
        myInt: Integer;
    begin
        TestStatusOpen();

        TestHORECAStatusOpen();
    end;



    trigger OnDeleteRecord(): Boolean
    Var
        Text50000: Label 'Are you sure to delete Document No. %1?';
        SalesLine: Record "Sales Line";
    begin
        TestStatusOpen();
        TestHORECAStatusOpen();

        if not confirm(Text50000, false, rec."No.") then begin
            Error('');
        end;

        SalesLine.RESET;
        SalesLine.SetRange("Document Type", rec."Document Type");
        SalesLine.SetFilter("Document No.", Rec."No.");
        if SalesLine.FindSet() then begin
            SalesLine.DeleteAll();
        end;


        //CurrPage.SaveRecord();
        //exit(ConfirmDeletion());


    end;

    trigger OnInit()
    begin

    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order, "No.");
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
        IsSalesLinesEditable: Boolean;
        DocNoVisible: Boolean;
        OnSchedule: Text;

        MinNextDeliveryDate: Date;
        NextDeliveryDate1: Date;
        NextDeliveryDate2: Date;

        StatusStyleTxt: Text;

        WorkDescription: Text;
        HorecaStatusStyleTxt: Text;

        vG_GLOBAL_StoreCode: Code[10];


}
/*
2017/11/23 VC comment Bill to Name
TAL0.1 2017/12/06 VC add 3 columns to calcualted total Qty
TAL0.2 2018/01/10 VC add fields 
  Created By 
  Create Date
  Last Modified By
  Last Modified Date

TAL0.3 2018/01/10 VC add logic to set customer by default
TAL0.4 2018/07/22 VC add field Batch No. 

TAL0.5 2020/03/06 VC add field Lot No.
TAL0.6 2020/03/06 VC add field Delivery No.,Delivery Sequence,Chain of Custody Tracking
TAL0.7 2021/03/26 VC add Total Qty Received for Return Shipments
TAL0.8 2021/04/06 VC add PrintAppendixRecords

*/

tableextension 50107 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here

        //+1.0.0.256
        modify("Requested Delivery Date")
        {
            trigger OnBeforeValidate()
            var
                ShiptoAddress: Record "Ship-to Address";
                WeekDay: Integer;
                WeekDayText: Text;
                Text50000: Label 'Your scheduled Delivery Date is %1. Not %2 - %3. Press F5 to Refresh the page and select a valid delivery date.';
                Text50001: Label 'Requested Delivery Date %1 cannot be earlier than minimum request date %2.';
                cuGeneralMgt: Codeunit "General Mgt.";
                userSetup: Record "User Setup";
                NoDeliveryDays: Integer;
                NoValidDays: Integer;
                MinRequestDate: Date;
            begin
                if userSetup.Get(UserId) then begin
                    if userSetup."HORECA Customer No." <> '' then begin
                        userSetup.TestField("HORECA Min. Order Period");
                        if "Requested Delivery Date" <> 0D then begin


                            MinRequestDate := CalcDate(userSetup."HORECA Min. Order Period", WorkDate());

                            if "Requested Delivery Date" < MinRequestDate then begin
                                Error(Text50001, "Requested Delivery Date", MinRequestDate);
                            end;


                            WeekDay := Date2DWY("Requested Delivery Date", 1);
                            WeekDayText := Format("Requested Delivery Date", 0, '<Weekday Text>');

                            NoDeliveryDays := 0;
                            NoValidDays := 0;
                            //Message(FORMAT(WeekDay)); //4

                            if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then begin
                                if (ShiptoAddress.Monday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 1 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;


                                end;

                                if (ShiptoAddress.Tuesday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 2 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if (ShiptoAddress.Wednesday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 3 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if (ShiptoAddress.Thursday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 4 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if (ShiptoAddress.Friday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 5 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if (ShiptoAddress.Saturday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 6 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if (ShiptoAddress.Sunday) then begin
                                    NoDeliveryDays += 1;
                                    if WeekDay = 7 then begin
                                        //date is valid
                                        NoValidDays := 1;
                                    end;

                                end;

                                if NoValidDays = 0 then begin
                                    //show error
                                    Error(Text50000, cuGeneralMgt.GetScheduleDays("Sell-to Customer No.", "Ship-to Code"), WeekDayText, "Requested Delivery Date");
                                end;

                                SetHideValidationDialog(true);

                                Validate("Document Date", "Requested Delivery Date");
                                Validate("Order Date", "Requested Delivery Date");
                                Validate("Shipment Date", "Requested Delivery Date");
                                Validate("Posting Date", "Requested Delivery Date");
                            end;

                        end; //end user setup

                    end;
                end;
            end;
        }
        //-1.0.0.256


        field(50000; "Total Qty"; Decimal)
        {
            CalcFormula = sum("Sales Line".Quantity where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Total Qty Shipped"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Quantity Shipped" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Total Qty Invoiced"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Quantity Invoiced" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Total Qty Received"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Return Qty. Received" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }


        field(50007; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Create Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50010; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50011; "Batch No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50014; "Lot No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50015; "Customer Reference No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50016; "Excel Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }



        field(50017; "Week No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(50018; "No. of Lines"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50019; "No. of New Lines"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "Line Source" = filter('<>''''')));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50020; "Requested Delivery Time"; Time)
        {
            Caption = 'Requested Delivery Time';
        }

        field(50021; "Shipment Time"; Time)
        {
            Caption = 'Shipment Time';
        }


        field(50022; "Price Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50023; "Price End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50024; "Price Update Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50025; "Price Update End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50099; "Delivery No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Delivery Schedule" where(Status = filter(' '));
        }
        field(50100; "Delivery Sequence"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Chain of Custody Tracking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            //TAL 1.0.0.201 >>
            trigger OnValidate()
            var
                Response: Boolean;
                rL_SalesLine: Record "Sales Line";
            begin
                rL_SalesLine.Reset();
                rL_SalesLine.SetRange("Document Type", "Document Type");
                rL_SalesLine.SetRange("Document No.", "No.");
                if rL_SalesLine.FindSet() then begin
                    Response := Dialog.Confirm('Do you want to update the lines?');
                    if Response then
                        UpdateTransferFromCode(rL_SalesLine);
                end;
            end;
            //TAL 1.0.0.201 <<
        }
        field(50103; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            //TAL 1.0.0.201 >>
            trigger OnValidate()
            var
                Response: Boolean;
                rL_SalesLine: Record "Sales Line";
            begin
                rL_SalesLine.Reset();
                rL_SalesLine.SetRange("Document Type", "Document Type");
                rL_SalesLine.SetRange("Document No.", "No.");
                if rL_SalesLine.FindSet() then begin
                    Response := Dialog.Confirm('Do you want to update the lines?');
                    if Response then
                        UpdateTransferToCode(rL_SalesLine);
                end;
            end;
            //TAL 1.0.0.201 <<
        }

        field(50146; "Shipping Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Shipping Temperature °C';
        }

        field(50147; "Shipping Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(50148; "HORECA Status"; Enum "HORECA Document Status")
        {
            Caption = 'HORECA Status';
            DataClassification = CustomerContent;
            // Editable = false;
        }
    }

    keys
    {

        key(key50000; "Delivery No.", "Delivery Sequence")
        {

        }
    }

    //+1.0.0.258
    fieldgroups
    {
        addlast(Brick; "Ship-to Code", "Ship-to Name", "Requested Delivery Date")
        {

        }
    }
    //-1.0.0.258

    trigger OnInsert()
    var
        rL_Customer: Record Customer;
    begin
        //+TAL0.3 
        "Created By" := UserId;
        "Create Date" := CurrentDateTime;
        //-TAL0.3 

        //+TAL0.3 
        if "Sell-to Customer No." = '' then begin
            if rG_UserSetup.Get(UserId) then;
            if rG_UserSetup."User Department" = rG_UserSetup."User Department"::"Web Order" then begin
                rL_Customer.Reset;
                rL_Customer.SetFilter("Responsibility Center", rG_UserSetup."User ID");
                if rL_Customer.FindSet then begin
                    Validate("Sell-to Customer No.", rG_UserSetup."User ID");
                end;
            end;
        end;
        //-TAL0.3 
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        UpdateAmendDate; //TAL0.3 
    end;

    procedure UpdateAmendDate();
    begin
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
    end;

    procedure PrintAppendixRecords(var pSalesHeader: Record "Sales Header");
    var
        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix FFH";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pSalesHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetSalesOrder("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pSalesHeader.Next = 0;
        end;
    end;

    procedure f_CreatePurchaseOrder(SalesHeader: Record "Sales Header"; var SelectedSalesLine: Record "Sales Line")
    var
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        OptionNumber: Integer;
        CreatePurchInvOptionQst: Label 'All Lines,Selected Lines';
        CreatePurchInvInstructionTxt: Label 'A purchase order will be created. Select which sales invoice lines to use.';
    begin
        OptionNumber := Dialog.StrMenu(CreatePurchInvOptionQst, 1, CreatePurchInvInstructionTxt);

        if OptionNumber = 0 then
            exit;

        case OptionNumber of
            0:
                exit;
            1:
                begin
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                end;
            2:
                SalesLine.Copy(SelectedSalesLine);
        end;

        if SelectVendor(Vendor, SalesLine) then begin

            CreatePurchaseHeader(PurchaseHeader, SalesHeader, Vendor);
            CopySalesLinesToPurchaseLines(PurchaseHeader, SalesLine);
            Page.Run(Page::"Purchase Order", PurchaseHeader);
        end;
    end;

    local procedure SelectVendor(var Vendor: Record Vendor; var SelectedSalesLine: Record "Sales Line"): Boolean
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        VendorList: Page "Vendor List";
        VendorNo: Code[20];
        DefaultVendorFound: Boolean;
        SelectVentorTxt: Label 'Select a vendor';
    begin
        SalesLine.Copy(SelectedSalesLine);

        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet then begin
            Item.Get(SalesLine."No.");
            VendorNo := Item."Vendor No.";
            DefaultVendorFound := (VendorNo <> '');

            while DefaultVendorFound and (SalesLine.Next <> 0) do begin
                Item.Get(SalesLine."No.");
                DefaultVendorFound := (VendorNo = Item."Vendor No.");
            end;

            if DefaultVendorFound then begin
                Vendor.Get(VendorNo);
                exit(true);
            end;
        end;

        VendorList.LookupMode(true);
        VendorList.Caption(SelectVentorTxt);
        if VendorList.RunModal = Action::LookupOK then begin
            VendorList.GetRecord(Vendor);
            exit(true);
        end;

        exit(false);
    end;

    local procedure CreatePurchaseHeader(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; Vendor: Record Vendor)
    var
        TypeNotSupportedErr: Label 'Type %1 is not supported.', Comment = 'Line or Document type';
    begin
        PurchaseHeader.Init();

        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then
            PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order)
        else
            Error(TypeNotSupportedErr, Format(SalesHeader."Document Type"));


        PurchaseHeader.InitRecord;
        PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");

        PurchaseHeader.Insert(true);
    end;

    local procedure CopySalesLinesToPurchaseLines(PurchaseHeader: Record "Purchase Header"; var SalesLine: Record "Sales Line")

    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLineNo: Integer;
        IsHandled: Boolean;
        TypeNotSupportedErr: Label 'Type %1 is not supported.', Comment = 'Line or Document type';
    begin
        PurchaseLineNo := 0;
        if SalesLine.Find('-') then
            repeat
                Clear(PurchaseLine);
                PurchaseLine.Init();
                PurchaseLine."Document No." := PurchaseHeader."No.";
                PurchaseLine."Document Type" := PurchaseHeader."Document Type";

                PurchaseLineNo := PurchaseLineNo + 10000;
                PurchaseLine."Line No." := PurchaseLineNo;

                case SalesLine.Type of
                    SalesLine.Type::" ":
                        PurchaseLine.Type := PurchaseLine.Type::" ";
                    SalesLine.Type::Item:
                        PurchaseLine.Type := PurchaseLine.Type::Item;
                    else begin
                        IsHandled := false;

                        if not IsHandled then
                            Error(TypeNotSupportedErr, Format(SalesLine.Type));
                    end
                end;

                PurchaseLine.Validate("No.", SalesLine."No.");
                PurchaseLine.Description := SalesLine.Description;

                if PurchaseLine."No." <> '' then begin
                    PurchaseLine.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.Validate("Pay-to Vendor No.", PurchaseHeader."Pay-to Vendor No.");
                    PurchaseLine.Validate(Quantity, SalesLine.Quantity);
                    PurchaseLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                end;


                PurchaseLine.Insert(true);
            until SalesLine.Next() = 0;
    end;


    /* 
    procedure GetPriceStartDate(): Date
    begin
        //exit("Order Date");
    end;

    procedure GetPriceEndDate(): Date
    begin
        
      
        if "Order Date" <> 0D then begin
            exit(CalcDate('+6D', "Order Date"));
        end;
      
    end;
    

    procedure GetPriceStartDatePreviousWeek(): Date
    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        
     
        SRSetup.GET;
        if "Document Date" <> 0D then begin
            //-1D-6D'
            exit(CalcDate(SRSetup."Start Date PWeek Formula", "Document Date"));
        end;
        
    end;

    procedure GetPriceEndDatePreviousWeek(): Date
    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        SRSetup.GET;
        if "Document Date" <> 0D then begin
            //'-1D'
            exit(CalcDate(SRSetup."End Date PWeek Formula", "Document Date"));
        end;
    end;
    */

    procedure SQPriceDateCalculation()
    var
        SRSetup: Record "Sales & Receivables Setup";
    begin
        SRSetup.Get;
        "Price Start Date" := 0D;
        "Price End Date" := 0D;

        "Price Update Start Date" := 0D;
        "Price Update End Date" := 0D;


        "Price Start Date" := CalcDate(SRSetup."Start Date PWeek Formula", "Document Date");
        "Price End Date" := CalcDate(SRSetup."End Date PWeek Formula", "Document Date");

        "Price Update Start Date" := CalcDate(SRSetup."Start Update Date Formula", "Requested Delivery Date");
        "Price Update End Date" := CalcDate(SRSetup."End Update Date Formula", "Requested Delivery Date");

    end;

    //TAL 1.0.0.201 >>
    procedure UpdateTransferFromCode(rL_SalesLine: Record "Sales Line")
    begin
        repeat
            rL_SalesLine."Transfer-from Code" := Rec."Transfer-from Code";
            rL_SalesLine.Modify();
        until rL_SalesLine.Next() = 0;
    end;

    procedure UpdateTransferToCode(rL_SalesLine: Record "Sales Line")
    begin
        repeat
            rL_SalesLine."Transfer-to Code" := Rec."Transfer-to Code";
            rL_SalesLine.Modify();
        until rL_SalesLine.Next() = 0;
    end;
    //TAL 1.0.0.201 <<

    procedure SetSecurityFilterOnCustomer(pGlobalCode: Code[10])
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("HORECA Customer No.");
        UserSetup.TestField("HORECA Ship-to Filter");

        FilterGroup(2);
        SetFilter("Sell-to Customer No.", '%1', UserSetup."HORECA Customer No.");
        if pGlobalCode = '' then begin
            SetFilter("Ship-to Code", '%1', UserSetup."HORECA Ship-to Filter");
        end else begin
            SetFilter("Ship-to Code", '%1', pGlobalCode);
        end;

        FilterGroup(0);


        SetRange("Date Filter", 0D, WorkDate());
    end;


    procedure TestHORECAStatusOpen()
    var
        numdays: Integer;
        Text50000: Label '24 hour Validation rule. Order cannot be edited';
    begin

        numdays := Rec."Requested Delivery Date" - WorkDate();
        if numdays <= 1 then begin
            Error(Text50000);
        end;
        TestField("HORECA Status", "HORECA Status"::Open);
    end;


    procedure GetHorecaStatusStyleText() StatusStyleText: Text
    begin
        if "HORECA Status" = "HORECA Status"::Open then
            StatusStyleText := 'Favorable'
        else
            StatusStyleText := 'Strong';
    end;

    var
        myInt: Integer;
        rG_UserSetup: Record "User Setup";

}
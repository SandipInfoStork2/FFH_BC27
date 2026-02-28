page 50072 "Horeca SSH"
{

    Caption = 'Posted Sales Shipment';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Shipment Header";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;

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

                    field("Posting Date"; "Posting Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }



                    field("Requested Delivery Date"; Rec."Requested Delivery Date")
                    {
                        ApplicationArea = All;
                        Editable = false;

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
                        Editable = false;

                        trigger OnValidate()
                        begin
                            //SetWorkDescription(WorkDescription);
                        end;
                    }
                }

            }

            part(HorecaLines; "Horeca SSH Subform")
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

                    clear(rptSalesShipment);
                    rptSalesShipment.SetTableView(SalesShptHeader);
                    rptSalesShipment.UseRequestPage(false);
                    rptSalesShipment.Run();
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



    trigger OnOpenPage()
    var
    begin
        //Rec.SetSecurityFilterOnCustomer();

        // SetRange("Date Filter", 0D, WorkDate());

        //SetDocNoVisible();
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




        if userSetup.get(UserId) then begin
            if userSetup."HORECA Customer No." <> '' then begin
                userSetup.TestField("HORECA Min. Order Period");


                //WD4	The next 4th day of a week (Thursday)
                //WD4

                if ShiptoAddress.GET("Sell-to Customer No.", "Ship-to Code") then begin
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

    end;

    trigger OnModifyRecord(): Boolean;
    var
        myInt: Integer;
    begin
       
    end;

    trigger OnDeleteRecord(): Boolean
    begin
      
    end;

    trigger OnInit()
    begin

    end;




    var
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        IsSalesLinesEditable: Boolean;
        DocNoVisible: Boolean;
        OnSchedule: Text;



        StatusStyleTxt: Text;

        WorkDescription: Text;
}
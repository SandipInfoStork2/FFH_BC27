page 50076 "Horeca SIH"
{

    Caption = 'Posted Sales Invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    ApplicationArea = All;

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
                    ToolTip = 'Specifies the posted invoice number.';


                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }

                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                }

                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                }

                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }

                /*
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                */


                group(grpDate)
                {
                    Caption = '';

                    field(SystemCreatedAt; Rec.SystemCreatedAt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the SystemCreatedAt field.';
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
                        ToolTip = 'Specifies the value of the On Schedule field.';
                    }

                    /*
                    field("MinNextDeliveryDate"; MinNextDeliveryDate)
                    {
                        caption = 'Min. Next Delivery Date';
                        Editable = false;
                    }
                    */

                    field("Posting Date"; Rec."Posting Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the date on which the invoice was posted.';
                    }



                    /*
                    field("Requested Delivery Date"; Rec."Requested Delivery Date")
                    {
                        ApplicationArea = All;
                        Editable = false;

                    }
                    */
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

            part(HorecaLines; "Horeca SIH Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = IsSalesLinesEditable;
                Enabled = IsSalesLinesEditable;
                SubPageLink = "Document No." = field("No.");
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //if DocNoVisible then
        //    CheckCreditMaxBeforeInsert();

        if (Rec."Sell-to Customer No." = '') and (Rec.GetFilter("Sell-to Customer No.") <> '') then
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
        WorkDescription := Rec.GetWorkDescription();
        OnSchedule := cuGeneralMgt.GetScheduleDays(Rec."Sell-to Customer No.", Rec."Ship-to Code");




        if userSetup.Get(UserId) then begin
            if userSetup."HORECA Customer No." <> '' then begin
                userSetup.TestField("HORECA Min. Order Period");


                //WD4	The next 4th day of a week (Thursday)
                //WD4

                if ShiptoAddress.GET(Rec."Sell-to Customer No.", Rec."Ship-to Code") then begin
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
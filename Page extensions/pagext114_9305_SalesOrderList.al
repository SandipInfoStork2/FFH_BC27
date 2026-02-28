/*
TAL0.2 2017/11/13  VC design post and print action from 2015
TAL0.3 2017/12/06 VC add 3 columns to calcualted total Qty
                     add delete invoiced sales orders
TAL0.4 2018/07/22 VC add field Batch No. 
TAL0.5 2019/03/29 VC add action Email Work Order
TAL0.6 2020/03/06 VC add field Delivery No.,Delivery Sequence,
TAL0.7 2021/04/06 VC add PrintAppendixRecords
TAL0.8 2021/04/13 VC mark orders with Sundry Grower 
TAL0.9 2021/10/18 VC add Action Import PHC Orders
TAL0.10 2021/11/23 VC add Action Import Horeca Orders v2
TAL0.11 2021/12/14 VC add Action Order per Ship-to Address

*/
pageextension 50214 SalesOrderListExt extends "Sales Order List"
{
    PromotedActionCategories = 'New,Process,Report,Request Approval,Order,Release,Posting,Print/Send,Navigate,Delivery';
    layout
    {
        // Add changes to page layout here
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
        }

        movebefore("No."; "Posting Date")

        movebefore("Posting Date"; "Document Date")

        moveafter("No."; "External Document No.")
        moveafter("External Document No."; "Ship-to Code")

        modify("Sell-to Customer Name")
        {
            StyleExpr = StyleTxt;
        }

        modify("Bill-to Name")
        {
            Visible = true;
        }
        moveafter("Sell-to Customer Name"; "Bill-to Name")

        addafter("Bill-to Name")
        {
            field("Batch No."; "Batch No.")
            {
                ApplicationArea = all;
            }
        }

        moveafter("Batch No."; Status)
        moveafter(Status; Amount)
        moveafter(Amount; "Amount Including VAT")
        moveafter("Amount Including VAT"; "Location Code")



        addafter("Completely Shipped")
        {
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Qty Shipped"; "Total Qty Shipped")
            {
                ApplicationArea = all;
            }
            field("Total Qty Invoiced"; "Total Qty Invoiced")
            {
                ApplicationArea = all;
            }
            field("Req. Vendor No."; "Req. Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Delivery No."; "Delivery No.")
            {
                ApplicationArea = all;
            }
            field("Delivery Sequence"; "Delivery Sequence")
            {
                ApplicationArea = all;
            }
            field(vG_SundryGrowerExists; vG_SundryGrowerExists)
            {
                ApplicationArea = all;
                CaptionML = ELL = 'Sundry Grower Exists',
                                ENU = 'Sundry Grower Exists';
                Editable = false;
            }
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
            }
            field("Excel Order Date"; "Excel Order Date")
            {
                ApplicationArea = all;
            }
        }

        modify("Ship-to Code")
        {
            Visible = true;
        }
        moveafter("Amt. Ship. Not Inv. (LCY)"; "Ship-to Code")

        modify("Requested Delivery Date")
        {
            visible = true;
        }
        moveafter("Ship-to Code"; "Requested Delivery Date")
        addafter("Requested Delivery Date")
        {

            field("Requested Delivery Time"; "Requested Delivery Time")
            {
                ApplicationArea = all;
            }

            field("Shipment Date2"; "Shipment Date")
            {
                ApplicationArea = all;
            }

            field("Shipment Time"; "Shipment Time")
            {
                ApplicationArea = all;

            }

            field(SystemCreatedAt; SystemCreatedAt)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(SystemCreatedBy; rG_User."User Name")
            {
                ApplicationArea = all;
                Caption = 'System Created By';

            }


            field(NumDays; numdays)
            {
                Caption = 'Allowed HORECA Users Edit Days';
                ApplicationArea = all;
            }

            field("HORECA Status"; "HORECA Status")
            {
                ApplicationArea = all;
                StyleExpr = HorecaStatusStyleTxt;
            }
        }



    }

    actions
    {
        // Add changes to page actions here
        addafter("Send IC Sales Order Cnfmn.")
        {
            action("Delete Invoiced S.O.")
            {
                ApplicationArea = all;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Delete Invoiced Sales Orders";
            }
            action("Import HORECA Order v1")
            {
                ApplicationArea = all;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(1, false); //TAL0.10
                                                                //-TAL0.9
                end;
            }
            action("Import HORECA Order v2")
            {
                ApplicationArea = all;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                caption = 'Import HORECA Order v2 (zip)';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(2, false); //TAL0.10
                                                                //-TAL0.9
                end;
            }




            action("Import HORECA Order Excel")
            {
                ApplicationArea = all;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                caption = 'Import HORECA Order v2 (xlsx)';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(2, true); //TAL0.10
                                                               //-TAL0.9
                end;
            }
            action(CountRec)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                caption = 'Count Records';

                trigger OnAction()
                begin
                    Message('# records: ' + Format(Rec.Count));
                end;
            }

            action("HORECA Auto Release")
            {
                ApplicationArea = All;
                Image = Process;
                //Promoted = true;
                // PromotedCategory = Process;
                //PromotedOnly = true;
                RunObject = report "HORECA Auto Release";
            }

        }

        addafter(PostAndSend)
        {
            action(PostAndPrint)
            {
                ApplicationArea = All;
                Caption = 'Post and Print';
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                trigger OnAction()
                begin
                    LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                    SendToPosting(CODEUNIT::"Sales-Post + Print");
                end;
            }
        }

        addafter("Work Order")
        {
            action("Email Work Order")
            {
                ApplicationArea = All;
                Caption = 'Email Work Order';
                Ellipsis = true;
                Image = Email;
                ToolTip = 'Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.';

                trigger OnAction();
                begin
                    cu_GeneralMgt.EmailSalesOrder(Rec, Usage::"Work Order");
                end;
            }
        }

        addafter("Pick Instruction")
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
                    vL_SalesHeader: Record "Sales Header";
                begin
                    vL_SalesHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(vL_SalesHeader);
                    vL_SalesHeader.PrintAppendixRecords(vL_SalesHeader);
                end;
            }

            action("Order per Ship-to Address")
            {
                ApplicationArea = All;
                Image = OrderList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Order per Ship-to Location (S)";
            }


        }

        addafter("&Order Confirmation")
        {
            group(Delivery)
            {
                action(Action_MoveUpPage)
                {
                    ApplicationArea = All;
                    Caption = 'Move &Up Page';
                    Enabled = AllowMoveUpPage;
                    Image = MoveUp;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Moves up the selected page within the category.';

                    trigger OnAction();
                    begin
                        MovePage(true);
                    end;
                }
                action(Action_MoveDownPage)
                {
                    ApplicationArea = All;
                    Caption = 'Move &Down Page';
                    Enabled = AllowMoveDownPage;
                    Image = MoveDown;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedIsBig = true;
                    ToolTip = 'Moves down the selected page within the category.';

                    trigger OnAction();
                    begin
                        MovePage(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Rec.SetCurrentKey(SystemCreatedAt);
        //Rec.Ascending := false;
    end;

    trigger OnAfterGetRecord();
    begin

        //+TAL0.6
        AllowMoveUpPage := "Delivery Sequence" <> 1; //TRUE; //(DataKind = CONST_DK_PAGE) AND NOT IsFirst;
        AllowMoveDownPage := "Delivery Sequence" <> COUNT; //TRUE;//(DataKind = CONST_DK_PAGE) AND NOT IsLast;
        //-TAL0.6

        //+TAL0.8
        vG_SundryGrowerExists := cu_GeneralMgt.SundryGrowerExistsSO("No.");
        StyleTxt := '';
        if vG_SundryGrowerExists then begin
            StyleTxt := 'Attention';
        end;
        //-TAL0.8

        clear(rG_User);
        if rG_User.Get(Rec.SystemCreatedBy) then;

        numdays := 0;
        if ("Requested Delivery Date" <> 0D) and (Status = Status::Open) and ("Ship-to Code" <> '') then begin
            numdays := "Requested Delivery Date" - WorkDate();
        end;

        HorecaStatusStyleTxt := GetHorecaStatusStyleText();

    end;

    local procedure MovePage(_MoveUp: Boolean);
    var
        Rec1: Record "Sales Header";
        Rec2: Record "Sales Header";
    begin
        FocusedRec := Rec;

        if _MoveUp then begin
            Rec2.GET("No.");
            NEXT(-1);
            Rec1.GET("No.");
        end
        else begin
            Rec1.GET("No.");
            NEXT(1);
            Rec2.GET("No.");
        end;

        Rec1."Delivery Sequence" += 1;
        Rec1.MODIFY(false);
        Rec2."Delivery Sequence" -= 1;
        Rec2.MODIFY(false);

        RefreshCurrentPage(false);
        //CurrPage.UPDATE(FALSE);
    end;

    local procedure RefreshCurrentPage(_InitialRefresh: Boolean);
    var
        Eof: Boolean;
    begin
        //CheckInitialized;
        //BuildTree;
        SETCURRENTKEY("Delivery No.", "Delivery Sequence");

        if not _InitialRefresh then
            CurrPage.UPDATE(false);

        if FINDFIRST then begin
            if not _InitialRefresh then begin
                Eof := false;
                while (("No." <> FocusedRec."No.")) and not Eof do
                    Eof := NEXT = 0;

                if Eof then
                    FINDFIRST;
            end;
        end;
    end;

    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";

        FocusedRec: Record "Sales Header" temporary;
        [InDataSet]
        AllowMoveUpPage: Boolean;
        [InDataSet]
        AllowMoveDownPage: Boolean;
        vG_SundryGrowerExists: Boolean;
        cu_GeneralMgt: Codeunit "General Mgt.";
        [InDataSet]
        StyleTxt: Text;
        rG_User: Record User;

        numdays: Integer;

        HorecaStatusStyleTxt: Text;
}
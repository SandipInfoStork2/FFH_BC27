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
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }
        }

        moveafter("Batch No."; Status)
        moveafter(Status; Amount)
        moveafter(Amount; "Amount Including VAT")
        moveafter("Amount Including VAT"; "Location Code")



        addafter("Completely Shipped")
        {
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty Shipped"; Rec."Total Qty Shipped")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Shipped field.';
            }
            field("Total Qty Invoiced"; Rec."Total Qty Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty Invoiced field.';
            }
            field("Req. Vendor No."; Rec."Req. Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Req. Vendor No. field.';
            }
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
            field(vG_SundryGrowerExists; vG_SundryGrowerExists)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Sundry Grower Exists',
                                ENU = 'Sundry Grower Exists';
                Editable = false;
                ToolTip = 'Specifies the value of the vG_SundryGrowerExists field.';
            }
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
            }
            field("Excel Order Date"; Rec."Excel Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Excel Order Date field.';
            }
        }

        modify("Ship-to Code")
        {
            Visible = true;
        }
        moveafter("Amt. Ship. Not Inv. (LCY)"; "Ship-to Code")

        modify("Requested Delivery Date")
        {
            Visible = true;
        }
        moveafter("Ship-to Code"; "Requested Delivery Date")
        addafter("Requested Delivery Date")
        {

            field("Requested Delivery Time"; Rec."Requested Delivery Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Delivery Time field.';
            }

            field("Shipment Date2"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
            }

            field("Shipment Time"; Rec."Shipment Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Time field.';

            }

            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.';
            }

            field(SystemCreatedBy; rG_User."User Name")
            {
                ApplicationArea = All;
                Caption = 'System Created By';
                ToolTip = 'Specifies the value of the System Created By field.';

            }


            field(NumDays; numdays)
            {
                Caption = 'Allowed HORECA Users Edit Days';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allowed HORECA Users Edit Days field.';
            }

            field("HORECA Status"; Rec."HORECA Status")
            {
                ApplicationArea = All;
                StyleExpr = HorecaStatusStyleTxt;
                ToolTip = 'Specifies the value of the HORECA Status field.';
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
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "Delete Invoiced Sales Orders";
                ToolTip = 'Executes the Delete Invoiced S.O. action.';
            }
            action("Import HORECA Order v1")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Import HORECA Order v1 action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(1, false); //TAL0.10
                                                                //-TAL0.9
                end;
            }
            action("Import HORECA Order v2")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Import HORECA Order v2 (zip)';
                ToolTip = 'Executes the Import HORECA Order v2 (zip) action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(2, false); //TAL0.10
                                                                //-TAL0.9
                end;
            }




            action("Import HORECA Order Excel")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Import HORECA Order v2 (xlsx)';
                ToolTip = 'Executes the Import HORECA Order v2 (xlsx) action.';

                trigger OnAction();
                var
                    rL_SalesHeader: Record "Sales Header";
                begin
                    //+TAL0.9
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportHorecaOrders(2, true); //TAL0.10
                                                               //-TAL0.9
                end;
            }
            action(CountRec)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Count Records';
                ToolTip = 'Executes the Count Records action.';

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
                ToolTip = 'Executes the HORECA Auto Release action.';
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
                    Rec.SendToPosting(Codeunit::"Sales-Post + Print");
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
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                var
                    vL_SalesHeader: Record "Sales Header";
                begin
                    vL_SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(vL_SalesHeader);
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
                RunObject = page "Order per Ship-to Location (S)";
                ToolTip = 'Executes the Order per Ship-to Address action.';
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
        AllowMoveUpPage := Rec."Delivery Sequence" <> 1; //TRUE; //(DataKind = CONST_DK_PAGE) AND NOT IsFirst;
        AllowMoveDownPage := Rec."Delivery Sequence" <> Rec.COUNT; //TRUE;//(DataKind = CONST_DK_PAGE) AND NOT IsLast;
        //-TAL0.6

        //+TAL0.8
        vG_SundryGrowerExists := cu_GeneralMgt.SundryGrowerExistsSO(Rec."No.");
        StyleTxt := '';
        if vG_SundryGrowerExists then begin
            StyleTxt := 'Attention';
        end;
        //-TAL0.8

        Clear(rG_User);
        if rG_User.Get(Rec.SystemCreatedBy) then;

        numdays := 0;
        if (Rec."Requested Delivery Date" <> 0D) and (Rec.Status = Rec.Status::Open) and (Rec."Ship-to Code" <> '') then begin
            numdays := Rec."Requested Delivery Date" - WorkDate();
        end;

        HorecaStatusStyleTxt := Rec.GetHorecaStatusStyleText();

    end;

    local procedure MovePage(_MoveUp: Boolean);
    var
        Rec1: Record "Sales Header";
        Rec2: Record "Sales Header";
    begin
        FocusedRec := Rec;

        if _MoveUp then begin
            Rec2.GET(Rec."No.");
            Rec.NEXT(-1);
            Rec1.GET(Rec."No.");
        end
        else begin
            Rec1.GET(Rec."No.");
            Rec.NEXT(1);
            Rec2.GET(Rec."No.");
        end;

        Rec1."Delivery Sequence" += 1;
        Rec1.Modify(false);
        Rec2."Delivery Sequence" -= 1;
        Rec2.Modify(false);

        RefreshCurrentPage(false);
        //CurrPage.UPDATE(FALSE);
    end;

    local procedure RefreshCurrentPage(_InitialRefresh: Boolean);
    var
        Eof: Boolean;
    begin
        //CheckInitialized;
        //BuildTree;
        Rec.SETCURRENTKEY("Delivery No.", "Delivery Sequence");

        if not _InitialRefresh then
            CurrPage.Update(false);

        if Rec.FINDFIRST then begin
            if not _InitialRefresh then begin
                Eof := false;
                while ((Rec."No." <> FocusedRec."No.")) and not Eof do
                    Eof := Rec.NEXT = 0;

                if Eof then
                    Rec.FINDFIRST;
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
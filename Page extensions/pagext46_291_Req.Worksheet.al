/*
Deltia Apostolis - outbound
Deltia Paralavis inbound
TAL0.1 2019/06/06 VC add action LoadDeltia;
TAL0.2 2019/06/12 VC add action to open "Prod. Order No. Ref"
TAL0.3 2019/11/07 ANP add function to remove lines witho 0 qty and filled descr

*/
pageextension 50146 ReqWorksheetExt extends "Req. Worksheet"
{
    layout
    {
        // Add changes to page layout here
        addafter("Description 2")
        {
            field("Extended Description"; "Extended Description")
            {
                ApplicationArea = All;
            }
        }

        modify("Transfer-from Code")
        {
            Editable = true;
        }
        modify("Supply From")
        {
            Visible = true;
        }

        modify("Action Message")
        {
            Visible = false;
        }
        modify("Accept Action Message")
        {
            Visible = false;
        }

        addafter("Blanket Purch. Order Exists")
        {
            field("Prod. Order No. Ref"; "Prod. Order No. Ref")
            {
                ApplicationArea = All;

                trigger OnDrillDown();
                var
                    rL_ProductionOrder: Record "Production Order";
                begin
                    //+TAL0.2
                    rL_ProductionOrder.RESET;
                    rL_ProductionOrder.SETRANGE(Status, rL_ProductionOrder.Status::Released);
                    rL_ProductionOrder.SETFILTER("No.", "Prod. Order No. Ref");
                    PAGE.RUN(PAGE::"Released Production Order", rL_ProductionOrder);
                    //-TAL0.2
                end;
            }
        }

        //+1.0.0.46 
        addafter("Vendor No.")
        {
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
            }
        }


        modify("Vendor No.")
        {
            //DrillDownPageId = "Vendor List";
            //LookupPageId = "Vendor List";
            trigger OnLookup(var Text: Text): Boolean
            var
                Vend: Record Vendor;
            begin
                Vend.RESET;
                Vend.SetRange(Blocked, Vend.Blocked::" ");
                if PAGE.RunModal(0, Vend) = ACTION::LookupOK then begin
                    Validate("Vendor No.", Vend."No.");

                    //"Vendor No." := Vend."No.";
                end;
            end;

            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                CurrPage.Update(true);
            end;


        }
        //-1.0.0.46 

    }

    actions
    {
        // Add changes to page actions here

        addbefore("F&unctions")
        {
            group(Deltia)
            {
                Image = Action;

                action(InsertDeltioApostolis)
                {
                    ApplicationArea = All;
                    Caption = 'Add Deltio Apostolis';
                    Ellipsis = true;
                    Enabled = vG_DeltiaAEditable;
                    Image = New;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        rG_RequisitionWkshName.GET('REQ.', "Journal Batch Name");
                        rG_RequisitionWkshName.LoadDeltia('DA', '');
                    end;
                }
                action(InsertDeltioParalavis)
                {
                    ApplicationArea = All;
                    Caption = 'Add Deltio Paralavis';
                    Ellipsis = true;
                    Enabled = vG_DeltiaPEditable;
                    Image = New;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Page;

                    trigger OnAction();
                    begin
                        rG_RequisitionWkshName.GET('REQ.', "Journal Batch Name");
                        rG_RequisitionWkshName.LoadDeltia('DP', '');
                    end;
                }
                action(Print)
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        rL_Deltia: Report "Deltia Apostolis - Paralavis";
                    begin

                        CLEAR(rL_Deltia);
                        rL_Deltia.SetFilters("Worksheet Template Name", "Journal Batch Name");
                        rL_Deltia.RUN;

                        rG_RequisitionWkshName.GET("Worksheet Template Name", "Journal Batch Name");
                        rG_RequisitionWkshName."Print Date Time" := CURRENTDATETIME;
                        rG_RequisitionWkshName."Print By" := USERID;
                        rG_RequisitionWkshName.MODIFY;
                    end;
                }
                action("Create Documents")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        //Message;
                        CLEAR(cu_GeneralMgt);
                        cu_GeneralMgt.CreateProductionDocuments("Worksheet Template Name", "Journal Batch Name");
                    end;
                }
                action("Delete Lines with 0 Qty")
                {
                    ApplicationArea = All;
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin

                        //TAL0.3
                        rL_ReqLine.RESET;
                        rL_ReqLine.SETRANGE("Worksheet Template Name", "Worksheet Template Name");
                        rL_ReqLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                        rL_ReqLine.SETFILTER(Quantity, '%1', 0);
                        rL_ReqLine.SETFILTER(Description, '<>%1', '');
                        if rL_ReqLine.FINDSET then
                            repeat
                                rL_ReqLine.DELETE;
                            until rL_ReqLine.NEXT = 0;
                        //TAL0.3
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        vG_DeltiaAEditable := false;
        vG_DeltiaPEditable := false;




        //+TAL0.1
        if rG_RequisitionWkshName.GET('REQ.', "Journal Batch Name") then;
        if rG_RequisitionWkshName."Transaction Type" = rG_RequisitionWkshName."Transaction Type"::Inbound then begin
            vG_DeltiaPEditable := true;
        end else
            if rG_RequisitionWkshName."Transaction Type" = rG_RequisitionWkshName."Transaction Type"::Outbound then begin
                vG_DeltiaAEditable := true;
            end;
        //-TAL0.1
    end;

    var
        Text50000: Label 'Delete any records to insert new set.';
        rG_RequisitionWkshName: Record "Requisition Wksh. Name";
        [InDataSet]
        vG_DeltiaAEditable: Boolean;
        [InDataSet]
        vG_DeltiaPEditable: Boolean;
        rL_ReqLine: Record "Requisition Line";
}
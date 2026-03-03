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
            field("Extended Description"; Rec."Extended Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Extended Description field.';
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
            field("Prod. Order No. Ref"; Rec."Prod. Order No. Ref")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prod. Order No. Ref field.';

                trigger OnDrillDown();
                var
                    rL_ProductionOrder: Record "Production Order";
                begin
                    //+TAL0.2
                    rL_ProductionOrder.Reset;
                    rL_ProductionOrder.SetRange(Status, rL_ProductionOrder.Status::Released);
                    rL_ProductionOrder.SETFILTER("No.", Rec."Prod. Order No. Ref");
                    Page.Run(Page::"Released Production Order", rL_ProductionOrder);
                    //-TAL0.2
                end;
            }
        }

        //+1.0.0.46 
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
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
                Vend.Reset;
                Vend.SetRange(Blocked, Vend.Blocked::" ");
                if Page.RunModal(0, Vend) = Action::LookupOK then begin
                    Rec.Validate("Vendor No.", Vend."No.");

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
                    ToolTip = 'Executes the Add Deltio Apostolis action.';

                    trigger OnAction();
                    begin
                        rG_RequisitionWkshName.GET('REQ.', Rec."Journal Batch Name");
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
                    ToolTip = 'Executes the Add Deltio Paralavis action.';

                    trigger OnAction();
                    begin
                        rG_RequisitionWkshName.GET('REQ.', Rec."Journal Batch Name");
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
                    ToolTip = 'Executes the Print action.';

                    trigger OnAction();
                    var
                        rL_Deltia: Report "Deltia Apostolis - Paralavis";
                    begin

                        Clear(rL_Deltia);
                        rL_Deltia.SetFilters(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                        rL_Deltia.Run;

                        rG_RequisitionWkshName.GET(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                        rG_RequisitionWkshName."Print Date Time" := CurrentDateTime;
                        rG_RequisitionWkshName."Print By" := UserId;
                        rG_RequisitionWkshName.Modify;
                    end;
                }
                action("Create Documents")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Create Documents action.';

                    trigger OnAction();
                    var
                        cu_GeneralMgt: Codeunit "General Mgt.";
                    begin
                        //Message;
                        Clear(cu_GeneralMgt);
                        cu_GeneralMgt.CreateProductionDocuments(Rec."Worksheet Template Name", Rec."Journal Batch Name");
                    end;
                }
                action("Delete Lines with 0 Qty")
                {
                    ApplicationArea = All;
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Delete Lines with 0 Qty action.';

                    trigger OnAction();
                    begin

                        //TAL0.3
                        rL_ReqLine.Reset;
                        rL_ReqLine.SETRANGE("Worksheet Template Name", Rec."Worksheet Template Name");
                        rL_ReqLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        rL_ReqLine.SetFilter(Quantity, '%1', 0);
                        rL_ReqLine.SetFilter(Description, '<>%1', '');
                        if rL_ReqLine.FindSet then
                            repeat
                                rL_ReqLine.Delete;
                            until rL_ReqLine.Next = 0;
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
        if rG_RequisitionWkshName.GET('REQ.', Rec."Journal Batch Name") then;
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
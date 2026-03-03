/*
TAL0.1 2019/06/06 VC add Field Vendor No.
TAL0.2 2019/06/12 VC add Field 
      Documents Created
      Documents Created By
      Documents Create Date

TAL0.3 2019/06/14 VC add validations
TAL0.4 2019/09/11 ANP Added ITM1-INT No. Series to get on req line
TAL0.4 2019/09/23 ANP Added ShowProductionJournal Function and Production Journal Action
TAL0.5 2022/01/10 VC add Field  
          Created By
          Client Computer Name
          Creation Date
*/
pageextension 50223 ReleasedProductionOrderExt extends "Released Production Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }

            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Packing Agent field.';
            }
            field("Documents Created"; Rec."Documents Created")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents Created field.';
            }
            field("Documents Created By"; Rec."Documents Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents Created By field.';
            }
            field("Documents Create Date"; Rec."Documents Create Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents Create Date field.';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.';
            }
            field("Client Computer Name"; Rec."Client Computer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Client Computer Name field.';
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which you created the production order.';
            }
        }

        modify("Location Code")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("C&opy Prod. Order Document")
        {
            action(UpdateWorksheet)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Update Worksheet',
                                ENU = 'Update Worksheet';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the UpdateWorksheet action.';

                trigger OnAction();
                begin
                    UpdateWorksheet;
                end;
            }
            action(OpenWorksheet)
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Open Worksheet',
                                ENU = 'Open Worksheet';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the OpenWorksheet action.';

                trigger OnAction();
                begin
                    OpenWorksheet;
                end;
            }
            action("Production Journal")
            {
                ApplicationArea = All;
                Image = Journal;
                ToolTip = 'Executes the Production Journal action.';

                trigger OnAction();
                begin
                    ShowProductionJournal;
                end;
            }



            action("Get Computer Name")
            {
                ApplicationArea = All;
                Image = Journal;
                ToolTip = 'Executes the Get Computer Name action.';

                trigger OnAction();
                var
                    cuMgt: Codeunit "General Mgt.";
                begin
                    Clear(cuMgt);
                    cuMgt.GetComputerName();
                end;
            }

            //item card
        }


        addafter("Co&mments")
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = Item;
                ToolTip = 'Executes the Item Card action.';
                // RunObject = page "Item Card";
                //RunPageLink = "No." = field("No.");
                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if Rec."Source Type" = Rec."Source Type"::Item then begin
                        Item.Get(Rec."Source No.");
                        Page.Run(Page::"Item Card", Item);
                    end;
                end;
            }
        }
        //+1.0.0.229
        modify(RefreshProductionOrder)
        {
            trigger OnBeforeAction()
            var
                ManufacturingSetup: Record "Manufacturing Setup";
            begin
                ManufacturingSetup.Get;
                if ManufacturingSetup."Mandatory Packing Agent" then begin
                    Rec.TestField("Packing Agent");
                end;

            end;
        }
        //-1.0.0.229
    }

    local procedure UpdateWorksheet();
    var
        rL_RequisitionLine: Record "Requisition Line";
        rL_RequisitionLineLast: Record "Requisition Line";
        rL_RequisitionLineCheck: Record "Requisition Line";
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
        rL_ProductionOrderComponents: Record "Prod. Order Component";
        rL_Item: Record Item;
        rL_LastLineNo: Integer;
    begin
        Rec.TESTFIELD("Documents Created", false);
        Rec.TESTFIELD("Vendor No."); //TAL0.3

        //+TAL0.3
        rL_ProductionOrderComponents.Reset;
        rL_ProductionOrderComponents.SetRange(Status, rL_ProductionOrderComponents.Status::Released);
        rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", Rec."No.");
        if not rL_ProductionOrderComponents.FindSet then begin
            if rL_ProductionOrderComponents.Count = 0 then begin
                Error(Text50001);
            end;
        end;
        //-TAL0.3

        //check if
        rL_RequisitionWkshName.Reset;
        rL_RequisitionWkshName.SetFilter("Worksheet Template Name", 'REQ.');
        rL_RequisitionWkshName.SETFILTER("Vendor No.", Rec."Vendor No.");
        rL_RequisitionWkshName.SetRange("Transaction Type", rL_RequisitionWkshName."Transaction Type"::Inbound);
        if rL_RequisitionWkshName.FindSet then begin


            //STEP 1 LOAD THE LIST
            rL_RequisitionLine.Reset;
            rL_RequisitionLine.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
            if not rL_RequisitionLine.FindSet then begin
                //load the data
                rL_RequisitionWkshName.LoadDeltia('DP', '');
            end;

            //STEP 2 match the list and update quantity
            rL_RequisitionLine.Reset;
            rL_RequisitionLine.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
            rL_RequisitionLine.SetRange(Type, rL_RequisitionLine.Type::Item);
            rL_RequisitionLine.SetFilter("Prod. Order No. Ref", '%1', '');
            if rL_RequisitionLine.FindSet then begin
                repeat
                    //loop the components
                    //if line is found in the requisition update the quantity
                    rL_ProductionOrderComponents.Reset;
                    rL_ProductionOrderComponents.SetRange(Status, rL_ProductionOrderComponents.Status::Released);
                    rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", Rec."No.");
                    rL_ProductionOrderComponents.SetFilter("Item No.", rL_RequisitionLine."No.");
                    if rL_ProductionOrderComponents.FindSet then begin
                        //REPEAT
                        //rL_Item.GET(rL_ProductionOrderComponents."Item No.");
                        // IF (rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No.") OR (rL_Item."No. Series"='ITM1-RFV')  THEN BEGIN
                        rL_RequisitionLine.Validate("Location Code", rL_ProductionOrderComponents."Location Code");
                        rL_RequisitionLine.Validate(Quantity, rL_ProductionOrderComponents."Expected Quantity" * (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                        rL_RequisitionLine."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" * (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                        rL_RequisitionLine.Validate("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                        rL_RequisitionLine."Prod. Order No. Ref" := Rec."No.";
                        rL_RequisitionLine.Modify;
                        //END;
                        //UNTIL rL_ProductionOrderComponents.NEXT=0;
                    end;

                until rL_RequisitionLine.Next = 0;
            end;

            //STEP 3
            //loop the component list and add the Raw material in the requisition worksheet
            rL_ProductionOrderComponents.Reset;
            rL_ProductionOrderComponents.SetRange(Status, rL_ProductionOrderComponents.Status::Released);
            rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", Rec."No.");
            if rL_ProductionOrderComponents.FindSet then begin
                repeat
                    rL_Item.Get(rL_ProductionOrderComponents."Item No.");
                    if (rL_Item."No. Series" = 'ITM1-RFV') or (rL_Item."No. Series" = 'ITM1-INT') then begin //TAL0.4 added itm1-int
                                                                                                             //create the line if it does not exist
                        rL_RequisitionLineCheck.Reset;
                        rL_RequisitionLineCheck.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                        rL_RequisitionLineCheck.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
                        rL_RequisitionLineCheck.SetRange(Type, rL_RequisitionLineCheck.Type::Item);
                        rL_RequisitionLineCheck.SetFilter("No.", rL_ProductionOrderComponents."Item No.");
                        rL_RequisitionLineCheck.SETFILTER("Prod. Order No. Ref", Rec."No.");
                        if not rL_RequisitionLineCheck.FindSet then begin

                            Clear(rL_RequisitionLine);
                            rL_RequisitionLine.Reset;
                            rL_LastLineNo := 0;

                            rL_RequisitionLine.SetRange("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLine.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
                            if rL_RequisitionLine.FindLast then begin
                                rL_LastLineNo := rL_RequisitionLine."Line No.";
                            end;
                            rL_LastLineNo += 10000;

                            rL_RequisitionLine.Reset;
                            rL_RequisitionLine.Init;
                            rL_RequisitionLine.Validate("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLine.Validate("Journal Batch Name", rL_RequisitionWkshName.Name);
                            rL_RequisitionLine.Validate("Line No.", rL_LastLineNo);
                            rL_RequisitionLine.Insert(true);

                            rL_RequisitionLine.Validate(Type, rL_RequisitionLine.Type::Item);
                            rL_RequisitionLine.Validate("No.", rL_ProductionOrderComponents."Item No.");
                            rL_RequisitionLine.Validate("Action Message", rL_RequisitionLine."Action Message"::New);
                            rL_RequisitionLine.Validate("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                            rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Purchase;
                            rL_RequisitionLine.Validate("Location Code", rL_ProductionOrderComponents."Location Code");

                            rL_RequisitionLine.Validate(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                            rL_RequisitionLine."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                            rL_RequisitionLine.Validate("Unit of Measure Code", rL_ProductionOrderComponents."Unit of Measure Code");
                            rL_RequisitionLine."Prod. Order No. Ref" := Rec."No.";

                            rL_RequisitionLine.Modify;
                        end else
                            if rL_RequisitionLineCheck.FindSet then begin
                                rL_RequisitionLineCheck.Validate(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                rL_RequisitionLineCheck."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                rL_RequisitionLine.Modify;
                            end;

                    end;
                until rL_ProductionOrderComponents.Next = 0;
            end;


            //STEP 4 add line from other released orders
            rL_RequisitionLine.Reset;
            rL_RequisitionLine.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
            rL_RequisitionLine.SetRange(Type, rL_RequisitionLine.Type::Item);
            if rL_RequisitionLine.FindSet then begin
                //MESSAGE(FORMAT(rL_RequisitionLine.COUNT));
                repeat
                    //loop the components
                    //if line is found in the requisition update the quantity
                    rL_ProductionOrderComponents.Reset;
                    rL_ProductionOrderComponents.SetRange(Status, rL_ProductionOrderComponents.Status::Released);
                    rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", Rec."No.");
                    rL_ProductionOrderComponents.SetFilter("Item No.", rL_RequisitionLine."No.");
                    if rL_ProductionOrderComponents.FindSet then begin
                        // REPEAT
                        //rL_Item.GET(rL_ProductionOrderComponents."Item No.");

                        //IF (rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No.") OR (rL_Item."No. Series"='ITM1-RFV')  THEN BEGIN
                        //MESSAGE(rL_ProductionOrderComponents."Item No.");
                        if (rL_RequisitionLine."Prod. Order No. Ref" <> Rec."No.") or (rL_RequisitionLine.Quantity <> rL_ProductionOrderComponents."Expected Quantity") then begin
                            //insert new line.
                            //find the item with the
                            rL_RequisitionLineCheck.Reset;
                            rL_RequisitionLineCheck.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLineCheck.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
                            rL_RequisitionLineCheck.SetRange(Type, rL_RequisitionLineCheck.Type::Item);
                            rL_RequisitionLineCheck.SetFilter("No.", rL_ProductionOrderComponents."Item No.");
                            rL_RequisitionLineCheck.SETFILTER("Prod. Order No. Ref", Rec."No.");
                            if not rL_RequisitionLineCheck.FindSet then begin

                                rL_RequisitionWkshName.LoadDeltia('DP', rL_ProductionOrderComponents."Item No.");

                                rL_RequisitionLineLast.Reset;
                                rL_RequisitionLineLast.SetFilter("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                                rL_RequisitionLineLast.SetFilter("Journal Batch Name", rL_RequisitionWkshName.Name);
                                rL_RequisitionLineLast.SetRange(Type, rL_RequisitionLineLast.Type::Item);
                                rL_RequisitionLineLast.SetFilter("No.", rL_ProductionOrderComponents."Item No.");

                                if rL_RequisitionLineLast.FindLast then begin
                                    rL_RequisitionLineLast.Validate("Location Code", rL_ProductionOrderComponents."Location Code");
                                    rL_RequisitionLineLast.Validate(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                    rL_RequisitionLineLast."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                    rL_RequisitionLine.Validate("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                                    rL_RequisitionLineLast."Prod. Order No. Ref" := Rec."No.";
                                    rL_RequisitionLineLast.Modify;
                                end;
                            end else
                                if rL_RequisitionLineCheck.FindSet then begin
                                    //Update Quantity
                                    rL_RequisitionLineCheck.Validate(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                    rL_RequisitionLineCheck."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                    rL_RequisitionLineCheck.Modify;
                                end;


                        end;// IF rL_RequisitionLine."Prod. Order No. Ref"<>"No."
                            //END; //IF rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No."
                            //UNTIL rL_ProductionOrderComponents.NEXT=0;
                    end; // IF rL_ProductionOrderComponents.FINDSET

                until rL_RequisitionLine.Next = 0;
            end;


            Message('Update Completed.');

        end else begin
            Error(Text50000);
        end;
    end;

    local procedure OpenWorksheet();
    var
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
    begin

        rL_RequisitionWkshName.Reset;
        rL_RequisitionWkshName.SetFilter("Worksheet Template Name", 'REQ.');
        rL_RequisitionWkshName.SETFILTER("Vendor No.", Rec."Vendor No.");
        rL_RequisitionWkshName.SetRange("Transaction Type", rL_RequisitionWkshName."Transaction Type"::Inbound);
        if rL_RequisitionWkshName.FindSet then begin
            Page.Run(Page::"Req. Wksh. Names", rL_RequisitionWkshName);
        end;
    end;

    local procedure ShowProductionJournal();
    var
        ProdOrder: Record "Production Order";
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        CurrPage.SaveRecord;

        ProdOrder.GET(Rec.Status, Rec."No.");

        Clear(ProductionJrnlMgt);
        ProductionJrnlMgt.Handling(ProdOrder, ProdOrderLine."Line No.");
    end;

    var
        Text50000: Label 'Worksheet not found.';
        Text50001: Label 'Component lines do not exist.';
}
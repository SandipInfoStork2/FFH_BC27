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
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }

            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Documents Created"; "Documents Created")
            {
                ApplicationArea = All;
            }
            field("Documents Created By"; "Documents Created By")
            {
                ApplicationArea = All;
            }
            field("Documents Create Date"; "Documents Create Date")
            {
                ApplicationArea = All;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = All;
            }
            field("Client Computer Name"; "Client Computer Name")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; "Creation Date")
            {
                ApplicationArea = All;
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

                trigger OnAction();
                begin
                    OpenWorksheet;
                end;
            }
            action("Production Journal")
            {
                ApplicationArea = All;
                Image = Journal;

                trigger OnAction();
                begin
                    ShowProductionJournal;
                end;
            }



            action("Get Computer Name")
            {
                ApplicationArea = All;
                Image = Journal;

                trigger OnAction();
                var
                    cuMgt: Codeunit "General Mgt.";
                begin
                    clear(cuMgt);
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
                caption = 'Item Card';
                Image = Item;
                // RunObject = page "Item Card";
                //RunPageLink = "No." = field("No.");
                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if "Source Type" = "Source Type"::Item then begin
                        item.Get("Source No.");
                        page.Run(page::"Item Card", item);
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
                ManufacturingSetup.GET;
                if ManufacturingSetup."Mandatory Packing Agent" then begin
                    TestField("Packing Agent");
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
        TESTFIELD("Documents Created", false);
        TESTFIELD("Vendor No."); //TAL0.3

        //+TAL0.3
        rL_ProductionOrderComponents.RESET;
        rL_ProductionOrderComponents.SETRANGE(Status, rL_ProductionOrderComponents.Status::Released);
        rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", "No.");
        if not rL_ProductionOrderComponents.FINDSET then begin
            if rL_ProductionOrderComponents.COUNT = 0 then begin
                ERROR(Text50001);
            end;
        end;
        //-TAL0.3

        //check if
        rL_RequisitionWkshName.RESET;
        rL_RequisitionWkshName.SETFILTER("Worksheet Template Name", 'REQ.');
        rL_RequisitionWkshName.SETFILTER("Vendor No.", "Vendor No.");
        rL_RequisitionWkshName.SETRANGE("Transaction Type", rL_RequisitionWkshName."Transaction Type"::Inbound);
        if rL_RequisitionWkshName.FINDSET then begin


            //STEP 1 LOAD THE LIST
            rL_RequisitionLine.RESET;
            rL_RequisitionLine.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
            if not rL_RequisitionLine.FINDSET then begin
                //load the data
                rL_RequisitionWkshName.LoadDeltia('DP', '');
            end;

            //STEP 2 match the list and update quantity
            rL_RequisitionLine.RESET;
            rL_RequisitionLine.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
            rL_RequisitionLine.SETRANGE(Type, rL_RequisitionLine.Type::Item);
            rL_RequisitionLine.SETFILTER("Prod. Order No. Ref", '%1', '');
            if rL_RequisitionLine.FINDSET then begin
                repeat
                    //loop the components
                    //if line is found in the requisition update the quantity
                    rL_ProductionOrderComponents.RESET;
                    rL_ProductionOrderComponents.SETRANGE(Status, rL_ProductionOrderComponents.Status::Released);
                    rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", "No.");
                    rL_ProductionOrderComponents.SETFILTER("Item No.", rL_RequisitionLine."No.");
                    if rL_ProductionOrderComponents.FINDSET then begin
                        //REPEAT
                        //rL_Item.GET(rL_ProductionOrderComponents."Item No.");
                        // IF (rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No.") OR (rL_Item."No. Series"='ITM1-RFV')  THEN BEGIN
                        rL_RequisitionLine.VALIDATE("Location Code", rL_ProductionOrderComponents."Location Code");
                        rL_RequisitionLine.VALIDATE(Quantity, rL_ProductionOrderComponents."Expected Quantity" * (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                        rL_RequisitionLine."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" * (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                        rL_RequisitionLine.VALIDATE("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                        rL_RequisitionLine."Prod. Order No. Ref" := "No.";
                        rL_RequisitionLine.MODIFY;
                        //END;
                        //UNTIL rL_ProductionOrderComponents.NEXT=0;
                    end;

                until rL_RequisitionLine.NEXT = 0;
            end;

            //STEP 3
            //loop the component list and add the Raw material in the requisition worksheet
            rL_ProductionOrderComponents.RESET;
            rL_ProductionOrderComponents.SETRANGE(Status, rL_ProductionOrderComponents.Status::Released);
            rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", "No.");
            if rL_ProductionOrderComponents.FINDSET then begin
                repeat
                    rL_Item.GET(rL_ProductionOrderComponents."Item No.");
                    if (rL_Item."No. Series" = 'ITM1-RFV') or (rL_Item."No. Series" = 'ITM1-INT') then begin //TAL0.4 added itm1-int
                                                                                                             //create the line if it does not exist
                        rL_RequisitionLineCheck.RESET;
                        rL_RequisitionLineCheck.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                        rL_RequisitionLineCheck.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
                        rL_RequisitionLineCheck.SETRANGE(Type, rL_RequisitionLineCheck.Type::Item);
                        rL_RequisitionLineCheck.SETFILTER("No.", rL_ProductionOrderComponents."Item No.");
                        rL_RequisitionLineCheck.SETFILTER("Prod. Order No. Ref", "No.");
                        if not rL_RequisitionLineCheck.FINDSET then begin

                            CLEAR(rL_RequisitionLine);
                            rL_RequisitionLine.RESET;
                            rL_LastLineNo := 0;

                            rL_RequisitionLine.SETRANGE("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLine.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
                            if rL_RequisitionLine.FINDLAST then begin
                                rL_LastLineNo := rL_RequisitionLine."Line No.";
                            end;
                            rL_LastLineNo += 10000;

                            rL_RequisitionLine.RESET;
                            rL_RequisitionLine.INIT;
                            rL_RequisitionLine.VALIDATE("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLine.VALIDATE("Journal Batch Name", rL_RequisitionWkshName.Name);
                            rL_RequisitionLine.VALIDATE("Line No.", rL_LastLineNo);
                            rL_RequisitionLine.INSERT(true);

                            rL_RequisitionLine.VALIDATE(Type, rL_RequisitionLine.Type::Item);
                            rL_RequisitionLine.VALIDATE("No.", rL_ProductionOrderComponents."Item No.");
                            rL_RequisitionLine.VALIDATE("Action Message", rL_RequisitionLine."Action Message"::New);
                            rL_RequisitionLine.VALIDATE("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                            rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Purchase;
                            rL_RequisitionLine.VALIDATE("Location Code", rL_ProductionOrderComponents."Location Code");

                            rL_RequisitionLine.VALIDATE(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                            rL_RequisitionLine."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                            rL_RequisitionLine.VALIDATE("Unit of Measure Code", rL_ProductionOrderComponents."Unit of Measure Code");
                            rL_RequisitionLine."Prod. Order No. Ref" := "No.";

                            rL_RequisitionLine.MODIFY;
                        end else
                            if rL_RequisitionLineCheck.FINDSET then begin
                                rL_RequisitionLineCheck.VALIDATE(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                rL_RequisitionLineCheck."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                rL_RequisitionLine.MODIFY;
                            end;

                    end;
                until rL_ProductionOrderComponents.NEXT = 0;
            end;


            //STEP 4 add line from other released orders
            rL_RequisitionLine.RESET;
            rL_RequisitionLine.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
            rL_RequisitionLine.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
            rL_RequisitionLine.SETRANGE(Type, rL_RequisitionLine.Type::Item);
            if rL_RequisitionLine.FINDSET then begin
                //MESSAGE(FORMAT(rL_RequisitionLine.COUNT));
                repeat
                    //loop the components
                    //if line is found in the requisition update the quantity
                    rL_ProductionOrderComponents.RESET;
                    rL_ProductionOrderComponents.SETRANGE(Status, rL_ProductionOrderComponents.Status::Released);
                    rL_ProductionOrderComponents.SETFILTER("Prod. Order No.", "No.");
                    rL_ProductionOrderComponents.SETFILTER("Item No.", rL_RequisitionLine."No.");
                    if rL_ProductionOrderComponents.FINDSET then begin
                        // REPEAT
                        //rL_Item.GET(rL_ProductionOrderComponents."Item No.");

                        //IF (rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No.") OR (rL_Item."No. Series"='ITM1-RFV')  THEN BEGIN
                        //MESSAGE(rL_ProductionOrderComponents."Item No.");
                        if (rL_RequisitionLine."Prod. Order No. Ref" <> "No.") or (rL_RequisitionLine.Quantity <> rL_ProductionOrderComponents."Expected Quantity") then begin
                            //insert new line.
                            //find the item with the
                            rL_RequisitionLineCheck.RESET;
                            rL_RequisitionLineCheck.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                            rL_RequisitionLineCheck.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
                            rL_RequisitionLineCheck.SETRANGE(Type, rL_RequisitionLineCheck.Type::Item);
                            rL_RequisitionLineCheck.SETFILTER("No.", rL_ProductionOrderComponents."Item No.");
                            rL_RequisitionLineCheck.SETFILTER("Prod. Order No. Ref", "No.");
                            if not rL_RequisitionLineCheck.FINDSET then begin

                                rL_RequisitionWkshName.LoadDeltia('DP', rL_ProductionOrderComponents."Item No.");

                                rL_RequisitionLineLast.RESET;
                                rL_RequisitionLineLast.SETFILTER("Worksheet Template Name", rL_RequisitionWkshName."Worksheet Template Name");
                                rL_RequisitionLineLast.SETFILTER("Journal Batch Name", rL_RequisitionWkshName.Name);
                                rL_RequisitionLineLast.SETRANGE(Type, rL_RequisitionLineLast.Type::Item);
                                rL_RequisitionLineLast.SETFILTER("No.", rL_ProductionOrderComponents."Item No.");

                                if rL_RequisitionLineLast.FINDLAST then begin
                                    rL_RequisitionLineLast.VALIDATE("Location Code", rL_ProductionOrderComponents."Location Code");
                                    rL_RequisitionLineLast.VALIDATE(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                    rL_RequisitionLineLast."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                    rL_RequisitionLine.VALIDATE("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                                    rL_RequisitionLineLast."Prod. Order No. Ref" := "No.";
                                    rL_RequisitionLineLast.MODIFY;
                                end;
                            end else
                                if rL_RequisitionLineCheck.FINDSET then begin
                                    //Update Quantity
                                    rL_RequisitionLineCheck.VALIDATE(Quantity, rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100)));
                                    rL_RequisitionLineCheck."Original Quantity" := rL_ProductionOrderComponents."Expected Quantity" / (1 + (rL_ProductionOrderComponents."Scrap %" / 100));
                                    rL_RequisitionLineCheck.MODIFY;
                                end;


                        end;// IF rL_RequisitionLine."Prod. Order No. Ref"<>"No."
                            //END; //IF rL_ProductionOrderComponents."Item No."=rL_RequisitionLine."No."
                            //UNTIL rL_ProductionOrderComponents.NEXT=0;
                    end; // IF rL_ProductionOrderComponents.FINDSET

                until rL_RequisitionLine.NEXT = 0;
            end;


            MESSAGE('Update Completed.');

        end else begin
            ERROR(Text50000);
        end;
    end;

    local procedure OpenWorksheet();
    var
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
    begin

        rL_RequisitionWkshName.RESET;
        rL_RequisitionWkshName.SETFILTER("Worksheet Template Name", 'REQ.');
        rL_RequisitionWkshName.SETFILTER("Vendor No.", "Vendor No.");
        rL_RequisitionWkshName.SETRANGE("Transaction Type", rL_RequisitionWkshName."Transaction Type"::Inbound);
        if rL_RequisitionWkshName.FINDSET then begin
            PAGE.RUN(PAGE::"Req. Wksh. Names", rL_RequisitionWkshName);
        end;
    end;

    local procedure ShowProductionJournal();
    var
        ProdOrder: Record "Production Order";
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        CurrPage.SAVERECORD;

        ProdOrder.GET(Status, "No.");

        CLEAR(ProductionJrnlMgt);
        ProductionJrnlMgt.Handling(ProdOrder, ProdOrderLine."Line No.");
    end;

    var
        Text50000: Label 'Worksheet not found.';
        Text50001: Label 'Component lines do not exist.';
}
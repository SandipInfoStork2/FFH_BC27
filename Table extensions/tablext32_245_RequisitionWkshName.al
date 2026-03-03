//TAL0.1 2019/05/17 VC add Log fields, Vendor No, Type 

tableextension 50132 RequisitionWkshNameExt extends "Requisition Wksh. Name"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Create Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50002; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50004; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50005; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaptionML = ELL = ' ,Inbound,Outbound',
                              ENU = ' ,Inbound,Outbound';
            OptionMembers = " ",Inbound,Outbound;
        }
        field(50006; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Editable = false;

        }
        field(50007; "Print Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Print By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "No. of Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Requisition Line" where("Worksheet Template Name" = field("Worksheet Template Name"), "Journal Batch Name" = field(Name)));
            Editable = false;

        }
        field(50014; "No. of Boxes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header Addon" where("Buy-from Vendor No." = field("Vendor No.")));
            Editable = false;

        }
    }


    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Create Date" := CurrentDateTime;
        "Created By" := UserId;
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;

    end;

    procedure LoadDeltia(pCode: Code[10]; pItemNo: Code[20])
    var
        myInt: Integer;
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
        rL_StandardPurchaseLine: Record "Standard Purchase Line";
        rL_RequisitionLine: Record "Requisition Line";
        rL_LastLineNo: Integer;
    begin
        //Name from Vendor Card is Recurring Purchase Lines    


        if pItemNo = '' then begin
            rL_RequisitionLine.Reset;
            rL_RequisitionLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
            rL_RequisitionLine.SetFilter("Journal Batch Name", Name);
            if rL_RequisitionLine.FindSet then begin
                Error(Text50000);
            end;
        end;

        rL_RequisitionWkshName.Get("Worksheet Template Name", Name);

        rL_StandardPurchaseLine.Reset;
        rL_StandardPurchaseLine.SetFilter("Standard Purchase Code", pCode);
        if pItemNo <> '' then begin
            rL_StandardPurchaseLine.SetFilter("No.", pItemNo);
        end;

        if rL_StandardPurchaseLine.FindSet then begin
            repeat

                Clear(rL_RequisitionLine);
                rL_RequisitionLine.Reset;
                rL_LastLineNo := 0;

                rL_RequisitionLine.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
                rL_RequisitionLine.SetFilter("Journal Batch Name", Rec.Name);
                if rL_RequisitionLine.FindLast then begin
                    rL_LastLineNo := rL_RequisitionLine."Line No.";
                end;
                rL_LastLineNo += 10000;

                rL_RequisitionLine.Reset;
                rL_RequisitionLine.Init;
                rL_RequisitionLine.Validate("Worksheet Template Name", Rec."Worksheet Template Name");
                rL_RequisitionLine.Validate("Journal Batch Name", Rec.Name);
                rL_RequisitionLine.Validate("Line No.", rL_LastLineNo);
                rL_RequisitionLine.Insert(true);

                if rL_StandardPurchaseLine."No." <> '' then begin
                    rL_RequisitionLine.Validate(Type, rL_StandardPurchaseLine.Type);
                    rL_RequisitionLine.Validate("No.", rL_StandardPurchaseLine."No.");
                    rL_RequisitionLine.Validate("Action Message", rL_RequisitionLine."Action Message"::New);
                    rL_RequisitionLine.Validate("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                    //rL_RequisitionLine."Extended Description":=rL_StandardPurchaseLine."Extended Description";

                    case rL_StandardPurchaseLine."Replenishment System" of

                        rL_StandardPurchaseLine."Replenishment System"::Boxes:
                            begin
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Boxes;
                            end;

                        rL_StandardPurchaseLine."Replenishment System"::Sales:
                            begin
                                if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound then begin
                                    rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::"Sales Return Order";
                                end else
                                    if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound then begin
                                        rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::"Sales Order";
                                    end;
                            end;

                        rL_StandardPurchaseLine."Replenishment System"::Transfer:
                            begin
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Transfer;
                            end;

                        //+1.0.0.236
                        rL_StandardPurchaseLine."Replenishment System"::Purchase:
                            begin
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Purchase;
                            end;
                    //-1.0.0.236

                    end;


                end else begin
                    rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::" ";
                end;


                rL_RequisitionLine.Modify;
            until rL_StandardPurchaseLine.Next = 0;
        end;

    end;

    procedure UpdateReplenishment(var pRequisitionLine: Record "Requisition Line"; pCode: Code[10])
    var
        myInt: Integer;
        rL_StandardPurchaseLine: Record "Standard Purchase Line";
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        rL_RequisitionWkshName.Get(pRequisitionLine."Worksheet Template Name", pRequisitionLine."Journal Batch Name");

        rL_StandardPurchaseLine.Reset;
        rL_StandardPurchaseLine.SetFilter("Standard Purchase Code", pCode);
        rL_StandardPurchaseLine.SetFilter("No.", pRequisitionLine."No.");
        if rL_StandardPurchaseLine.FindSet then begin



            case rL_StandardPurchaseLine."Replenishment System" of

                rL_StandardPurchaseLine."Replenishment System"::Boxes:
                    begin
                        pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::Boxes;
                    end;

                rL_StandardPurchaseLine."Replenishment System"::Sales:
                    begin
                        if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound then begin
                            pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::"Sales Return Order";
                        end else
                            if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound then begin
                                pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::"Sales Order";
                            end;
                    end;

                rL_StandardPurchaseLine."Replenishment System"::Transfer:
                    begin
                        pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::Transfer;
                    end;

            end;


            pRequisitionLine.Modify;

        end;

    end;

    var
        myInt: Integer;
        Text50000: Label 'Delete any records to insert new set.';
}
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
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
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
            CalcFormula = Count("Requisition Line" WHERE("Worksheet Template Name" = FIELD("Worksheet Template Name"), "Journal Batch Name" = FIELD(Name)));
            Editable = false;

        }
        field(50014; "No. of Boxes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Header Addon" WHERE("Buy-from Vendor No." = FIELD("Vendor No.")));
            Editable = false;

        }
    }


    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Create Date" := CURRENTDATETIME;
        "Created By" := USERID;
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        "Last Modified By" := USERID;
        "Last Modified Date" := CURRENTDATETIME;

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


        IF pItemNo = '' THEN BEGIN
            rL_RequisitionLine.RESET;
            rL_RequisitionLine.SETRANGE("Worksheet Template Name", "Worksheet Template Name");
            rL_RequisitionLine.SETFILTER("Journal Batch Name", Name);
            IF rL_RequisitionLine.FINDSET THEN BEGIN
                ERROR(Text50000);
            END;
        END;

        rL_RequisitionWkshName.GET("Worksheet Template Name", Name);

        rL_StandardPurchaseLine.RESET;
        rL_StandardPurchaseLine.SETFILTER("Standard Purchase Code", pCode);
        IF pItemNo <> '' THEN BEGIN
            rL_StandardPurchaseLine.SETFILTER("No.", pItemNo);
        END;

        IF rL_StandardPurchaseLine.FINDSET THEN BEGIN
            REPEAT

                CLEAR(rL_RequisitionLine);
                rL_RequisitionLine.RESET;
                rL_LastLineNo := 0;

                rL_RequisitionLine.SETRANGE("Worksheet Template Name", Rec."Worksheet Template Name");
                rL_RequisitionLine.SETFILTER("Journal Batch Name", Rec.Name);
                IF rL_RequisitionLine.FINDLAST THEN BEGIN
                    rL_LastLineNo := rL_RequisitionLine."Line No.";
                END;
                rL_LastLineNo += 10000;

                rL_RequisitionLine.RESET;
                rL_RequisitionLine.INIT;
                rL_RequisitionLine.VALIDATE("Worksheet Template Name", Rec."Worksheet Template Name");
                rL_RequisitionLine.VALIDATE("Journal Batch Name", Rec.Name);
                rL_RequisitionLine.VALIDATE("Line No.", rL_LastLineNo);
                rL_RequisitionLine.INSERT(TRUE);

                IF rL_StandardPurchaseLine."No." <> '' THEN BEGIN
                    rL_RequisitionLine.VALIDATE(Type, rL_StandardPurchaseLine.Type);
                    rL_RequisitionLine.VALIDATE("No.", rL_StandardPurchaseLine."No.");
                    rL_RequisitionLine.VALIDATE("Action Message", rL_RequisitionLine."Action Message"::New);
                    rL_RequisitionLine.VALIDATE("Vendor No.", rL_RequisitionWkshName."Vendor No.");
                    //rL_RequisitionLine."Extended Description":=rL_StandardPurchaseLine."Extended Description";

                    CASE rL_StandardPurchaseLine."Replenishment System" OF

                        rL_StandardPurchaseLine."Replenishment System"::Boxes:
                            BEGIN
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Boxes;
                            END;

                        rL_StandardPurchaseLine."Replenishment System"::Sales:
                            BEGIN
                                IF rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound THEN BEGIN
                                    rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::"Sales Return Order";
                                END ELSE
                                    IF rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound THEN BEGIN
                                        rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::"Sales Order";
                                    END;
                            END;

                        rL_StandardPurchaseLine."Replenishment System"::Transfer:
                            BEGIN
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Transfer;
                            END;

                        //+1.0.0.236
                        rL_StandardPurchaseLine."Replenishment System"::Purchase:
                            BEGIN
                                rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::Purchase;
                            END;
                    //-1.0.0.236

                    END;


                END ELSE BEGIN
                    rL_RequisitionLine."Replenishment System" := rL_RequisitionLine."Replenishment System"::" ";
                END;


                rL_RequisitionLine.MODIFY;
            UNTIL rL_StandardPurchaseLine.NEXT = 0;
        END;

    end;

    procedure UpdateReplenishment(VAR pRequisitionLine: Record "Requisition Line"; pCode: Code[10])
    var
        myInt: Integer;
        rL_StandardPurchaseLine: Record "Standard Purchase Line";
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        rL_RequisitionWkshName.GET(pRequisitionLine."Worksheet Template Name", pRequisitionLine."Journal Batch Name");

        rL_StandardPurchaseLine.RESET;
        rL_StandardPurchaseLine.SETFILTER("Standard Purchase Code", pCode);
        rL_StandardPurchaseLine.SETFILTER("No.", pRequisitionLine."No.");
        IF rL_StandardPurchaseLine.FINDSET THEN BEGIN



            CASE rL_StandardPurchaseLine."Replenishment System" OF

                rL_StandardPurchaseLine."Replenishment System"::Boxes:
                    BEGIN
                        pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::Boxes;
                    END;

                rL_StandardPurchaseLine."Replenishment System"::Sales:
                    BEGIN
                        IF rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound THEN BEGIN
                            pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::"Sales Return Order";
                        END ELSE
                            IF rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound THEN BEGIN
                                pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::"Sales Order";
                            END;
                    END;

                rL_StandardPurchaseLine."Replenishment System"::Transfer:
                    BEGIN
                        pRequisitionLine."Replenishment System" := pRequisitionLine."Replenishment System"::Transfer;
                    END;

            END;


            pRequisitionLine.MODIFY;

        END;

    end;

    var
        myInt: Integer;
        Text50000: Label 'Delete any records to insert new set.';
}
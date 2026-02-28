/*
 TAL0.1 2019/06/07 VC update Vendor No. when location is changed
      TAL0.2 2019/06/07 VC update replenishment
      TAL0.3 2019/06/20 ANP Get customer from vendor card
*/

//event OnUpdateDescriptionFromItem

tableextension 50133 RequisitionLine extends "Requisition Line"
{
    fields
    {
        // Add changes to table fields here

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                ReqWkshName: Record "Requisition Wksh. Name";
            begin
                //+TAL0.1
                IF "Vendor No." = '' THEN BEGIN
                    ReqWkshName.GET("Worksheet Template Name", "Journal Batch Name");
                    "Vendor No." := ReqWkshName."Vendor No.";
                END;
                //-TAL0.1

                //+TAL0.2
                //update replenishment from Standad Sales Lines
                IF xRec."Replenishment System" <> "Replenishment System" THEN BEGIN
                    ReqWkshName.GET("Worksheet Template Name", "Journal Batch Name");
                    IF ReqWkshName."Transaction Type" = ReqWkshName."Transaction Type"::Inbound THEN BEGIN
                        ReqWkshName.UpdateReplenishment(Rec, 'DP');
                    END ELSE
                        IF ReqWkshName."Transaction Type" = ReqWkshName."Transaction Type"::Outbound THEN BEGIN
                            ReqWkshName.UpdateReplenishment(Rec, 'DA');
                        END;
                END;
                //-TAL0.2

            end;
        }

        //+1.0.0.46 
        modify("Vendor No.")
        {
            TableRelation = Vendor;
        }
        //-1.0.0.46 

        field(50000; "Extended Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Prod. Order No. Ref"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Production Order" WHERE(Status = FILTER(Released));
        }

        //+1.0.0.46 
        field(50002; "Vendor Name"; Text[100])
        {
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
        //-1.0.0.46 
    }

    var
        myInt: Integer;
}
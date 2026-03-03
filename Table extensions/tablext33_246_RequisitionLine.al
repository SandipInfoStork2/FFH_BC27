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
                if "Vendor No." = '' then begin
                    ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
                    "Vendor No." := ReqWkshName."Vendor No.";
                end;
                //-TAL0.1

                //+TAL0.2
                //update replenishment from Standad Sales Lines
                if xRec."Replenishment System" <> "Replenishment System" then begin
                    ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
                    if ReqWkshName."Transaction Type" = ReqWkshName."Transaction Type"::Inbound then begin
                        ReqWkshName.UpdateReplenishment(Rec, 'DP');
                    end else
                        if ReqWkshName."Transaction Type" = ReqWkshName."Transaction Type"::Outbound then begin
                            ReqWkshName.UpdateReplenishment(Rec, 'DA');
                        end;
                end;
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
            TableRelation = "Production Order" where(Status = filter(Released));
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
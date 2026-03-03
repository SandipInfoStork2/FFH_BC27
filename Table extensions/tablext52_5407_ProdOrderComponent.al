/*
 TAL0.1 2018/07/25 VC add Item Category Code, Transfer From item
      TAL0.2 2019/06/06 VC Validate SKU
      TAL0.3 2019/06/13 VC check unit cost from max unit cost

      TAL0.4 2022/01/11 VC add field Last Date Modified
                                Created By
                                Client Computer Name
*/

tableextension 50152 ProdOrderComponentExt extends "Prod. Order Component"
{
    fields
    {
        // Add changes to table fields here

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                SKU: Record "Stockkeeping Unit";
                GetPlanningParameters: Codeunit "Planning-Get Parameters";
            begin
                //+TAL0.2 
                GetPlanningParameters.AtSKU(SKU, "Item No.", "Variant Code", "Location Code");
                if "Location Code" <> '' then begin
                    case SKU."Replenishment System" of

                        SKU."Replenishment System"::Purchase:
                            begin
                                Validate("Action Type", "Action Type"::"Purchase Order");
                            end;

                        SKU."Replenishment System"::"Prod. Order":
                            begin

                            end;

                        SKU."Replenishment System"::Transfer:
                            begin
                                Validate("Action Type", "Action Type"::Transfer);
                            end;

                        SKU."Replenishment System"::Assembly:
                            begin

                            end;

                        SKU."Replenishment System"::Box:
                            begin
                                Validate("Action Type", "Action Type"::"Plastic Box");
                            end;

                        SKU."Replenishment System"::Sale:
                            begin
                                Validate("Action Type", "Action Type"::"Sales Return Order");
                            end;

                    end;
                end;
                //-TAL0.2 
            end;
        }

        field(50000; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(50001; "Action Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Transfer,"Purchase Order","Sales Return Order","Plastic Box";
        }
        field(50002; "Requisition Quantity"; Decimal)
        {
            CalcFormula = sum("Requisition Line".Quantity where("Prod. Order No. Ref" = field("Prod. Order No."), "No." = field("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Last Date Modified"; Date)
        {
            CalcFormula = lookup("Production Order"."Last Date Modified" where(Status = field(Status), "No." = field("Prod. Order No.")));
            Caption = 'Last Date Modified';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Created By"; Code[50])
        {
            CalcFormula = lookup("Production Order"."Created By" where(Status = field(Status), "No." = field("Prod. Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Client Computer Name"; Text[250])
        {
            CalcFormula = lookup("Production Order"."Client Computer Name" where(Status = field(Status), "No." = field("Prod. Order No.")));
            Caption = 'Client Computer Name';
            Editable = false;
            FieldClass = FlowField;
        }

        //+1.0.0.57
        field(50008; "Posted Quantity"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry".Quantity where("Order No." = field("Prod. Order No."),
                                "Order Type" = filter('Production'),
                                "Prod. Order Comp. Line No." = field("Line No.")
                                )
                                );
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        //-1.0.0.57

        field(50009; "Quantity per BUOM"; Decimal)
        {
            Caption = 'Quantity per BUOM';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }



    }

    var
        myInt: Integer;
}
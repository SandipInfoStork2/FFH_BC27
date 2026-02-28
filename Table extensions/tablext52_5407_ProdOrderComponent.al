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
                IF "Location Code" <> '' THEN BEGIN
                    CASE SKU."Replenishment System" OF

                        SKU."Replenishment System"::Purchase:
                            BEGIN
                                VALIDATE("Action Type", "Action Type"::"Purchase Order");
                            END;

                        SKU."Replenishment System"::"Prod. Order":
                            BEGIN

                            END;

                        SKU."Replenishment System"::Transfer:
                            BEGIN
                                VALIDATE("Action Type", "Action Type"::Transfer);
                            END;

                        SKU."Replenishment System"::Assembly:
                            BEGIN

                            END;

                        SKU."Replenishment System"::Box:
                            BEGIN
                                VALIDATE("Action Type", "Action Type"::"Plastic Box");
                            END;

                        SKU."Replenishment System"::Sale:
                            BEGIN
                                VALIDATE("Action Type", "Action Type"::"Sales Return Order");
                            END;

                    END;
                END;
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
            CalcFormula = Sum("Requisition Line".Quantity WHERE("Prod. Order No. Ref" = FIELD("Prod. Order No."), "No." = FIELD("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Last Date Modified"; Date)
        {
            CalcFormula = Lookup("Production Order"."Last Date Modified" WHERE(Status = FIELD(Status), "No." = FIELD("Prod. Order No.")));
            Caption = 'Last Date Modified';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Created By"; Code[50])
        {
            CalcFormula = Lookup("Production Order"."Created By" WHERE(Status = FIELD(Status), "No." = FIELD("Prod. Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Client Computer Name"; Text[250])
        {
            CalcFormula = Lookup("Production Order"."Client Computer Name" WHERE(Status = FIELD(Status), "No." = FIELD("Prod. Order No.")));
            Caption = 'Client Computer Name';
            Editable = false;
            FieldClass = FlowField;
        }

        //+1.0.0.57
        field(50008; "Posted Quantity"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Order No." = FIELD("Prod. Order No."),
                                "Order Type" = filter('Production'),
                                "Prod. Order Comp. Line No." = FIELD("Line No.")
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

/*
TAL0.1 2018/07/25 VC add No. Carton Lines
TAL0.2 2019/06/06 VC add Field Vendor No.
TAL0.3 2019/06/12 VC add Field 
      Documents Created
      Documents Created By
      Documents Create Date

TAL0.4 2022/01/10 VC add Field  
          Created By
          Client Computer Name
*/
tableextension 50150 ProductionOrderExt extends "Production Order"
{
    fields


    {
        // Add changes to table fields here


        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Location: Record Location;
            begin
                //+1.0.0.293
                if "Packing Agent" = '' then begin
                    if Location.Get("Location Code") then begin
                        if Location."Packing Agent" <> '' then begin
                            "Packing Agent" := Location."Packing Agent";
                        end;
                    end;

                end;
                //-1.0.0.293
            end;
        }
        field(50000; "No. Carton Lines"; Integer)
        {
            CalcFormula = count("Prod. Order Component" where("Item Category Code" = filter('CARTONS|RBAG|VERTBAG|POTBAGS|CLIPMACH'), "Prod. Order No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Νο. Prod. Order Line"; Integer)
        {
            CalcFormula = count("Prod. Order Line" where("Prod. Order No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50003; "Documents Created"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                //+TAL0.3
                if "Documents Created" then begin
                    "Documents Created By" := UserId;
                    "Documents Create Date" := CurrentDateTime;
                end else begin
                    "Documents Created By" := '';
                    "Documents Create Date" := 0DT;
                end;
                //-TAL0.3
            end;
        }
        field(50004; "Documents Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Documents Create Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50007; "Client Computer Name"; Text[250])
        {
            Caption = 'Client Computer Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        //+1.0.0.229
        field(50008; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(5404), Type = const(Category1));
        }
        //-1.0.0.229


    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        //+TAL0.4
        "Created By" := UserId;
        if ActiveSession.Get(ServiceInstanceId, SessionId) then begin
            "Client Computer Name" := ActiveSession."Client Computer Name";
        end;
        //-TAL0.4
    end;

    var
        myInt: Integer;
        ActiveSession: Record "Active Session";
}
tableextension 50110 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        modify(Quantity)
        {

            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                "Total Net Weight" := "Quantity (Base)" * "Net Weight";
            end;
        }

        field(50000; "Unit of Measure (Base)"; Code[10])
        {
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50012; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        //TAL 1.0.0.201 >>
        field(50013; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50014; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        //TAL 1.0.0.201 <<

        field(50146; "Receiving Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Receiving Temperature °C';
        }

        field(50147; "Receiving Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    var
        rL_PurchaseHeader: Record "Purchase Header";
        rL_PPSetup: Record "Purchases & Payables Setup";
    begin
        if "Document Type" = "Document Type"::Order then begin

            rL_PPSetup.Get;


            rL_PurchaseHeader.Reset;
            rL_PurchaseHeader.SetRange("Document Type", "Document Type");
            rL_PurchaseHeader.SetFilter("No.", "Document No.");
            if rL_PurchaseHeader.FindSet() then begin
                if rL_PPSetup."Mand. P.O. Expected Recpt Date" then begin
                    rL_PurchaseHeader.TestField("Location Code");
                    rL_PurchaseHeader.TestField("Expected Receipt Date");
                end;


            end;
        end;

    end;

    var
        myInt: Integer;
}
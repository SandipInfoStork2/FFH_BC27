tableextension 50109 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Total Qty"; Decimal)
        {
            CalcFormula = sum("Purchase Line".Quantity where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Total Qty Received"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Quantity Received" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Total Qty Invoiced"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Quantity Invoiced" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Deliver-to Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate();

            var
                Vend: Record Vendor;
            begin
                Vend.Get("Deliver-to Vendor No.");
                "Deliver-to Name" := Vend.Name;
            end;
        }
        field(50004; "Deliver-to Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Vendor: Record Vendor;
            begin
            end;
        }
        field(50005; "Deliver Address Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Order Address".Code where("Vendor No." = field("Deliver-to Vendor No."));

            trigger OnValidate();
            var
                OrderAddr: Record "Order Address";
            begin
                if "Deliver Address Code" <> '' then begin
                    OrderAddr.Get("Deliver-to Vendor No.", "Deliver Address Code");

                    SetShipToAddress(
                      OrderAddr.Name, OrderAddr."Name 2", OrderAddr.Address, OrderAddr."Address 2",
                      OrderAddr.City, OrderAddr."Post Code", OrderAddr.County, OrderAddr."Country/Region Code");
                    "Ship-to Contact" := OrderAddr.Contact;
                end;
            end;
        }
        field(50006; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }

        field(50007; "Total Return Qty Shipped"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Return Qty. Shipped" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }

        field(50008; "Expected Receipt Time"; Time)
        {
            Caption = 'Expected Receipt Time';

            trigger OnValidate()
            begin

            end;
        }
        field(50102; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            //TAL 1.0.0.201 >>
            trigger OnValidate()
            var
                Response: Boolean;
                rL_PurchaseLine: Record "Purchase Line";
            begin
                rL_PurchaseLine.Reset();
                rL_PurchaseLine.SetRange("Document Type", "Document Type");
                rL_PurchaseLine.SetRange("Document No.", "No.");
                if rL_PurchaseLine.FindSet() then begin
                    Response := Dialog.Confirm('Do you want to update the lines?');
                    if Response then
                        UpdateTransferFromCode(rL_PurchaseLine);
                end;
            end;
            //TAL 1.0.0.201 <<
        }
        field(50103; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            //TAL 1.0.0.201 >>
            trigger OnValidate()
            var
                Response: Boolean;
                rL_PurchaseLine: Record "Purchase Line";
            begin
                rL_PurchaseLine.Reset();
                rL_PurchaseLine.SetRange("Document Type", "Document Type");
                rL_PurchaseLine.SetRange("Document No.", "No.");
                if rL_PurchaseLine.FindSet() then begin
                    Response := Dialog.Confirm('Do you want to update the lines?');
                    if Response then
                        UpdateTransferToCode(rL_PurchaseLine);
                end;
            end;
            //TAL 1.0.0.201 <<
        }

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




    procedure PrintAppendixRecords(var pPurchaseHeader: Record "Purchase Header")
    var
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix FFH";
    begin
        if pPurchaseHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetPurchaseOrder("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pPurchaseHeader.Next = 0;
        end;
    end;

    //TAL 1.0.0.201 >>
    procedure UpdateTransferFromCode(rL_PurchaseLine: Record "Purchase Line")
    begin
        repeat
            rL_PurchaseLine."Transfer-from Code" := Rec."Transfer-from Code";
            rL_PurchaseLine.Modify();
        until rL_PurchaseLine.Next() = 0;
    end;

    procedure UpdateTransferToCode(rL_PurchaseLine: Record "Purchase Line")
    begin
        repeat
            rL_PurchaseLine."Transfer-to Code" := Rec."Transfer-to Code";
            rL_PurchaseLine.Modify();
        until rL_PurchaseLine.Next() = 0;
    end;
    //TAL 1.0.0.201 <<

    var
        myInt: Integer;
}
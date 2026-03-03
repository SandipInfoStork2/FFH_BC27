
table 50003 "Order Qty"
{
    DrillDownPageId = "Order Qty";
    LookupPageId = "Order Qty";

    fields
    {
        field(1; "Document Type"; Enum "Order Qty Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(4; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }

        field(5; "Create Datime"; DateTime)
        {
            Caption = 'Create Datime';
        }

        field(6; "Max Version No."; Boolean)
        {

        }

        field(7; Deleted; Boolean)
        {

        }

        field(10; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(15; "Sales Line Quantity"; Decimal)
        {
            Caption = 'Sales Line Quantity';
            DecimalPlaces = 0 : 5;
        }



        field(30; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(40; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(41; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(70; "UOM (Base)"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(5407; "Sales Unit of Measure Code"; Code[10])
        {
            Caption = 'Sales Unit of Measure Code';
        }

        field(50052; "Qty. Requested"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50053; "Previous Qty. Requested"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50054; "Stat. Qty. Requested Change"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50055; "Stat. Qty. Requested Change %"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }

        field(50057; "Qty. Confirmed"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50058; "Previous Qty. Confirmed"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }

        field(50059; "Stat. Qty. Confirmed Change"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50060; "Stat. Qty. Confirmed Change %"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }

        field(50145; "New Order Qty"; Boolean)
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Version No.", "Shelf No.")
        {
            //Clustered = true;
        }

        key(Key2; "Order Date")
        {
        }

        key(Key3; "Customer No.")
        {
        }

        key(Key4; "Shelf No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure UpdateQty(var pSalesLine: Record "Sales Line"; pOrderQtyDocumentType: Enum "Order Qty Document Type")
    var
        OrderQty: Record "Order Qty";
        SalesHeader: Record "Sales Header";
        vVersionNo: Integer;

        vL_oldQtyRequested: Decimal;
        vL_oldQtyConfirmed: Decimal;
        DeleteEntryFound: Boolean;
    begin
        if pSalesLine.Type <> pSalesLine.Type::Item then begin
            exit;
        end;

        if pSalesLine."Shelf No." = '' then begin
            exit;
        end;

        vL_oldQtyRequested := 0;
        vL_oldQtyConfirmed := 0;
        DeleteEntryFound := false;

        SalesHeader.Get(pSalesLine."Document Type", pSalesLine."Document No.");
        pSalesLine.CalcFields("Unit of Measure (Base)");

        //update old deleted
        Clear(OrderQty);
        OrderQty.Reset;
        OrderQty.SetFilter("Customer No.", SalesHeader."Sell-to Customer No.");
        OrderQty.SetRange("Order Date", SalesHeader."Order Date");
        OrderQty.SetFilter("Shelf No.", pSalesLine."Shelf No.");
        OrderQty.SetRange(Deleted, true);
        if OrderQty.FindSet() then begin
            OrderQty.ModifyAll("Sales Unit of Measure Code", '');
            OrderQty.ModifyAll("Sales Line Quantity", 0);
            OrderQty.ModifyAll(Deleted, false);

            DeleteEntryFound := true;
        end;

        Clear(OrderQty);
        OrderQty.Reset;
        OrderQty.SetCurrentKey("Document Type", "Customer No.", "Order Date", "Shelf No.", "Version No.");
        OrderQty.SetRange("Document Type", pOrderQtyDocumentType);
        //OrderQty.SetFilter("Document No.", pSalesLine."Document No.");
        //OrderQty.SetRange("Line No.", pSalesLine."Line No.");
        OrderQty.SetFilter("Customer No.", pSalesLine."Sell-to Customer No.");
        OrderQty.SetRange("Order Date", SalesHeader."Order Date");
        OrderQty.SetFilter("Shelf No.", pSalesLine."Shelf No.");
        if not OrderQty.FindSet() then begin
            Clear(OrderQty);
            OrderQty."Document Type" := pOrderQtyDocumentType;
            OrderQty."Document No." := pSalesLine."Document No.";
            OrderQty."Line No." := pSalesLine."Line No.";
            OrderQty."Version No." := 1;
            OrderQty."Shelf No." := pSalesLine."Shelf No."; //because line no can be different 
            OrderQty.Insert();
        end else begin
            if OrderQty.FindLast() then begin
                vVersionNo := OrderQty."Version No." + 1;
                vL_oldQtyRequested := OrderQty."Qty. Requested";
                vL_oldQtyConfirmed := OrderQty."Qty. Confirmed";

                Clear(OrderQty);
                OrderQty."Document Type" := pOrderQtyDocumentType;
                OrderQty."Document No." := pSalesLine."Document No.";
                OrderQty."Line No." := pSalesLine."Line No.";
                OrderQty."Version No." := vVersionNo;
                OrderQty."Shelf No." := pSalesLine."Shelf No.";
                OrderQty.Insert();
                //insert new record
            end;

        end;

        OrderQty."Order Date" := SalesHeader."Order Date";
        OrderQty."Item No." := pSalesLine."No.";
        OrderQty."Shelf No." := pSalesLine."Shelf No.";
        OrderQty."Qty. Requested" := pSalesLine."Qty. Requested";
        OrderQty."Previous Qty. Requested" := vL_oldQtyRequested;

        OrderQty."Qty. Confirmed" := pSalesLine."Qty. Confirmed";
        OrderQty."Previous Qty. Confirmed" := vL_oldQtyConfirmed;

        if DeleteEntryFound then begin
            //if previous qty is deleted then set to zero
            if OrderQty."Qty. Requested" = vL_oldQtyRequested then begin
                OrderQty."Previous Qty. Requested" := 0;
                OrderQty."Previous Qty. Confirmed" := 0;
            end;
        end;

        OrderQty."UOM (Base)" := pSalesLine."Unit of Measure (Base)";
        OrderQty."Customer No." := pSalesLine."Sell-to Customer No.";
        OrderQty."Create Datime" := CurrentDateTime;


        OrderQty."Stat. Qty. Requested Change" := false;
        OrderQty."Stat. Qty. Requested Change %" := 0;
        if OrderQty."Previous Qty. Requested" <> OrderQty."Qty. Requested" then begin
            OrderQty."Stat. Qty. Requested Change" := true;

            if OrderQty."Previous Qty. Requested" <> 0 then
                OrderQty."Stat. Qty. Requested Change %" := ((OrderQty."Qty. Requested" / OrderQty."Previous Qty. Requested") * 100) - 100;
        end;

        OrderQty."Stat. Qty. Confirmed Change" := false;
        OrderQty."Stat. Qty. Confirmed Change %" := 0;
        if OrderQty."Previous Qty. Confirmed" <> OrderQty."Qty. Confirmed" then begin
            OrderQty."Stat. Qty. Confirmed Change" := true;

            if OrderQty."Previous Qty. Confirmed" <> 0 then
                OrderQty."Stat. Qty. Confirmed Change %" := ((OrderQty."Qty. Confirmed" / OrderQty."Previous Qty. Confirmed") * 100) - 100;
        end;

        if OrderQty.Modify() then;
        //OrderQty.Modify();
        OrderQty.UpdateMaxVersionNo(OrderQty);


    end;


    procedure UpdateMaxVersionNo(var pOrderQty: Record "Order Qty")
    var
        rLOrderQty: Record "Order Qty";
    begin
        rLOrderQty.Reset;
        rLOrderQty.SetRange("Document Type", pOrderQty."Document Type");
        //rLOrderQty.SetFilter("Document No.", pOrderQty."Document No.");
        //rLOrderQty.SetRange("Line No.", pOrderQty."Line No.");
        rLOrderQty.SetFilter("Customer No.", pOrderQty."Customer No.");
        rLOrderQty.SetRange("Order Date", pOrderQty."Order Date");
        rLOrderQty.SetFilter("Shelf No.", pOrderQty."Shelf No.");
        if rLOrderQty.FindSet() then begin
            rLOrderQty.ModifyAll("Max Version No.", false);
        end;

        rLOrderQty.Reset;
        //rLOrderQty.SetCurrentKey("Document Type", "Document No.", "Line No.", "Version No.");
        rLOrderQty.SetCurrentKey("Document Type", "Customer No.", "Order Date", "Shelf No.", "Version No.");
        //rLOrderQty.SetRange("Document Type", pOrderQty."Document Type");
        //rLOrderQty.SetFilter("Document No.", pOrderQty."Document No.");
        //rLOrderQty.SetRange("Line No.", pOrderQty."Line No.");
        rLOrderQty.SetFilter("Customer No.", pOrderQty."Customer No.");
        rLOrderQty.SetRange("Order Date", pOrderQty."Order Date");
        rLOrderQty.SetFilter("Shelf No.", pOrderQty."Shelf No.");
        if rLOrderQty.FindLast() then begin
            rLOrderQty."Max Version No." := true;
            rLOrderQty.Modify();
        end;

    end;

    procedure DeleteOrderQty(var pSalesLine: Record "Sales Line")
    var
        rLOrderQty: Record "Order Qty";
        SalesHeader: Record "Sales Header";
    begin
        if pSalesLine.Type <> pSalesLine.Type::Item then begin
            exit;
        end;

        if pSalesLine."Shelf No." = '' then begin
            exit;
        end;

        //find the last line and mark as deleted
        SalesHeader.Get(pSalesLine."Document Type", pSalesLine."Document No.");

        rLOrderQty.Reset;
        //rLOrderQty.SetRange("Document Type", pOrderQty."Document Type");
        rLOrderQty.SetFilter("Customer No.", SalesHeader."Sell-to Customer No.");
        rLOrderQty.SetRange("Order Date", SalesHeader."Order Date");
        rLOrderQty.SetFilter("Shelf No.", pSalesLine."Shelf No.");
        rLOrderQty.SetRange("Max Version No.", true);
        if rLOrderQty.FindSet() then begin
            rLOrderQty.Deleted := true;
            rLOrderQty."Sales Unit of Measure Code" := pSalesLine."Unit of Measure Code";
            rLOrderQty."Sales Line Quantity" := pSalesLine.Quantity;
            rLOrderQty.Modify();
        end;

    end;


}



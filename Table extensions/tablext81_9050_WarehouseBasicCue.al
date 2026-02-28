tableextension 50181 WarehouseBasicCueExt extends "Warehouse Basic Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Upcoming Ship. Transfer Orders"; Integer)
        {
            //AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count("Transfer Header" WHERE(Status = FILTER(Released),
                                                         "Shipment Date" = FIELD("Date Filter3")
                                                        ));
            Caption = 'Upcoming Shipment Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50001; "Upcoming Rec. Transfer Orders"; Integer)
        {
            //AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count("Transfer Header" WHERE(Status = FILTER(Released),
                                                         "Receipt Date" = FIELD("Date Filter3")
                                                        ));
            Caption = 'Upcoming Receipt Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50002; "Count Transfer Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header");
            Caption = 'Count Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50003; "Date Filter3"; Date)
        {
            Caption = 'Date Filter3';
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(50004; "Outstanding Ship. T.O."; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                         Status = FILTER(Released),
                                                         "Completely Shipped" = FILTER(false)
                                                         ));
            Caption = 'Outstanding Shipment Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50005; "Outstanding Receipt. T.O."; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                         Status = FILTER(Released),
                                                         "Completely Received" = FILTER(false)
                                                         ));
            Caption = 'Outstanding Receipt Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "Open Transfer Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                         Status = FILTER(Open)
                                                         ));
            Caption = 'Open Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //***********************
        //Receipts
        //***********************
        //ARAD-1 Aradipou - Main
        field(50007; "To Aradipou - Main Orders"; Integer)
        {
          
            CalcFormula = Count("Transfer Header" WHERE(
                                                        "Transfer-to Code" = FILTER('ARAD-1'),
                                                         "Completely Received" = FILTER(false)));
            Caption = 'Aradipou - Main Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50008; "To Fresh Cut Orders"; Integer)
        {
            
            CalcFormula = Count("Transfer Header" WHERE(
                                                         "Transfer-to Code" = FILTER('ARAD-3'),
                                                         "Completely Received" = FILTER(false)));
            Caption = 'To Fresh Cut Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50009; "To Kitchen Orders"; Integer)
        {
           
            CalcFormula = Count("Transfer Header" WHERE(
                                                         "Transfer-to Code" = FILTER('ARAD-4'),
                                                         "Completely Received" = FILTER(false)));
            Caption = 'To Kitchen Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50010; "To Potatoes Orders"; Integer)
        {
          
            CalcFormula = Count("Transfer Header" WHERE(
                                                         "Transfer-to Code" = FILTER('ARAD-5'),
                                                         "Completely Received" = FILTER(false)));
            Caption = 'To Potatoes Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //***********************
        //Shipments
        //***********************
        //ARAD-1 Aradipou - Main
        field(50012; "From Aradipou - Main Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                         "Transfer-From Code" = FILTER('ARAD-1'),
                                                         "Completely Shipped" = FILTER(false)));
            Caption = 'From Aradipou - Main Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50013; "From Fresh Cut Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                          "Transfer-From Code" = FILTER('ARAD-3'),
                                                          "Completely Shipped" = FILTER(false)));
            Caption = 'From Fresh Cut Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50014; "From Kitchen Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                          "Transfer-From Code" = FILTER('ARAD-4'),
                                                          "Completely Shipped" = FILTER(false)));
            Caption = 'From Kitchen Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50015; "From Potatoes Orders"; Integer)
        {

            CalcFormula = Count("Transfer Header" WHERE(
                                                          "Transfer-From Code" = FILTER('ARAD-5'),
                                                          "Completely Shipped" = FILTER(false)));
            Caption = 'From Potatoes Orders';
            Editable = false;
            FieldClass = FlowField;
        }


    }

    var
        myInt: Integer;
}
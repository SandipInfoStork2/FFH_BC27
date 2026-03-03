tableextension 50181 WarehouseBasicCueExt extends "Warehouse Basic Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Upcoming Ship. Transfer Orders"; Integer)
        {
            //AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = count("Transfer Header" where(Status = filter(Released),
                                                         "Shipment Date" = field("Date Filter3")
                                                        ));
            Caption = 'Upcoming Shipment Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50001; "Upcoming Rec. Transfer Orders"; Integer)
        {
            //AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = count("Transfer Header" where(Status = filter(Released),
                                                         "Receipt Date" = field("Date Filter3")
                                                        ));
            Caption = 'Upcoming Receipt Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50002; "Count Transfer Orders"; Integer)
        {

            CalcFormula = count("Transfer Header");
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

            CalcFormula = count("Transfer Header" where(
                                                         Status = filter(Released),
                                                         "Completely Shipped" = filter(false)
                                                         ));
            Caption = 'Outstanding Shipment Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50005; "Outstanding Receipt. T.O."; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                         Status = filter(Released),
                                                         "Completely Received" = filter(false)
                                                         ));
            Caption = 'Outstanding Receipt Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "Open Transfer Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                         Status = filter(Open)
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

            CalcFormula = count("Transfer Header" where(
                                                        "Transfer-to Code" = filter('ARAD-1'),
                                                         "Completely Received" = filter(false)));
            Caption = 'Aradipou - Main Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50008; "To Fresh Cut Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                         "Transfer-to Code" = filter('ARAD-3'),
                                                         "Completely Received" = filter(false)));
            Caption = 'To Fresh Cut Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50009; "To Kitchen Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                         "Transfer-to Code" = filter('ARAD-4'),
                                                         "Completely Received" = filter(false)));
            Caption = 'To Kitchen Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50010; "To Potatoes Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                         "Transfer-to Code" = filter('ARAD-5'),
                                                         "Completely Received" = filter(false)));
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

            CalcFormula = count("Transfer Header" where(
                                                         "Transfer-from Code" = filter('ARAD-1'),
                                                         "Completely Shipped" = filter(false)));
            Caption = 'From Aradipou - Main Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50013; "From Fresh Cut Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                          "Transfer-from Code" = filter('ARAD-3'),
                                                          "Completely Shipped" = filter(false)));
            Caption = 'From Fresh Cut Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50014; "From Kitchen Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                          "Transfer-from Code" = filter('ARAD-4'),
                                                          "Completely Shipped" = filter(false)));
            Caption = 'From Kitchen Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50015; "From Potatoes Orders"; Integer)
        {

            CalcFormula = count("Transfer Header" where(
                                                          "Transfer-from Code" = filter('ARAD-5'),
                                                          "Completely Shipped" = filter(false)));
            Caption = 'From Potatoes Orders';
            Editable = false;
            FieldClass = FlowField;
        }


    }

    var
        myInt: Integer;
}
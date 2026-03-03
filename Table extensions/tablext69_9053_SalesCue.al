tableextension 50169 SalesCueExt extends "Sales Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Not Invoiced"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order), "Completely Received" = filter(true), Invoice = filter(false), "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Purchase Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order)));
            Caption = 'Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50003; "Upcoming Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                        "Requested Delivery Date" = field("Date Filter2"),
                                                          "Completely Shipped" = filter(false),
                                                         "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Upcoming Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50004; "Outstanding Sales Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         "Completely Shipped" = filter(false),
                                                         "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Outstanding Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50005; "Sales Invoices"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Invoice),
                                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Sales Invoices';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "Count Sales Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order)));
            Caption = 'Count Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50007; "Sales Orders Not Invoiced"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order), "Completely Shipped" = filter(true), Invoice = filter(false), "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50008; "S.O. Partially Invoiced"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         "Completely Shipped" = filter(true),
                                                         Invoice = filter(true),
                                                         "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Partially Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-1 Aradipou - Main
        field(50012; "Aradipou - Main Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-1'),
                                                         "Completely Shipped" = filter(false),
                                                         "Requested Delivery Date" = field("Date Filter3")));
            Caption = 'Aradipou - Main Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50013; "Fresh Cut Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-3'),
                                                          "Completely Shipped" = filter(false),
                                                           "Requested Delivery Date" = field("Date Filter3")));
            Caption = 'Fresh Cut Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50014; "Kitchen Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-4'),
                                                          "Completely Shipped" = filter(false),
                                                           "Requested Delivery Date" = field("Date Filter3")));
            Caption = 'Kitchen Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50015; "Potatoes Orders"; Integer)
        {

            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-5'),
                                                          "Completely Shipped" = filter(false),
                                                           "Requested Delivery Date" = field("Date Filter3")));
            Caption = 'Potatoes Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50016; "Date Filter3"; Date)
        {
            Caption = 'Date Filter 3';
            Editable = false;
            FieldClass = FlowFilter;
        }

        //+1.0.0.286
        field(50017; "Not Invoiced ARAD-3"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header"
             where("Document Type" = filter(Order),
              //"Completely Received" = FILTER(True), 
              Invoice = filter(false),
              "Responsibility Center" = field("Responsibility Center Filter"),
              "Location Code" = const('ARAD-3'),
              "Total Qty Received" = filter('<>0'),
              "Total Qty Invoiced" = filter('0')
              ));

            Caption = 'Not Invoiced ARAD-3';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50018; "Not Invoiced ARAD-4"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header"
             where("Document Type" = filter(Order),
              //"Completely Received" = FILTER(True), 
              Invoice = filter(false),
              "Responsibility Center" = field("Responsibility Center Filter"),
              "Location Code" = const('ARAD-4'),
              "Total Qty Received" = filter('<>0'),
              "Total Qty Invoiced" = filter('0')
              ));

            Caption = 'Not Invoiced ARAD-4';
            Editable = false;
            FieldClass = FlowField;
        }
        //-1.0.0.286


    }

    var
        myInt: Integer;
}
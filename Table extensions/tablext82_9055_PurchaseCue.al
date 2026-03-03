tableextension 50182 PurchaseCueExt extends "Purchase Cue"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Count Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Count Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50001; "Count Return Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Return Order"),
                                                         "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Count Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-1 Aradipou - Main
        field(50002; "Aradipou - Main Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-1'),
                                                         "Completely Received" = filter(false),
                                                         "Expected Receipt Date" = field("Date Filter2")));
            Caption = 'Aradipou - Main Purch. Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut

        field(50003; "Fresh Cut Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-3'),
                                                         "Completely Received" = filter(false),
                                                         "Expected Receipt Date" = field("Date Filter2")));
            Caption = 'Fresh Cut Purch. Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen

        field(50004; "Kitchen Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-4'),
                                                         "Completely Received" = filter(false),
                                                         "Expected Receipt Date" = field("Date Filter2")));
            Caption = 'Kitchen Purch. Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50005; "Potatoes Orders"; Integer)
        {
            AccessByPermission = tabledata "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Location Code" = filter('ARAD-5'),
                                                         "Completely Received" = filter(false),
                                                         "Expected Receipt Date" = field("Date Filter2")));
            Caption = 'Potatoes Purch. Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "Date Filter2"; Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(50007; "Total Upcoming Orders"; Integer)
        {
            //AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                       "Completely Received" = filter(false),
                                                       "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Total Upcoming Orders';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
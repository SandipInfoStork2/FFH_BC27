/*
TAL0.1 2022/01/11 VC add fields Zero Component Lines,
                         Zero Date Filter
*/

tableextension 50170 ManufacturingCueExt extends "Manufacturing Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Zero Component Lines"; Integer)
        {
            CalcFormula = count("Prod. Order Component" where(Quantity = filter(0), "Last Date Modified" = field("Zero Date Filter"), Status = filter(Finished)));
            FieldClass = FlowField;
        }
        field(50001; "Zero Date Filter"; Date)
        {
            Caption = 'Zero Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }

        //Released Production Orders
        //ARAD-1 Aradipou - Main
        field(50002; "Aradipou - Main Orders"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = filter(Released),
                                                         "Location Code" = filter('ARAD-1')));
            Caption = 'Aradipou - Main Rel. Production Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-3 Fresh Cut
        field(50003; "Fresh Cut Orders"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = filter(Released),
                                                         "Location Code" = filter('ARAD-3')));
            Caption = 'Fresh Cut Rel. Production Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-4 Kitchen
        field(50004; "Kitchen Orders"; Integer)
        {

            CalcFormula = count("Production Order" where(Status = filter(Released),
                                                         "Location Code" = filter('ARAD-4')));
            Caption = 'Kitchen Rel. Production Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        //ARAD-5 - Potatoes
        field(50005; "Potatoes Orders"; Integer)
        {
            CalcFormula = count("Production Order" where(Status = filter(Released),
                                                         "Location Code" = filter('ARAD-5')));
            Caption = 'Potatoes Rel. Production Orders';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    var
        myInt: Integer;
}
/*
TAL0.1 2018/11/14 VC add field GLN Delivery for EDI
TAL0.2 2021/12/14 VC add field No. of Orders for Matrix

*/

tableextension 50129 ShiptoAddressExt extends "Ship-to Address"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "GLN Delivery"; Code[13])
        {
            DataClassification = ToBeClassified;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                //+TAL0.2
                if "GLN Delivery" <> '' then
                    GLNCalculator.AssertValidCheckDigit13("GLN Delivery");
                //-TAL0.2
            end;
        }
        field(50002; "No. of Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Ship-to Code" = field(Code), "Bill-to Customer No." = field("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50003; "Interface Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50008; Monday; Boolean)
        {
            Caption = 'Monday';
            NotBlank = false;
        }
        field(50009; Tuesday; Boolean)
        {
            Caption = 'Tuesday';
            NotBlank = false;
        }
        field(50010; Wednesday; Boolean)
        {
            Caption = 'Wednesday';
            NotBlank = false;
        }
        field(50011; Thursday; Boolean)
        {
            Caption = 'Thursday';

            NotBlank = false;
        }
        field(50012; Friday; Boolean)
        {
            Caption = 'Friday';
            NotBlank = false;
        }
        field(50013; Saturday; Boolean)
        {
            Caption = 'Saturday';
            NotBlank = false;
        }
        field(50014; Sunday; Boolean)
        {
            Caption = 'Sunday';
            NotBlank = false;
        }

        field(50015; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50016; "Notify Place Order"; Boolean)
        {
            Caption = 'Notify Place Order';
            NotBlank = false;
        }

        field(50017; "Shop Password"; Text[20])
        {
            Caption = 'Shop Password';
            NotBlank = false;
            ExtendedDatatype = Masked;

            trigger OnValidate()
            var

                ShiptoAdress: Record "Ship-to Address";
                Text50000: Label 'Password has been entered again. Please enter unique password for all shops. Shop %1';
            begin
                //check if the password has been entered.
                if "Shop Password" <> '' then begin
                    ShiptoAdress.Reset;
                    ShiptoAdress.SetFilter("Customer No.", "Customer No.");
                    ShiptoAdress.SetFilter("Shop Password", "Shop Password");
                    if ShiptoAdress.FindSet() then begin
                        if ShiptoAdress.Count > 1 then begin
                            Error(Text50000, ShiptoAdress.Code);
                        end;
                    end;


                end;


            end;
        }
    }

    procedure SetSecurityFilterOnCustomer()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if UserSetup."HORECA Customer No." <> '' then begin
            UserSetup.TestField("HORECA Customer No.");
            UserSetup.TestField("HORECA Ship-to Filter");

            FilterGroup(2);
            SetFilter("Customer No.", '%1', UserSetup."HORECA Customer No.");
            SetFilter("Code", '%1', UserSetup."HORECA Ship-to Filter");
            FilterGroup(0);
        end;


    end;


    var
        myInt: Integer;
}
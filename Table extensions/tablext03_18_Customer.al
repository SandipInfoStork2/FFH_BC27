/*
TAL0.1 2018/05/24 VC existing customisation with zero 0:0 format create conflict with new request
                     dynamic show posted sales Shipment and posted sales Invoice qty and shiped qty(Qty Base) with decimals or not  
                     add field Report Decimal Places

TAL0.2 2018/11/13 VC add field "GLN Delivery"
TAL0.3 2020/03/06 VC add field Ship-to Warehouse Code,Ship-to Warehouse Name 
TAL0.4 2020/03/06 VC add field Chain of Custody Tracking
*/

tableextension 50103 CustomerExt extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Report Decimal Places"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "GLN Delivery"; Code[13])
        {
            DataClassification = ToBeClassified;
            Numeric = true;

            trigger OnValidate();
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
                //+TAL0.2
                IF "GLN Delivery" <> '' THEN
                    GLNCalculator.AssertValidCheckDigit13("GLN Delivery");
                //-TAL0.2
            end;
        }
        field(50002; "Ship-to Warehouse Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Ship-to Warehouse Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50004; "T.I.C. Registration No."; Code[20])
        {
            Caption = 'T.I.C. Registration No.';

        }

        field(50005; "E-Mail CC"; Text[80])
        {
            Caption = 'Email CC';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                ValidateEmailCC();
            end;
        }

        field(50006; "Show GlobalGab COC No."; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50007; "Show Total Qty"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50008; "Mandatory CY Fields"; Boolean)
        {
            //Caption = 'Mandatory Line Category Fields';
            DataClassification = ToBeClassified;

        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.1

    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        IF "No." = '' THEN BEGIN
            ERROR('Blank No is not allowed');
        END;
        //-TAL0.1
    end;

    local procedure ValidateEmailCC()
    var
        MailManagement: Codeunit "Mail Management";
        IsHandled: Boolean;
    begin

        if "E-Mail CC" = '' then
            exit;
        MailManagement.CheckValidEmailAddresses("E-Mail CC");
    end;


    procedure SetSecurityFilterOnCustomer()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(UserId);
        if UserSetup."HORECA Customer No." <> '' then begin
            //UserSetup.TestField("HORECA Customer No.");
            FilterGroup(2);
            SetFilter("No.", '%1', UserSetup."HORECA Customer No.");
            FilterGroup(0);
        end;


    end;


    var
        myInt: Integer;
}
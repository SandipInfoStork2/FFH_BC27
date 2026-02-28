/*
TAL.JQEMail 2017/11/20 VC add field Job Queue Email
TAL0.1 2018/01/10 VC add fields User Department
TAL0.2 2019/12/06 VC add field Close Inventory Period

*/

tableextension 50115 UserSetupExt extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Job Queue Email"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Job Queue Email" THEN BEGIN
                    TESTFIELD("E-Mail");
                END;
            end;
        }
        field(50011; "User Department"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Retail Store,Wholesale,Accounting,Purchasing,Warehouse,Service Callcenter,Service Parts,Service Workshop,Service Admin,Controller,Read Only,Field Service,Stock Take,Web Order';
            OptionMembers = " ","Retail Store",Wholesale,Accounting,Purchasing,Warehouse,"Service Callcenter","Service Parts","Service Workshop","Service Admin",Controller,"Read Only","Field Service","Stock Take","Web Order";
        }
        field(50012; "Close Inventory Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //TAL 1.0.0.69 >>
        field(50016; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Signature"; BLOB)
        {
            SubType = Bitmap;
            DataClassification = CustomerContent;
        }
        //TAL 1.0.0.69 <<

        //+1.0.0.228
        field(50020; "Unit Cost Editable"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        //-1.0.0.228

        field(50021; "HORECA Customer No."; Code[20])
        {
            Caption = 'HORECA Customer No.';
            TableRelation = Customer;
        }

        field(50022; "HORECA Ship-to Filter"; Code[20])
        {
            Caption = 'HORECA Ship-to Filter';

        }

        field(50023; "HORECA Items"; Code[20])
        {
            Caption = 'HORECA Items';
            TableRelation = "Standard Sales Code";

        }


        field(50024; "HORECA Min. Order Period"; dateformula)
        {
            Caption = 'HORECA Min. Order Period';

        }

        field(50025; "HORECA Manager Email 1"; Text[80])
        {
            Caption = 'HORECA Manager Email 1';

            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "HORECA Manager Email 1" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("HORECA Manager Email 1");
            end;

        }

        field(50026; "HORECA Manager Email 2"; Text[80])
        {
            Caption = 'HORECA Manager Email 2';

            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "HORECA Manager Email 2" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("HORECA Manager Email 2");
            end;

        }

        field(50027; "HORECA Manager Email 3"; Text[80])
        {
            Caption = 'HORECA Manager Email 3';

            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "HORECA Manager Email 3" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("HORECA Manager Email 3");
            end;

        }

        //+1.0.0.292
        field(50028; "HORECA Package Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        //-1.0.0.292



    }

    var
        myInt: Integer;
}
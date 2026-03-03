//TAL0.1 2019/05/17 VC add fields Inbound Req. Wksh,Outbound Req. Wksh


tableextension 50101 LocationExt extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Inbound Req. Wksh"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Requisition Wksh. Name" where("Vendor No." = field(Code), "Transaction Type" = filter(Inbound)));
            Editable = false;

        }
        field(50001; "Outbound Req. Wksh"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Requisition Wksh. Name" where("Vendor No." = field(Code), "Transaction Type" = filter(Outbound)));
            Editable = false;

        }

        field(50002; "Last Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //TAL 1.0.0.95 >>
        field(50003; "Email CC"; Text[80])
        {
            Caption = 'Email CC';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                //MailManagement.ValidateEmailAddressField("Email CC");
                // if Rec."Email CC" <> '' then
                //     MailManagement.CheckValidEmailAddress("Email CC");
            end;
        }
        //TAL 1.0.0.95 <<

        field(50004; "Default Reason Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Reason Code';
            TableRelation = "Reason Code";
        }

        field(50005; "Work Order Email"; Text[80])
        {
            Caption = 'Work Order Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email");
            end;
        }

        field(50006; "Work Order Email CC"; Text[80])
        {
            Caption = 'Work Order Email CC';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email CC");
            end;
        }


        field(50007; "Work Order Email 2"; Text[80])
        {
            Caption = 'Work Order Email 2';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email 2");
            end;
        }

        field(50008; "Work Order Email 3"; Text[80])
        {
            Caption = 'Work Order Email 3';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email 3");
            end;
        }

        field(50009; "Work Order Email CC 2"; Text[80])
        {
            Caption = 'Work Order Email CC 2';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email CC 2");
            end;
        }

        field(50010; "Work Order Email CC 3"; Text[80])
        {
            Caption = 'Work Order Email CC 3';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Work Order Email CC 3");
            end;
        }

        //+1.0.0.293
        field(50011; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(5404), Type = const(Category1));
        }
        //-1.0.0.293
    }

    var
        myInt: Integer;
}
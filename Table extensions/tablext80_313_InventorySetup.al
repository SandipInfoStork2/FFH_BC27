tableextension 50180 InventorySetupExt extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Allow Change Tracking Code"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Notify Expired Items Email 1"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 1" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 1");
            end;
        }

        field(50002; "Notify Expired Items Email 2"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 2" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 2");
            end;
        }

        field(50003; "Notify Expired Items Email 3"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 3" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 3");
            end;
        }

        field(50004; "Notify Expired Items Email 4"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 4" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 4");
            end;
        }

        field(50005; "Notify Expired Items Email 5"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 5" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 5");
            end;
        }

        field(50006; "Notify Expired Items Email 6"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Expired Items Email 6" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Expired Items Email 6");
            end;
        }

        field(50007; "Allow Item Trac. Code Change"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow Item Tracking Code Change';
        }


        field(50011; "Item Cat. 10 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50012; "Item Cat. 11 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50013; "Item Cat. 12 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50014; "Item Cat. 13 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50015; "Item Cat. 14 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50016; "Item Cat. 15 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50017; "Item Cat. 16 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50018; "Item Cat. 17 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50019; "Item Cat. 18 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50020; "Item Cat. 19 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }

        field(50021; "Item Cat. 20 Caption"; Text[30])
        {
            DataClassification = SystemMetadata;
        }
    }

    var
        myInt: Integer;
}
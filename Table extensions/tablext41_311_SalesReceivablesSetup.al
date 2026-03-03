//TAL0.1 2021/04/03 add field Lidl Import Sundry Grower

tableextension 50141 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "EDI Last Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "EDI Counter"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "EDI Export Path Server"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "EDI Encoding Export"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'DOS-PC8,ANSI,UTF8,Unicode';
            OptionMembers = "DOS-PC8",ANSI,UTF8,Unicode;
        }
        field(50004; "EDI Export Dot Net"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "EDI Export Path Client"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Enable Lidl Cross-Ref Search"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Lidl Import Dev Mode"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Lidl Import Sundry Grower"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Grower;
        }
        field(50009; "Default Item Tracking Code"; Code[10])
        {
            CaptionML = ELL = 'Default Item Tracking Code',
                        ENU = 'Default Item Tracking Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Tracking Code";

            trigger OnValidate();
            begin
                //+TAL
                /*
                IF "Item Tracking Code" <> '' THEN
                  TESTFIELD(Type,Type::Inventory);
                IF "Item Tracking Code" = xRec."Item Tracking Code" THEN
                  EXIT;
                
                IF NOT ItemTrackingCode.GET("Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode);
                
                IF NOT ItemTrackingCode2.GET(xRec."Item Tracking Code") THEN
                  CLEAR(ItemTrackingCode2);
                
                IF (ItemTrackingCode."SN Specific Tracking" <> ItemTrackingCode2."SN Specific Tracking") OR
                   (ItemTrackingCode."Lot Specific Tracking" <> ItemTrackingCode2."Lot Specific Tracking")
                THEN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));
                
                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));
                
                  TESTFIELD("Item Tracking Code");
                
                  ItemTrackingCode.GET("Item Tracking Code");
                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                    ERROR(
                      Text018,
                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                      FIELDCAPTION("Costing Method"),"Costing Method");
                END;
                
                TestNoOpenDocumentsWithTrackingExist;
                */ //-TAL

            end;
        }
        field(50010; "Default Lot Nos."; Code[10])
        {
            CaptionML = ELL = 'Default Lot Nos.',
                        ENU = 'Default Lot Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

        field(50011; "EDI Create Server File"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50012; "Box Statement Codes"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50013; "Cost Profit %"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 5;
        }

        field(50014; "Box Stmt Item Category Filter"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Box Statement Item Category Filter';

            trigger OnLookup()
            var
                ItemCategory: Record "Item Category";
                pItemCategories: Page "Item Categories";
            begin

                Clear(pItemCategories);
                pItemCategories.SetTableView(ItemCategory);
                pItemCategories.LookupMode(true);
                if pItemCategories.RunModal = Action::LookupOK then begin
                    "Box Stmt Item Category Filter" := pItemCategories.GetSelectionFilter();
                end;
            end;
        }
        field(50015; "Box Stmt Show Cust. Location"; Boolean)
        {
            Caption = 'Box Statement Show Customer Location';
            DataClassification = ToBeClassified;
        }
        field(50016; "Mand. S.O. Req. Delivery Date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mandatory S.O. Requested Delivery Date';
        }

        field(50017; "Carton Category Filter"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50018; "Cup Category Filter"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50019; "Other Category Filter"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50020; "Costing Cost Field"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'None,Unit Cost,Last Direct Cost,Last Landed Unit Cost';
            OptionMembers = None,"Unit Cost","Last Direct Cost","Last Landed Unit Cost";
        }

        field(50021; "FILM Category Filter"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
            ValidateTableRelation = false;
        }

        field(50022; "FILM Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }


        field(50023; "Start Date PWeek Formula"; DateFormula)
        {
            Caption = 'Start Date Previous Week Formula';
            DataClassification = ToBeClassified;
        }

        field(50024; "End Date PWeek Formula"; DateFormula)
        {
            Caption = 'End Date Previous Week Formula';
            DataClassification = ToBeClassified;
        }

        field(50025; "Start Update Date Formula"; DateFormula)
        {
            Caption = 'Start Update Date Formula';
            DataClassification = ToBeClassified;
        }

        field(50026; "End Update Date Formula"; DateFormula)
        {
            Caption = 'End Update Date Formula';
            DataClassification = ToBeClassified;
        }

        field(50027; "Lidl Archive Orders"; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(50028; "Lidl Copy Quote History"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50030; "Lidl Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }


        //+1.0.0.247
        field(50031; "Horeca Start Date Validation"; DateFormula)
        {
            Caption = 'Horeca Import Start Date Validation';
            DataClassification = ToBeClassified;
        }

        field(50032; "Horeca End Date Validation"; DateFormula)
        {
            Caption = 'Horeca Import End Date Validation';
            DataClassification = ToBeClassified;
        }
        //-1.0.0.247


        //+1.0.0.268
        field(50033; "Notify Horeca Reminder Email 1"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 1" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 1");
            end;
        }

        field(50034; "Notify Horeca Reminder Email 2"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 2" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 2");
            end;
        }

        field(50035; "Notify Horeca Reminder Email 3"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 3" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 3");
            end;
        }

        field(50036; "Notify Horeca Reminder Email 4"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 4" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 4");
            end;
        }

        field(50037; "Notify Horeca Reminder Email 5"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 5" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 5");
            end;
        }

        field(50038; "Notify Horeca Reminder Email 6"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Notify Horeca Reminder Email 6" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Notify Horeca Reminder Email 6");
            end;
        }
        //-1.0.0.268


        //+1.0.0.291
        field(50040; "Potatoes Item Category Code"; Code[20])
        {
            Caption = 'Potatoes Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            var
            begin

            end;
        }

        field(50041; "Default Product Class"; Text[3])
        {
            DataClassification = ToBeClassified;

            Caption = 'Default Product Class (Κατηγορία)';
            TableRelation = "General Categories".Code where("Table No." = const(27), Type = const(Category8));
        }


        field(50042; "Default Country of Origin Code"; Code[10])
        {
            Caption = 'Default Country of Origin Code';
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }
        //-1.0.0.291

        field(50043; "Fresh Inventory Posting Group"; Code[20])
        {
            Caption = 'Fresh Inventory Posting Group';
            TableRelation = "Inventory Posting Group";

        }

        field(50044; "Box Stmt Start Date"; Date)
        {
            Caption = 'Box Statement Start Date';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
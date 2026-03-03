table 50002 "Delivery Schedule"
{
    // version COC


    fields
    {
        field(1; "Delivery No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Driver; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." where("Resource Group No." = const('DRIVER'));
        }
        field(6; Van; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." where("Resource Group No." = const('VAN'));
        }
        field(7; "Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

                //The value 1 corresponds to day of the week (1-7, Monday = 1).
                //The value 2 corresponds to week number (1-53).
                //The value 3 corresponds to year.

                if "Delivery Date" <> 0D then begin
                    "Week No." := Date2DWY("Delivery Date", 2);
                end;
            end;
        }
        field(8; "Van Start Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Van End Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(11; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "No. of Sales Shipments"; Integer)
        {
            CalcFormula = count("Sales Shipment Header" where("Delivery No." = field("Delivery No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Week No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "No. of Sales Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Delivery No." = field("Delivery No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(300; "Work Description"; Blob)
        {
            Caption = 'Work Description';
            DataClassification = ToBeClassified;
        }
        field(301; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Completed,Cancelled';
            OptionMembers = " ",Completed,Cancelled;
        }
        field(50001; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50002; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50003; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50005; "Print Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(50006; "Print By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
    }

    keys
    {
        key(Key1; "Delivery No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Delivery No.", Driver, Van, "Delivery Date")
        {
        }
    }

    trigger OnDelete();
    var
        rL_SalesShipmentHeader: Record "Sales Shipment Header";
    begin

        if "Delivery No." <> '' then begin
            rL_SalesShipmentHeader.Reset;
            rL_SalesShipmentHeader.SetCurrentKey("Delivery No.");
            rL_SalesShipmentHeader.SetFilter("Delivery No.", "Delivery No.");
            if rL_SalesShipmentHeader.FindSet then begin
                repeat
                    rL_SalesShipmentHeader."Delivery No." := '';
                    rL_SalesShipmentHeader."Delivery Sequence" := 0;
                    rL_SalesShipmentHeader.Modify;
                until rL_SalesShipmentHeader.Next = 0;
            end;
        end;
    end;

    trigger OnInsert();
    begin
        if "Delivery No." = '' then begin
            rG_WarehouseSetup.Get;
            rG_WarehouseSetup.TestField("Delivery Nos.");
            "Delivery No." := NoSeries.GetNextNo(rG_WarehouseSetup."Delivery Nos.", 0D);
            //NoSeriesMgt.InitSeries(rG_WarehouseSetup."Delivery Nos.", xRec."No. Series", 0D, "Delivery No.", "No. Series");
        end;

        "Creation Date" := CurrentDateTime;
        "Created By" := UserId;

        TestField(Driver);
        TestField(Van);

        Validate("Delivery Date", Today);
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
    end;

    var
        rG_WarehouseSetup: Record "Warehouse Setup";
        NoSeries: Codeunit "No. Series";
}


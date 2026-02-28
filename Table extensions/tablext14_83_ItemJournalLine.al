/*
TAL0.1 2019/06/13 VC check unit cost from max unit cost
TAL0.2 2020/03/03 VC chain of custody 

TAL0.3 2021/03/26 VC add fields Shelf No.,Document Lot No.
TAL0.4 2021/05/14 ANP Design Location Name
*/
tableextension 50114 ItemJournalLineExt extends "Item Journal Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                Item: Record Item;
            begin
                //+TAL0.1
                Item.GET("Item No.");
                IF Item."Max Unit Cost" <> 0 THEN BEGIN
                    IF "Unit Cost" > Item."Max Unit Cost" THEN BEGIN
                        ERROR(Text50000, FORMAT("Unit Cost"), FORMAT(Item."Max Unit Cost"), Item."No.");
                    END;
                END;
                //-TAL0.1
            end;
        }
        field(50001; "Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("Vendor Posting Group" = FILTER('GROWER'));
        }
        field(50002; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50058; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50059; "Document Lot No."; Code[20])
        {
            CaptionML = ELL = 'Document Lot No.',
                        ENU = 'Document Lot No.';
            DataClassification = ToBeClassified;
        }
        field(50060; "Location Name"; Text[100])
        {
            CalcFormula = Lookup(Location.Name WHERE(Code = FIELD("Location Code")));
            FieldClass = FlowField;
        }

        field(50061; "Item Tracking Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Item Tracking Code" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
            Editable = false;
        }

        field(50062; "Tracking Lot No."; Code[50])
        {
            CalcFormula = Lookup("Reservation Entry"."Lot No." WHERE("Item No." = FIELD("Item No."), "Location Code" = FIELD("Location Code"), "Source ID" = FIELD("Journal Template Name"), "Source Batch Name" = FIELD("Journal Batch Name"), "Source Ref. No." = FIELD("Line No.")));
            FieldClass = FlowField;
            Editable = false;
        }

        field(50063; "Tracking Expiration Date"; Date)
        {
            CalcFormula = Lookup("Reservation Entry"."Expiration Date" WHERE("Item No." = FIELD("Item No."), "Location Code" = FIELD("Location Code"), "Source ID" = FIELD("Journal Template Name"), "Source Batch Name" = FIELD("Journal Batch Name"), "Source Ref. No." = FIELD("Line No.")));
            FieldClass = FlowField;
            Editable = false;
        }







        //+1.0.0.229
        field(50101; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code WHERE("Table No." = CONST(5404), Type = CONST(Category1));
        }
        //-1.0.0.229
    }

    var
        Text50000: Label 'Unit Cost %1 cannot exceed Max Unit Cost %2 Item %3';

}
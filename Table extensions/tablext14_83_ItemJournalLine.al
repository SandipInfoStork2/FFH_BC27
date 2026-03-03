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
                Item.Get("Item No.");
                if Item."Max Unit Cost" <> 0 then begin
                    if "Unit Cost" > Item."Max Unit Cost" then begin
                        Error(Text50000, Format("Unit Cost"), Format(Item."Max Unit Cost"), Item."No.");
                    end;
                end;
                //-TAL0.1
            end;
        }
        field(50001; "Grower No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor where("Vendor Posting Group" = filter('GROWER'));
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
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            FieldClass = FlowField;
        }

        field(50061; "Item Tracking Code"; Code[20])
        {
            CalcFormula = lookup(Item."Item Tracking Code" where("No." = field("Item No.")));
            FieldClass = FlowField;
            Editable = false;
        }

        field(50062; "Tracking Lot No."; Code[50])
        {
            CalcFormula = lookup("Reservation Entry"."Lot No." where("Item No." = field("Item No."), "Location Code" = field("Location Code"), "Source ID" = field("Journal Template Name"), "Source Batch Name" = field("Journal Batch Name"), "Source Ref. No." = field("Line No.")));
            FieldClass = FlowField;
            Editable = false;
        }

        field(50063; "Tracking Expiration Date"; Date)
        {
            CalcFormula = lookup("Reservation Entry"."Expiration Date" where("Item No." = field("Item No."), "Location Code" = field("Location Code"), "Source ID" = field("Journal Template Name"), "Source Batch Name" = field("Journal Batch Name"), "Source Ref. No." = field("Line No.")));
            FieldClass = FlowField;
            Editable = false;
        }







        //+1.0.0.229
        field(50101; "Packing Agent"; Code[20])
        {
            Caption = 'Packing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "General Categories".Code where("Table No." = const(5404), Type = const(Category1));
        }
        //-1.0.0.229
    }

    var
        Text50000: Label 'Unit Cost %1 cannot exceed Max Unit Cost %2 Item %3';

}
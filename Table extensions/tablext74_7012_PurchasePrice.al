/*
TAL0.1 2021/10/11 VC add field Item description 
                     add last modified by/date
                     item category dim2 
*/

tableextension 50174 PurchasePriceExt extends "Purchase Price"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Item Category Code"; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Global Dimension 2 Code"; Code[20])
        {
            CalcFormula = lookup(Item."Global Dimension 2 Code" where("No." = field("Item No.")));
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
        //-TAL0.1 
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        "Last Modified Date" := CurrentDateTime;
        "Last Modified By" := UserId;
        //-TAL0.1 
    end;

    var
        myInt: Integer;
}
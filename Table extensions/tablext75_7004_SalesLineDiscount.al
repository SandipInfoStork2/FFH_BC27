/*
TAL0.1 2021/10/11 VC add field Item description 
                     add last modified by/date
                     item category dim2 
*/

tableextension 50175 SalesLineDiscountExt extends "Sales Line Discount"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Item Category Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Global Dimension 2 Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Global Dimension 2 Code" WHERE("No." = FIELD("Code")));
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
        "Last Modified Date" := CURRENTDATETIME;
        "Last Modified By" := USERID;
        //-TAL0.1 
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        "Last Modified Date" := CURRENTDATETIME;
        "Last Modified By" := USERID;
        //-TAL0.1 
    end;

    var
        myInt: Integer;
}
tableextension 50178 ItemJournalTemplateExt extends "Item Journal Template"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Posting Report ID 2"; Integer)
        {
            Caption = 'Posting Report ID 2';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }

        field(50001; "Posting Report Caption 2"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Posting Report ID 2")));
            Caption = 'Posting Report Caption 2';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
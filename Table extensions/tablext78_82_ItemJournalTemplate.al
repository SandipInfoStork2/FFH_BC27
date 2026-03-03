tableextension 50178 ItemJournalTemplateExt extends "Item Journal Template"
{
    fields
    {
        // Add changes to table fields here

        field(50000; "Posting Report ID 2"; Integer)
        {
            Caption = 'Posting Report ID 2';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }

        field(50001; "Posting Report Caption 2"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Posting Report ID 2")));
            Caption = 'Posting Report Caption 2';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
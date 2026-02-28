tableextension 50130 PostCodeExt extends "Post Code"
{
    fields
    {
        // Add changes to table fields here
    }

    procedure ClearFields(VAR City: Text[30]; VAR PostCode: Code[20]; VAR County: Text[30])
    var
        myInt: Integer;
    begin
        City := '';
        PostCode := '';
        County := '';
    end;


    var
        myInt: Integer;
}
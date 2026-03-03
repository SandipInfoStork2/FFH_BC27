tableextension 50130 PostCodeExt extends "Post Code"
{
    fields
    {
        // Add changes to table fields here
    }

    procedure ClearFields(var City: Text[30]; var PostCode: Code[20]; var County: Text[30])
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
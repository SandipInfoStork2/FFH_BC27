/*
TAL0.1 2021/04/08 VC add field Item Tracking

*/
tableextension 50140 NoSeriesExt extends "No. Series"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Item Tracking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
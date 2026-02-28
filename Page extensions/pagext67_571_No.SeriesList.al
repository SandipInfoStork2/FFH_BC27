/*
TAL0.1 2021/04/08 VC add field Item Tracking

*/
pageextension 50167 NoSeriesListExt extends "No. Series List"
{
    layout
    {
        // Add changes to page layout here

        addafter("Date Order")
        {
            field("Item Tracking"; "Item Tracking")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
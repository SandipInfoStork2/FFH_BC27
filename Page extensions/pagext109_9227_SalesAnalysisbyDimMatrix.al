pageextension 50209 SalesAnalysisbyDimMatrixExt extends "Sales Analysis by Dim Matrix"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("rG_Item.""Shelf No."""; rG_Item."Shelf No.")
            {
                ApplicationArea = all;
                Caption = 'Shelf No.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord();
    begin

        CLEAR(rG_Item);
        if rG_Item.GET(Code) then;
    end;


    var
        rG_Item: Record Item;
}
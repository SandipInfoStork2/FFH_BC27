pageextension 50209 SalesAnalysisbyDimMatrixExt extends "Sales Analysis by Dim Matrix"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("rG_Item.""Shelf No."""; rG_Item."Shelf No.")
            {
                ApplicationArea = All;
                Caption = 'Shelf No.';
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord();
    begin

        Clear(rG_Item);
        if rG_Item.GET(Rec.Code) then;
    end;


    var
        rG_Item: Record Item;
}
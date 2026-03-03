pageextension 50238 FinishedProdOrderLinesExt extends "Finished Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Variant Code")
        {
            Visible = true;
        }

        //+1.0.0.228
        modify("Unit Cost")
        {
            Editable = UnitCostEditable;
        }
        //-1.0.0.228

    }

    actions
    {
        // Add changes to page actions here
    }

    //+1.0.0.228
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
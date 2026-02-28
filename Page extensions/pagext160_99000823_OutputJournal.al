pageextension 50260 OutputJournalExt extends "Output Journal"
{
    layout
    {
        // Add changes to page layout here

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
        UserSetup.GET(UserId);
        UnitCostEditable := UserSetup."Unit Cost Editable";
    end;
    //-1.0.0.228

    var
        UnitCostEditable: Boolean;
}
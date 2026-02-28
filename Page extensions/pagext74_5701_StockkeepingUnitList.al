pageextension 50174 StockkeepingUnitListExt extends "Stockkeeping Unit List"
{
    layout
    {
        // Add changes to page layout here

        addafter("Location Code")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.197 >>
        addafter(Inventory)
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.197 <<
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
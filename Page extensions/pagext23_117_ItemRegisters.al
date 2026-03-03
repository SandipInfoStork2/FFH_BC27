/*
TAL0.1 vasilis 2020/05/03 add reports Item Register - Value 5805, Item Register - Quantity 703

*/
pageextension 50123 ItemRegistersExt extends "Item Registers"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Reporting)
        {

            //Caption = 'Reports';
            action(ReportItemRegQty)
            {
                ApplicationArea = All;
                Caption = 'Item Register - Quantity';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Item Register - Quantity action.';

                trigger OnAction();
                var
                    rpt_: Report "Item Register - Quantity FFH";
                    rL_ItemRegister: Record "Item Register";
                begin
                    rL_ItemRegister.Reset;
                    rL_ItemRegister.SETRANGE("No.", Rec."No.");
                    if rL_ItemRegister.FindSet then begin
                        Clear(rpt_);
                        rpt_.SetTableView(rL_ItemRegister);
                        rpt_.RunModal;
                    end;
                end;
            }
            action(ReportItemRegValue)
            {
                ApplicationArea = All;
                Caption = 'Item Register - Value';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Item Register - Value action.';

                trigger OnAction();
                var
                    rpt_: Report "Item Register - Value FFH";
                    rL_ItemRegister: Record "Item Register";
                begin
                    rL_ItemRegister.Reset;
                    rL_ItemRegister.SETRANGE("No.", Rec."No.");
                    if rL_ItemRegister.FindSet then begin
                        Clear(rpt_);
                        rpt_.SetTableView(rL_ItemRegister);
                        rpt_.RunModal;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
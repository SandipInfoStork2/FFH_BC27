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

                trigger OnAction();
                var
                    rpt_: Report "Item Register - Quantity FFH";
                    rL_ItemRegister: Record "Item Register";
                begin
                    rL_ItemRegister.RESET;
                    rL_ItemRegister.SETRANGE("No.", "No.");
                    if rL_ItemRegister.FINDSET then begin
                        CLEAR(rpt_);
                        rpt_.SETTABLEVIEW(rL_ItemRegister);
                        rpt_.RUNMODAL;
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

                trigger OnAction();
                var
                    rpt_: Report "Item Register - Value FFH";
                    rL_ItemRegister: Record "Item Register";
                begin
                    rL_ItemRegister.RESET;
                    rL_ItemRegister.SETRANGE("No.", "No.");
                    if rL_ItemRegister.FINDSET then begin
                        CLEAR(rpt_);
                        rpt_.SETTABLEVIEW(rL_ItemRegister);
                        rpt_.RUNMODAL;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
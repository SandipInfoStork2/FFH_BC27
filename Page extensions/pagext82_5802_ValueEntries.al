/*
TAL0.1 2020/03/27 show Item Ledger Posting Date

*/

pageextension 50182 ValueEntriesExt extends "Value Entries"
{
    layout
    {
        // Add changes to page layout here

        addafter("Valuation Date")
        {
            field("ILE Posting Date"; rG_ILE."Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Item. Ledger Entry Posting Date';
                Editable = false;
                StyleExpr = StyleTxt;
                ToolTip = 'Specifies the posting date of this entry.';
            }
        }

        modify("Return Reason Code")
        {
            Visible = true;
        }

        addbefore("Return Reason Code")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord();
    begin
        //+TAL0.1
        Clear(rG_ILE);
        if rG_ILE.GET(Rec."Item Ledger Entry No.") then;

        StyleTxt := '';
        if Rec."Posting Date" <> rG_ILE."Posting Date" then begin
            StyleTxt := 'Unfavorable';
        end;
        //-TAL0.1

    end;

    var
        rG_ILE: Record "Item Ledger Entry";
        StyleTxt: Text;
}
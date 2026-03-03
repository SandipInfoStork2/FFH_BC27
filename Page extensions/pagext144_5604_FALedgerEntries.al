pageextension 50244 FALedgerEntriesExt extends "FA Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        //TAL 1.0.0.71 >>
        addafter(Description)
        {
            field("Location Code27795"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Code field.';
            }
            field("FA Location Code88589"; Rec."FA Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FA Location Code field.';
            }
        }
        //TAL 1.0.0.71 <<
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 50234 GeneralJournalTemplatesExt extends "General Journal Templates"
{
    layout
    {
        // Add changes to page layout here
        //TAL 1103 >>
        modify("Cust. Receipt Report ID")
        {
            Visible = true;
        }
        modify("Vendor Receipt Report ID")
        {
            Visible = true;
        }
        //TAL 1103 <<
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
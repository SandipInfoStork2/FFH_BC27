pageextension 50263 CustomerLookupExt extends "Customer Lookup"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
    }

    //+1.0.0.264
    trigger OnOpenPage()
    var
    begin
        Rec.SetSecurityFilterOnCustomer();
    end;
    //-1.0.0.264

    var
        myInt: Integer;
}
/*
TAL0.1 2019/06/06 VC add Fields
                No. of Released Prod. Orders
                No. of Finished Prod. Orders
*/
pageextension 50207 VendorHistBuyfromFactBoxExt extends "Vendor Hist. Buy-from FactBox"
{
    layout
    {
        // Add changes to page layout here
        addafter(NoOfIncomingDocuments)
        {
            field("No. of Released Prod. Orders"; "No. of Released Prod. Orders")
            {
                ApplicationArea = all;
            }
            field("No. of Finished Prod. Orders"; "No. of Finished Prod. Orders")
            {
                ApplicationArea = all;
            }
        }

        addafter(CueIncomingDocuments)
        {
            field("CueNo. of Released Prod. Orders"; "No. of Released Prod. Orders")
            {
                ApplicationArea = all;
            }
            field("CueNo. of Finished Prod. Orders"; "No. of Finished Prod. Orders")
            {
                ApplicationArea = all;
            }
        }




    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
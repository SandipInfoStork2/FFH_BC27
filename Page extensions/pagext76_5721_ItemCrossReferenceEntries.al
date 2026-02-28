/*
TAL0.1 2020/03/04 VC add Description 2

*/
/*
pageextension 50176 ItemCrossReferenceEntriesExt extends "Item Cross Reference Entries"
{
    layout
    {
        // Add changes to page layout here

        addafter(Description)
        {
            field("Description 3"; "Description 3")
            {
                ApplicationArea = All;
            }
        }
        addafter("Cross-Reference Type No.")
        {
            field("Category 2"; "Category 2")
            {
                ApplicationArea = All;
            }
        }
        modify("Description 2")
        {
            Visible = true;
        }

    }

    actions
    {
        // Add changes to page actions here
        addfirst(navigation)
        {
            action("Lidl Item")
            {
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Lidl Item List";
                RunPageLink = Code = FIELD("Category 2");
            }
        }
    }

    var
        myInt: Integer;
}
*/
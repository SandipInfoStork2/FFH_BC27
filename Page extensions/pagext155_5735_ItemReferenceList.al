pageextension 50255 ItemReferenceListExt extends "Item Reference List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure")
        {
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("S. Quote Description"; "S. Quote Description")
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
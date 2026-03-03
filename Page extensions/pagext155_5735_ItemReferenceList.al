pageextension 50255 ItemReferenceListExt extends "Item Reference List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure")
        {
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';
            }
        }
        addafter(Description)
        {
            field("S. Quote Description"; Rec."S. Quote Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the S. Quote Description field.';
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
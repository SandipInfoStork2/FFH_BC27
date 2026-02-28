page 50016 "Update Posted Boxes Card"
{
    // TAL0.1 2019/03/26 VC allow to edit certain fields request from Koullis

    DeleteAllowed = false;
    InsertAllowed = false;
    Permissions = TableData "Purchase Header Addon Posted" = rm;
    SourceTable = "Purchase Line Addon Posted";

    layout
    {
        area(content)
        {
            field("Document No."; "Document No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Line No."; "Line No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("No."; "No.")
            {
                ApplicationArea = All;
            }
            field(Description; Description)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Variant Code"; "Variant Code")
            {
                ApplicationArea = All;
            }
            field("Location Code"; "Location Code")
            {
                ApplicationArea = All;
            }
            field(Quantity; Quantity)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    var
        oldPostingDate: Date;
        NewPostingDate: Date;
        rG_PostedBoxesHeader: Record "Purchase Header Addon Posted";
        Text001: Label 'Posted Boxes Header %1 Posting Date modified.';
}


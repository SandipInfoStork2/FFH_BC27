page 50016 "Update Posted Boxes Card"
{
    // TAL0.1 2019/03/26 VC allow to edit certain fields request from Koullis

    DeleteAllowed = false;
    InsertAllowed = false;
    Permissions = tabledata "Purchase Header Addon Posted" = rm;
    SourceTable = "Purchase Line Addon Posted";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Document No."; Rec."Document No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document No. field.';
            }
            field("Line No."; Rec."Line No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line No. field.';
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. field.';
            }
            field(Description; Rec.Description)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Variant Code field.';
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Code field.';
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity field.';
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


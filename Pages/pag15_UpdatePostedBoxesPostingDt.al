page 50015 "Update Posted Boxes Posting Dt"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    Permissions = tabledata "Purchase Header Addon Posted" = rm;
    SourceTable = "Purchase Header Addon Posted";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. field.';
            }
            field(oldPostingDate; oldPostingDate)
            {
                Caption = 'old Posting Date';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the old Posting Date field.';
            }
            field(NewPostingDate; NewPostingDate)
            {
                Caption = 'New Posting Date';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New Posting Date field.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        oldPostingDate := Rec."Posting Date";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        //+NOD0.1
        rG_PostedBoxesHeader.Reset;
        if (NewPostingDate <> 0D) and (oldPostingDate <> NewPostingDate) then begin
            if rG_PostedBoxesHeader.GET(Rec."Document Type", Rec."No.") then begin
                rG_PostedBoxesHeader."Posting Date" := NewPostingDate;
                rG_PostedBoxesHeader.Modify;
                MESSAGE(Text001, Rec."No.");
            end;
        end;
        //-NOD0.1
    end;

    var
        oldPostingDate: Date;
        NewPostingDate: Date;
        rG_PostedBoxesHeader: Record "Purchase Header Addon Posted";
        Text001: Label 'Posted Boxes Header %1 Posting Date modified.';
}


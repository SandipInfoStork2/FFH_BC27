page 50015 "Update Posted Boxes Posting Dt"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    Permissions = TableData "Purchase Header Addon Posted" = rm;
    SourceTable = "Purchase Header Addon Posted";

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(oldPostingDate; oldPostingDate)
            {
                Caption = 'old Posting Date';
                Editable = false;
                ApplicationArea = All;
            }
            field(NewPostingDate; NewPostingDate)
            {
                Caption = 'New Posting Date';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        oldPostingDate := "Posting Date";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        //+NOD0.1
        rG_PostedBoxesHeader.RESET;
        if (NewPostingDate <> 0D) and (oldPostingDate <> NewPostingDate) then begin
            if rG_PostedBoxesHeader.GET("Document Type", "No.") then begin
                rG_PostedBoxesHeader."Posting Date" := NewPostingDate;
                rG_PostedBoxesHeader.MODIFY;
                MESSAGE(Text001, "No.");
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


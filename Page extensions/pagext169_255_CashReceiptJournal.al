pageextension 50269 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // addbefore(Preview)
        // {
        //     action(PostAndSend)
        //     {
        //         ApplicationArea = All;
        //         Image = PostSendTo;
        //         Promoted = true;
        //         PromotedCategory = Category6;
        //         Caption = 'Post and Email';
        //         Tooltip = 'Custom: Post and Email';
        //         trigger OnAction()
        //         var
        //             CurrentJnlBatchName: Code[10];
        //         begin
        //             CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Email", Rec);
        //             CurrentJnlBatchName := Rec.GETRANGEMAX(Rec."Journal Batch Name");
        //             CurrPage.UPDATE(FALSE);
        //         end;
        //     }
        // }
    }

    var
        myInt: Integer;
}
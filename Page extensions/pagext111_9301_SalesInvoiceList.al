/*
TAL0.2 2017/11/13  VC design post and print action from 2015
//use post and send
*/
pageextension 50211 SalesInvoiceListExt extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(PostAndSend)
        {
            action("Post and &Print")
            {
                ApplicationArea = all;
                Caption = 'Post and &Print';
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                begin
                    LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                    SendToPosting(CODEUNIT::"Sales-Post + Print");
                end;
            }

        }
    }

    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
}
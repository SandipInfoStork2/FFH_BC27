/*
TAL0.2 2017/11/13  VC design post and print action from 2015

*/
pageextension 50212 SalesCreditMemosExt extends "Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Req. Vendor No."; Rec."Req. Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Req. Vendor No. field.';
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the document.';
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
                ApplicationArea = All;
                Caption = 'Post and &Print';
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortcutKey = 'Shift+F9';
                ToolTip = 'Executes the Post and &Print action.';

                trigger OnAction();
                begin
                    CheckSalesCheckAllLinesHaveQuantityAssigned(Rec);
                    Rec.SendToPosting(Codeunit::"Sales-Post + Print");
                end;
            }
        }


    }

    local procedure CheckSalesCheckAllLinesHaveQuantityAssigned(SalesHeader: Record "Sales Header")
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
    end;

    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
}
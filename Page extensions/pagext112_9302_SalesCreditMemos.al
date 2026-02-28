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
            field("Req. Vendor No."; "Req. Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Reason Code"; "Reason Code")
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
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F9';

                trigger OnAction();
                begin
                    CheckSalesCheckAllLinesHaveQuantityAssigned(Rec);
                    SendToPosting(CODEUNIT::"Sales-Post + Print");
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
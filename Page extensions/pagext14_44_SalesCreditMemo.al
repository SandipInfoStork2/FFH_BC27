/*
TAL0.2 2017/11/13  VC design post and print action from 2015
TAL0.3 2017/11/23 VC design Sell to customer no, sell to fields are set to standard and not additional 
TAL0.4 2017/12/07 VC design Bill-to Name

*/

pageextension 50114 SalesCreditMemoExt extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        modify("Sell-to Customer No.")
        {
            Visible = true;
        }
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Name2"; Rec."Bill-to Name")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Name';
                Importance = Promoted;
                ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';

                trigger OnValidate()
                begin
                    if Rec.GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                        if Rec."Bill-to Customer No." <> xRec."Bill-to Customer No." then
                            Rec.SetRange("Bill-to Customer No.");

                    CurrPage.SaveRecord;
                    //SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);

                    CurrPage.Update(false);
                end;
            }
        }

        modify("Sell-to Address")
        {
            Importance = Standard;
        }
        modify("Sell-to Address 2")
        {
            Importance = Standard;
        }
        modify("Sell-to Post Code")
        {
            Importance = Standard;
        }
        modify("Sell-to City")
        {
            Importance = Standard;
        }

        modify("Sell-to Contact")
        {
            Importance = Standard;
        }

        modify("Reason Code")
        {
            ShowMandatory = true;
            Visible = true;
        }

        addafter("Applies-to ID")
        {
            field("Reason Code_2"; Rec."Reason Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the document.';
                Visible = true;
                ShowMandatory = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(PostAndSend)
        {
            action(PostAndPrint)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post and &Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
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
/*
TAL0.2 2017/11/13  VC design post and print action from 2015
TAL0.3 2017/11/23 VC design Sell to customer no, sell to fields are set to standard and not additional 
TAL0.4 2017/12/07 VC design Bill-to Name
*/

pageextension 50113 SalesInvoiceExt extends "Sales Invoice"
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
                Caption = 'Bill-to Name';
                //Editable = BillToOptions = BillToOptions::"Another Customer";
                //Enabled = BillToOptions = BillToOptions::"Another Customer";
                Importance = Promoted;
                NotBlank = true;
                ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';

                trigger OnValidate()
                var
                    ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                begin
                    if Rec.GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                        if Rec."Bill-to Customer No." <> xRec."Bill-to Customer No." then
                            Rec.SetRange("Bill-to Customer No.");

                    CurrPage.SaveRecord;
                    // if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                    //    SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);

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

        addafter(BillToContactEmail)
        {
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                Caption = 'Sell-to E-Mail';
                ToolTip = 'Specifies the email address of the contact person that the sales document will be sent to.';
            }
        }

        addafter("Your Reference")
        {
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
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
                Ellipsis = true;
                Image = PostPrint;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortcutKey = 'Shift+F9';
                ToolTip = 'Executes the Post and &Print action.';

                trigger OnAction();
                begin

                    LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                    Rec.SendToPosting(Codeunit::"Sales-Post + Print");
                end;
            }
        }

    }


    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
}
/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
TAL0.2 2019/01/03 VC add Deliver to vendor fields 
TAL0.3 2021/04/06 VC add PrintAppendixRecords
TAL0.4 2021/10/26 VC add Quality Control Fields

*/
pageextension 50132 PostedPurchaseReceiptExt extends "Posted Purchase Receipt"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Ship-to Name")
        {
            group("Deliver to Vendor")
            {
                Caption = 'Deliver to Vendor';
                field("Deliver-to Vendor No."; Rec."Deliver-to Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Deliver-to Vendor No. field.';
                }
                field("Deliver-to Name"; Rec."Deliver-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Deliver-to Name field.';
                }
            }
        }
        addafter("Responsibility Center")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
        }

        addafter(Shipping)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Receiving Temperature"; Rec."Receiving Temperature")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
                }
                field("Receiving Quality Control"; Rec."Receiving Quality Control")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receiving Quality Control field.';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action("Grower Receipt")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Grower Receipt',
                            ENU = 'Grower Receipt';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Grower Receipt action.';

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintGrowerReceiptRecords(PurchRcptHeader);
                end;
            }
            action("Item Tracking Appendix")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Item Tracking Appendix',
                            ENU = 'Item Tracking Appendix';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Item Tracking Appendix action.';

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintAppendixRecords(PurchRcptHeader);
                end;
            }

            action("Item Tracking Appendix Quality")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Item Tracking Appendix Quality',
                            ENU = 'Item Tracking Appendix Quality';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = true;
                ToolTip = 'Executes the Item Tracking Appendix Quality action.';

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintAppendixRecordsQuality(PurchRcptHeader);
                end;
            }

            action("Update Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document';
                Image = Edit;
                ToolTip = 'Add new information that is relevant to the document, such as quality control details. You can only edit a few fields because the document has already been posted.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PostedPurchReceiptUpdate: Page "Posted Purch. Receipt - Update";
                begin
                    PostedPurchReceiptUpdate.LookupMode := true;
                    PostedPurchReceiptUpdate.SetRec(Rec);
                    PostedPurchReceiptUpdate.RunModal();
                end;
            }
        }

        addafter("&Navigate")
        {
            action(UpdateNos)
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Used for Grower Receipt Report, incase the Grower Receipt nos are not updated during posting.';

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin
                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.GrowerReceiptNos(Rec."No.");
                end;
            }
        }


    }

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
}
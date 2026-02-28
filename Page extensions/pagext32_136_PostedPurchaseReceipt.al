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
                field("Deliver-to Vendor No."; "Deliver-to Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deliver-to Name"; "Deliver-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        addafter("Responsibility Center")
        {
            field("Transfer-from Code"; "Transfer-from Code")
            {
                ApplicationArea = All;
                Editable = False;
            }
            field("Transfer-to Code"; "Transfer-to Code")
            {
                ApplicationArea = All;
                Editable = False;
            }
        }

        addafter(Shipping)
        {
            group(QC)
            {
                Caption = 'Quality Control';
                field("Receiving Temperature"; "Receiving Temperature")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Receiving Quality Control"; "Receiving Quality Control")
                {
                    ApplicationArea = all;
                    Editable = false;
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

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
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

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
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

                trigger OnAction();
                begin
                    PurchRcptHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
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
                    CLEAR(cu_GeneralMgt);
                    cu_GeneralMgt.GrowerReceiptNos("No.");
                end;
            }
        }


    }

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
}
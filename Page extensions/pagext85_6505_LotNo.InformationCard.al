/*
TAL0.1 2021/04/02 VC add field Producer Group Name
TAL0.2 2021/04/02 VC add field Producer Group Name

*/
pageextension 50185 LotNoInformationCardExt extends "Lot No. Information Card"
{
    layout
    {
        // Add changes to page layout here

        addafter("Item No.")
        {
            field("Item Description"; "Item Description")
            {
                ApplicationArea = All;
            }
        }

        addafter("Lot No.")
        {
            field("Category 1"; "Category 1")
            {
                ApplicationArea = All;

                trigger OnValidate();
                begin

                    CurrPage.UPDATE(true);
                end;
            }
            field("Producer Group Name"; "Producer Group Name")
            {
                ApplicationArea = All;
            }
            field("Grower No."; "Grower No.")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = All;
            }
            field("Grower GGN"; "Grower GGN")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor GLN"; "Vendor GLN")
            {
                ApplicationArea = All;
            }
            field("Vendor GGN"; "Vendor GGN")
            {
                ApplicationArea = All;
            }
            group("Quality Control")
            {
                field("Receiving Temperature Celsius"; "Receiving Temperature Celsius")
                {
                    ApplicationArea = All;
                    caption = 'Receiving Temperature °C';
                }
                field("QC Validate COC-GGN Certficate"; "QC Validate COC-GGN Certficate")
                {
                    ApplicationArea = All;
                }
                field("QC Visual Check"; "QC Visual Check")
                {
                    ApplicationArea = All;
                }
                group(Comment)
                {

                    CaptionML = ELL = 'Comment',
                                    ENU = 'Comment';
                    field(vG_QCComment; vG_QCComment)
                    {
                        ApplicationArea = All;
                        Caption = 'Comment';
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';

                        trigger OnValidate();
                        begin
                            SetQCComments(vG_QCComment);
                        end;
                    }
                }
            }
            group(Product)
            {
                field("Category 4"; "Category 4")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Purchased Code"; "Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                }
                field("Category 2"; "Category 2")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Category 3"; "Category 3")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Label Description Line 1"; "Label Description Line 1")
                {
                    ApplicationArea = All;
                }
                field("Label Description Line 2"; "Label Description Line 2")
                {
                    ApplicationArea = All;
                }

                field("Spec Category 3"; "Spec Category 3")
                {
                    ApplicationArea = All;
                }
                field(Packing; Packing)
                {
                    ApplicationArea = All;
                }
                field("Spec Category 7"; "Spec Category 7")
                {
                    ApplicationArea = All;
                }
                field("Spec Category 4"; "Spec Category 4")
                {
                    ApplicationArea = All;
                }
                field("Spec Category 5"; "Spec Category 5")
                {
                    ApplicationArea = All;
                }
            }
        }

        moveafter("Label Description Line 2"; Description)
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord();
    begin
        vG_QCComment := GetQCComments;
    end;

    var
        vG_QCComment: Text;
}
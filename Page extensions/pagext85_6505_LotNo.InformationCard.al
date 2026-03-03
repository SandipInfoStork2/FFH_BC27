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
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
        }

        addafter("Lot No.")
        {
            field("Category 1"; Rec."Category 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group field.';

                trigger OnValidate();
                begin

                    CurrPage.Update(true);
                end;
            }
            field("Producer Group Name"; Rec."Producer Group Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group Name field.';
            }
            field("Grower No."; Rec."Grower No.")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower GGN field.';
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Vendor GLN"; Rec."Vendor GLN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GLN field.';
            }
            field("Vendor GGN"; Rec."Vendor GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GGN field.';
            }
            group("Quality Control")
            {
                field("Receiving Temperature Celsius"; Rec."Receiving Temperature Celsius")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Temperature °C';
                    ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
                }
                field("QC Validate COC-GGN Certficate"; Rec."QC Validate COC-GGN Certficate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QC Validate COC-GGN Certficate field.';
                }
                field("QC Visual Check"; Rec."QC Visual Check")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QC Visual Check field.';
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
                            Rec.SetQCComments(vG_QCComment);
                        end;
                    }
                }
            }
            group(Product)
            {
                field("Category 4"; Rec."Category 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product No. field.';
                }
                field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Purchased Code field.';
                }
                field("Category 2"; Rec."Category 2")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Category 2 field.';
                }
                field("Category 3"; Rec."Category 3")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Category 3 field.';
                }
                field("Label Description Line 1"; Rec."Label Description Line 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label Description Line 1 field.';
                }
                field("Label Description Line 2"; Rec."Label Description Line 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Label Description Line 2 field.';
                }

                field("Spec Category 3"; Rec."Spec Category 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field(Packing; Rec.Packing)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Packing field.';
                }
                field("Spec Category 7"; Rec."Spec Category 7")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variety field.';
                }
                field("Spec Category 4"; Rec."Spec Category 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Caliber Min field.';
                }
                field("Spec Category 5"; Rec."Spec Category 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Caliber Max field.';
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
        vG_QCComment := Rec.GetQCComments;
    end;

    var
        vG_QCComment: Text;
}
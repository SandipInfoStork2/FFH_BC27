page 50012 "Item Picture - Sales Line"
{
    // version NAVW110.0

    // TAL0.1 2018/01/11 VC link item picture

    Caption = 'Item Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Sales Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(rG_Item; rG_Item.Picture)
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Clear(rG_Item);
        if Rec.Type = Rec.Type::Item then begin
            if rG_Item.GET(Rec."No.") then begin
                //rG_Item.CALCFIELDS(Picture);
            end;
        end;
    end;

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DownloadImageTxt: Label 'Download image';
        rG_Item: Record Item;
}


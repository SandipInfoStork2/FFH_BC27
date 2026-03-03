pageextension 50173 FixedAssetListExt extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here

        addafter(Acquired)
        {
            field(DepreciationStartingDate; FADepreciationBook."Depreciation Starting Date")
            {
                ApplicationArea = All;
                Caption = 'Depreciation Starting Date';
                ShowMandatory = true;
                ToolTip = 'Specifies the date on which depreciation of the fixed asset starts.';
            }
            field(DepreciationEndingDate; FADepreciationBook."Depreciation Ending Date")
            {
                ApplicationArea = All;
                Caption = 'Depreciation Ending Date';
                ToolTip = 'Specifies the date on which depreciation of the fixed asset ends.';
            }
        }

        //TAL 1.0.0.71 >>
        addafter("FA Location Code")
        {
            field("Location Code89451"; Rec."Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Code field.';
            }
        }
        //TAL 1.0.0.71 <<
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord();
    begin
        //+TAL0.1
        Clear(FADepreciationBook);
        LoadDepreciationBooks;
        FADepreciationBook.Copy(FADepreciationBookOld);
        //-TAL0.1
    end;


    local procedure LoadDepreciationBooks();
    begin
        //+TAL0.1
        Clear(FADepreciationBookOld);
        FADepreciationBookOld.SETRANGE("FA No.", Rec."No.");
        if FADepreciationBookOld.Count <= 1 then begin
            if FADepreciationBookOld.FindFirst then begin
                FADepreciationBookOld.CalcFields("Book Value");
                ShowAddMoreDeprBooksLbl := true
            end;
            Simple := true;
        end else
            Simple := false;
        //-TAL0.1
    end;

    var
        FADepreciationBook: Record "FA Depreciation Book";
        FADepreciationBookOld: Record "FA Depreciation Book";
        Simple: Boolean;
        ShowAddMoreDeprBooksLbl: Boolean;

}
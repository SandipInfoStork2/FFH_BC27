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
        CLEAR(FADepreciationBook);
        LoadDepreciationBooks;
        FADepreciationBook.COPY(FADepreciationBookOld);
        //-TAL0.1
    end;


    local procedure LoadDepreciationBooks();
    begin
        //+TAL0.1
        CLEAR(FADepreciationBookOld);
        FADepreciationBookOld.SETRANGE("FA No.", "No.");
        if FADepreciationBookOld.COUNT <= 1 then begin
            if FADepreciationBookOld.FINDFIRST then begin
                FADepreciationBookOld.CALCFIELDS("Book Value");
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
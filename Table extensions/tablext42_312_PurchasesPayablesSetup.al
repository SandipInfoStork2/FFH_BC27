tableextension 50142 PurchasesPayablesSetupExt extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Grower Nos."; Code[10])
        {
            CaptionML = ELL = 'Grower Nos.',
                        ENU = 'Grower Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Grower Receipt Nos."; Code[10])
        {
            CaptionML = ELL = 'Grower Receipt Nos.',
                        ENU = 'Grower Receipt Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Mand. P.O. Expected Recpt Date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mandatory P.O. Expected Receipt Date';
        }
    }

    var
        myInt: Integer;
}
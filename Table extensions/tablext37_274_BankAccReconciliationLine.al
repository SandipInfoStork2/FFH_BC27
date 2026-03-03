/*
TAL0.2 Corrected logic on Cr and Dr Fields

*/
tableextension 50137 BankAccReconciliationLine extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Credit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                //+TAL0.1
                if "Credit Amount" <> 0 then begin
                    Validate("Statement Amount", "Credit Amount");
                end;
                //TAL0.1
            end;
        }
        field(50001; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if "Description 2" <> '' then begin
                    if StrLen(Description + "Description 2") > 50 then begin
                        Description := Description + "Description 2";
                    end else begin
                        Description := Description + ' ' + "Description 2";
                    end;


                end;
            end;
        }
        field(50002; DebitAmountDiv; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if DebitAmountDiv <> 0 then begin
                    Validate("Statement Amount", DebitAmountDiv * -1);///100);//TAL0.2
                end;
            end;
        }
        field(50003; CreditAmluntDiv; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if CreditAmluntDiv <> 0 then begin
                    Validate("Credit Amount", CreditAmluntDiv);///100);//TAL0.2
                end;
            end;
        }
        field(50004; Found; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
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
                IF "Credit Amount" <> 0 THEN BEGIN
                    VALIDATE("Statement Amount", "Credit Amount");
                END;
                //TAL0.1
            end;
        }
        field(50001; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Description 2" <> '' THEN BEGIN
                    IF STRLEN(Description + "Description 2") > 50 THEN BEGIN
                        Description := Description + "Description 2";
                    END ELSE BEGIN
                        Description := Description + ' ' + "Description 2";
                    END;


                END;
            end;
        }
        field(50002; DebitAmountDiv; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF DebitAmountDiv <> 0 THEN BEGIN
                    VALIDATE("Statement Amount", DebitAmountDiv * -1);///100);//TAL0.2
                END;
            end;
        }
        field(50003; CreditAmluntDiv; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF CreditAmluntDiv <> 0 THEN BEGIN
                    VALIDATE("Credit Amount", CreditAmluntDiv);///100);//TAL0.2
                END;
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
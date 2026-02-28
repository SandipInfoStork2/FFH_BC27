xmlport 50000 "Import Transactions Payroll"
{
    // TAL0.1 2021/03/21 add review dimension 2 with dim 4

    Direction = Import;
    FieldSeparator = '|';
    Format = VariableText;
    RecordSeparator = '<CR/LF>';
    UseRequestPage = false;

    schema
    {
        textelement(Header)
        {
            tableelement("Gen. Journal Line";"Gen. Journal Line")
            {
                XmlName = 'Table';
                fieldelement(BatchName;"Gen. Journal Line"."Journal Batch Name")
                {
                    FieldValidate = no;
                }
                fieldelement(LineNo;"Gen. Journal Line"."Line No.")
                {
                }
                fieldelement(AccType;"Gen. Journal Line"."Account Type")
                {
                }
                fieldelement(AccNo;"Gen. Journal Line"."Account No.")
                {
                    FieldValidate = no;
                }
                fieldelement(PostDate;"Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(Currency;"Gen. Journal Line"."Currency Code")
                {
                }
                fieldelement(DocNo;"Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(ExtDocNo;"Gen. Journal Line"."External Document No.")
                {
                }
                fieldelement(Description;"Gen. Journal Line".Description)
                {
                }
                fieldelement(Amount;"Gen. Journal Line".Amount)
                {
                }
                fieldelement(Dim1;"Gen. Journal Line"."Shortcut Dimension 1 Code")
                {
                }
                textelement(Dim4)
                {

                    trigger OnAfterAssignVariable();
                    var
                        rL_GLSetup : Record "General Ledger Setup";
                    begin
                        //+TAL0.1
                        //rL_GLSetup.GET;
                        //"Gen. Journal Line".ValidateShortcutDimCode(Dim4,rL_GLSetup."Shortcut Dimension 4 Code");

                        if Dim4<>'' then begin
                          EVALUATE(Dim4Code,Dim4);
                          "Gen. Journal Line".ValidateShortcutDimCode(4,Dim4Code);
                        end;

                        //-TAL0.1
                    end;
                }
                textelement(Blank1)
                {
                }
                textelement(Blank2)
                {
                }

                trigger OnBeforeInsertRecord();
                begin
                    //IF "Gen. Journal Line"."Journal Batch Name"='' THEN BEGIN
                    //   currXMLport.SKIP;
                    //END;

                    "Gen. Journal Line"."Journal Template Name":='GENERAL';
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort();
    begin
        "Gen. Journal Line"."Journal Template Name":='GENERAL';

        "Gen. Journal Line".VALIDATE("Gen. Journal Line"."Shortcut Dimension 1 Code");
    end;

    var
        Dim4Code : Code[20];
}


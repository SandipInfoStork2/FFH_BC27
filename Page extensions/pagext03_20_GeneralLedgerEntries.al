/*
 TAL0.1 2017/12/07 VC design Ext. Doc. No
      TAL0.2 2021/12/03 ANP Design Cost Center
*/
pageextension 50103 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        moveafter("Document No."; "External Document No.")

        //TAL 1.0.0.71 >>
        /*
        addafter("Entry No.")
        {
            field(Reversed43575; Rec.Reversed)
            {
                ApplicationArea = All;
            }
            field("Reversed by Entry No.13328"; Rec."Reversed by Entry No.")
            {
                ApplicationArea = All;
            }
            field("Reversed Entry No.00320"; Rec."Reversed Entry No.")
            {
                ApplicationArea = All;
            }
        }
        */
        //TAL 1.0.0.71 <<
        modify(Reversed)
        {
            Visible = true;
        }
        modify("Reversed by Entry No.")
        {
            Visible = true;
        }
        modify("Reversed Entry No.")
        {
            Visible = true;
        }
        modify("Reason Code")
        {
            Visible = true;
        }

        moveafter("Entry No."; Reversed)
        moveafter(Reversed; "Reversed by Entry No.")
        moveafter("Reversed by Entry No."; "Reversed Entry No.")



        addafter("External Document No.")
        {
            field("Register No."; Rec."Register No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Register No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin

        /*
        DocBalAccNo := '';
        DocBalAccName := '';

        if "Debit Amount" <> 0 then begin
            GLEntry.RESET;
            GLEntry.SetFilter("Document No.", "Document No.");
            GLEntry.SetRange("Posting Date", "Posting Date");
            GLEntry.SetFilter("G/L Account No.", '<>%1', "G/L Account No.");
            GLEntry.SetFilter("Credit Amount", '<>%1', 0);
            if GLEntry.FindSet() then begin
                DocBalAccNo := GLEntry."G/L Account No.";

            end;
        end;

        if "Credit Amount" <> 0 then begin
            GLEntry.RESET;
            GLEntry.SetFilter("Document No.", "Document No.");
            GLEntry.SetRange("Posting Date", "Posting Date");
            GLEntry.SetFilter("G/L Account No.", '<>%1', "G/L Account No.");
            GLEntry.SetFilter("Debit Amount", '<>%1', 0);
            if GLEntry.FindSet() then begin
                DocBalAccNo := GLEntry."G/L Account No.";

            end;
        end;

        if DocBalAccNo <> '' then begin
            if GLAccount.GET(DocBalAccNo) then begin
                DocBalAccName := GLAccount.Name;
            end;
        end;
        */


    end;

    var
    //myInt: Integer;
    /*
    DocBalAccNo: Code[20];
    DocBalAccName: Text;
    GLAccount: Record "G/L Account";
    GLEntry: Record "G/L Entry";
    */
}
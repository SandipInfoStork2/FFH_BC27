codeunit 50004 "Bank Account Ledger Entry-Edit"
{
    // version RECON

    Permissions = tabledata "Bank Account Ledger Entry" = rm;

    trigger OnRun();
    begin
    end;

    procedure EditBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry");
    begin
    end;

    procedure EditCheckLedgerEntry(var Rec: Record "Check Ledger Entry");
    begin
    end;

    procedure OpenBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry");
    var
        rL_BankAccLE: Record "Bank Account Ledger Entry";
    begin
        rL_BankAccLE := Rec;
        rL_BankAccLE.LockTable;
        rL_BankAccLE.Find;

        rL_BankAccLE.TestField("Statement No.", '-1');
        //IF rL_BankAccLE.GET("Entry No.") THEN BEGIN
        rL_BankAccLE."Statement Status" := rL_BankAccLE."Statement Status"::Open;
        rL_BankAccLE."Statement No." := '';
        rL_BankAccLE."Statement Line No." := 0;
        rL_BankAccLE."Remaining Amount" := rL_BankAccLE.Amount;
        rL_BankAccLE.Open := true;
        rL_BankAccLE.Modify;
        //END;

        Rec := rL_BankAccLE;
    end;

    procedure CloseBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry");
    var
        rL_BankAccLE: Record "Bank Account Ledger Entry";
        rL_BankAccLE2: Record "Bank Account Ledger Entry";
        vG_LineNo: Integer;
    begin
        rL_BankAccLE := Rec;
        rL_BankAccLE.LockTable;
        rL_BankAccLE.Find;



        vG_LineNo := 0;
        rL_BankAccLE2.Reset;
        rL_BankAccLE2.SetFilter("Bank Account No.", rL_BankAccLE."Bank Account No.");
        rL_BankAccLE2.SetFilter("Statement No.", '-1');
        if rL_BankAccLE2.FindLast then begin
            vG_LineNo := rL_BankAccLE2."Statement Line No." + 10000;
        end;


        rL_BankAccLE."Statement Status" := rL_BankAccLE."Statement Status"::Closed;
        rL_BankAccLE."Statement No." := '-1';
        rL_BankAccLE."Statement Line No." := vG_LineNo;
        rL_BankAccLE."Remaining Amount" := 0;
        rL_BankAccLE.Open := false;
        rL_BankAccLE.Modify;

        Rec := rL_BankAccLE;
    end;
}


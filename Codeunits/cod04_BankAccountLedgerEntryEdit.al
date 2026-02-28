codeunit 50004 "Bank Account Ledger Entry-Edit"
{
    // version RECON

    Permissions = TableData "Bank Account Ledger Entry"=rm;

    trigger OnRun();
    begin
    end;

    procedure EditBankAccountLedgerEntry(var Rec : Record "Bank Account Ledger Entry");
    begin
    end;

    procedure EditCheckLedgerEntry(var Rec : Record "Check Ledger Entry");
    begin
    end;

    procedure OpenBankAccountLedgerEntry(var Rec : Record "Bank Account Ledger Entry");
    var
        rL_BankAccLE : Record "Bank Account Ledger Entry";
    begin
        rL_BankAccLE := Rec;
        rL_BankAccLE.LOCKTABLE;
        rL_BankAccLE.FIND;

        rL_BankAccLE.TESTFIELD("Statement No.",'-1');
        //IF rL_BankAccLE.GET("Entry No.") THEN BEGIN
          rL_BankAccLE."Statement Status" := rL_BankAccLE."Statement Status"::Open;
          rL_BankAccLE."Statement No." := '';
          rL_BankAccLE."Statement Line No." := 0;
          rL_BankAccLE."Remaining Amount" := rL_BankAccLE.Amount;
          rL_BankAccLE.Open := true;
          rL_BankAccLE.MODIFY;
        //END;

        Rec := rL_BankAccLE;
    end;

    procedure CloseBankAccountLedgerEntry(var Rec : Record "Bank Account Ledger Entry");
    var
        rL_BankAccLE : Record "Bank Account Ledger Entry";
        rL_BankAccLE2 : Record "Bank Account Ledger Entry";
        vG_LineNo : Integer;
    begin
        rL_BankAccLE := Rec;
        rL_BankAccLE.LOCKTABLE;
        rL_BankAccLE.FIND;



        vG_LineNo:=0;
        rL_BankAccLE2.RESET;
        rL_BankAccLE2.SETFILTER("Bank Account No.",rL_BankAccLE."Bank Account No.");
        rL_BankAccLE2.SETFILTER("Statement No.",'-1');
        if rL_BankAccLE2.FINDLAST then begin
          vG_LineNo:=rL_BankAccLE2."Statement Line No." +10000;
        end;


        rL_BankAccLE."Statement Status" := rL_BankAccLE."Statement Status"::Closed;
        rL_BankAccLE."Statement No." := '-1';
        rL_BankAccLE."Statement Line No." := vG_LineNo;
        rL_BankAccLE."Remaining Amount" :=0;
        rL_BankAccLE.Open := false;
        rL_BankAccLE.MODIFY;

        Rec := rL_BankAccLE;
    end;
}


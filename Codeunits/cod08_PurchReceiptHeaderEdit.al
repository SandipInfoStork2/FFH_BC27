codeunit 50008 "Purch. Rcpt. Header - Edit"
{
    Permissions = TableData "Purch. Rcpt. Header" = rm;
    TableNo = "Purch. Rcpt. Header";

    trigger OnRun()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchRcptHeader := Rec;
        PurchRcptHeader.LockTable();
        PurchRcptHeader.Find();
        //PurchRcptHeader."Payment Reference" := "Payment Reference";
        //PurchRcptHeader."Payment Method Code" := "Payment Method Code";
        //PurchRcptHeader."Creditor No." := "Creditor No.";
        //PurchRcptHeader."Ship-to Code" := "Ship-to Code";
        PurchRcptHeader."Receiving Temperature" := "Receiving Temperature";
        PurchRcptHeader."Receiving Quality Control" := "Receiving Quality Control";
        OnBeforePurchInvHeaderModify(PurchRcptHeader, Rec);
        PurchRcptHeader.TestField("No.", "No.");
        PurchRcptHeader.Modify();
        Rec := PurchRcptHeader;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchRcptHeaderRec: Record "Purch. Rcpt. Header")
    begin
    end;
}


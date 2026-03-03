codeunit 50008 "Purch. Rcpt. Header - Edit"
{
    Permissions = tabledata "Purch. Rcpt. Header" = rm;
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
        PurchRcptHeader."Receiving Temperature" := Rec."Receiving Temperature";
        PurchRcptHeader."Receiving Quality Control" := Rec."Receiving Quality Control";
        OnBeforePurchInvHeaderModify(PurchRcptHeader, Rec);
        PurchRcptHeader.TestField("No.", Rec."No.");
        PurchRcptHeader.Modify();
        Rec := PurchRcptHeader;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchRcptHeaderRec: Record "Purch. Rcpt. Header")
    begin
    end;
}


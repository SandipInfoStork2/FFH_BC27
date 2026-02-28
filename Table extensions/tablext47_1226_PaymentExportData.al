tableextension 50147 PaymentExportDataExt extends "Payment Export Data"
{
    fields
    {
        // Add changes to table fields here
        // Add changes to table fields here
        field(50000; "Bank Transfer Company Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Category Purpose"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Recipient Address 2"; Text[50])
        {
            Caption = 'Recipient Address 2';
            DataClassification = ToBeClassified;
        }
        field(50009; "Intermediary Bank Swift Code"; Code[11])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Sorting Code"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "R Correspondent Swift Code"; Code[11])
        {
            Caption = 'Receivers Correspondent Swift Code';
            DataClassification = ToBeClassified;
        }
        field(50012; "R Correspondent Bank Name"; Text[35])
        {
            Caption = 'Receivers Correspondent Bank Name';
            DataClassification = ToBeClassified;
        }
        field(50013; "R Correspondent Address 1"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 1';
            DataClassification = ToBeClassified;
        }
        field(50014; "R Correspondent Address 2"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 2';
            DataClassification = ToBeClassified;
        }
        field(50015; "R Correspondent Address 3"; Text[35])
        {
            Caption = 'Receivers Correspondent Address 3';
            DataClassification = ToBeClassified;
        }
        field(50021; "Thrd R Institution Swift Code"; Code[11])
        {
            Caption = 'Third Reimbursement Institution Swift Code';
            DataClassification = ToBeClassified;
        }
        field(50022; "Thrd R Institution Bank Name"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Bank Name';
            DataClassification = ToBeClassified;
        }
        field(50023; "Thr R Institution RC Address 1"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 1';
            DataClassification = ToBeClassified;
        }
        field(50024; "Thr R Institution RC Address 2"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 2';
            DataClassification = ToBeClassified;
        }
        field(50025; "Thr R Institution RC Address 3"; Text[35])
        {
            Caption = 'Third Reimbursement Institution Address 3';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
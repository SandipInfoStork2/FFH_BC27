/*
TAL0.1 2021/11/03 VC add field GlobalGab COC No.

*/

tableextension 50112 CompanyInformationExt extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Lidl Rep. No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Lidl Rep. Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Packaging Location GLN"; Code[13])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Packaging Location Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "GlobalGab COC No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "ISO Release Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "ISO Version"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "ISO Authorised By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "ISO Review"; Text[10])
        {
            DataClassification = ToBeClassified;
        }

        field(50009; "BIO Certification Body"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50010; "Web Portal URL"; Text[50])
        {
            Caption = 'Web Portal URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;

        }
    }

    var
        myInt: Integer;
}
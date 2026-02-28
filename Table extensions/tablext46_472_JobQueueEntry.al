tableextension 50146 JobQueueEntryExt extends "Job Queue Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Email Result"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Execute User ID"; Text[65])
        {
            Caption = 'Execute User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
    }

    var
        myInt: Integer;
}
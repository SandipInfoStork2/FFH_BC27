report 50019 "HORECA Order Reminder Admin"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Admin';
    ProcessingOnly = true;
    UsageCategory = Tasks;


    dataset
    {
        dataitem(IntegerDS; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1));

            trigger OnAfterGetRecord()
            var
                cuGeneralMgt: Codeunit "General Mgt.";
            begin

                CLEAR(cuGeneralMgt);
                cuGeneralMgt.HORECAOrderReminder(true);
            end;
        }
    }

}
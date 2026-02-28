report 50014 "HORECA Order Reminder"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Reminder';
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
                cuGeneralMgt.HORECAOrderReminder(false);
            end;
        }
    }

}
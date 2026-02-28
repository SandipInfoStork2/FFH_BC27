// send email to store managers
report 50021 "HORECA Order Reminder Manager"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Manager';
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
                cuGeneralMgt.HORECAOrderReminderManager();
            end;
        }
    }

}
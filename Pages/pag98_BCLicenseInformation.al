page 50098 "BC License Information"
{

    ApplicationArea = All;
    Caption = 'BC License Information';
    PageType = List;
    SourceTable = "License Information";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}

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
        area(Content)
        {
            repeater(General)
            {
                field(Text; Rec.Text)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Text field.';
                }
            }
        }
    }

}

pageextension 50171 ItemUnitsofMeasureExt extends "Item Units of Measure"
{
    layout
    {
        // Add changes to page layout here
        modify(Weight)
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
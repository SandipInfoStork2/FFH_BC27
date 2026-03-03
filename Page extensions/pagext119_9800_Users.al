pageextension 50219 UsersExt extends Users
{
    layout
    {
        // Add changes to page layout here
        modify(State)
        {
            Visible = true;
        }

        modify("Authentication Email")
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
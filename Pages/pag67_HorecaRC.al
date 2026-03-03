page 50067 "HORECA RC"
{
    PageType = RoleCenter;
    Caption = 'HORECA RC';
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {

        }
    }

    actions
    {
        /*
        area(Creation)
        {
            action(ActionBarAction)
            {
                RunObject = Page ObjectName;
            }
        }
        */
        /*
        area(Sections)
        {
            group(SectionsGroupName)
            {
                Caption = '';
                action(SectionsAction)
                {
                    Caption = 'Orders';
                    RunObject = Page "Horeca Order List";
                }
            }
        }
        */

        area(Embedding)
        {
            /*
            action(EmbeddingAction)
            {
                RunObject = Page ObjectName;
            }
            */
            action(SectionsAction)
            {
                Caption = 'Orders';
                RunObject = page "Horeca Order List";
                ToolTip = 'Executes the Orders action.';
            }
        }

    }
}
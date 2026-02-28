permissionset 50000 "TAL_BASIC_EXT"
{
    Assignable = True;
    Access = Public;


    Permissions =
        tabledata "General Categories" = RIDM,
        tabledata "Delivery Schedule" = RIDM,
        //tabledata "Chain Of Custody Link" = RIDM,
        tabledata "Order Qty" = RIDM,
        tabledata "Item Grower Vendor" = RIDM,
        tabledata "Grower" = RIDM,
        tabledata "Purchase Header Addon" = RIDM,
        tabledata "Purchase Line Addon" = RIDM,
        tabledata "Purchase Header Addon Posted" = RIM,
        tabledata "Purchase Line Addon Posted" = RIDM,
         tabledata "Lidl Order Archive" = RIDM,


        tabledata "Manufacturing Setup" = Rimd,
        tabledata "Order Tracking Entry" = Rimd,
        tabledata "Item Availability Line" = Rimd,
        tabledata "Planning Buffer" = Rimd,
        tabledata "Action Message Entry" = Rimd,
        tabledata "Planning Assignment" = RIMD,
        tabledata "Inventory Profile Track Buffer" = R,
        tabledata "Untracked Planning Element" = R,
        tabledata "Order Promising Setup" = R;


    //tabledata "Email Account" = RIDM;

}


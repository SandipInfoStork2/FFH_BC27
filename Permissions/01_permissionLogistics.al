permissionset 50001 TAL_Logistics_EXT
{
    Assignable = true;
    Access = Public;


    Permissions =
        tabledata "Planning Assignment" = RIDM,
        tabledata "Manufacturing Cue" = RM,
        tabledata "Warehouse Basic Cue" = RM,
        tabledata "Sales & Receivables Setup" = RM;


    //tabledata "Email Account" = RIDM;

}


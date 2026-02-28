/*
TAL0.1 2021/04/03 add field Lidl Import Sundry Grower

*/

pageextension 50163 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here

        addafter(General)
        {
            group(IDE)
            {
                Caption = 'IDE';
                field("EDI Export Path Server"; "EDI Export Path Server")
                {
                    ApplicationArea = All;
                }
                field("EDI Export Path Client"; "EDI Export Path Client")
                {
                    ApplicationArea = All;
                }
                field("EDI Encoding Export"; "EDI Encoding Export")
                {
                    ApplicationArea = All;
                }
                field("EDI Export Dot Net"; "EDI Export Dot Net")
                {
                    ApplicationArea = All;
                }
                field("EDI Last Date"; "EDI Last Date")
                {
                    ApplicationArea = All;
                }
                field("EDI Counter"; "EDI Counter")
                {
                    ApplicationArea = All;
                }
                field("EDI Create Server File"; "EDI Create Server File")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter("Background Posting")
        {
            group(Lidl)
            {
                field("Enable Lidl Cross-Ref Search"; "Enable Lidl Cross-Ref Search")
                {
                    ApplicationArea = All;
                }
                field("Lidl Import Dev Mode"; "Lidl Import Dev Mode")
                {
                    ApplicationArea = All;
                }
                field("Lidl Import Sundry Grower"; "Lidl Import Sundry Grower")
                {
                    ApplicationArea = All;
                }
                field("Default Item Tracking Code"; "Default Item Tracking Code")
                {
                    ApplicationArea = All;
                }
                field("Default Lot Nos."; "Default Lot Nos.")
                {
                    ApplicationArea = All;
                }
                field("Cost Profit %"; "Cost Profit %")
                {
                    ApplicationArea = All;
                }
                field("Lidl Archive Orders"; "Lidl Archive Orders")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter("Document Default Line Type")
        {
            group(BoxStatement)
            {
                caption = 'Box Statement';
                field("Box Statement Codes"; "Box Statement Codes")
                {
                    ApplicationArea = All;
                }
                field("Box Stmt Show Cust. Location"; "Box Stmt Show Cust. Location")
                {
                    ApplicationArea = All;
                }
                field("Box Stmt Item Category Filter"; "Box Stmt Item Category Filter")
                {
                    ApplicationArea = All;
                }
                field("Box Stmt Start Date"; "Box Stmt Start Date")
                {
                    ApplicationArea = All;
                }
            }
            field("Mand. S.O. Req. Delivery Date"; "Mand. S.O. Req. Delivery Date")
            {
                ApplicationArea = All;
            }

            group(Costing)
            {
                field("Carton Category Filter"; "Carton Category Filter")
                {
                    ApplicationArea = All;
                }
                field("Cup Category Filter"; "Cup Category Filter")
                {
                    ApplicationArea = All;
                }
                field("Other Category Filter"; "Other Category Filter")
                {
                    ApplicationArea = All;
                }
                field("Costing Cost Field"; "Costing Cost Field")
                {
                    ApplicationArea = All;
                }
                field("FILM Category Filter"; "FILM Category Filter")
                {
                    ApplicationArea = All;
                }
                field("FILM Cost"; "FILM Cost")
                {
                    ApplicationArea = All;
                }
                field("Start Date PWeek Formula"; "Start Date PWeek Formula")
                {
                    ApplicationArea = All;
                }
                field("End Date PWeek Formula"; "End Date PWeek Formula")
                {
                    ApplicationArea = All;
                }
                field("Start Update Date Formula"; "Start Update Date Formula")
                {
                    ApplicationArea = All;
                }

                field("End Update Date Formula"; "End Update Date Formula")
                {
                    ApplicationArea = All;
                }

                field("Lidl Copy Quote History"; "Lidl Copy Quote History")
                {
                    ApplicationArea = All;
                }

                field("Lidl Customer No."; "Lidl Customer No.")
                {
                    ApplicationArea = All;
                }

                //+1.0.0.247
                group(ImportHorecaExcel)
                {
                    caption = 'Import Horeca Excel';

                    field("Horeca Start Date Validation"; "Horeca Start Date Validation")
                    {
                        ApplicationArea = All;
                    }
                    field("Horeca End Date Validation"; "Horeca End Date Validation")
                    {
                        ApplicationArea = All;
                    }

                }
                //-1.0.0.247
                group(CYLAW)
                {
                    caption = 'CY leg. Setup for fresh products';
                    //+1.0.0.291
                    field("Fresh Inventory Posting Group"; "Fresh Inventory Posting Group")
                    {
                        ApplicationArea = All;
                    }
                    field("Potatoes Item Category Code"; "Potatoes Item Category Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Default Product Class"; "Default Product Class")
                    {
                        ApplicationArea = All;
                    }
                    field("Default Country of Origin Code"; "Default Country of Origin Code")
                    {
                        ApplicationArea = All;
                    }
                    //-1.0.0.291
                }


            }
        }

        //+1.0.0.268
        addafter(Archiving)
        {
            group(HorecaNotification)
            {
                caption = 'Horeca Notification';
                field("Notify Horeca Reminder Email 1"; "Notify Horeca Reminder Email 1")
                {
                    ApplicationArea = all;
                }

                field("Notify Horeca Reminder Email 2"; "Notify Horeca Reminder Email 2")
                {
                    ApplicationArea = all;
                }

                field("Notify Horeca Reminder Email 3"; "Notify Horeca Reminder Email 3")
                {
                    ApplicationArea = all;
                }

                field("Notify Horeca Reminder Email 4"; "Notify Horeca Reminder Email 4")
                {
                    ApplicationArea = all;
                }
                field("Notify Horeca Reminder Email 5"; "Notify Horeca Reminder Email 5")
                {
                    ApplicationArea = all;
                }
                field("Notify Horeca Reminder Email 6"; "Notify Horeca Reminder Email 6")
                {
                    ApplicationArea = all;
                }


            }
        }
        //-1.0.0.268
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
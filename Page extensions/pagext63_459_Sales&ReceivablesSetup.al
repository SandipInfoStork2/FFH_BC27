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
                field("EDI Export Path Server"; Rec."EDI Export Path Server")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Export Path Server field.';
                }
                field("EDI Export Path Client"; Rec."EDI Export Path Client")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Export Path Client field.';
                }
                field("EDI Encoding Export"; Rec."EDI Encoding Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Encoding Export field.';
                }
                field("EDI Export Dot Net"; Rec."EDI Export Dot Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Export Dot Net field.';
                }
                field("EDI Last Date"; Rec."EDI Last Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Last Date field.';
                }
                field("EDI Counter"; Rec."EDI Counter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Counter field.';
                }
                field("EDI Create Server File"; Rec."EDI Create Server File")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Create Server File field.';
                }
            }
        }

        addafter("Background Posting")
        {
            group(Lidl)
            {
                field("Enable Lidl Cross-Ref Search"; Rec."Enable Lidl Cross-Ref Search")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Lidl Cross-Ref Search field.';
                }
                field("Lidl Import Dev Mode"; Rec."Lidl Import Dev Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lidl Import Dev Mode field.';
                }
                field("Lidl Import Sundry Grower"; Rec."Lidl Import Sundry Grower")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lidl Import Sundry Grower field.';
                }
                field("Default Item Tracking Code"; Rec."Default Item Tracking Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Item Tracking Code field.';
                }
                field("Default Lot Nos."; Rec."Default Lot Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Lot Nos. field.';
                }
                field("Cost Profit %"; Rec."Cost Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Profit % field.';
                }
                field("Lidl Archive Orders"; Rec."Lidl Archive Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lidl Archive Orders field.';
                }
            }
        }

        addafter("Document Default Line Type")
        {
            group(BoxStatement)
            {
                Caption = 'Box Statement';
                field("Box Statement Codes"; Rec."Box Statement Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box Statement Codes field.';
                }
                field("Box Stmt Show Cust. Location"; Rec."Box Stmt Show Cust. Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box Statement Show Customer Location field.';
                }
                field("Box Stmt Item Category Filter"; Rec."Box Stmt Item Category Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box Statement Item Category Filter field.';
                }
                field("Box Stmt Start Date"; Rec."Box Stmt Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Box Statement Start Date field.';
                }
            }
            field("Mand. S.O. Req. Delivery Date"; Rec."Mand. S.O. Req. Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mandatory S.O. Requested Delivery Date field.';
            }

            group(Costing)
            {
                field("Carton Category Filter"; Rec."Carton Category Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carton Category Filter field.';
                }
                field("Cup Category Filter"; Rec."Cup Category Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cup Category Filter field.';
                }
                field("Other Category Filter"; Rec."Other Category Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Category Filter field.';
                }
                field("Costing Cost Field"; Rec."Costing Cost Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Costing Cost Field field.';
                }
                field("FILM Category Filter"; Rec."FILM Category Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FILM Category Filter field.';
                }
                field("FILM Cost"; Rec."FILM Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FILM Cost field.';
                }
                field("Start Date PWeek Formula"; Rec."Start Date PWeek Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date Previous Week Formula field.';
                }
                field("End Date PWeek Formula"; Rec."End Date PWeek Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date Previous Week Formula field.';
                }
                field("Start Update Date Formula"; Rec."Start Update Date Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Update Date Formula field.';
                }

                field("End Update Date Formula"; Rec."End Update Date Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Update Date Formula field.';
                }

                field("Lidl Copy Quote History"; Rec."Lidl Copy Quote History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lidl Copy Quote History field.';
                }

                field("Lidl Customer No."; Rec."Lidl Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lidl Customer No. field.';
                }

                //+1.0.0.247
                group(ImportHorecaExcel)
                {
                    Caption = 'Import Horeca Excel';

                    field("Horeca Start Date Validation"; Rec."Horeca Start Date Validation")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Horeca Import Start Date Validation field.';
                    }
                    field("Horeca End Date Validation"; Rec."Horeca End Date Validation")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Horeca Import End Date Validation field.';
                    }

                }
                //-1.0.0.247
                group(CYLAW)
                {
                    Caption = 'CY leg. Setup for fresh products';
                    //+1.0.0.291
                    field("Fresh Inventory Posting Group"; Rec."Fresh Inventory Posting Group")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Fresh Inventory Posting Group field.';
                    }
                    field("Potatoes Item Category Code"; Rec."Potatoes Item Category Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Potatoes Item Category Code field.';
                    }
                    field("Default Product Class"; Rec."Default Product Class")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Default Product Class (Κατηγορία) field.';
                    }
                    field("Default Country of Origin Code"; Rec."Default Country of Origin Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Default Country of Origin Code field.';
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
                Caption = 'Horeca Notification';
                field("Notify Horeca Reminder Email 1"; Rec."Notify Horeca Reminder Email 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 1 field.';
                }

                field("Notify Horeca Reminder Email 2"; Rec."Notify Horeca Reminder Email 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 2 field.';
                }

                field("Notify Horeca Reminder Email 3"; Rec."Notify Horeca Reminder Email 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 3 field.';
                }

                field("Notify Horeca Reminder Email 4"; Rec."Notify Horeca Reminder Email 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 4 field.';
                }
                field("Notify Horeca Reminder Email 5"; Rec."Notify Horeca Reminder Email 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 5 field.';
                }
                field("Notify Horeca Reminder Email 6"; Rec."Notify Horeca Reminder Email 6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify Horeca Reminder Email 6 field.';
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
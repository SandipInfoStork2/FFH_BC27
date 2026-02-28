/*
TAL0.1 2021/01/11 VC add field Zero Component Lines

*/
pageextension 50205 ProductionPlannerActivitiesExt extends "Production Planner Activities"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Simulated Prod. Orders")
        {
            field("Zero Component Lines"; "Zero Component Lines")
            {
                DrillDownPageID = "Prod. Order Components";
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage();
    begin

        //+TAL0.1
        rG_MNSetup.GET;
        if FORMAT(rG_MNSetup."Zero Date Component Formula") <> '' then begin
            vG_ZeroDateComponentFormula := rG_MNSetup."Zero Date Component Formula";
        end else begin
            EVALUATE(vG_ZeroDateComponentFormula, '-7D');
        end;

        vG_ZeroDateFilter := CALCDATE(vG_ZeroDateComponentFormula, WORKDATE);
        SETRANGE("Zero Date Filter", vG_ZeroDateFilter, WORKDATE);
        //-TAL0.1
    end;


    var
        vG_ZeroDateFilter : Date;
        rG_MNSetup : Record "Manufacturing Setup";
        vG_ZeroDateComponentFormula : DateFormula;
}
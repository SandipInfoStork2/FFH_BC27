codeunit 50001 "Adjust Cost Scheduler"
{
    // version TAL.JQEMail


    trigger OnRun();
    var
        rpt_AdjustCostItemEntries: Report "Adjust Cost - Item Entries";
        rpt_PostInventoryCosttoGL: Report "Post Inventory Cost to G/L";
        rL_PostValueEntrytoGL: Record "Post Value Entry to G/L";
        vL_StartDate: Date;
        vL_EndDate: Date;
        vL_DateText: Text;
    begin
        /*
        //Adjust Cost
        CLEAR(rpt_AdjustCostItemEntries);
        rpt_AdjustCostItemEntries.USEREQUESTPAGE(FALSE);
        rpt_AdjustCostItemEntries.RUN;
        */

        //Post Cost to GL
        vL_DateText := Format(Today, 0, '<Day,2><Month,2><Year4>');
        //vL_StartDate:=DMY2DATE(1,1,DATE2DMY(TODAY, 3)); //01/01/2017
        //vL_EndDate:=TODAY; //DMY2DATE(25,1,2018); //TODAY;
        //rL_PostValueEntrytoGL.RESET;
        //rL_PostValueEntrytoGL.SETRANGE("Posting Date",vL_StartDate,vL_EndDate);
        //IF rL_PostValueEntrytoGL.FINDSET THEN BEGIN
        Clear(rpt_PostInventoryCosttoGL);
        rpt_PostInventoryCosttoGL.InitializeRequest(PostMethod::"per Posting Group", 'ADJ' + Format(vL_DateText), true);
        //rpt_PostInventoryCosttoGL.SETTABLEVIEW(rL_PostValueEntrytoGL);
        rpt_PostInventoryCosttoGL.UseRequestPage(false);
        rpt_PostInventoryCosttoGL.Run;
        //END;


    end;

    var
        PostMethod: Option "per Posting Group","per Entry";
}


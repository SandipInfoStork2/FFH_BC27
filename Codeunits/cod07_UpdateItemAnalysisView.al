codeunit 50007 "TAL Update Item Analysis View"
{
    // version TAL.JQEMail


    trigger OnRun();
    var
        rl_ItemAnalysisView: Record "Item Analysis View";
        cu_UpdateItemAnalysisView: Codeunit "Update Item Analysis View";

    begin
        rl_ItemAnalysisView.Reset;
        rl_ItemAnalysisView.SetRange("Analysis Area", rl_ItemAnalysisView."Analysis Area"::Sales);
        rl_ItemAnalysisView.SetRange(Blocked, false);
        if rl_ItemAnalysisView.FindSet() then begin
            repeat
                cu_UpdateItemAnalysisView.Run(rl_ItemAnalysisView);
            //rl_ItemAnalysisView
            until rl_ItemAnalysisView.Next() = 0;
        end;
    end;

}
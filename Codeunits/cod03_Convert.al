codeunit 50003 Convert
{
    // version TAL.SEPA

    // //VC add & sign
    // //VC add Pc2ElotHB for HB bank file export
    // 2018/08/02 VC add % sign
    // //


    trigger OnRun();
    begin
    end;

    var
        Text003: Label 'No Data To Send';
        Text004: Label 'Exporting #4######.......\';
        Text005: Label 'Total #1####of#2######\\';

        Junk: Label '000000000000000500000';
        Text50001: Label '"The length of the Barcode can not be more than 13 - Barcode No.-''%1'',Item No.-''%2'' "';
        Text50002: Label '"The length of the Barcode is more than 13 - Barcode No.-''%1'',Item No.-''%2''. Do you want to skip the record? "';

    procedure Pc2Elot(InString: Text[250]): Text[250];
    var
        TempInFile: File;
        PCTable: Text[100];
        ElotTable: Text[100];
    begin
        PCTable := 'ϊϋάέήίύώόαβγδεζηθικλμνξοπρστυφχψωςΆΈΉΊΎΏΌΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ&''"%';
        ElotTable := 'iyaeiiyooabgdeziuiklmnjoprstyfxcosAEIIYOOABGDEZIUIKLMNJOPRSTYFXCO    ';

        exit(ConvertStr(InString, PCTable, ElotTable));
    end;

    procedure Pc2ElotHB(InString: Text[250]): Text[250];
    var
        TempInFile: File;
        PCTable: Text[100];
        ElotTable: Text[100];
    begin
        PCTable := '.,';
        ElotTable := ',.';

        exit(ConvertStr(InString, PCTable, ElotTable));
    end;
}


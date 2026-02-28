xmlport 50001 "Import Dimens Trans Payroll"
{
    // ValueDescription
    // <None>There is no text delimiter for the field.
    // <">Double straight quotes.
    // <NewLine>Any combination of CR and LF characters.
    // <CR/LF>CR followed by LF.
    // <CR>CR alone.
    // <LF>LF alone.
    // <TAB>Tabulator alone.
    // 
    // Jounral Line Dimensions does not exists in 2018 version
    // //

    Direction = Import;
    FieldDelimiter = 'None';
    FieldSeparator = '|';
    Format = VariableText;
    Permissions = TableData "Dimension Set Entry" = rimd;
    UseRequestPage = false;

    schema
    {
        textelement(Header)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'ImportDimensionsPayroll';
                textelement(TableID)
                {
                }
                textelement(TemlateName)
                {
                }
                textelement(BatchName)
                {
                }
                textelement(LineNo)
                {
                }
                textelement(DimCode)
                {
                }
                textelement(DimValueCode)
                {
                }

                trigger OnAfterInsertRecord();
                begin

                    CLEAR(DimValue);
                    DimValue.SETRANGE(DimValue."Dimension Code", DimCode);
                    DimValue.SETRANGE(DimValue.Code, DimValueCode);
                    if DimValue.FINDSET then;


                    //MESSAGE(LineNo);
                    GenJournal.RESET;
                    GenJournal.SETRANGE(GenJournal."Journal Template Name", TemlateName);
                    GenJournal.SETRANGE(GenJournal."Journal Batch Name", BatchName);
                    GenJournal.SETFILTER(GenJournal."Line No.", LineNo);
                    if GenJournal.FINDFIRST then begin
                        case DimCode of
                            'DEPARTMENT':
                                GenJournal.ValidateShortcutDimCode(1, DimValue.Code);
                            'dim2':
                                GenJournal.ValidateShortcutDimCode(2, DimValue.Code);
                            'dim3':
                                GenJournal.ValidateShortcutDimCode(3, DimValue.Code);
                            'COST CENTRE':
                                GenJournal.ValidateShortcutDimCode(4, DimValue.Code);
                            'dim5':
                                GenJournal.ValidateShortcutDimCode(5, DimValue.Code);
                            'dim6':
                                GenJournal.ValidateShortcutDimCode(6, DimValue.Code);
                            'dim7':
                                GenJournal.ValidateShortcutDimCode(7, DimValue.Code);
                        end;

                        GenJournal.MODIFY;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort();
    begin

        //loop the template and update the dimension
    end;

    trigger OnPreXmlPort();
    begin

        //rG_TempDefaultDimension.DELETEALL;
    end;

    var
        GenJournal: Record "Gen. Journal Line";
        DimValue: Record "Dimension Value";
}


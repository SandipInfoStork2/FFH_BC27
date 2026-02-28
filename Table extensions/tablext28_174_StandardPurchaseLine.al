/*
TAL0.1 2019/05/17 VC add fields Extended Description,Replenishment System
TAL0.2 2019/06/07 VC add field Description 2

*/
tableextension 50128 StandardPurchaseLine extends "Standard Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        modify("No.")
        {

            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                case Type of
                    Type::Item:
                        begin
                            Item.Get("No.");
                            //+TAL0.2
                            "Description 2" := Item."Description 2";
                            "Extended Description" := Item."Extended Description";
                            //-TAL0.2
                        end;
                end;
            end;
        }

        field(50000; "Extended Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Replenishment System"; Option)
        {
            Caption = 'Replenishment System';
            DataClassification = ToBeClassified;
            OptionCaptionML = ELL = ' ,Transfer,Boxes,Sales,Purchase',
                              ENU = ' ,Transfer,Boxes,Sales,Purchase';
            OptionMembers = " ",Transfer,Boxes,Sales,Purchase; //1.0.0.236

            trigger OnValidate();
            var
                TempSKU: Record "Stockkeeping Unit" temporary;
                AsmHeader: Record "Assembly Header";
            //NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
            end;
        }
        field(50002; "Description 2"; Text[50])
        {
            CaptionML = ELL = 'Description 2 (GR)',
                        ENU = 'Description 2';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
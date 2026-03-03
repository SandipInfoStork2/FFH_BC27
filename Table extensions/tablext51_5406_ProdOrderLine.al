/*
TAL0.1 2018/05/08 VC allow delete of production line when item ledger entry qty has been posted and qty is zero
TAL0.2 2019/05/03 VC Max Unit Cost validation
*/

tableextension 50151 ProdOrderLineExt extends "Prod. Order Line"
{
    fields
    {
        // Add changes to table fields here
        field(50009; "Shelf No."; Code[10])
        {
            CalcFormula = lookup(Item."Shelf No." where("No." = field("Item No.")));
            Caption = 'Shelf No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    trigger OnDelete()
    var
        myInt: Integer;
    begin
        /*
         IF (NOT ItemLedgEntry.ISEMPTY) AND (Quantity<>0)  THEN //TAL0.1 allow to delete posted zero qty
            ERROR(
              Text99000000,
              TABLECAPTION,"Line No.",ItemLedgEntry.TABLECAPTION);

          IF (CheckCapLedgEntry) AND (Quantity<>0)  THEN //TAL0.1 allow to delete posted zero qty
            ERROR(
              Text99000000,
              TABLECAPTION,"Line No.",CapLedgEntry.TABLECAPTION);
        */
    end;

    var
        myInt: Integer;
}
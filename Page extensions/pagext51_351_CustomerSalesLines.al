/*
TAL0.1 2017/12/04 VC add columns 

  Original Costs (LCY)
  Adjusted Profit (LCY)
  Adjusted Costs (LCY)
*/
pageextension 50151 CustomerSalesLinesExt extends "Customer Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cust.""Profit (LCY)""")
        {
            field("CustSalesLCY- CustProfit"; CustSalesLCY - CustProfit)
            {
                ApplicationArea = All;
                Caption = 'Original Costs (LCY)';
            }
            field(AdjCustProfit; AdjCustProfit)
            {
                ApplicationArea = All;
                Caption = 'Adjusted Profit (LCY)';
            }
            field("CustSalesLCY - CustProfit- AdjmtCostLCY"; CustSalesLCY - CustProfit - AdjmtCostLCY)
            {
                ApplicationArea = All;
                Caption = 'Adjusted Costs (LCY)';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord();
    begin

        //+TAL0.1
        CustSalesLCY := Cust."Sales (LCY)";
        CustProfit := Cust."Profit (LCY)" + CostCalcMgt.NonInvtblCostAmt(Cust);
        AdjmtCostLCY := CustSalesLCY - CustProfit + CostCalcMgt.CalcCustActualCostLCY(Cust);
        AdjCustProfit := CustProfit + AdjmtCostLCY;
        //-TAL0.1
    end;

    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
        CustProfit: Decimal;
        AdjCustProfit: Decimal;
        AdjProfitPct: Decimal;
        AdjmtCostLCY: Decimal;
        CustSalesLCY: Decimal;
}
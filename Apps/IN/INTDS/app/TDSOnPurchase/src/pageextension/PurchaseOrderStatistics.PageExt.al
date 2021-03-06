pageextension 18719 "Purchase Order Statistics" extends "Purchase Order Statistics"
{
    layout
    {
        addlast(General)
        {
            field("TDS Amount"; TDSAmount)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specifies the amount of TDS that is included in the total amount.';
                Caption = 'TDS Amount';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        TDSStatistics: Codeunit "TDS Statistics";
    begin
        TDSStatistics.GetStatisticsAmount(Rec, TDSAmount);
    end;

    var
        TDSAmount: Decimal;
}
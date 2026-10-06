pageextension 50100 "PDS General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Dispense Date Cover"; Rec."Dispense Date Cover")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dispense Date Cover field.', Comment = '%';
            }
            field("Prescription Validity Months"; Rec."Prescription Validity Months")
            {
                ApplicationArea = All;
                MaxValue = 12;
                MinValue = 0;
                ToolTip = 'Specifies the value of the Prescription Validity Months field.', Comment = '%';
            }
        }
    }
}

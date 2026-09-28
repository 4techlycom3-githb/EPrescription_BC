tableextension 50102 "PDS General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50010; "Dispense Date Cover"; DateFormula)
        {
            Caption = 'Dispense Date Cover';
            DataClassification = CustomerContent;
        }
    }
}

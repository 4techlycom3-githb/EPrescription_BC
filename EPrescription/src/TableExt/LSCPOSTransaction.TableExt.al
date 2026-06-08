tableextension 50100 "PDS LSC POS Transaction" extends "LSC POS Transaction"
{
    fields
    {
        field(50100; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
        }
        field(50101; "Prescribing Doctor"; Text[100])
        {
            Caption = 'Prescribing Doctor';
        }
        field(50102; "Healthcare Assistant"; Text[100])
        {
            Caption = 'Healthcare Assistant';
        }
    }
}

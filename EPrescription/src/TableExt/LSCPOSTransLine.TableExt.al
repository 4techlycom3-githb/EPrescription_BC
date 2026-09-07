tableextension 50101 "PDS LSC POS Trans. Line" extends "LSC POS Trans. Line"
{
    fields
    {
        field(50100; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
            DataClassification = CustomerContent;
        }
        field(50101; "Prescription Line No."; Integer)
        {
            Caption = 'Prescription Line No.';
            DataClassification = CustomerContent;
        }
    }
}

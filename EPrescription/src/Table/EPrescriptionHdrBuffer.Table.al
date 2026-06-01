table 50015 "PDS EPrescription Hdr Buffer"
{
    Caption = 'E-Prescription Header Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
        }
        field(2; "Patient ID"; Code[50])
        {
            Caption = 'Patient ID';
        }
        field(3; "Patient First Name"; Text[100])
        {
            Caption = 'Patient First Name';
        }
        field(4; "Patient Middle Name"; Text[100])
        {
            Caption = 'Patient Middle Name';
        }
        field(5; "Patient Last Name"; Text[100])
        {
            Caption = 'Patient Last Name';
        }
        field(51; "Prescribing Doctor"; Text[100])
        {
            Caption = 'Prescribing Doctor';
        }
        field(52; "Healthcare Assistant"; Text[100])
        {
            Caption = 'Healthcare Assistant';
        }
        field(100; "Sent to POS"; Boolean)
        {
            Caption = 'Sent to POS';
        }
    }
    keys
    {
        key(PK; "Prescription ID")
        {
            Clustered = true;
        }
    }
}

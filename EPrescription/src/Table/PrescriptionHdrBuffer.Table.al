table 50015 "PDS Prescription Hdr Buffer"
{
    Caption = 'Prescription Header Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
        }
        field(2; "Member Card No."; Code[50])
        {
            Caption = 'Member Card No.';
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
        field(101; "Converted to POS"; Boolean)
        {
            Caption = 'Converted to POS';
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

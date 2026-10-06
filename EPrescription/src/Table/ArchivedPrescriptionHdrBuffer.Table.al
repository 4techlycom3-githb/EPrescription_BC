table 50017 "PDS Archived Presc. Header"
{
    Caption = 'Archived Prescription Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
            Editable = false;
        }
        field(2; "Member Card No."; Code[50])
        {
            Caption = 'Member Card No.';
            Editable = false;
        }
        field(3; "Patient First Name"; Text[100])
        {
            Caption = 'Patient First Name';
            Editable = false;
        }
        field(4; "Patient Middle Name"; Text[100])
        {
            Caption = 'Patient Middle Name';
            Editable = false;
        }
        field(5; "Patient Last Name"; Text[100])
        {
            Caption = 'Patient Last Name';
            Editable = false;
        }
        field(6; Age; Integer)
        {
            Caption = 'Age';
            Editable = false;
        }
        field(7; Gender; Code[10])
        {
            Caption = 'Gender';
            Editable = false;
        }
        field(8; Address; Text[100])
        {
            Caption = 'Address';
            Editable = false;
        }
        field(9; "Prescription Date"; Date)
        {
            Caption = 'Prescription Date';
            Editable = false;
        }
        field(10; "Health Plus No."; code[50])
        {
            Caption = 'Health Plus No.';
            Editable = false;
        }
        field(11; "Pharmacy No."; code[50])
        {
            Caption = 'Pharmacy No.';
            Editable = false;
        }
        field(12; "Member Account No."; code[50])
        {
            Caption = 'Member Account No.';
            Editable = false;
        }
        field(13; "Birthdate"; Date)
        {
            Caption = 'Birthdate';
            Editable = false;
        }

        field(51; "Prescribing Doctor"; Text[100])
        {
            Caption = 'Prescribing Doctor';
            Editable = false;
        }
        field(52; "Healthcare Assistant"; Text[100])
        {
            Caption = 'Healthcare Assistant';
            Editable = false;
        }
        field(100; "Sent to POS"; Boolean)
        {
            Caption = 'Sent to POS';
            Editable = false;
        }
        field(101; "Converted to POS"; Boolean)
        {
            Caption = 'Converted to POS';
            Editable = false;
        }
        field(102; "Archived By User"; Code[50])
        {
            Caption = 'Archived By User';
            Editable = false;
        }
        field(103; "Archived Date"; Date)
        {
            Caption = 'Archived Date';
            Editable = false;
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

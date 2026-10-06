table 50018 "PDS Archived Presc. Line"
{
    Caption = 'Archived Prescription Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; Medicine; Text[100])
        {
            Caption = 'Medicine';
            Editable = false;
        }
        field(4; Dosage; Text[50])
        {
            Caption = 'Dosage';
            Editable = false;
        }
        field(5; Signa; Text[50])
        {
            Caption = 'Signa';
            Editable = false;
        }
        field(6; Duration; Text[50])
        {
            Caption = 'Duration';
            Editable = false;
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Qty';
            Editable = false;
        }
        field(8; Notes; Text[100])
        {
            Caption = 'Notes';
            Editable = false;
        }
        field(51; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
        }
        field(52; "Item Sub Description"; Text[100])
        {
            Caption = 'Item Sub Description';
            Editable = false;
        }
        field(53; "Qty. to Dispense"; Decimal)
        {
            Caption = 'Qty. to Dispense';
            Editable = false;
        }
        field(54; "Converted to POS"; Boolean)
        {
            Caption = 'Converted to POS';
            Editable = false;
        }
        field(55; "Converted Date"; Date)
        {
            Caption = 'Converted Date';
            Editable = false;
        }
        field(56; "Item Sub Brand"; Text[100])
        {
            Caption = 'Item Sub Brand';
            Editable = false;
        }
        field(57; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            Editable = false;
        }
        field(58; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Editable = false;
        }
        field(59; "Store No."; Code[20])
        {
            Caption = 'Store No.';
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
        key(PK; "Prescription ID", "Line No.")
        {
            Clustered = true;
        }
    }
}

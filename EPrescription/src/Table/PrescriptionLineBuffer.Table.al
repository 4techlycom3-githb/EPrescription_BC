table 50016 "PDS Prescription Line Buffer"
{
    Caption = 'Prescription Line Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Prescription ID"; Code[20])
        {
            Caption = 'Prescription ID';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Medicine; Text[100])
        {
            Caption = 'Medicine';
        }
        field(4; Dosage; Text[50])
        {
            Caption = 'Dosage';
        }
        field(5; Signa; Text[50])
        {
            Caption = 'Signa';
        }
        field(6; Duration; Text[50])
        {
            Caption = 'Duration';
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Qty';
        }
        field(8; Notes; Text[100])
        {
            Caption = 'Notes';
        }
        field(51; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            trigger OnValidate()
            var
                PlanetSubCode: Record "Planet Subcode";
                PrescHeader: Record "PDS Prescription Hdr Buffer";
            begin
                if xRec."Item No." <> "Item No." then begin
                    "Item Sub Description" := '';
                    "Item Sub Brand" := '';
                    "Qty. to Dispense" := 0;
                    "Lot No." := '';
                    "Expiration Date" := 0D;
                    Modify();
                end;
                if PrescHeader.Get(Rec."Prescription ID") then;
                if "Item No." <> '' then begin
                    if PlanetSubCode.Get("Item No.", PrescHeader."Pharmacy No.") then begin
                        "Item Sub Description" := PlanetSubCode."Sub Description";
                        "Item Sub Brand" := PlanetSubCode."Sub Description 2";
                        Modify();
                    end else
                        error('The item %1 is not available in the pharmacy %2.', "Item No.", PrescHeader."Pharmacy No.");
                end;
            end;
        }
        field(52; "Item Sub Description"; Text[100])
        {
            Caption = 'Item Sub Description';
            Editable = false;
        }
        field(53; "Qty. to Dispense"; Decimal)
        {
            Caption = 'Qty. to Dispense';
            trigger OnValidate()
            begin
                if xRec."Qty. to Dispense" <> "Qty. to Dispense" then begin
                    "Lot No." := '';
                    "Expiration Date" := 0D;
                    Modify();
                end;
                if "Qty. to Dispense" > Qty then
                    Error('The value of the Qty. to Dispense field cannot be greater than the value of the Qty field.');
            end;
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
            trigger OnValidate()
            begin
                if Rec."Lot No." = '' then begin
                    Rec."Expiration Date" := 0D;
                    Rec.Modify();
                end;
            end;
        }
        field(58; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
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

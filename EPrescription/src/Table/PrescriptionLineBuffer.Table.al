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
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Item: Record Item;
                PlanetSubCode: Record "Planet Subcode";
                RetailUser: Record "LSC Retail User";
            begin
                if RetailUser.Get(UserId) then;
                if "Item No." <> '' then begin
                    if Item.Get("Item No.") then
                        if PlanetSubCode.Get("Item No.", RetailUser."Store No.") then begin
                            "Item Sub Description" := PlanetSubCode."Sub Description";
                            Modify();
                        end else begin
                            "Item Sub Description" := Item.Description;
                            Modify();
                        end;
                end else begin
                    "Item Sub Description" := '';
                    Modify();
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
        // field(54; "Lot No."; Code[20])
        // {
        //     Caption = 'Lot No.';
        // }
    }
    keys
    {
        key(PK; "Prescription ID", "Line No.")
        {
            Clustered = true;
        }
    }
}

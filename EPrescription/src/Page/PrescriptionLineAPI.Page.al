page 50040 "PDS Prescription Line API"
{
    APIGroup = 'prescriptionData';
    APIPublisher = 'planetSysAd';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'pdsPrescriptionLineAPI';
    DelayedInsert = true;
    EntityName = 'prescriptionLine';
    EntitySetName = 'prescriptionLines';
    PageType = API;
    SourceTable = "PDS Prescription Line Buffer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(prescriptionID; Rec."Prescription ID")
                {
                    Caption = 'Prescription ID';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(medicine; Rec.Medicine)
                {
                    Caption = 'Medicine';
                }
                field(dosage; Rec.Dosage)
                {
                    Caption = 'Dosage';
                }
                field(frequency; Rec.Frequency)
                {
                    Caption = 'Frequency';
                }
                field(duration; Rec."Duration")
                {
                    Caption = 'Duration';
                }
                field(qty; Rec.Qty)
                {
                    Caption = 'Qty';
                }
                field(notes; Rec.Notes)
                {
                    Caption = 'Notes';
                }
            }
        }
    }
}

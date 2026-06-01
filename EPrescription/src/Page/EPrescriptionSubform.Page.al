page 50038 "PDS E-Prescription Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "PDS EPrescription Line Buffer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field(Medicine; Rec.Medicine)
                {
                    ToolTip = 'Specifies the value of the Medicine field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                }
                field("Qty. to Dispense"; Rec."Qty. to Dispense")
                {
                    ToolTip = 'Specifies the value of the Qty. to Dispense field.', Comment = '%';
                }
                field(Dosage; Rec.Dosage)
                {
                    ToolTip = 'Specifies the value of the Dosage field.', Comment = '%';
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field("Duration"; Rec."Duration")
                {
                    ToolTip = 'Specifies the value of the Duration field.', Comment = '%';
                }
            }
        }
    }
}

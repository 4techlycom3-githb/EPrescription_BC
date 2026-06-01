page 50037 "PDS E-Prescription Card"
{
    ApplicationArea = All;
    Caption = 'E-Prescription Card';
    PageType = Card;
    SourceTable = "PDS EPrescription Hdr Buffer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Prescription ID"; Rec."Prescription ID")
                {
                    ToolTip = 'Specifies the value of the Prescription ID field.', Comment = '%';
                }
                field("Patient ID"; Rec."Patient ID")
                {
                    ToolTip = 'Specifies the value of the Patient ID field.', Comment = '%';
                }
                field("Patient First Name"; Rec."Patient First Name")
                {
                    ToolTip = 'Specifies the value of the Patient First Name field.', Comment = '%';
                }
                field("Patient Middle Name"; Rec."Patient Middle Name")
                {
                    ToolTip = 'Specifies the value of the Patient Middle Name field.', Comment = '%';
                }
                field("Patient Last Name"; Rec."Patient Last Name")
                {
                    ToolTip = 'Specifies the value of the Patient Last Name field.', Comment = '%';
                }
                field("Prescribing Doctor"; Rec."Prescribing Doctor")
                {
                    ToolTip = 'Specifies the value of the Prescribing Doctor field.', Comment = '%';
                }
                field("Healthcare Assistant"; Rec."Healthcare Assistant")
                {
                    ToolTip = 'Specifies the value of the Healthcare Assistant field.', Comment = '%';
                }
                field("Sent to POS"; Rec."Sent to POS")
                {
                    ToolTip = 'Specifies the value of the Sent to POS field.', Comment = '%';
                }
            }
            part(epresciptionLines; "PDS E-Prescription Subform")
            {
                Caption = 'Prescription Lines';
                SubPageLink = "Prescription ID" = field("Prescription ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("SendToPOS")
            {
                Caption = 'Send to POS';
                ToolTip = 'Send the prescription to a point-of-sale transaction.';
                Image = ChangeTo;
                Promoted = true;
                promotedCategory = Process;

                trigger OnAction()
                var
                    StoreTerminalSelectionPage: Page "PDS Store & Terminal Selection";
                    EprescriptionEventFns: Codeunit "PDS E-Prescription Event & Fns";
                    StoreNoTxt: Code[20];
                    TerminalNoTxt: Code[20];
                    StaffNoTxt: Code[20];
                begin
                    if EprescriptionEventFns.HasIncompleteLineBeforeConvertToPOS(Rec."Prescription ID") then
                        Error('The prescription has incomplete lines and cannot be sent to POS.');

                    Rec."Sent to POS" := true;
                    Rec.Modify();

                    // if StoreTerminalSelectionPage.RunModal() = Action::OK then begin
                    //     StoreTerminalSelectionPage.GetSelection(StoreNoTxt, TerminalNoTxt, StaffNoTxt);
                    //     EprescriptionEventFns.ConvertPrescriptionToPOS(Rec."Prescription ID", StoreNoTxt, TerminalNoTxt, StaffNoTxt);
                    //     Message('done');
                    // end;
                end;
            }
        }
    }
}

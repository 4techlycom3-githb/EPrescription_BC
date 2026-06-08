page 50037 "PDS Prescription Card"
{
    ApplicationArea = All;
    Caption = 'Prescription Card';
    PageType = Card;
    SourceTable = "PDS Prescription Hdr Buffer";

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
                field("Member Card No."; Rec."Member Card No.")
                {
                    ToolTip = 'Specifies the value of the Member Card No. field.', Comment = '%';
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
            part(presciptionLines; "PDS Prescription Subform")
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
                    PrescriptionEventFns: Codeunit "PDS E-Prescription Event & Fns";
                    StoreNoTxt: Code[20];
                    TerminalNoTxt: Code[20];
                    StaffNoTxt: Code[20];
                begin
                    if PrescriptionEventFns.HasIncompleteLineBeforeConvertToPOS(Rec."Prescription ID") then
                        Error('The prescription has incomplete lines and cannot be sent to POS.');

                    Rec."Sent to POS" := true;
                    Rec.Modify();

                    // if StoreTerminalSelectionPage.RunModal() = Action::OK then begin
                    //     StoreTerminalSelectionPage.GetSelection(StoreNoTxt, TerminalNoTxt, StaffNoTxt);
                    //     PrescriptionEventFns.ConvertPrescriptionToPOS(Rec."Prescription ID", StoreNoTxt, TerminalNoTxt, StaffNoTxt);
                    //     Message('done');
                    // end;
                end;
            }
        }
    }
}

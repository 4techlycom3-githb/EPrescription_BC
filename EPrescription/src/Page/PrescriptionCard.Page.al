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
                field("Health Plus No."; Rec."Health Plus No.")
                {
                    ToolTip = 'Specifies the value of the Health Plus No. field.', Comment = '%';
                }
                field("Member Account No."; Rec."Member Account No.")
                {
                    ToolTip = 'Specifies the value of the Member Account No. field.', Comment = '%';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        MemberAccountNew: Record "LSC Member Account";
                        MemberContactNew: Record "LSC Member Contact";
                    begin
                        if Rec."Member Account No." = '' then begin
                            MemberAccountNew.Init();
                            MemberAccountNew."No." := '';
                            MemberAccountNew.Description := StrSubstNo('%1 %2 %3', Rec."Patient First Name", Rec."Patient Middle Name", Rec."Patient Last Name");
                            MemberAccountNew.Insert(true);

                            MemberContactNew.Init();
                            MemberContactNew.Validate("Account No.", MemberAccountNew."No.");
                            MemberContactNew."Contact No." := '';
                            MemberContactNew."First Name" := Rec."Patient First Name";
                            MemberContactNew."Middle Name" := Rec."Patient Middle Name";
                            MemberContactNew.Surname := Rec."Patient Last Name";
                            MemberContactNew.Name := StrSubstNo('%1 %2 %3', Rec."Patient First Name", Rec."Patient Middle Name", Rec."Patient Last Name");
                            MemberContactNew."PDI Age" := Rec.Age;
                            MemberContactNew."Date of Birth" := Rec.Birthdate;
                            MemberContactNew.Address := Rec.Address;
                            if StrPos(Rec.Gender, 'female') <> 0 then
                                MemberContactNew.Gender := MemberContactNew.Gender::Female
                            else
                                MemberContactNew.Gender := MemberContactNew.Gender::Male;
                            MemberContactNew.Insert(true);

                            Page.Run(Page::"LSC Member Account", MemberAccountNew);
                            Rec."Member Account No." := MemberAccountNew."No.";
                            Rec.Modify(false);
                        end;
                    end;
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
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
                }
                field(Birthdate; Rec.Birthdate)
                {
                    ToolTip = 'Specifies the value of the Birthdate field.', Comment = '%';
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Prescribing Doctor"; Rec."Prescribing Doctor")
                {
                    ToolTip = 'Specifies the value of the Prescribing Doctor field.', Comment = '%';
                }
                field("Healthcare Assistant"; Rec."Healthcare Assistant")
                {
                    ToolTip = 'Specifies the value of the Healthcare Assistant field.', Comment = '%';
                }
                field("Pharmacy No."; Rec."Pharmacy No.")
                {
                    ToolTip = 'Specifies the value of the Pharmacy No. field.', Comment = '%';
                }
                field("Sent to POS"; Rec."Sent to POS")
                {
                    ToolTip = 'Specifies the value of the Sent to POS field.', Comment = '%';
                }
                field(InventoryLocation; InventoryLocation)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Inventory Location field.', Comment = '%';
                }
            }
            part(presciptionLines; "PDS Prescription Subform")
            {
                Caption = 'Prescription Lines';
                SubPageLink = "Prescription ID" = field("Prescription ID");
            }
            part(memberSalesHistory; "PDS Member Sales History")
            {
                Caption = 'Member Sales History';
                // Provider = presciptionLines;
                // SubPageLink = "Item No." = field("Item No.");
                SubPageLink = "Member Account" = field("Member Card No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrintPrescription)
            {
                Caption = 'Print Prescription';
                ToolTip = 'Print this prescription.';
                Image = Print;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PrescriptionHeader: record "PDS Prescription Hdr Buffer";
                begin
                    PrescriptionHeader.SetRange("Prescription ID", Rec."Prescription ID");
                    Report.RunModal(Report::"PDS Prescription", true, false, PrescriptionHeader);
                end;
            }
            action("SendToPOS")
            {
                Caption = 'Send to POS';
                ToolTip = 'Send the prescription to a point-of-sale transaction.';
                Image = ChangeTo;
                Promoted = true;
                promotedCategory = Process;

                trigger OnAction()
                var
                    PrescriptionEventFns: Codeunit "PDS E-Prescription Event & Fns";
                    StoreNoTxt: Code[20];
                    TerminalNoTxt: Code[20];
                    StaffNoTxt: Code[20];
                begin
                    if PrescriptionEventFns.HasIncompleteLineBeforeConvertToPOS(Rec."Prescription ID") then
                        Error('The prescription has incomplete lines and cannot be sent to POS.');

                    Rec."Sent to POS" := true;
                    Rec.Modify();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        RetailUser: Record "LSC Retail User";
    begin
        if RetailUser.Get(UserId()) then
            InventoryLocation := RetailUser."Inventory Location";

        CurrPage.memberSalesHistory.Page.LoadData(Rec."Member Card No.");    //comment for testing
    end;

    var
        InventoryLocation: Code[20];
}

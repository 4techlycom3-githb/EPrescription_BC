page 50041 "PDS Store & Terminal Selection"
{
    ApplicationArea = All;
    Caption = 'PDS Store & Terminal Selection';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Selection';

                field(StoreNo; StoreNoTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Store No.';
                    ToolTip = 'Enter the Store No.';
                    ShowMandatory = true;
                    TableRelation = "LSC Store"."No.";
                }

                field(TerminalNo; TerminalNoTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Terminal No.';
                    ToolTip = 'Enter the Terminal No.';
                    ShowMandatory = true;
                    // TableRelation = "LSC POS Terminal"."No.";
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Terminals: Record "LSC POS Terminal";
                    begin
                        if StoreNoTxt = '' then
                            exit;
                        Terminals.SetRange("Store No.", StoreNoTxt);
                        if Page.RunModal(page::"LSC POS Terminal List", Terminals) = Action::LookupOK then
                            TerminalNoTxt := Terminals."No.";
                    end;
                }
                field(StaffNo; StaffNoTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Staff No.';
                    ToolTip = 'Enter the Staff No.';
                    ShowMandatory = true;
                    // TableRelation = "LSC Staff";
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Staff: Record "LSC Staff";
                    begin
                        if StoreNoTxt = '' then
                            exit;
                        Staff.SetRange("Store No.", StoreNoTxt);
                        if Page.RunModal(page::"LSC Staff List", Staff) = Action::LookupOK  then
                            StaffNoTxt := Staff.ID; 
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LSCStore: Record "LSC Store";
        Staff: Record "LSC Staff";
        LSCPOSTerminal: Record "LSC POS Terminal";
    begin
        if CloseAction <> CloseAction::OK then
            exit;
        if not LSCStore.Get(StoreNoTxt) then
            Error('Store No. is required to convert the prescription to POS.');
        if not LSCPOSTerminal.Get(TerminalNoTxt) then
            Error('Terminal No. is required to convert the prescription to POS.');
        if not Staff.Get(StaffNoTxt) then
            Error('Staff No. is required to convert the prescription to POS.');
    end;

    var
        StoreNoTxt: Code[20];
        TerminalNoTxt: Code[20];
        StaffNoTxt: Code[20];

    procedure GetSelection(var OutStoreNo: Code[20]; var OutTerminalNo: Code[20]; var OutStaffNo: Code[20])
    begin
        OutStoreNo := StoreNoTxt;
        OutTerminalNo := TerminalNoTxt;
        OutStaffNo := StaffNoTxt;
    end;
}

page 50041 "PDS Member Sales History"
{
    ApplicationArea = All;
    Caption = 'Member Sales History';
    PageType = ListPart;
    SourceTable = "PDI Member POS Sales History";
    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Ackn. Receipt No."; Rec."Ackn. Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Ackn. Receipt No. field.', Comment = '%';
                }
                // field("Store Name"; Rec."Store Name")
                // {
                //     ToolTip = 'Specifies the value of the Store Name field.', Comment = '%';
                // }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Sub Description"; Rec."Sub Description")
                {
                    ToolTip = 'Specifies the value of the Sub Description field.', Comment = '%';
                }
                field("Sub Brand"; Rec."Sub Brand")
                {
                    ToolTip = 'Specifies the value of the Sub Brand field.', Comment = '%';
                }
                field("Dispense Date"; Rec."Dispense Date")
                {
                    ToolTip = 'Specifies the value of the Dispense Date field.', Comment = '%';
                }
                field("Posted Qty"; Rec."Posted Qty")
                {
                    ToolTip = 'Specifies the value of the Posted Qty field.', Comment = '%';
                }
                field("Suspended Qty"; Rec."Suspended Qty")
                {
                    ToolTip = 'Specifies the value of the Suspended Qty field.', Comment = '%';
                }
            }
        }
    }

    procedure LoadData(memberCardNo: Code[50])
    var
        POSTransaction: Record "LSC POS Transaction";
        POSTransLine: Record "LSC POS Trans. Line";
        TransactionHeader: Record "LSC Transaction Header";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        GenLedgerSetup: Record "General Ledger Setup";
        TempMemberPOSSalesHistory: Record "PDI Member POS Sales History" temporary;
    begin
        Rec.DeleteAll();
        TempMemberPOSSalesHistory.DeleteAll();
        GenLedgerSetup.Get();

        //--Unposted
        POSTransaction.Reset();
        POSTransaction.SetCurrentKey("Member Card No.", "Dispense Date");
        POSTransaction.SetRange("Member Card No.", memberCardNo);
        POSTransaction.SetFilter("Dispense Date", '%1..%2', CALCDATE(GenLedgerSetup."Dispense Date Cover", Today()), Today());
        if POSTransaction.FindSet() then
            repeat
                POSTransLine.Reset();
                POSTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
                POSTransLine.SetRange("Entry Type", POSTransLine."Entry Type"::Item);
                POSTransLine.SetRange("Entry Status", POSTransLine."Entry Status"::" ");
                if POSTransLine.FindSet() then
                    repeat
                        PopulateMemberSalesHistory(POSTransaction, POSTransLine, TempMemberPOSSalesHistory);
                    until POSTransLine.Next() = 0;
            until POSTransaction.Next() = 0;
        //--Posted
        TransactionHeader.Reset();
        TransactionHeader.SetCurrentKey("Member Card No.", "Dispense Date");
        TransactionHeader.SetRange("Member Card No.", memberCardNo);
        TransactionHeader.SetFilter("Dispense Date", '%1..%2', CALCDATE(GenLedgerSetup."Dispense Date Cover", Today()), Today());
        if TransactionHeader.FindSet() then
            repeat
                TransSalesEntry.Reset();
                TransSalesEntry.SetCurrentKey("Receipt No.");
                TransSalesEntry.SetRange("Receipt No.", TransactionHeader."Receipt No.");
                if TransSalesEntry.FindSet() then
                    repeat
                        PopulateMemberSalesHistoryPosted(TransactionHeader, TransSalesEntry, TempMemberPOSSalesHistory);
                    until TransSalesEntry.Next() = 0;
            until TransactionHeader.Next() = 0;

        TempMemberPOSSalesHistory.Reset();
        if TempMemberPOSSalesHistory.FindSet() then
            repeat
                Rec.Init();
                Rec := TempMemberPOSSalesHistory;
                Rec.Insert();
            until TempMemberPOSSalesHistory.Next() = 0;
        CurrPage.Update(false); // Refresh the subpage display
    end;

    local procedure PopulateMemberSalesHistory(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var TempMemberPOSSalesHistory: Record "PDI Member POS Sales History" temporary)
    var
        Item: Record Item;
    begin
        if not Item.Get(POSTransLine.Number) then
            Clear(Item);
        TempMemberPOSSalesHistory.Reset();
        TempMemberPOSSalesHistory.SetRange("Store No.", POSTransaction."Store No.");
        TempMemberPOSSalesHistory.SetRange("POS Terminal No.", POSTransaction."Created on POS Terminal");
        TempMemberPOSSalesHistory.SetRange("Member Account", POSTransaction."Member Card No.");
        TempMemberPOSSalesHistory.SetRange("Receipt No.", POSTransaction."Receipt No.");
        TempMemberPOSSalesHistory.SetRange("Item No.", POSTransLine.Number);
        if TempMemberPOSSalesHistory.FindFirst() then begin
            TempMemberPOSSalesHistory."Ackn. Receipt No." := POSTransaction."Ackn. Receipt No.";
            TempMemberPOSSalesHistory."Dispense Date" := POSTransaction."Dispense Date";
            TempMemberPOSSalesHistory."Item No." := POSTransLine.Number;
            TempMemberPOSSalesHistory.Description := Item.Description;
            TempMemberPOSSalesHistory.Brand := Item."Description 2";
            TempMemberPOSSalesHistory."Posted Qty" := 0;
            TempMemberPOSSalesHistory."Suspended Qty" += POSTransLine.Quantity;
            TempMemberPOSSalesHistory."Customer No." := POSTransaction."Customer No.";
            TempMemberPOSSalesHistory."Sub Description" := POSTransLine."Sub Description";
            TempMemberPOSSalesHistory."Sub Brand" := POSTransLine."Sub Description 2";
            TempMemberPOSSalesHistory.Modify();
        end else begin
            TempMemberPOSSalesHistory.Init();
            TempMemberPOSSalesHistory."Store No." := POSTransaction."Store No.";
            TempMemberPOSSalesHistory."POS Terminal No." := POSTransaction."Created on POS Terminal";
            TempMemberPOSSalesHistory."Member Account" := POSTransaction."Member Card No.";
            TempMemberPOSSalesHistory."Receipt No." := POSTransaction."Receipt No.";
            TempMemberPOSSalesHistory."Ackn. Receipt No." := POSTransaction."Ackn. Receipt No.";
            TempMemberPOSSalesHistory."Dispense Date" := POSTransaction."Dispense Date";
            TempMemberPOSSalesHistory."Item No." := POSTransLine.Number;
            TempMemberPOSSalesHistory.Description := Item.Description;
            TempMemberPOSSalesHistory.Brand := Item."Description 2";
            TempMemberPOSSalesHistory."Posted Qty" := 0;
            TempMemberPOSSalesHistory."Suspended Qty" := POSTransLine.Quantity;
            TempMemberPOSSalesHistory."Customer No." := POSTransaction."Customer No.";
            TempMemberPOSSalesHistory."Sub Description" := POSTransLine."Sub Description";
            TempMemberPOSSalesHistory."Sub Brand" := POSTransLine."Sub Description 2";
            TempMemberPOSSalesHistory.Insert();
        end;
    end;

    local procedure PopulateMemberSalesHistoryPosted(var TransactionHeader: Record "LSC Transaction Header"; var TransSalesEntry: Record "LSC Trans. Sales Entry"; var TempMemberPOSSalesHistory: Record "PDI Member POS Sales History" temporary)
    var
        Item: Record Item;
    begin
        if not Item.Get(TransSalesEntry."Item No.") then
            Clear(Item);
        TempMemberPOSSalesHistory.Reset();
        TempMemberPOSSalesHistory.SetRange("Store No.", TransactionHeader."Store No.");
        TempMemberPOSSalesHistory.SetRange("POS Terminal No.", TransactionHeader."POS Terminal No.");
        TempMemberPOSSalesHistory.SetRange("Member Account", TransactionHeader."Member Card No.");
        TempMemberPOSSalesHistory.SetRange("Receipt No.", TransactionHeader."Receipt No.");
        TempMemberPOSSalesHistory.SetRange("Item No.", TransSalesEntry."Item No.");
        if TempMemberPOSSalesHistory.FindFirst() then begin
            TempMemberPOSSalesHistory."Ackn. Receipt No." := TransactionHeader."Ackn. Receipt No.";
            TempMemberPOSSalesHistory."Dispense Date" := TransactionHeader."Dispense Date";
            TempMemberPOSSalesHistory."Item No." := TransSalesEntry."Item No.";
            TempMemberPOSSalesHistory.Description := Item.Description;
            TempMemberPOSSalesHistory.Brand := Item."Description 2";
            TempMemberPOSSalesHistory."Posted Qty" += (TransSalesEntry.Quantity * -1);
            TempMemberPOSSalesHistory."Suspended Qty" := 0;
            TempMemberPOSSalesHistory."Customer No." := TransactionHeader."Customer No.";
            TempMemberPOSSalesHistory.Modify();
        end else begin
            TempMemberPOSSalesHistory.Init();
            TempMemberPOSSalesHistory."Store No." := TransactionHeader."Store No.";
            TempMemberPOSSalesHistory."POS Terminal No." := TransactionHeader."POS Terminal No.";
            TempMemberPOSSalesHistory."Member Account" := TransactionHeader."Member Card No.";
            TempMemberPOSSalesHistory."Receipt No." := TransactionHeader."Receipt No.";
            TempMemberPOSSalesHistory."Ackn. Receipt No." := TransactionHeader."Ackn. Receipt No.";
            TempMemberPOSSalesHistory."Dispense Date" := TransactionHeader."Dispense Date";
            TempMemberPOSSalesHistory."Item No." := TransSalesEntry."Item No.";
            TempMemberPOSSalesHistory.Description := Item.Description;
            TempMemberPOSSalesHistory.Brand := Item."Description 2";
            TempMemberPOSSalesHistory."Posted Qty" := (TransSalesEntry.Quantity * -1);
            TempMemberPOSSalesHistory."Suspended Qty" := 0;
            TempMemberPOSSalesHistory."Customer No." := TransactionHeader."Customer No.";
            TempMemberPOSSalesHistory.Insert();
        end;
    end;

    procedure FilterRecordsPerItem(ItemNo: Code[20])
    begin
        Rec.SetRange("Item No.", ItemNo);
        CurrPage.Update(false); // Refresh the subpage display
    end;
}

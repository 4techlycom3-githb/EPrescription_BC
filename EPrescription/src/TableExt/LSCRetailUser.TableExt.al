tableextension 50103 "PDS LSC Retail User" extends "LSC Retail User"
{
    fields
    {
        field(50000; "Inventory Location"; Code[20])
        {
            Caption = 'Inventory Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
    }
}

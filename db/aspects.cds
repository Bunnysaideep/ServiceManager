
using { managed } from '@sap/cds/common';

aspect AuditInfo: managed {}

aspect Address {
    street: String(100);
    city: String(50);
    postalCode: String(20);
    country: String(50);
    landmark: String(100);
}
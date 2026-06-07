namespace servicemgmt;

using { cuid } from '@sap/cds/common';
using { Address, AuditInfo } from './aspects';
using { servicemgmt.common as types } from './types';

entity Customers: cuid, Address, AuditInfo {
    name: String(100);
    email: types.EmailAddress;
    country_code: String(50);
    latitude: Decimal(10, 7);
    longitude: Decimal(10, 7);
}

entity Equipment: cuid, AuditInfo {
    name: String(100);
    serialNumber: String(50);
    description: String(255);
    customer: Association to Customers;
}

entity Technicians: cuid, AuditInfo, Address {
    name: String(100);
    email: types.EmailAddress;
    phone: types.PhoneNumber;
    specialization: String(100);
    skillLevel: Integer;
}

entity ServiceOrders: cuid, AuditInfo {
    orderNumber: String(20);
    equipment: Association to Equipment;
    customer: Association to Customers;
    description: String(255);
    status: types.ServiceStatus;
    priority: types.Priority;
    assignedTechnician: Association to Technicians;
    plannedStartDate: Date;
    plannedEndDate: Date;
    items: Composition of many ServiceOrderItems on items.serviceOrder = $self;
}

entity ServiceOrderItems: cuid, AuditInfo {
    serviceOrder: Association to ServiceOrders;
    itemDescription: String(255);
    quantity: Integer;
    unitPrice: Decimal(10, 2);
    effortHours: Decimal(5, 2);
}


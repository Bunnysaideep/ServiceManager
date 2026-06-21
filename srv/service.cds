using { servicemgmt } from '../db/schema';

@requires: 'authenticated-user'
service ServiceManagementSrv @(path: '/service') {
  
    @odata.draft.enabled
    @restrict: [
        {
            grant: ['READ'],
            to   : 'ServiceViewer'
        },
        {
            grant: [
                'CREATE',
                'UPDATE'
            ],
            to   : 'ServiceEditor'
        },
        {
            grant: ['DELETE'],
            to   : 'ServiceAdmin'
        }
    ]
    entity ServiceOrders as projection on servicemgmt.ServiceOrders 
        actions {
            action assignTechnician(technicianId: UUID) returns ServiceOrders; 
            function calculateETA()                       returns Integer;
        };


    entity ServiceOrderItems as projection on servicemgmt.ServiceOrderItems;

    entity Customers as projection on servicemgmt.Customers;

    entity Equipment as projection on servicemgmt.Equipment;
    entity Technicians as projection on servicemgmt.Technicians;
    entity Priorities as projection on servicemgmt.Priorities;

     function getCurrentExchangeRate(toCurrency: String) returns Decimal;

    function getExchangeRate(from: String, to: String) returns Decimal;

    // action assignTechnician(serviceOrderId: UUID, technicianId: UUID) returns ServiceOrders;
}
using ServiceManagementSrv as service from './service';

annotate service.ServiceOrders with @(
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Label: 'Order Number',
            Value: orderNumber
        },
        {
            $Type: 'UI.DataField',
            Label: 'Customer',
            Value: customer.name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Equipment',
            Value: equipment.name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Status',
            Value: status
        },
        {
            $Type: 'UI.DataField',
            Label: 'Priority',
            Value: priority
        },
        {
            $Type: 'UI.DataField',
            Label: 'Assigned Technician',
            Value: assignedTechnician.name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Planned Start Date',
            Value: plannedStartDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Planned End Date',
            Value: plannedEndDate
        }

    ],

    UI.SelectionFields: [
        orderNumber,
        plannedStartDate,
        plannedEndDate,
        status,
        priority,
        customer_ID
    ]
);

annotate service.ServiceOrders with {
    orderNumber  @(Common.ValueList: {
        CollectionPath: 'ServiceOrders',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: orderNumber,
            ValueListProperty: 'orderNumber'
        }]
    });

    customer @(Common.ValueList: {
        CollectionPath: 'Customers',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: customer_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'street'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'city'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'country_code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'postalCode'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    });

    priority @(Common.ValueList: {
        CollectionPath: 'Priorities',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: priority,
            ValueListProperty: 'priority'
        }]
    },
    Common.ValueListWithFixedValues: true
    );

};




//Object page
annotate service.ServiceOrders with @(
    UI.HeaderInfo: {
        TypeName: 'Service Order',
        TypeNamePlural: 'Service Orders',
        Title: {
            Value: orderNumber
        },
        Description: {
            Value: status
        }
    },

    UI.FieldGroup #General: {
        $Type: 'UI.FieldGroupType',
        Label: 'General Information',
        Data: [
            {
                $Type: 'UI.DataField',
                Label: 'Order Number',
                Value: orderNumber
            },
            {
                $Type: 'UI.DataField',
                Label: 'Customer',
                Value: customer.name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Equipment',
                Value: equipment.name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Status',
                Value: status
            },
            {
                $Type: 'UI.DataField',
                Label: 'Priority',
                Value: priority
            },
            {
                $Type: 'UI.DataField',
                Label: 'Impact',
                Value: impact
            },
            {
                $Type: 'UI.DataField',
                Label: 'Assigned Technician',
                Value: assignedTechnician.name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Planned Start Date',
                Value: plannedStartDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Planned End Date',
                Value: plannedEndDate
            }
        ]
    },

    UI.Facets: [{
        $Type: 'UI.ReferenceFacet',
        Label: 'General Information',
        Target: '@UI.FieldGroup#General'
    }]
);

annotate service.ServiceOrders with {
    orderNumber @Common.FieldControl : #ReadOnly;
}

annotate service.ServiceOrders @(Common: {SideEffects  : {
    SourceProperties: ['priority'],
    TargetProperties: ['impact']
}})
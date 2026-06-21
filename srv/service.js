const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
    const { ServiceOrders, Technicians } = this.entities;

    // Before create: initialize defaults
    this.before('CREATE', 'ServiceOrders', req => {
        req.data.orderNumber = req.data.orderNumber || `SO-${new Date().getFullYear()}-${cds.utils.uuid().substring(0, 8).toUpperCase()}`;
    });

    // Action: assignTechnician
    this.on('assignTechnician', async (req) => {

        const orderID = req.params[0].ID;
        const { technicianId } = req.data;

        if (!technicianId) {
            req.reject(400, 'Technician ID is required');
        }

        const tx = cds.tx(req);

        const [order, technician] = await Promise.all([
            tx.run(
                SELECT.one
                    .from(ServiceOrders)
                    .where({ ID: orderID })
            ),
            tx.run(
                SELECT.one
                    .from(Technicians)
                    .where({ ID: technicianId })
            )
        ]);

        // Collect validation errors
        if (!order) {
            req.error(404, 'Service Order not found');
        }

        if (!technician) {
            req.error(404, 'Technician not found');
        }

        if (req.errors) {
            return;
        }

        // Business rule validations
        if (order.status === 'Completed') {
            req.reject(
                400,
                'Cannot assign technician to a completed order'
            );
        }

        if (order.status === 'Cancelled') {
            req.reject(
                400,
                'Cannot assign technician to a cancelled order'
            );
        }

        // Already assigned
        if (order.technician_ID === technicianId) {
            return order;
        }

        const updatedOrder = await tx.run(
            UPDATE(ServiceOrders)
                .set({
                    assignedTechnician_ID: technicianId,
                    status: 'InProcess'
                })
                .where({ ID: orderID })
        );

        return {
            updatedOrder
        };
    });

    // Function: calculateETA
    this.on('calculateETA', async req => {
        const orderID = req.params[0].ID ;

        const order = await SELECT.one.from(ServiceOrders, orderID).columns('priority');
        if (!order) return req.error(404, 'Order not found');

        const base = order.priority === 'Critical' ? 60 :
            order.priority === 'High' ? 120 : 240;
        return base; // minutes
    });

    //Function: getExchangeRate
    this.on('getExchangeRate', async req => {
        const { from, to } = req.data;

        if (!from || !to) {
            return req.error(400, 'Both from and to are required');
        }

        // Mock exchange rates for demonstration
        const exchangeRates = {
            'USD_EUR': 0.85,
            'EUR_USD': 1.18,
            'USD_JPY': 110.0,
            'JPY_USD': 0.0091
        };

        const key = `${from}_${to}`;
        const rate = exchangeRates[key];

        if (!rate) {
            return req.error(404, `Exchange rate from ${from} to ${to} not found`);
        }

        return rate;
    });

    this.on('READ', 'Priorities', async () => {
        return [
            { priority: 'Critical', description: 'Requires immediate attention' },
            { priority: 'High', description: 'Should be addressed soon' },
            { priority: 'Medium', description: 'Normal priority' },
            { priority: 'Low', description: 'Can be addressed at a later time' },
            { priority: 'Planning', description: 'Under planning' }
        ];
    });

    this.before('UPDATE', 'ServiceOrders.drafts', async (req) => {
        
        if(req.data.priority){
            switch (req.data.priority) {
                case 'Critical':
                case 'High':
                    req.data.impact = 'High';
                    break;
                case 'Medium':
                    req.data.impact = 'Medium';
                    break;
                case 'Low':
                case 'Planning':
                    req.data.impact = 'Low';
                    break;
            }
        }
    }); 

});
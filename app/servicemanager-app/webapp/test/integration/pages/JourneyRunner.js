sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"servicemanagerapp/test/integration/pages/ServiceOrdersList",
	"servicemanagerapp/test/integration/pages/ServiceOrdersObjectPage",
	"servicemanagerapp/test/integration/pages/ServiceOrderItemsObjectPage"
], function (JourneyRunner, ServiceOrdersList, ServiceOrdersObjectPage, ServiceOrderItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('servicemanagerapp') + '/test/flp.html#app-preview',
        pages: {
			onTheServiceOrdersList: ServiceOrdersList,
			onTheServiceOrdersObjectPage: ServiceOrdersObjectPage,
			onTheServiceOrderItemsObjectPage: ServiceOrderItemsObjectPage
        },
        async: true
    });

    return runner;
});


%dw 2.0

/**
 * Order Transformation Module
 * Transforms order data between Salesforce and NetSuite formats
 */

/**
 * Transform Salesforce order to NetSuite format
 */
fun sfToNetsuiteOrder(order: Object): Object = {
    externalId: order.salesforceOrderId,
    entity: {
        internalId: order.customerId
    },
    tranDate: order.orderDate as String {format: "yyyy-MM-dd"},
    status: order.status,
    currency: {
        name: order.currency
    },
    itemList: {
        item: (order.items default []) map (item) -> {
            item: {
                internalId: item.productCode
            },
            quantity: item.quantity,
            rate: item.unitPrice
        }
    },
    shippingAddress: transformAddress(order.shippingAddress),
    billingAddress: transformAddress(order.billingAddress)
}

/**
 * Transform NetSuite order to API format
 */
fun netsuiteToApiOrder(nsOrder: Object): Object = {
    orderId: nsOrder.internalId default nsOrder.id,
    salesforceOrderId: nsOrder.externalId default "",
    customerId: nsOrder.entity.internalId default "",
    orderDate: nsOrder.tranDate,
    status: nsOrder.status default "UNKNOWN",
    currency: nsOrder.currency.name default "USD",
    totalAmount: nsOrder.total default 0,
    items: (nsOrder.itemList.item default []) map (item) -> {
        productCode: item.item.internalId default "",
        quantity: item.quantity default 0,
        unitPrice: item.rate default 0
    },
    shippingAddress: transformNetsuiteAddress(nsOrder.shippingAddress),
    billingAddress: transformNetsuiteAddress(nsOrder.billingAddress)
}

/**
 * Transform address to NetSuite format
 */
fun transformAddress(addr: Object | Null): Object = 
    if (addr != null) {
        addr1: addr.street default "",
        city: addr.city default "",
        state: addr.state default "",
        zip: addr.postalCode default "",
        country: addr.country default ""
    } else {
        addr1: "",
        city: "",
        state: "",
        zip: "",
        country: ""
    }

/**
 * Transform NetSuite address to API format
 */
fun transformNetsuiteAddress(addr: Object | Null): Object = 
    if (addr != null) {
        street: addr.addr1 default "",
        city: addr.city default "",
        state: addr.state default "",
        postalCode: addr.zip default "",
        country: addr.country default ""
    } else {
        street: "",
        city: "",
        state: "",
        postalCode: "",
        country: ""
    }

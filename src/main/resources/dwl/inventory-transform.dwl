%dw 2.0

/**
 * Inventory Transformation Module
 * Transforms inventory data between NetSuite and Salesforce formats
 */

/**
 * Transform NetSuite inventory to API format
 */
fun netsuiteToApiInventory(items: Array): Array = 
    items map (item) -> {
        productCode: item.itemId default item.internalId default "",
        location: item.location.name default item.locationId default "",
        availableQuantity: item.quantityAvailable default item.quantity default 0,
        lastUpdated: item.lastModifiedDate default now() as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
    }

/**
 * Transform API inventory to Salesforce format
 */
fun apiToSalesforceInventory(items: Array): Object = {
    records: items map (item) -> {
        attributes: {
            "type": "Product2"
        },
        ProductCode: item.productCode,
        QuantityUnitOfMeasure: item.location,
        StockKeepingUnit: item.availableQuantity as String,
        LastModifiedDate: item.lastUpdated
    }
}

/**
 * Build inventory update response
 */
fun buildInventoryUpdateResponse(success: Boolean): Object = {
    updated: success,
    processedAt: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
}

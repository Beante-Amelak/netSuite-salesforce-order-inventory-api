%dw 2.0

/**
 * Error Response Module
 * Standardized error response builder
 */

/**
 * Build standard error response
 */
fun buildErrorResponse(errorCode: String, message: String, correlationId: String): Object = {
    errorCode: errorCode,
    message: message,
    correlationId: correlationId,
    timestamp: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss'Z'"}
}

/**
 * Build bad request error
 */
fun badRequestError(message: String, correlationId: String): Object = 
    buildErrorResponse("BAD_REQUEST", message, correlationId)

/**
 * Build unauthorized error
 */
fun unauthorizedError(correlationId: String): Object = 
    buildErrorResponse("UNAUTHORIZED", "Unauthorized - Invalid or missing credentials", correlationId)

/**
 * Build not found error
 */
fun notFoundError(resource: String, correlationId: String): Object = 
    buildErrorResponse("NOT_FOUND", "Resource not found: " ++ resource, correlationId)

/**
 * Build internal server error
 */
fun internalServerError(message: String, correlationId: String): Object = 
    buildErrorResponse("INTERNAL_SERVER_ERROR", message, correlationId)

/**
 * Build gateway timeout error
 */
fun gatewayTimeoutError(system: String, correlationId: String): Object = 
    buildErrorResponse("GATEWAY_TIMEOUT", "Timeout connecting to " ++ system, correlationId)

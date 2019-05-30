global class WarehouseCalloutServiceMock implements HttpCalloutMock{
    private static final String RESPONSE_BODY1 = '{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100002"}';
    private static final String RESPONSE_BODY2 = '{"_id":"55d66226726b611100aaf743","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}';

    public static final String RESPONSE_HEADER_PARAM_NAME = 'Content-Type';
    public static final String RESPONSE_HEADER_CONTENT_TYPE = 'application/json';

    // implement http mock callout
    global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse response = new HttpResponse();
			response.setStatusCode(200);
			response.setStatus('Complete');
            response.setHeader(RESPONSE_HEADER_PARAM_NAME, RESPONSE_HEADER_CONTENT_TYPE);
			response.setBody('[' + RESPONSE_BODY1 + ',' + RESPONSE_BODY2 + ']');
			return response;
    }
}
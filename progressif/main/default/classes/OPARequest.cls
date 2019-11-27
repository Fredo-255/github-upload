public with sharing class OPARequest {
    public String bareme;
    public String body;
    //public Asset autorisation;

    private OPAResponse response;    
    
    // Constructeur
    public OPARequest(Id authorizationId) {
        OPADAO.setAuthorizationId(authorizationId);
        Asset autorisation = OPADAO.mapAuthorizations.get(authorizationId);
        bareme = autorisation.Offre__r.Scale__c;
        body = OPARequestBody.create(autorisation);
        //this.autorisation = autorisation;       
    }   

    public OPAResponse getRates() {
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('callout:callout_mario' + OPAConstants.SERVICE_URI + OPAConstants.VERSION + '/' + bareme);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json; charset=UTF-8');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setHeader('SOAPAction', OPAConstants.SOAPACTION);
        req.setBody(body);
        System.debug('Body : ' + body);

        HttpResponse resp = http.send(req);

        if(resp.getStatusCode() == 200) {
            response = new OPAResponse(resp.getBody());
            response.OPARequestErrorCode = 0;
        } else {
            response = new OPAResponse();
            response.jsonResponse = resp.getBody();
            response.HTTPStatusCode = resp.getStatusCode();
            response.OPARequestErrorCode = -2000 -resp.getStatusCode();
        }
        return response;
        
    } 

}
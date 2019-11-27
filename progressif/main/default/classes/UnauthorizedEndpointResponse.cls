@TestVisible 
// Cette classe n'a pour but que de causer des callout exceptions dans les tests
// Pour l'utiliser il suffit de la référencer ainsi lors de la déclaration du Mock :
// Test.setMock(HttpCalloutMock.class, new UnauthorizedEndpointResponse());
public class UnauthorizedEndpointResponse implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        throw e;
    }
}
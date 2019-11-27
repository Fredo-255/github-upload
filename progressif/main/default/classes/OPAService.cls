public without sharing class OPAService {

    @InvocableMethod(label='Récupérer le tarif HT')
    public static List<OPAService.OPAResult> retrieveRates(List<Id> authorizationIds) {
        List<OPAService.OPAResult> lstResults = new List<OPAService.OPAResult>();
        System.debug(authorizationIds);
        OPAService.OPAResult result = retrieveRates(authorizationIds[0]);
        lstResults.add(result);
        return lstResults;
    }
    
    public static OPAService.OPAResult retrieveRates(Id authorizationId){
        OPAService.OPAResult result = new OPAService.OPAResult();
        result.resultCode = 0;
        result.authorizationId = authorizationId;
        OPADAO.setAuthorizationId(authorizationId);

        // Construction de la requpête
        OPARequest request;
        try {
            request = new OPARequest(authorizationId);
        } catch (Exception e) {
            result.resultCode = -1000;
            result.errorMessage = e.getMessage();
            return result;
        }

        // Interrogation OPA et stockage de la réponse dans rates
        OPAResponse response;
        try {
            FailTest.Here('OtherOPAFail');
            response = request.getRates();
            if(response.OPARequestErrorCode < 0) {
                result.resultCode = response.OPARequestErrorCode;
                result.errorMessage = 'Error returned by Mario/OPA';
                result.jsonRequest = request.body;
                result.jsonResponse = response.jsonResponse;
                System.debug('In OPA Service : ' + result.errorMessage);
                System.debug('/// REQUEST ///');
                System.debug(JSON.serializePretty(JSON.deserializeUntyped(result.jsonRequest)));
                System.debug('/// RESPONSE ///');
                System.debug(JSON.serializePretty(JSON.deserializeUntyped(result.jsonResponse)));
                return result;
            }
        } catch(CalloutException e) {
            result.resultCode = -2001;
            result.errorMessage = e.getMessage();
            System.debug('CalloutException caught in OPAService' + e);
            return result;
        } catch (Exception e) {
            result.resultCode = -2000;
            result.errorMessage = e.getMessage();
            System.debug('Unidentified exception caught in OPAService : ' + e);
            return result;
        }

        // Ecriture des tarifs dans Salesforce
        try {
            FailTest.Here('WriteFail');
            response.writeRatesToAuthorization(authorizationId);
        } catch (Exception e) {
            result.resultCode = -3000;
            result.errorMessage = 'Error while writing rates : ' + e.getMessage();
            System.debug('Unidentified exception caught in OPAService : ' + e);
            return result;
        }

        result.ratesCreated = response.rates.size();
        return result;
    }

    // Subclasses

    public class OPAResult {
        @InvocableVariable
        public Integer resultCode;
        @InvocableVariable
        public Integer ratesCreated;
        @InvocableVariable
        public String errorMessage;
        @InvocableVariable
        public String jsonRequest;
        @InvocableVariable
        public String jsonResponse;
        @InvocableVariable
        public Id authorizationId;
    }

    public class OPAException extends Exception {
        public Integer OPAExceptionCode;
        public String requestBody;
        public String responseBody;
        public Integer httpStatusCode;
        public String httpStatus;
        
    }
}
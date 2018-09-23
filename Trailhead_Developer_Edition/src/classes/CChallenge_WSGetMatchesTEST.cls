/*
*	class : CChallenge_WSGetMatchesTEST
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: test class that check all the test case in CChallenge_WSGetMatches service
*
*/

@isTest(seeAllData=false)
public class CChallenge_WSGetMatchesTEST {

	@TestSetup
	public static void createSetUpData(){
		//Subscriber
		Subscriber__c sub = CChallenge_TestHelper.createSubscriber();
		insert sub;
		
		// Tournament
		Tournament__c tournmt = CChallenge_TestHelper.createTournament(sub.Id);
		insert tournmt;
		
		// Match
		Match__c mt = CChallenge_TestHelper.createMatch(tournmt.Id);
		insert mt;
		
		// Teams
		Team__c localTeam = CChallenge_TestHelper.createLocalTeam(mt.Id);
		insert localTeam;
		
		Team__c visitorTeam = CChallenge_TestHelper.createVisitorTeam(mt.Id); 
		insert visitorTeam;
		
		// Players
		Player__c localPlayer = CChallenge_TestHelper.createLocalPlayer(localTeam.Id);
		insert localPlayer;
		
		Player__c visitPlayer = CChallenge_TestHelper.createVisitorPlayer(visitorTeam.Id);
		insert visitPlayer;
	}    
	
	/* Method to check there are not results because of the lack of parameters */
	@isTest static void testResultsWithoutParams(){
		Map<String, String> params = getMapRequestParameters('', '');
		GetMatchResultsWrapper.RequestBody requestBody = new GetMatchResultsWrapper.RequestBody(params);
		instanceContext(requestBody);
		
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResponseBody;
		
		Test.startTest();
			CChallenge_WSGetMatches.doGet();
		Test.stopTest();
		
		String jsonResult = RestContext.response.responseBody.toString();
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResult = (GetMatchResultsWrapper.ResponseMatchesWrapper) JSON.deserialize(jsonResult, GetMatchResultsWrapper.ResponseMatchesWrapper.class);
		System.assertEquals(CChallenge_GeneralConstants.STATUSCODE_KO, wrapperResult.codeResult);
		System.assertEquals(CChallenge_GeneralConstants.MSG_NO_PARAMS, wrapperResult.msgResult);
		System.assert( RestContext.response.responseBody != null );
		
	}
	
	/* Method to check that email is invalid */
	@isTest static void testResultsInvalidEmail(){
		Map<String, String> params = getMapRequestParameters('', 'invalidEmailTest.com');
		GetMatchResultsWrapper.RequestBody requestBody = new GetMatchResultsWrapper.RequestBody(params);
		instanceContext(requestBody);	

		Test.startTest();
			CChallenge_WSGetMatches.doGet();
		Test.stopTest();
		
		String jsonResult = RestContext.response.responseBody.toString();
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResult = (GetMatchResultsWrapper.ResponseMatchesWrapper) JSON.deserialize(jsonResult, GetMatchResultsWrapper.ResponseMatchesWrapper.class);
		System.assertEquals(CChallenge_GeneralConstants.STATUSCODE_KO, wrapperResult.codeResult);
		System.assertEquals(CChallenge_GeneralConstants.MSG_NOVALID_EMAIL, wrapperResult.msgResult);
		System.assert(RestContext.response.responseBody != null);
	}
	
	/* Method to check that id is invalid */
	@isTest static void testResultsInvalidID(){
		Map<String, String> params = getMapRequestParameters('1634AES', '');
		GetMatchResultsWrapper.RequestBody requestBody = new GetMatchResultsWrapper.RequestBody(params);
		instanceContext(requestBody);	

		Test.startTest();
			CChallenge_WSGetMatches.doGet();
		Test.stopTest();
		
		String jsonResult = RestContext.response.responseBody.toString();
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResult = (GetMatchResultsWrapper.ResponseMatchesWrapper) JSON.deserialize(jsonResult, GetMatchResultsWrapper.ResponseMatchesWrapper.class);
		System.assertEquals(CChallenge_GeneralConstants.STATUSCODE_KO, wrapperResult.codeResult);
		System.assertEquals(CChallenge_GeneralConstants.MSG_NOVALID_ID, wrapperResult.msgResult);
		System.assert(RestContext.response.responseBody != null);
	}
	
	/* Method to check that the service retrieve results */
	@isTest static void testResultsOK(){
		Subscriber__c s = [SELECT Id, Email__c, SubscriberID__c FROM Subscriber__c LIMIT 1];
		system.debug('**************** Subscriber : ' + s);
		Map<String, String> params = getMapRequestParameters(s.SubscriberID__c, s.Email__c);
		GetMatchResultsWrapper.RequestBody requestBody = new GetMatchResultsWrapper.RequestBody(params);
		instanceContext(requestBody);
		
		Test.startTest();
			CChallenge_WSGetMatches.doGet();
		Test.stopTest();
		
		String jsonResult = RestContext.response.responseBody.toString();
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResult = (GetMatchResultsWrapper.ResponseMatchesWrapper) JSON.deserialize(jsonResult, GetMatchResultsWrapper.ResponseMatchesWrapper.class);
		System.assertEquals(CChallenge_GeneralConstants.STATUSCODE_OK, wrapperResult.codeResult);
		System.assertEquals(CChallenge_GeneralConstants.MSG_RESULTS_FOUND, wrapperResult.msgResult);
	}
	
	
	
	/* Method to store in a map all the parameters */
	private static Map<String, String> getMapRequestParameters (String id, String email){
		Map<String, String> requestParams = new Map<String, String>();
		if(String.isNotEmpty(id))		requestParams.put('id', id);
		if(String.isNotEmpty(email))	requestParams.put('email', email);
		
		return requestParams;
	} 
	
	/* Method to prepare url and parameters request */
	private static void instanceContext (GetMatchResultsWrapper.RequestBody reqBody){
		RestContext.response = new RestResponse();
		RestRequest request  = new RestRequest();
		
		request.requestURI 	 = '/matches';
		request.httpMethod = 'GET';
		request.addParameter('id', reqBody.IDnumber);
		request.addParameter('email', reqBody.email);
		
		RestContext.request = request;
	}
}
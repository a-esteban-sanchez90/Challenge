/*
*	class : CChallenge_WSGetMatches
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: class that retrieves information about matches of a tournament according to several parameters from a subscriber
*
*/

@RestResource(urlMapping='/matches/*')
global class CChallenge_WSGetMatches {
	
	@HttpGet
	global static void doGet(){
		 // Initializing request and reponse
        RestRequest request = RestContext.request;
        RestResponse response = new RestResponse();

        response.addHeader(CChallenge_GeneralConstants.REQUEST_CONTENT_TYPE, CChallenge_GeneralConstants.REQUEST_CHARSET_APPLICATION);

        System.debug( 'CChallenge_WSGetMatches: doGet: params ::' + request.params );
        
        //instanciate request body
        GetMatchResultsWrapper.RequestBody requestBody = new GetMatchResultsWrapper.RequestBody( request.params );
        
        //instanciate response body
        GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResponseBody;
        
        try {
        	/* Previous Validations */
        	if(hasEmptyParams(requestBody)){ // No params
        		wrapperResponseBody = new GetMatchResultsWrapper.ResponseMatchesWrapper(null, CChallenge_GeneralConstants.STATUSCODE_KO, CChallenge_GeneralConstants.MSG_NO_PARAMS);
        		response.statusCode = 500;
        	} else if (!hasEmptyParams(requestBody) && String.isNotEmpty(requestBody.email) && !isValidEmail(requestBody.email)) { // Invalid Email Format
        		wrapperResponseBody = new GetMatchResultsWrapper.ResponseMatchesWrapper(null, CChallenge_GeneralConstants.STATUSCODE_KO, CChallenge_GeneralConstants.MSG_NOVALID_EMAIL);
        		response.statusCode = 500;		
        	} else if (!hasEmptyParams(requestBody) && String.isNotEmpty(requestBody.idNumber) && !isValidIdNumber(requestBody.idNumber)){ // Invalid ID Format
        		wrapperResponseBody = new GetMatchResultsWrapper.ResponseMatchesWrapper(null, CChallenge_GeneralConstants.STATUSCODE_KO, CChallenge_GeneralConstants.MSG_NOVALID_ID);
        		response.statusCode = 500;
        	} else { // with Valid Params
        		wrapperResponseBody = getListMatchesResponse(requestBody);
        	}

        } catch(Exception ex){
        	System.debug('CChallenge_WSGetMatches: doGet: Exception Message :: ' + ex.getMessage());
            System.debug('CChallenge_WSGetMatches: doGet: Exception Trace ::' + ex.getStackTraceString());
            
            // Generating a response body with exception message
            wrapperResponseBody = new GetMatchResultsWrapper.ResponseMatchesWrapper( null , CChallenge_GeneralConstants.STATUSCODE_KO, ex.getMessage());
            response.statusCode = 500;
        }
        
        RestContext.response.addHeader(CChallenge_GeneralConstants.REQUEST_CONTENT_TYPE, CChallenge_GeneralConstants.REQUEST_CHARSET_APPLICATION);     
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty( wrapperResponseBody, true));
        
	}
	
	
	
	public static GetMatchResultsWrapper.ResponseMatchesWrapper getListMatchesResponse (GetMatchResultsWrapper.RequestBody bodyReq){
		System.debug('CChallenge_WSGetMatches: getListMatchesResponse: bodyRequest : ' + bodyReq);
		
		// Variables to retrieve JSON Response Structures
		GetMatchResultsWrapper.ResponseMatchesWrapper wrapperResult;
		List<GetMatchResultsWrapper.InfoMatch> wrapperMtchList = new List<GetMatchResultsWrapper.InfoMatch>();
		// Wrapper List variables to store the information into JSON
		List<GetMatchResultsWrapper.InfoPlayer> wrapperPlayerLst; 
		List<GetMatchResultsWrapper.InfoLineUps> wrapperlUpList;
		
		// Maps and Sets to store Salesforce Data
		Map<String, Match__c> mapMatchById = new Map<String, Match__c>(); 
		Map<String, Set<Team__c>> mapTeamByMatchId = new Map<String, Set<Team__c>>();
		Map<String, Set<Player__c>> mapPlayersByMatch = new Map<String, Set<Player__c>>();
		Set<Id> setIdMatches = new set<Id>();
		Set<Id> setIdTeams = new Set<Id>();
		
		// Obtain Matches in DB according to passed parameters
		mapMatchById = CChallenge_MatchGateway.getmapMatchBySubscriberInfo(bodyReq.email, bodyReq.IDNumber);
		System.debug('CChallenge_WSGetMatches: getListMatchesResponse: mapMatchById : ' + mapMatchById);
		
		if(mapMatchById != null){
			for(Id idKey : mapMatchById.keySet()){
				setIdMatches.add(idKey);	
			}
			
			System.debug('CChallenge_WSGetMatches: getListMatchesResponse: setIdMatches : ' + setIdMatches);
			// Obtain Teams based on related Matches found
			mapTeamByMatchId = CChallenge_TeamGateway.getTeamMapByMatchId(setIdMatches);

			if(mapTeamByMatchId != null){
				for(Set<Team__c> tm : mapTeamByMatchId.values()){
					for(Team__c t : tm){
						setIdTeams.add(t.Id);
					}	
				}
				System.debug('CChallenge_WSGetMatches: getListMatchesResponse: setIdTeams : ' + setIdTeams);
				// Map of players based on related teams found
				mapPlayersByMatch = CChallenge_PlayerGateway.getPlayersMapBySetMatchIds(setIdTeams);				
				System.debug('CChallenge_WSGetMatches: getListMatchesResponse: mapPlayersByMatch : ' + mapPlayersByMatch);

				// Loop for Matches
				for(Match__c mt : mapMatchById.values()){
					system.debug('Registro Partido :: ' + mt.Name);
					wrapperlUpList = new List<GetMatchResultsWrapper.InfoLineUps>();
					// Get Team List of the current Match record
					Set<Team__c> teams = mapTeamByMatchId.get(mt.Id);
					system.debug('Equipos pertenecientes al Partido :: ' + mt.Name + ' --> ' + teams);
					// Loop for Team list
					if(teams != null && teams.size() > 0){
						for(Team__c t : teams){
							wrapperPlayerLst = new List<GetMatchResultsWrapper.InfoPlayer>();
							system.debug('Registro de Equipo :: ' + t.Name );
							// Get Player List of the current Team Record
							if(t.Match__c == mt.Id){
								Set<Player__c> setPlayers = mapPlayersByMatch.get(t.Id);
								system.debug('Jugadores pertenecientes al Equipo :: ' + t.Name + ' --> ' + setPlayers);
								if(setPlayers != null && setPlayers.size()>0){
									// Loop for Players List
									for(Player__c ply : setPlayers){
										// Store Players information into Player Wrapper and add to the list
										if(ply.Team__r.Match__c == t.Match__c){
											system.debug('Registro de Jugador :: ' + ply.Name );
											GetMatchResultsWrapper.InfoPlayer plyr = new GetMatchResultsWrapper.InfoPlayer(ply);
											wrapperPlayerLst.add(plyr);
										}
										
									}
								}
							}
							
							// Prepare LineUp Wrapper
							GetMatchResultsWrapper.InfoLineUps lnUp = new GetMatchResultsWrapper.InfoLineUps(wrapperPlayerLst);
							// Add LinueUp Wrapper to the list
							wrapperlUpList.add(lnUp);
						}	
					}
					// Prepare Match Wrapper
					GetMatchResultsWrapper.InfoMatch inMatch = new GetMatchResultsWrapper.InfoMatch(mt, wrapperlUpList);
					// Add Match Wrapper to the list
					wrapperMtchList.add(inMatch);
					
				}
				
				// Prepare the Whole Wrapper structure
				if(wrapperMtchList != null){
					wrapperResult  = new GetMatchResultsWrapper.ResponseMatchesWrapper(wrapperMtchList, CChallenge_GeneralConstants.STATUSCODE_OK, CChallenge_GeneralConstants.MSG_RESULTS_FOUND);
				}
			} 
		}
		
		System.debug('CChallenge_WSGetMatches: getListMatchesResponse: wrapperResult : ' + wrapperResult);
		return wrapperResult;
	}
	
	
	
	/* Checks if request has no params */
	public static boolean hasEmptyParams(GetMatchResultsWrapper.RequestBody bodyRequest){
		boolean emptyParams = false;
		
		if(bodyRequest != null){
			if(String.isEmpty(bodyRequest.email) && String.isEmpty(bodyRequest.idNumber)){
				emptyParams = true;
			}
		}
		
		System.debug('CChallenge_WSGetMatches: hasEmptyParams? ' + emptyParams);
    	return emptyParams;
	}
	
	/* Checks if Subscriber ID number param has a valid format, only digits */
	public static boolean isValidIdNumber(String idNumber){
		boolean isValid = false;
		
		// TO-DEFINE : Features of a valid IDNumber --> Right now we validate that it does not contain letters
		if(String.isNotEmpty(idNumber) && idNumber.isNumeric()){
			isValid = true;
		}
		
		system.debug('CChallenge_WSGetMatches: isValidIdNumber? ' + isValid);
		return isValid;
	}
	
	/* Checks if email param has a valid format */
	public static boolean isValidEmail (String email){
		boolean isValid = false;
		
		if(String.isNotEmpty(email) && email.contains('@')){
			isValid = true;
		}
		
		System.debug('CChallenge_WSGetMatches: isValidEmail? ' + isValid);
		return isValid;
	}
    
    
}
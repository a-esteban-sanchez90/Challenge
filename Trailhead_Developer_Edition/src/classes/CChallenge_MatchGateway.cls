/*
*	class : CChallenge_MatchGateway
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: class that contains all methods in which Match sObject queries are made
*
*/

public class CChallenge_MatchGateway {
	
	public static Map<String, Match__c> getmapMatchBySubscriberInfo(String emailParam, String idNumParam){
		System.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: emailParam :: ' + emailParam);
		System.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: idNumParam :: ' + idNumParam);
		
		Map<String, Match__c> mapMatches = new Map<String, Match__c>();
		List<Match__c> matchList = new List<Match__c>();
		
		String strQuery = 'SELECT Id, Name, Comments__c, Phase__c, Scoring1__c, Scoring2__c, Tournament__c, Tournament__r.Name FROM Match__c WHERE';
		String strWhere = '';
		
		if(String.isNotEmpty(emailParam)){
			strWhere += ' Tournament__r.Subscriber__r.Email__c = \'' + emailParam + '\' OR';	
		}
		
		if(String.isNotEmpty(idNumParam)){
			strWhere += ' Tournament__r.Subscriber__r.SubscriberID__c = \'' + idNumParam + '\' OR';
		}
		
		if(strWhere.contains(' OR')){
			strWhere = strWhere.substring(0, strWhere.lastIndexOf(' OR'));
		}
		
		System.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: strWhere : ' + strWhere);
		
		if(String.isNotEmpty(strWhere) || strWhere != ''){
			strQuery += strWhere;
			system.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: stQuery final : ' + strQuery);
		} else {
			strQuery = strQuery.removeEnd('WHERE');
			system.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: stQuery final : ' + strQuery);
		}
		
		matchList = Database.query(strQuery);
		
		if(matchList != null && !matchList.isEmpty()){
			for(Match__c mtch : matchList){
				mapMatches.put(mtch.Id, mtch);
			}
		}
		
		System.debug('CChallenge_MatchGateway: getmapMatchBySubscriberInfo: mapMatches: ' + mapMatches);
		return mapMatches;
	}
    
}
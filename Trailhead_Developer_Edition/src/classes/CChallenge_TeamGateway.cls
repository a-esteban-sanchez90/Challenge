/*
*	class : CChallenge_TeamGateway
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: class that contains all methods in which Team sObject queries are made
*
*/

public class CChallenge_TeamGateway {
	
	public static Map<String, Set<Team__c>> getTeamMapByMatchId (Set<Id> setIdMatches){
		system.debug('CChallenge_TeamGateway: getTeamMapByMatchId : setIdMatches: ' + setIdMatches);
		
		Map<String, Set<Team__c>> teamMapByMatchKey = new Map<String, Set<Team__c>>();
		
		if(setIdmatches != null){
			List<Team__c> tmList = [SELECT Id, Name, Condition__c, Match__c, Match__r.Name FROM Team__c WHERE Match__c IN: setIdMatches];
			system.debug('CChallenge_TeamGateway: getTeamMapByMatchId : tmList: ' + tmList);
			if(tmList != null && !tmList.isEmpty()){
				for(Team__c tm : tmList){
					Set<Team__c> setTms = teamMapByMatchKey.get(tm.Match__c);
	                if(setTms != null && setTms.size()>0){
	                    setTms.add(tm);
	                    teamMapByMatchKey.put(tm.Match__c, setTms);
	                }else{
	                    setTms = new Set<Team__c>();
	                    setTms.add(tm);
	                    teamMapByMatchKey.put(tm.Match__c, setTms);
	                }
				}
			}
			
		}
		
		system.debug('CChallenge_TeamGateway: getTeamMapByMatchId : teamMapByMatchKey: ' + teamMapByMatchKey);
		return 	teamMapByMatchKey;
	}
    
}
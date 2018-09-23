/*
*	class : CChallenge_TeamGateway
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: class that contains all methods in which Player sObject queries are made
*
*/

public class CChallenge_PlayerGateway {
	
	public static Map<String, Set<Player__c>> getPlayersMapBySetMatchIds (Set<Id> setIdTeams){
		system.debug('CChallenge_PlayerGateway : getPlayersMapByTeamId: setIdTeams : ' + setIdTeams);
		
		Map<String, Set<Player__c>> playersMapByTeamId = new Map<String, Set<Player__c>>();
		Set<Player__c> lineUpList = new Set<Player__c>();
		if(setIdTeams != null){
			List<Player__c> playerList = [SELECT Id, Name, FirstName__c, Position__c, ID_Number__c, Team__c, Team__r.Name, Team__r.Match__c FROM Player__c WHERE Team__c IN: setIdTeams];
			System.debug('CChallenge_PlayerGateway: getPlayersMapBySetMatchIds: playerList: ' + playerList);
			for(Player__c ply : playerList){
				Set<Player__c> setPlayers = playersMapByTeamId.get(ply.Team__c);
                if(setPlayers != null && setPlayers.size()>0){
                    setPlayers.add(ply);
                    playersMapByTeamId.put(ply.Team__c, setPlayers);
                }else{
                    setPlayers = new Set<Player__c>();
                    setPlayers.add(ply);
                    playersMapByTeamId.put(ply.Team__c, setPlayers);
                }
			}
		}
		
		system.debug('CChallenge_PlayerGateway : getPlayersMapByTeamId: playersMapByTeamId: ' + playersMapByTeamId);
		return playersMapByTeamId;
	}   
}
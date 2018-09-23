/*
*	class : CChallenge_TestHelper
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: class that generates data to use in unit tests
*
*/

public class CChallenge_TestHelper {
    
    public static Subscriber__c createSubscriber(){
    	Subscriber__c subs = new Subscriber__c();
    	subs.Name = 'SubTestName';
    	subs.FirstName__c = 'FirstNameTest';
    	subs.Email__c = 'subscriber@test.com';
    	subs.SubscriberID__c = '123456';
    	
    	return subs;
    }
    
    public static Tournament__c createTournament(String idSubscriber){
    	Tournament__c t = new Tournament__c();
    	t.Name = 'TournamentTest';
    	t.Subscriber__c = idSubscriber;
    	
    	return t;
    }
    
    public static Match__c createMatch(String idTournament){
    	Match__c game = new Match__c();
    	game.Name = 'Team1-Team2';
    	game.Tournament__c = idTournament;
    	game.Phase__c = 'FN';
    	game.Scoring1__c = 1;
    	game.Scoring2__c = 2;
    	
    	return game;
    }
    
    public static Team__c createLocalTeam(String idMatch){
    	Team__c tm = new Team__c();
    	tm.Name = 'Local Team Test';
    	tm.Condition__c = 'L';
    	tm.Match__c = idMatch;
    	
    	return tm;
    }
    
    public static Team__c createVisitorTeam(String idMatch){
    	Team__c tm = new Team__c();
    	tm.Name = 'Visitor Team Test';
    	tm.Condition__c = 'V';
    	tm.Match__c = idMatch;
    	
    	return tm;
    }
    
    public static Player__c createLocalPlayer (String idTeam){
    	Player__c pl = new Player__c();
    	
    	pl.Name = 'Smith';
    	pl.FirstName__c = 'James';
    	pl.Sport_Name__c = 'FTB';
    	pl.Position__c = 'MF';
    	pl.ID_Number__c = 1;
    	pl.Team__c = idTeam;
    	
    	return pl;
    	
    }
    
    public static Player__c createVisitorPlayer (String idTeam){
    	Player__c pl = new Player__c();
    	
    	pl.Name = 'Williams';
    	pl.FirstName__c = 'Tom';
    	pl.Sport_Name__c = 'FTB';
    	pl.Position__c = 'DF';
    	pl.ID_Number__c = 5;
    	pl.Team__c = idTeam;
    	
    	return pl;
    	
    }
    
    
}
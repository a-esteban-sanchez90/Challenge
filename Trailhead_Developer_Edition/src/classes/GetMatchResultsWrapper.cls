/*
*	class : GetMatchResultsWrapper
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: wrapper class that webservice retrieves when subscriber ask for information about matches
*
*/

public class GetMatchResultsWrapper extends CChallenge_GlobalResults {
	
	public class RequestBody{
        
        public String IDnumber;
        public String email;
        
        public RequestBody(){}
        public RequestBody( Map< String, String > mapRequest ){
            this.email = String.isNotBlank( mapRequest.get( 'email' ) )        ? 	mapRequest.get( 'email' )     : '';
            this.IDnumber = String.isNotBlank( mapRequest.get( 'id' ) )  ? 	mapRequest.get( 'id' )  : '';
        }
    }
	
	public class InfoPlayer {
		// Variables
		public String lastName;
		public String firstName;
		public String idNumber;
		public String position;
		
		// Constructor
		public InfoPlayer (Player__c p){
			if(p != null){
				this.lastName = String.isNotEmpty(p.Name) ? p.Name : '';
				this.firstName = String.isNotEmpty(p.FirstName__c) ? p.FirstName__c : '';
				this.idNumber = p.ID_Number__c != null ? String.valueOf(p.ID_Number__c) : '';
				this.position = String.isNotEmpty(p.Position__c) ? p.Position__c : '';
			}
		}
	}
	
	public class InfoLineups {
		// Variables
		public List<InfoPlayer> players = new list<InfoPlayer>();
		
		// Constructor
		public InfoLineups (List<InfoPlayer> players){
			this.players = players;
		}
	} 
	
	public class InfoMatch {
		
		// Variables
		public String matchName;
		public String phase;
		public String score1;
		public String score2;
		public String comments;
		public List<InfoLineups> lineUps;
		public String tournament;
		
		
		// Constructor
		public InfoMatch (Match__c partido, List<InfoLineups> lineUps){
			
			if(partido != null){
				this.tournament = partido.Tournament__r.Name != null ? partido.Tournament__r.Name : '';
				this.matchName = String.isNotEmpty(partido.Name)	?	partido.Name : '';
				this.phase = String.isNotEmpty(partido.Phase__c) ? partido.Phase__c : '';
				this.score1 = partido.Scoring1__c != null ? String.valueOf(partido.Scoring1__c) : '';
				this.score2 = partido.Scoring2__c != null ? String.valueOf(partido.Scoring2__c) : '';
				this.comments = String.isNotEmpty(partido.Comments__c) ? partido.Comments__c : '';
			}

			this.lineUps = lineUps;
		}
	}
	
	public class ResponseMatchesWrapper extends CChallenge_GlobalResults{

        List<InfoMatch> responseBody;

        public ResponseMatchesWrapper(){}

        public ResponseMatchesWrapper( List<InfoMatch> respBody, String codeResult, String msgResult ){
            super( codeResult, msgResult );
            this.responseBody = respBody;
        }
           
    }  
}
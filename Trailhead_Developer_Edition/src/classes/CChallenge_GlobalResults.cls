/*
*	class : CChallenge_GlobalResults
*	author : Alejandro Esteban	
*	email :
*	fecha : 22/09/2018
*	description: wrapper class that show general status of the response (OK, KO, errorMessage...)
*
*/

global abstract class CChallenge_GlobalResults {
	
	webservice String codeResult;
    webservice String msgResult;
    
    global CChallenge_GlobalResults( String codeResult, String msgResult ){
    	
        this.codeResult  = codeResult != null ? codeResult : '';
        this.msgResult   = msgResult != null ? msgResult : '';
    }
    
    global CChallenge_GlobalResults(){
    	this.codeResult = '';
    	this.msgResult = '';
    }
    
}
Class REST.BatchWS Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url	= "/" Method="GET" Call="info" Cors="true"/>
<Route Url	= "/info" Method="GET" Call="info" Cors="true"/>
<Route Url	= "/EcritBatch/:pOrigine/:pRequete/:pParams" Method="GET" Call="EcritBatch" Cors="true"/>
<Route Url	= "/LitBatch/:pId" Method="GET" Call="LitBatch" Cors="true"/>
<Route Url	= "/LitBatchJSON/:pId" Method="GET" Call="LitBatchJSON" Cors="true"/>
<Route Url	= "/SupprimeBatch/:pId" Method="GET" Call="Supprime" Cors="true"/>
<Route Url	= "/LitTout" Method="GET" Call="GetAll" Cors="true"/>
<Route Url	= "/LitTousLesLogs" Method="GET" Call="GetAllLogs" Cors="true"/>
</Routes>
}

ClassMethod info() As %Status
{
	#; Renvoie les infos sur l'application Web et le serveur. 
    set sc						=$$$OK
    set %response.ContentType	="application/json"
    set json					={}
    set json.titre				="ADMIN SI"
    set json.system				=$system
    set json.IP					=##class(%Function).IPAddresses()
    set json.username			=$username
    set json.namespace			=$namespace
    set json.version			=$zv
    set json.date				=$zdt($h,3)
    set json.SessionId			=%session.SessionId
    set json.URL				=%request.URL
    write json.%ToJSON()
    return sc
}

ClassMethod EcritBatch(pOrigine As %String, pRequete As %String, pParametres As %String) As %Status
{
	#; Permet de stocker la requete REST dans la table de Batch.
    set sc					= $$$OK
    set UneReponse			= {}         	// Création de la structure de la réponse à renvoyée
    set UneReponse.IdCree	= 0
    set UneReponse.ERR		= {}     		// Création vide d'une erreur éventuelle à remonter
    set UneReponse.ERR.MSG	= "OK"
    set UneReponse.ERR.Code	= 0
    
	#;     
	#; Utilisation de la classe Objet ItemBatch
	
	set EnregBatch 				= ##class(User.ItemBatch).%New()
	set EnregBatch.Origine 		= pOrigine
	set EnregBatch.RequeteREST 	= pRequete					// requete REST séparés par "@BS@" et "@PI@"
	set EnregBatch.Parametres 	= pParametres 				// Parametres de la requete REST séparés par "@BS@" et "@PI@"
	set EnregBatch.DateHeure 	= $ZDATETIME($HOROLOG,3) 	// Date et heure complete.
	
	set StatusEnreg = EnregBatch.%Save()
	
	#; Traitement des erreurs au cas où
	If $$$ISERR(StatusEnreg) {
   		set UneReponse.ERR.MSG 	= $SYSTEM.Status.GetErrorText(StatusEnreg)  // renvoie une chaine contenant le texte de l'erreur.
   		set UneReponse.ERR.Code = $$$GETERRORCODE(StatusEnreg)
   		write UneReponse.%ToJSON()
   		Quit
 	}
 	
 	set UneReponse.IdCree 		= EnregBatch.%Id()	 
    write UneReponse.%ToJSON()
    return sc
}

ClassMethod LitBatch(pId As %Integer) As %Status
{
	#;    Permet de lire la requete REST stockée en Batch, dans le but de la 'rejouer'...
    set sc						= $$$OK
    set UneReponse				= {}         	// Création de la structure de la réponse à renvoyer
    set UneReponse.Id 			= 0
    set UneReponse.Origine 		= ""
    set UneReponse.RequeteREST 	= ""
	set UneReponse.Parametres 	= ""
	set UneReponse.DateHeure 	= ""
    set UneReponse.ERR			= {}     		// création vide d'une erreur éventuelle à remonter
    set UneReponse.ERR.MSG      = ""
    set UneReponse.ERR.Code     = 0
    
	#; Lecture de l'enregistrement    
	#; Utilisation de la classe Objet ItemBatch
	If pId '= 0 {
		If ##class(User.ItemBatch).%ExistsId(pId)=1 {
			set EnregBatch = ##class(User.ItemBatch).%OpenId(pId)
	
			set UneReponse.Id 			= EnregBatch.%Id()
			set UneReponse.Origine 		= EnregBatch.Origine
			set UneReponse.RequeteREST 	= EnregBatch.RequeteREST
			set UneReponse.Parametres 	= EnregBatch.Parametres
			set UneReponse.DateHeure 	= EnregBatch.DateHeure
		}
		Else {
			set UneReponse.ERR.MSG		= "La requete Batch N° "_pId_" n'existe pas."
    		set UneReponse.ERR.Code		= 1000		
		}
	}
			 
    write UneReponse.%ToJSON()
    return sc
}

ClassMethod SupprimeBatch(pId As %Integer) As %Status
{
	#; Permet de stocker la requete REST dans la table de Batch .
    set sc=$$$OK
    set UneReponse				= {}   	// Création de la structure de la réponse à renvoyée
    set UneReponse.IdSupprime	= 0
    set UneReponse.ERR			= {}     // Création vide d'une erreur éventuelle à remonter
    set UneReponse.ERR.MSG		= "OK"
    set UneReponse.ERR.Code		= 0
    
	#;     
	#; Utilisation de la classe Objet ItemBatch
	
	If ##class(User.ItemBatch).%ExistsId(pId) = 1 {
		
		#; Avant de supprimer, on archive la ligne dans le log de suivi.
		set EnregBatch = ##class(User.ItemBatch).%OpenId(pId)
		
		#; On stocke toutes les infos dans le log avant de supprimer la ligne.
		set EnregLog = ##class(User.LogBatch).%New()
		
		#; On remplit tous les membres de l objet Log.
		set EnregLog.RequeteREST 		= EnregBatch.RequeteREST
		set EnregLog.Origine 			= EnregBatch.Origine
		set EnregLog.Parametres 		= EnregBatch.Parametres
		set EnregLog.DateHeure 			= EnregBatch.DateHeure
		set EnregLog.ExecutionReussie 	= 1
		set EnregLog.Synchro 			= 1
		
		set StatusEnreg = EnregLog.%Save()
	
		#; Traitement des erreurs au cas où...
		If $$$ISERR(StatusEnreg) {
	   		set UneReponse.ERR.MSG 	= $SYSTEM.Status.GetErrorText(StatusEnreg)  // renvoie une chaine contenant le texte de l'erreur.
	   		set UneReponse.ERR.Code = $$$GETERRORCODE(StatusEnreg)
	   		write UneReponse.%ToJSON()
	   		Quit
	 	}
 	
		// On supprime la ligne des requêtes en attente.
		set StatusEnreg = ##class(User.ItemBatch).%DeleteId(pId)
	
		// Traitement des erreurs au cas où...
		If $$$ISERR(StatusEnreg) {
   			set UneReponse.ERR.MSG 	= $SYSTEM.Status.GetErrorText(StatusEnreg)  // renvoie une chaine contenant le texte de l'erreur.
   			set UneReponse.ERR.Code = $$$GETERRORCODE(StatusEnreg)
   			write UneReponse.%ToJSON()
   			Quit
 		}
 		set UneReponse.IdSupprime 	= pId	 
	}
	else {
		/*Traitement d'erreur : pas de requête correspondante*/
		set UneReponse.ERR.MSG		= "La requete Batch N° "_pId_" n'existe pas."
    	set UneReponse.ERR.Code		= 1000
	}
 	
    write UneReponse.%ToJSON()
    return sc
}

ClassMethod GetAll() As %Status
{
  Set EnregBatch = [] 														// on prépare un recordset à vide
  Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM ItemBatch") 	// On créé un 'pointeur' sur une requete sql pour permettre le parcours
  While rs.%Next() {
    Do EnregBatch.%Push({
	  	"ID":    		(rs.%Get("ID")),
	  	"DateHeure":  	(rs.%Get("DateHeure")),  							// Chargement des membres SQL dans le RecordSet
      	"RequeteREST":  (rs.%Get("RequeteREST")),
      	"Origine":    	(rs.%Get("Origine")),
      	"parametres": 	(rs.%Get("Parametres"))
    })
  }
  
  Write EnregBatch.%ToJSON()												// Conversion vers JSON pour la sortie.
  Quit $$$OK
}

ClassMethod GetAllLogs() As %Status
{
  Set EnregLogs = []														// On prépare un RecordSet
  Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM LogBatch")	// On créé un pointeur sur une requête SQL permettant le parcours
  While rs.%Next() {
    Do EnregLogs.%Push({													// Chargement des membres voulus dans le RecordSet
	  	"ID":    		(rs.%Get("ID")),
		"DateHeure":  	(rs.%Get("DateHeure")),  
      	"RequeteREST": 	(rs.%Get("RequeteREST")),
      	"Origine":    	(rs.%Get("Origine")),
      	"parametres": 	(rs.%Get("Parametres")),
		"Dh Synchro":  	(rs.%Get("DateHeureSynchro")),   
	  	"Synchro": 		(rs.%Get("Synchro"))
    })
  }
  Write EnregLogs.%ToJSON()
  Quit $$$OK
}

ClassMethod GetAllIDs() As %Status
{
  Set EnregBatch = [] 														// on prépare un recordset à vide
  Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM ItemBatch") 	// On créé un 'pointeur' sur une requete sql pour permettre le parcours
  While rs.%Next() {
    Do EnregBatch.%Push({
	  	"ID":    		(rs.%Get("ID"))
    })
  }
  
  Write EnregBatch.%ToJSON()												// Conversion vers JSON pour la sortie.
  Quit $$$OK
}

}

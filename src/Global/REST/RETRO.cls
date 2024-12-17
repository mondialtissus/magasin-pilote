Class Global.REST.RETRO Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

Parameter versionDev = 1.0;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="info" Cors="true"/>
<Route Url="/generate/mod/livraison" Method="GET" Call="generateModRetroLivraisonBetweenDates" Cors="true"/>
<Route Url="/generate/mod/commande" Method="GET" Call="generateModRetroCommandeBetweenDates" Cors="true"/>
<Route Url="/ListeRetroDate/:pdate" Method="GET" Call="ListeRetroDate" Cors="true"/>
<Route Url="/GetRetroCommande" Method="GET" Call="GetRetroCommande" Cors="true"/>
</Routes>
}

ClassMethod info() As %Status
{
	Set sc=$$$OK
	Set %response.ContentType="application/json"
	Set json={}
	Set json.titre="GENERAL"
	Set json.system=$SYSTEM
	Set json.IP=##class(%Function).IPAddresses()
	
	Set json.username=$USERNAME
	Set json.namespace=$NAMESPACE
	Set json.version=$ZVERSION
	Set json.date=$ZDATETIME($HOROLOG,3)
	Set json.SessionId=%session.SessionId
	Set json.URL=%request.URL
	Set json.versionDev = ..#versionDev
	Write json.%ToJSON()
	Return sc
}

/// Description
Query ModRetroLivraisonBetweenDates(pDateDe As %String, pDateA As %String) As %SQLQuery [ SqlProc ]
{
	SELECT 
	ID
	FROM Global_Vue_RETRO_CMD.EnTete
	WHERE ASLIV = 1
	AND DATESYS BETWEEN :pDateDe AND :pDateA
}

/// Demande de generation de mod retro livraison entre deux dates
/// 
ClassMethod generateModRetroLivraisonBetweenDates() As %Status
{
	
	Set sc=$$$OK
	
	Set datedebut = $Get(%request.Data("datedebut",1))
	Set datefin = $Get(%request.Data("datefin",1))

	if datedebut="" {
		Set %response.Status = ..#HTTP406NOTACCEPTABLE
		Set %Response.ContentType = "text/plain"
		Write "datedebut is required",!
		return $$$OK
	}

	if datefin="" {
		Set %response.Status = ..#HTTP406NOTACCEPTABLE
		Set %Response.ContentType = "text/plain"
		Write "datefin is required",!
		return $$$OK 
	}

	Set datedebut = $ZDH(datedebut,3)
	Set datefin = $ZDH(datefin,3)

	Set stmt = ##class(%SQL.Statement).%New()
	Set sc = stmt.%PrepareClassQuery("Global.REST.RETRO", "ModRetroLivraisonBetweenDates")
	If $$$ISERR(sc) {
		Quit sc
	}
	Set rset = stmt.%Execute(datedebut, datefin)
	Set arrayID = []
	While rset.%Next() {
		Set ID =  rset.%Get("ID")
		do arrayID.%Push(ID)

		set service = ##class(Global.Services.RETRO.CMD).%New()
		Set retro = ##class(Global.Factories.RETRO.CMD).OpenRetro(ID)
		d service.GenerateModLiv(retro)  
	}
	set tmpArray = ##class(%Stream.GlobalCharacter).%New() 
	Set %response.ContentType="application/json"
	do arrayID.%ToJSON(tmpArray)
	While 'tmpArray.AtEnd {w tmpArray.Read($$$MaxStringLength)}

	Return sc
}

/// Description
Query ModRetroCommandeBetweenDates(pDateDe As %String, pDateA As %String) As %SQLQuery [ SqlProc ]
{
	SELECT 
	ID
	FROM Global_Vue_RETRO_CMD.EnTete
	WHERE ASLIV = 0
	AND DATESYS BETWEEN :pDateDe AND :pDateA
}

/// Description
ClassMethod generateModRetroCommandeBetweenDates() As %Status
{
	Set sc=$$$OK
	
	Set datedebut = $Get(%request.Data("datedebut",1))
	Set datefin = $Get(%request.Data("datefin",1))

	if datedebut="" {
		Set %response.Status = ..#HTTP406NOTACCEPTABLE
		Set %Response.ContentType = "text/plain"
		Write "datedebut is required",!
		return $$$OK
	}

	if datefin="" {
		Set %response.Status = ..#HTTP406NOTACCEPTABLE
		Set %Response.ContentType = "text/plain"
		Write "datefin is required",!
		return $$$OK 
	}

	Set datedebut = $ZDH(datedebut,3)
	Set datefin = $ZDH(datefin,3)

	Set stmt = ##class(%SQL.Statement).%New()
	Set sc = stmt.%PrepareClassQuery("Global.REST.RETRO", "ModRetroCommandeBetweenDates")
	If $$$ISERR(sc) {
		Quit sc
	}
	Set rset = stmt.%Execute(datedebut, datefin)
	Set arrayID = []
	While rset.%Next() {
		Set ID =  rset.%Get("ID")
		do arrayID.%Push(ID)

		set service = ##class(Global.Services.RETRO.CMD).%New()
		Set retro = ##class(Global.Factories.RETRO.CMD).OpenRetro(ID)
		d service.GenerateModCmd(retro)  	
	}
	Set %response.ContentType="application/json"
	set tmpArray = ##class(%Stream.GlobalCharacter).%New()
	do arrayID.%ToJSON(tmpArray)
	While 'tmpArray.AtEnd {w tmpArray.Read($$$MaxStringLength)}
	Return sc
}

/// Description
Query ListeRetroDate(pdate) As %SQLQuery [ SqlProc ]
{
	SELECT 
	ID
	FROM Global_Vue_RETRO_CMD.EnTete
	WHERE DATESYS = :pdate
}

/// Description
ClassMethod ListeRetroDate(pdate = {$Zd(+$H,3)}) As %Status
{
	Set sc = $$$OK

	Set stmt = ##class(%SQL.Statement).%New()

	Set sc = stmt.%PrepareClassQuery("Global.REST.RETRO", "ListeRetroDate")
	If $$$ISERR(sc) {
		Quit sc
	}

	set pdate = $zdh(pdate, 3)
	Set rset = stmt.%Execute(pdate)
	Set arrayID = []
	While rset.%Next() {
		Set ID =  rset.%Get("ID")
		set retro =##class(Global.Factories.RETRO.CMD).OpenRetro(ID)
		do retro.%JSONExportToString(.json)
		do arrayID.%Push(json)
	}
	set tmpArray = ##class(%Stream.GlobalCharacter).%New()
	Set %response.ContentType="application/json"
	do arrayID.%ToJSON(tmpArray)
	While 'tmpArray.AtEnd {w tmpArray.Read($$$MaxStringLength)}

	// do something
	Return sc
}
Query GetRetroCommande(pRetro) As %Status
() As %SQLQuery [ SqlProc ]
{
	SELECT 
	ID
	FROM Global_Vue_RETRO_CMD.EnTete
	WHERE NUMRETRO=:pRetro
}

/// Description
/// Description
ClassMethod GetRetroCommande() As %Status
{
	Set sc = $$$OK
	Set stmt = ##class(%SQL.Statement).%New()
	Set retro = $Get(%request.Data("id",1))
	Set sc = stmt.%PrepareClassQuery("Global.REST.RETRO", "GetRetroCommande")
	If $$$ISERR(sc) {
		Quit sc
	}
	Set rset = stmt.%Execute(retro)
	do rset.%Next()
	Set ID =  rset.%Get("ID")
	set retro =##class(Global.Factories.RETRO.CMD).OpenRetro(ID)
	do retro.%JSONExportToString(.json)
	Set %response.ContentType="application/json"
	Write json
	// do something
	Return sc
}

}

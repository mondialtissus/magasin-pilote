Class REST.Retro Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url	= "/" Method="GET" Call="info" Cors="true"/>
    <Route Url	= "/info" Method="GET" Call="info" Cors="true"/>
    <Route Url	= "/CorrectionSBM" Method="GET" Call="CorrectionSBM" Cors="true"/>
    <Route Url="/generate/mod/livraison" Method="GET" Call="generateModRetroLivraisonBetweenDates" Cors="true"/>
    <Route Url="/generate/mod/commande" Method="GET" Call="generateModRetroCommandeBetweenDates" Cors="true"/>
    </Routes>
}

ClassMethod info() As %Status
{
    #; Renvoie les infos sur l'application Web et le serveur. 
    set sc						=$$$OK
    set %response.ContentType	="application/json"
    set json					={}
    set json.titre				="RETRO"
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

ClassMethod CorrectionSBM() As %Status
{
    Set sc=$$$OK
    //appel de la fonction de correction des retro SBM
    s sRetro = $$RetroConfectionCorriger^RETROSBM
    //correction effectuée ? 
    s nReturn = $CASE(sRetro,"":"0",:"1")
    //creation d'une structure de retour
    s strRetour = {}
    //generation de la structure de retour
    s strRetour.Retour = nReturn
    s strRetour.Message = $CASE(nReturn,"0":"Pas de retro SBM en doublon","1":sRetro,:"Inconnu:"_nReturn)
    //Conversion en JSON
    w strRetour.%ToJSON()
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

}

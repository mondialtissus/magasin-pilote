Class REST.Retro Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url	= "/" Method="GET" Call="info" Cors="true"/>
    <Route Url	= "/info" Method="GET" Call="info" Cors="true"/>
    <Route Url	= "/CorrectionSBM" Method="GET" Call="CorrectionSBM" Cors="true"/>
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

}

Class REST.StockEtMouvements Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="info" Cors="true"/>
<Route Url="/info" Method="GET" Call="info" Cors="true"/>
<Route Url="/TestWS" Method="GET" Call="info" Cors="true"/>
<Route Url="/SynchroniserMouvements/:pDateDebut/:pDateFin/:pNbMouvements" Method="GET" Call="SynchroniserMouvementsManquantsParSemaine" Cors="true"/>
</Routes>
}

ClassMethod info() As %Status
{
    set sc=$$$OK
	set %response.ContentType="application/json"
	set json={}
	set json.system=$system
	set json.IP=##class(%Function).IPAddresses()
	set json.TEST=##class(%SYSTEM.INetInfo).GetInterfacesInfo()
	;set json.roles=$roles
	set json.username=$username
	set json.namespace=$namespace
	set json.version=$zv
	set json.date=$zdt($h,3)
	set json.SessionId=%session.SessionId
	set json.URL=%request.URL
	write json.%ToJSON()
	return sc
}

ClassMethod SynchroniserMouvementsManquantsParSemaine(pDateDebut As %Date, pDateFin As %Date, pNbMouvements As %Integer) As %Status
{
    // initialisation des variables
    s sc                = $$$OK
	s Ret               = {}
	s Ret.Synchro       = 0
    s Ret.NbMouvements  = 0

    // On récupère le nombre de mouvements pour la semaine courante
    s sql               = "SELECT count(*) AS NB FROM map.MAGGUMVT WHERE DATEMVT BETWEEN " _ pDateDebut _ " AND " _ pDateFin
    s statement         = ##class(%SQL.Statement).%New()
    s status            = statement.%Prepare(sql)
    s result            = statement.%Execute()
    i result.%Next() {
        s nbMouvements  = result.%Get("NB")
        
        // Si le nombre de mouvements est différent de celui envoyé depuis le siège
        i nbMouvements '= pNbMouvements {
            // On provoque le renvoi au siège des mouvements de la semaine courante
            f i = pDateDebut:1:pDateFin {
                merge ^MODGUMVT(##class(%Function).HostName(), i) = ^GUMVT(i)
            }
        }
        
        // Valeurs à renvoyer
        s Ret.Synchro       = 1
        s Ret.NbMouvements  = nbMouvements
	}
        
    write Ret.%ToJSON()
	return sc
}

}

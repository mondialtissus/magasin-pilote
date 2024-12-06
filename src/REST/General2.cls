Class REST.General2 Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="info" Cors="true"/>
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
	Write json.%ToJSON()
	Return sc
}

}

Class REST.Admin Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/info" Method="GET" Call="info" Cors="true"/>
<Route Url="/updateClass/:pClass" Method="POST" Call="updateClass" Cors="true"/>
<Route Url="/copyFile/:pFile/:pTargetDir/:pForceCreateDir" Method="POST" Call="copyFile" Cors="true"/>
<Route Url="/createWebApp/:pPackage/:pAppName/:pDescription/:pPath/:pNameSpace/:pDispatchClass" Method="GET" Call="createWebApp" Cors="true"/>
<Route Url="/executeIRISCommand/::pCommand" Method="GET" Call="executeIRISCommand" Cors="true"/>
<Route Url="/CopyImageJPG/:pFile/:pTargetDir" Method="POST" Call="CopyImageJPG" Cors="true"/>
<Route Url="/shell" Method="POST" Call="shell" Cors="true"/>
</Routes>
}

ClassMethod info() As %Status
{
	s sc=$$$OK
	s %response.ContentType="application/json"
	s json={}
	s json.titre="ADMIN SI"
	s json.system=$system
	s json.IP=##class(%Function).IPAddresses()
	s json.username=$username
	s json.namespace=$namespace
	s json.version=$zv
	s json.date=$zdt($h,3)
	s json.SessionId=%session.SessionId
	s json.URL=%request.URL
	write json.%ToJSON()
	return sc
}

ClassMethod updateClass(pClass As %String) As %Status
{
	s sc=$$$OK
	
	s fDirXml = "C:\pos\Xml\"
	I '##class(%Library.File).DirectoryExists(fDirXml) d ##class(%Library.File).CreateDirectory(fDirXml)
	
	s sResult = {}
	s sResult.CodeMag=$G(^|"USER"|HWINFO("MAG"))
	s sResult.Update=0
	
	s file=##class(%Library.File).%New(fDirXml_pClass_".xml")
	d file.Open("WSN")
	While '%request.Content.AtEnd {
	     d file.Write(%request.Content.Read($$$MaxStringLength))
	}
	d file.Close()	
	
	s sResult.Update = +$SYSTEM.OBJ.Load(fDirXml_pClass_".xml","c-d")
	I sResult.Update=0
	{
		s sResult.ERR=sResult.CodeMag_" : Erreur d'enregistrement du Xml (Taille = "_$L(BinaryText)_")"
	}
	
	w sResult.%ToJSON()
	return sc
}

ClassMethod createWebApp(pPackage As %String, pAppName As %String, pDescription As %String, pPath As %String, pNameSpace As %String, pDispatchClass As %String) As %Status
{
	// Paramètres (exemple)
	;pPackage = "REST"
	;pAppName = "Admin" => pour former WebAppName="/"_pPackage_"/"_pAppName
	;pDescription = "WebService_REST_Admin_SI" --puis on remet les _ en espace (attention pas d'accent sinon plantage WebService)
	;pPath = "C:\gsiphotos" --renseigné que si non vide sinon mettre null
	;pNameSpace = "USER"
	;pDispatchClass = "REST.Admin" --A intégrer que si pPAth est vide
	
	S WebAppName="/"_pPackage_"/"_pAppName
	
	s sc=$$$OK
	
	s sResult={}
	s sResult.CodeMag=$G(^|"USER"|HWINFO("MAG"))
	s sResult.Update=0
	s sResult.ERR=""

	ZN "%SYS"
	s tSC = ##class(Security.Applications).Delete(WebAppName)
	s props("Name") = WebAppName
	s props("NameSpace") = pNameSpace
	s props("Description") = $Replace(pDescription,"_"," ")
	I pPath="null"
	{
		s props("DispatchClass") = pDispatchClass
		s props("CookiePath") = WebAppName_"/"
	}
	else
	{
		s props("Path") = $Replace(pPath,"|","\")
	}
	s props("AutheEnabled") = 64
	s props("Timeout") = 1
	s sResult.Update = +##class(Security.Applications).Create(WebAppName, .props)
	
	w sResult.%ToJSON()
	return sc
}

ClassMethod copyFile(pFile As %String, pTargetDir As %String, pForceCreateDir As %Boolean) As %Status
{
	s sc=$$$OK

	s sResult = {}
	s sResult.CodeMag=$G(^|"USER"|HWINFO("MAG"))
	s sResult.Update=0
	s sResult.ERR=""
	
	s sTargetDir=$Replace(pTargetDir,"|","\") // Surcharge pour ne pas paseer les \ dans les paramètres
	s sFile=$Replace(pFile,"_"," ") // Surcharge pour ne pas paseer les espaces dans les paramètres
	
	s bCreateOK=1
	I '##class(%Library.File).DirectoryExists(sTargetDir)
	{
		I +pForceCreateDir=1 {d ##class(%Library.File).CreateDirectory(sTargetDir)} else {s bCreateOK=0}
		I '##class(%Library.File).DirectoryExists(sTargetDir) s bCreate=0
		
		I bCreateOK=0 s sResult.ERR="Répertoire non trouvé ou non créé : "_sTargetDir
	}
	
	I bCreateOK=1
	{
		s file=##class(%Library.File).%New(sTargetDir_"\"_sFile)
		d file.Open("WSN")
		While '%request.Content.AtEnd {
		     d file.Write(%request.Content.Read($$$MaxStringLength))
		}
		d file.Close()	
		
		I '##class(%Library.File).Exists(sTargetDir_"\"_sFile)
		{
			s sResult.ERR="fichier non créé : "_sTargetDir_"\"_sFile
		}
		else
		{
			s fSize=file.SizeGet()
			I fSize<0 {s sResult.ERR="fichier vide : "_sTargetDir_"\"_sFile}
			else {s sResult.Update=1}
		}
	}
	
	w sResult.%ToJSON()
	return sc
}

ClassMethod executeIRISCommand(pCommand As %String) As %Status
{
	s sc=$$$OK
	
	s sResult = {}
	s sResult.CodeMag=$G(^|"USER"|HWINFO("MAG"))
	s sResult.Update=0
	s sResult.ERR=""
	
	s jCommand={}.%FromJSON(pCommand)
	
	I jCommand.Namespace'=""
	{
		s sResult.Update=$namespace = jCommand.Namespace
		I sResult.Update=0
		{
			s sResult.ERR=sResult.CodeMag_" : Erreur de changement de namespace : "_jCommand.Namespace
		}
	}
	
	I jCommand.Command'=""
	{
		s sResult.Update=jCommand.Command
	}
	
	w sResult.%ToJSON()
	return sc
}

ClassMethod CopyImageJPG(pNomFichierIMG As %String, pTargetDir As %String) As %Status
{
	// init
	s sc=$$$OK
	s Reponse={} // Création de la structure de la réponse à renvoyer
	s Reponse.ERR={} // création vide d'une erreur éventuelle à remonter
	s Reponse.ERR.MSG=""
	s Reponse.ERR.Code=0
	s Reponse.REP="OK"
	
	s sTargetDir=$Replace(pTargetDir,"|","\") // Surcharge pour ne pas passer les \ dans les paramètres
	s sNomFichierIMG=$Replace(pNomFichierIMG,"|"," ") // Surcharge pour ne pas passer les espaces dans les paramètres
	
	I '##class(%Library.File).DirectoryExists(sTargetDir)
	{
		s Reponse.ERR.Code=108
		s Reponse.ERR.MSG="Le répertoire n'existe plus !"
		s Reponse.REP="ERREUR"
		w Reponse.%ToJSON()
		return sc
	}
	
	s file=##class(%Library.File).%New(sTargetDir_"\"_sNomFichierIMG)
	d file.Open("WSN")
	While '%request.Content.AtEnd {
	     d file.Write(%request.Content.Read($$$MaxStringLength))
	}
	d file.Close()	
		
	I '##class(%Library.File).Exists(sTargetDir_"\"_sNomFichierIMG)
	{
		s Reponse.ERR.Code=108
		s Reponse.ERR.MSG="fichier image non créé !"
		s Reponse.REP="ERREUR"
		w Reponse.%ToJSON()
		return sc
	}
	else
	{
		s fSize=file.SizeGet()
		I fSize<0 
			{
				s Reponse.ERR.Code=109
				s Reponse.ERR.MSG="Le fichier a été crée vide !"
				s Reponse.REP="ERREUR"
			}
	}
	
	w Reponse.%ToJSON()
	return sc
}

ClassMethod shell() As %Status
{
	set sc = $$$OK
	Set cmd 		= $GET(%request.Data("cmd",1),"set")
	Set subscript 	= $GET(%request.Data("subscript",1))
	Set data 		= $GET(%request.Data("data",1))

	if cmd="set" {
		set @subscript = data
		zw @subscript
		return sc
	} 
	return sc
}

}

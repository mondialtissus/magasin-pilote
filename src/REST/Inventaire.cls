Class REST.Inventaire Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="info" Cors="true"/>
<Route Url="/info" Method="GET" Call="info" Cors="true"/>
<Route Url="/TestWS" Method="GET" Call="info" Cors="true"/>
<Route Url="/RecupereInfoFTP" Method="GET" Call="RecupereInfoFTP" Cors="true"/>
<Route Url="/ChargeSam/:pNomSam" Method="GET" Call="ChargeSam" Cors="true"/>
<Route Url="/ControleUtilisateur/:pCB/:pNom/:pMDP" Method="GET" Call="ControleUtilisateur" Cors="true"/>
<Route Url="/AjoutLogISS/:pLog/:pSam/:pUser" Method="GET" Call="AjoutLogISS" Cors="true"/>
<Route Url="/SetInfoSTP" Method="GET" Call="SetInfoSTP" Cors="true"/>
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

ClassMethod RecupereInfoFTP() As %Status
{
    set sc=$$$OK
	set Retour = {}

    set HWINFO = "^[""USER""]HWINFO"

    s Retour.IP = $g(@HWINFO@("FTP_ISS_DFLTSERVER"))
    s Retour.Login = $g(@HWINFO@("FTP_ISS_DFLTLOGIN"))
    s Retour.MDP = $g(@HWINFO@("FTP_ISS_DFLTPASSWORD"))
	s Retour.Port = $g(@HWINFO@("FTP_ISS_PORT"))
	s Retour.EmplacementInventaireSam = $g(@HWINFO@("FTP_ISS_EmplacementInventaireSam"))
	s Retour.EmplacementInventaireSamPC = $g(@HWINFO@("FTP_ISS_EmplacementInventaireSamPC"))
    s Retour.Status = "OK"

    i (Retour.IP = "") || (Retour.Login = "") || (Retour.MDP = "")
    {
        s Retour.Status = "KO"
        s:(Retour.IP = "") Retour.Msg = "IP Manquant,"
        s:(Retour.Login = "") Retour.Msg = Retour.Msg_"Login Manquant,"
        s:(Retour.MDP = "") Retour.Msg = Retour.Msg_"MDP Manquant,"
		s:(Retour.Port = "") Retour.Msg = Retour.Msg_"Port Manquant,"
		s:(Retour.EmplacementInventaireSam = "") Retour.Msg = Retour.Msg_"Emplacement inventaire sam Manquant,"
		s:(Retour.EmplacementInventaireSamPC = "") Retour.Msg = Retour.Msg_"Emplacement inventaire PC Manquant"

    }

	write Retour.%ToJSON()
	return sc
}

ClassMethod ChargeSam(pNomSam As %String) As %Status
{
	set sc = $$$OK

	s HWINFO = "^[""USER""]HWINFO"
	s SCANNERLISTE = "^[""USER""]SCANNERLISTE"

	s LastDataCharged = ""
	s InfoSam = ""
	s LastDecharge = ""
	s LastClot = ""
	s Data = ""

	IF pNomSam '= ""
	{
		i $d(@HWINFO@("TERMINAL",pNomSam)) > 0
		{
			s LastDataCharged= $o(@HWINFO@("TERMINAL",pNomSam,""),-1) 
			s:($d(@HWINFO@("TERMINAL",pNomSam,LastDataCharged))=1) InfoSam = $g(@HWINFO@("TERMINAL",pNomSam,LastDataCharged))
			s LastDecharge = $p(InfoSam,"\",2)
			s LastClot = $e(InfoSam,"\",3)
			IF (LastDataCharged = "") || (LastDecharge '= "")
			{
				IF (LastDecharge '= "") || (LastClot '= "")
				{
					s $p(Data,"\",1) = $p(InfoSam,"\",1)
					s $p(Data,"\",2) = $zd(+$h,8)_$replace($ztime($p($h,",",2)),":","")_"00"
				}else{
					s $p(Data,"\",1) = $zd(+$h,8)_$replace($ztime($p($h,",",2)),":","")_"00"
				}			
				s @HWINFO@("TERMINAL",pNomSam,+LastDataCharged+1) = Data
				s @HWINFO@("INVENTAIRE",$g(@HWINFO@("INVENTAIRE","DATE")),"TERMINAL",pNomSam) = +LastDataCharged+1
			}else{
				s @HWINFO@("TERMINAL",pNomSam,+LastDataCharged+1) = $zd(+$h,8)_$replace($ztime($p($h,",",2)),":","")_"00"
				s @HWINFO@("INVENTAIRE",$g(@HWINFO@("INVENTAIRE","DATE")),"TERMINAL",pNomSam) = +LastDataCharged+1
			}
		}else{
			s @HWINFO@("TERMINAL",pNomSam,+LastDataCharged+1) = $zd(+$h,8)_$replace($ztime($p($h,",",2)),":","")_"00"
			s @HWINFO@("INVENTAIRE",$g(@HWINFO@("INVENTAIRE","DATE")),"TERMINAL",pNomSam) = +LastDataCharged+1
		}
		s LastLine = $o(@SCANNERLISTE@("CHARGE",pNomSam,99999),-1)
		IF LastLine '= "" 
		{
				//Pour un déchargement nous devons mettre à jour la dernière ligne de scanner (celle-ci devrait exister)		
				s DataSam = $zdh(+$h,8)_$replace($ztime($p($h,",",2)),":","")_00_"\\\"
				s LastLine = +LastLine+1
				s @SCANNERLISTE@("CHARGE",pNomSam,LastLine) = DataSam
		}	
		ELSE
		{
			//Pour un déchargement nous devons mettre à jour la dernière ligne de scanner (celle-ci devrait exister)
			s LastLine = 1
			s DataSam = $zdh(+$h,8)_$replace($ztime($p($h,",",2)),":","")_00_"\\\"
			s @SCANNERLISTE@("CHARGE",pNomSam,LastLine) = DataSam
		}
	}

	return sc
}

ClassMethod ControleUtilisateur(pCB As %String, pNom As %String, pMDP As %String) As %Status
{
	set sc = $$$OK
	s SIB = "^[""USER""]SIB"
	s Ret = {}
	s OK = 0
	if (pCB '= "") && (pCB '= "<Null>")
	{
		s User = $o(@SIB@("USER",""))
		while User '= ""
		{
			i OK = 0
			{
				
					s Data = $g(@SIB@("USER",User))
					s CB = $p(Data,"\",8)
					s MDP = $p(Data,"\",4)
					i CB = pCB
					{
						s OK = 1
						s Ret.CB = CB
						s Ret.NOM = User
						s Ret.MDP = MDP
						s Ret.ERREUR = ""
					}
			}			
			s User = $o(@SIB@("USER",User))
		}
		s:(OK=0) Ret.ERREUR = "CB inexistant"
	}else{
		if (pNom '= "<Null>") && (pMDP '= "<Null>")
		{
			s User = $o(@SIB@("USER",""))
			while User '= ""
			{
				i OK = 0
				{
					i User = pNom
					{
						s Data = $g(@SIB@("USER",User))
						s OK = 0.5
						s CB = $p(Data,"\",8)
						s User = User		//je sais que c'est con mais c'est plus joli
						s MDP = $p(Data,"\",4)
						if MDP = pMDP
						{
							s OK = 1
							s Ret.CB = CB
							s Ret.NOM = User
							s Ret.MDP = MDP
							s Ret.ERREUR = ""
						}else{
							s Ret.ERREUR = "Nom et MDP incorrects"
						}					
					}
				}
				
				s User = $o(@SIB@("USER",User))
			}
			s:(OK=0) Ret.ERREUR = "Nom et MDP inexistants"
		}else{
			s Ret.ERREUR = "Parametres manquants : CB ("_pCB_" / "_((pCB'="")&&(pCB'="<Null>"))_"),ID ("_pNom_"/"_(pNom'="<Null>")_"),MDP ("_pMDP_"/"_(pMDP'="<Null>")_")"
		}
	}
	write Ret.%ToJSON()
	return sc
}

ClassMethod AjoutLogISS(pSam As %String, pUser As %String)
{
	set sc = $$$OK
	s LOGISS = "^[""USER""]LOGISS"
	s Date = +$h
	s Heure = $p($h,",",2)
	S bufferEntrant = %request.Content
	S LogISS = {}.%FromJSON(bufferEntrant)
	s Titre = LogISS.sTitre
	s Details = LogISS.sDetails
	s @LOGISS@(Date,Heure,pUser,pSam) = Titre_"/"_Details
	return sc
}

ClassMethod SetInfoSTP()
{
	set sc = $$$OK
    s HWINF = "^[""USER""]HWINFO"
    s HWPOS = "^[""USER""]HWPOS"
    s @HWINF@("FTP_ISS_DFLTLOGIN") = "sam"
    s CODEMAG = $G(@HWINF@("MAG"))
    s IP = $P($G(@HWPOS@(CODEMAG,13)),"\",11)
	s taille = $l(IP)
	s IP = $e(IP,0,taille-1)_250
    s @HWINF@("FTP_ISS_DFLTPASSWORD") = "Adm"_CODEMAG_"*!"
    s @HWINF@("FTP_ISS_DFLTSERVER") = IP
    s @HWINF@("FTP_ISS_EmplacementInventaireSam") = ""
    s @HWINF@("FTP_ISS_EmplacementInventaireSamPC") = "C:\Terminal\Sam\"
    s @HWINF@("FTP_ISS_PORT") = 21
    s @HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIRETOURNANT") = "C:\Terminal\SAM\ARCHIVES\INVENTAIRE TOURNANT\"
    s @HWINF@("SAM","REPERTOIREPC","REPERTOIRETMP") = "C:\Terminal\SAM\Dechargement"
	return sc
}

// FinWS

}

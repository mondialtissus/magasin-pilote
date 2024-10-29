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
<Route Url="/GETDATEINVPERIODIQUE" Method="GET" Call="GETDATEINVPERIODIQUE" Cors="true" />
<Route Url="/GetModuleISS" Method="GET" Call="GetModuleISS" Cors="true" />
<Route Url="/SetInfoFTP" Method="GET" Call="SetInfoFTP" Cors="true"/>
<Route Url="/SetModuleISS/:pTournant/:pPeriodique/:pPentes/:pEDI" Method="GET" Call="SetModuleISS" Cors="true"/>
<Route Url="/SetTournant/:pActivation" Method="GET" Call="SetTournant" Cors="true"/>
<Route Url="/SetPeriodique/:pActivation" Method="GET" Call="SetPeriodique" Cors="true"/>
<Route Url="/SetPentes/:pActivation" Method="GET" Call="SetPentes" Cors="true"/>
<Route Url="/SetEDI/:pActivation" Method="GET" Call="SetEDI" Cors="true"/>
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
        s:(Retour.IP = "") Retour.Msg = "IP Manquant"
        s:(Retour.Login = "") Retour.Msg = "Login Manquant"
        s:(Retour.MDP = "") Retour.Msg = "MDP Manquant"
		s:(Retour.Port = "") Retour.Msg = "Port Manquant"
		s:(Retour.EmplacementInventaireSam = "") Retour.Msg = "Emplacement inventaire sam Manquant"
		s:(Retour.EmplacementInventaireSamPC = "") Retour.Msg = "Emplacement inventaire PC Manquant"

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

ClassMethod AjoutLogISS(pSam As %String, pUser As %String) As %Status
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

// FinWS

ClassMethod GETDATEINVPERIODIQUE() As %Status
{
		SET HWINFO 			= "^[""USER""]HWINFO"	
		Set sc = $$$OK
		s MaReponse = {}
			s MaReponse.valeur=""
			s MaReponse.valeur1=""
			s MaReponse.ERR=""
				
		Set DateDEBInv=$ZD($GET(@HWINFO@("INVENTAIRE","DATEDEB")))
		Set DateFinInv=$ZD($GET(@HWINFO@("INVENTAIRE","DATEFIN")))

		if (DateDEBInv'="" )&& (DateFinInv'="" )
			{
				S MaReponse.valeur=DateDEBInv
				s MaReponse.valeur1=DateFinInv
				s MaReponse.ERR=""
			}
			else
			{
			S MaReponse.valeur= ""
			s MaReponse.valeur1=""
			s MaReponse.ERR=""
			}
			
			Write MaReponse.%ToJSON()
			
		
		Return sc
}

ClassMethod GetModuleISS() As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s ISS = {}
	s ISS.Tournant = {}
	s ISS.Periodique = {}
	s ISS.Pentes = {}
	s ISS.EDI = {}
	s ISS.Tournant.Actif = 0
	s ISS.Periodique.Actif = 0
	s ISS.Periodique.DateD = 0
	s ISS.Periodique.DateA = 0
	s ISS.Periodique.DateF = 0
	s ISS.Pentes.Actif = 0
	s ISS.EDI.Actif = 0

	s:(+$d(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))>0	) ISS.Tournant.Actif	 = $g(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))
	s:(+$d(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))>0	) ISS.Periodique.Actif	 = $g(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))
	s:(+$d(@HWINFO@("INVENTAIRE","DATEDEB"))>0					) ISS.Periodique.DateD	 = $g(@HWINFO@("INVENTAIRE","DATEDEB"))
	s:(+$d(@HWINFO@("INVENTAIRE","DATEARRETE"))>0				) ISS.Periodique.DateA	 = $g(@HWINFO@("INVENTAIRE","DATEARRETE"))
	s:(+$d(@HWINFO@("INVENTAIRE","DATEFIN"))>0					) ISS.Periodique.DateF	 = $g(@HWINFO@("INVENTAIRE","DATEFIN"))
	s:(+$d(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))>0		) ISS.Pentes.Actif		 = $g(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))
	s:(+$d(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))>0		) ISS.EDI.Actif			 = $g(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))
	s:(ISS.Periodique.DateD '= "") ISS.Periodique.DateD = $zd(ISS.Periodique.DateD,8)
	s:(ISS.Periodique.DateA '= "") ISS.Periodique.DateA = $zd(ISS.Periodique.DateA,8)
	s:(ISS.Periodique.DateF '= "") ISS.Periodique.DateF = $zd(ISS.Periodique.DateF,8)

	write ISS.%ToJSON()

	return sc
}

ClassMethod SetInfoFTP() As %Status
{
	set sc = $$$OK
    s HWINF = "^[""USER""]HWINFO"
    s HWPOS = "^[""USER""]HWPOS"
	s Ret = {}
	s Ret.FTP = {}
	s Ret.FTP.Serveur = ""
	s Ret.FTP.Port = ""
	s Ret.FTP.ID = ""
	s Ret.FTP.MDP = ""
	s Ret.Emp = {}
	s Ret.Emp.Defaut = ""
	s Ret.Emp.GenerationZipBaseSam = ""
	s Ret.Emp.ArchivesTournant = ""
	s Ret.Emp.ArchivesPermanent = ""
	s Ret.Emp.Dechargement = ""
	s Ret.Update = 0

    s CODEMAG = $G(@HWINF@("MAG"))
    s IP = $P($G(@HWPOS@(CODEMAG,13)),"\",11)
	s $p(IP,".",4) = 250

    s @HWINF@("FTP_ISS_DFLTLOGIN") = "sam"
	s @HWINF@("FTP_ISS_DFLTPASSWORD") = "Adm"_CODEMAG_"*!"
    s @HWINF@("FTP_ISS_DFLTSERVER") = IP
    s @HWINF@("FTP_ISS_EmplacementInventaireSam") = ""
    s @HWINF@("FTP_ISS_EmplacementInventaireSamPC") = "C:\Terminal\Sam\"
    s @HWINF@("FTP_ISS_PORT") = 21
    s @HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIRETOURNANT") = "C:\Terminal\SAM\ARCHIVES\INVENTAIRE TOURNANT\"
	s @HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIREPERMANENT") = "C:\Terminal\SAM\ARCHIVES\INVENTAIRE PERMANENT"
    s @HWINF@("SAM","REPERTOIREPC","REPERTOIRETMP") = "C:\Terminal\SAM\Dechargement"

	s:($d(@HWINF@("FTP_ISS_DFLTSERVER"))>0) Ret.FTP.Serveur = $g(@HWINF@("FTP_ISS_DFLTSERVER"))
	s:($d(@HWINF@("FTP_ISS_PORT"))>0) Ret.FTP.Port = $g(@HWINF@("FTP_ISS_PORT"))
	s:($d(@HWINF@("FTP_ISS_DFLTLOGIN"))>0) Ret.FTP.ID = $g(@HWINF@("FTP_ISS_DFLTLOGIN"))
	s:($d(@HWINF@("FTP_ISS_DFLTPASSWORD"))>0) Ret.FTP.MDP = $g(@HWINF@("FTP_ISS_DFLTPASSWORD"))
	s:($d(@HWINF@("FTP_ISS_EmplacementInventaireSam"))>0) Ret.Emp.Defaut = $g(@HWINF@("FTP_ISS_EmplacementInventaireSam"))
	s:($d(@HWINF@("FTP_ISS_EmplacementInventaireSamPC"))>0) Ret.Emp.GenerationZipBaseSam = $g(@HWINF@("FTP_ISS_EmplacementInventaireSamPC"))
	s:($d(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIRETOURNANT"))>0) Ret.Emp.ArchivesTournant = $g(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIRETOURNANT"))
	s:($d(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIREPERMANENT"))>0) Ret.Emp.ArchivesPermanent = $g(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIREPERMANENT"))
	s:($d(@HWINF@("SAM","REPERTOIREPC","REPERTOIRETMP"))>0) Ret.Emp.Dechargement = $g(@HWINF@("SAM","REPERTOIREPC","REPERTOIRETMP"))
	s:(($d(@HWINF@("FTP_ISS_DFLTSERVER"))>0)&&($d(@HWINF@("FTP_ISS_PORT"))>0)&&($d(@HWINF@("FTP_ISS_DFLTLOGIN"))>0)&&($d(@HWINF@("FTP_ISS_DFLTPASSWORD"))>0)&&($d(@HWINF@("FTP_ISS_EmplacementInventaireSam"))>0)&&($d(@HWINF@("FTP_ISS_EmplacementInventaireSamPC"))>0)&&($d(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIRETOURNANT"))>0)&&($d(@HWINF@("SAM","REPERTOIREPC","ARCHIVES","INVENTAIREPERMANENT"))>0)&&($d(@HWINF@("SAM","REPERTOIREPC","REPERTOIRETMP"))>0)) Ret.Update = 1
	write Ret.%ToJSON()
	return sc
}

ClassMethod SetModuleISS(pTournant As %String, pPeriodique As %String, pPentes As %String, pEDI As %String) As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s Ret = {}
	s Ret.EtatTournant = ""
	s Ret.EtatPeriodique = ""
	s Ret.EtatPentes = ""
	s Ret.EtatEDI = ""
	s Ret.Update = 0

    set @HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF") = pTournant
	set @HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF") = pPeriodique
	set @HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF") = pPentes
	set @HWINFO@("INVENTAIRE","ISS","EDI","ACTIF") = pEDI

	s:($d(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))>0) Ret.EtatTournant = $g(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))>0) Ret.EtatPeriodique = $g(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))>0) Ret.EtatPentes = $g(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))>0) Ret.EtatEDI = $g(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))
	s:(($d(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))>0)&&($d(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))>0)&&($d(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))>0)&&($d(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))>0)) Ret.Update = 1
	
	write Ret.%ToJSON()
	return sc
}

ClassMethod SetTournant(pActivation As %String) As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s Ret = {}
	s Ret.EtatTournant = ""
	s Ret.Update = 0

    set @HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF") = pActivation

	s:($d(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))>0) Ret.EtatTournant = $g(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","TOURNANT","ACTIF"))>0) Ret.Update = 1
	
	write Ret.%ToJSON()
	return sc
}

ClassMethod SetPeriodique(pActivation As %String) As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s Ret = {}
	s Ret.EtatPeriodique = ""
	s Ret.Update = 0

    set @HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF") = pActivation
	
	s:($d(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))>0) Ret.EtatPeriodique = $g(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","PERIODIQUE","ACTIF"))>0) Ret.Update = 1
	
	write Ret.%ToJSON()
	return sc
}

ClassMethod SetPentes(pActivation As %String) As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s Ret = {}
	s Ret.EtatPentes = ""
	s Ret.Update = 0

    set @HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF") = pActivation
	
	s:($d(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))>0) Ret.EtatPentes = $g(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","PENTES","ACTIF"))>0) Ret.Update = 1
	
	write Ret.%ToJSON()
	return sc
}

ClassMethod SetEDI(pActivation As %String) As %Status
{
	set sc = $$$OK
	s HWINFO = "^[""USER""]HWINFO"
	s Ret = {}
	s Ret.EtatEDI = ""
	s Ret.Update = 0

    set @HWINFO@("INVENTAIRE","ISS","EDI","ACTIF") = pActivation

	s:($d(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))>0) Ret.EtatEDI = $g(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))
	s:($d(@HWINFO@("INVENTAIRE","ISS","EDI","ACTIF"))>0) Ret.Update = 1
	
	write Ret.%ToJSON()
	return sc
}

}

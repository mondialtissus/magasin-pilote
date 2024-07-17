Class REST.General Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

Parameter versionDev = 1.0;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="info" Cors="true"/>
<Route Url="/RapprochementManuel/:MagCapInfo/:sNumCmdBCI" Method="GET" Call="RapprochementManuel" Cors="true"/>
<Route Url="/info" Method="GET" Call="info" Cors="true"/>
<Route Url="/testsoap" Method="GET" Call="testsoap" Cors="true"/>
<Route Url="/testserveur" Method="GET" Call="testserveur" Cors="true"/>
<Route Url="/login/:pLogin/:pMdp" Method="GET" Call="LoginFusion" Cors="true"/>
<Route Url="/getidmag" Method="GET" Call="getIdMag" Cors="true"/>
<Route Url="/infoarticle/:pPLU" Method="GET" Call="InfoArticle" Cors="true"/>
<Route Url="/multicrit/:pFindString" Method="GET" Call="RechercheMultiCrit" Cors="true"/>
<Route Url="/loadretro/:pGlobal/:pMagSrc/:pCalcul" Method="GET" Call="LoadRetro" Cors="true"/>
<Route Url="/loadretrodetail/:pGlobal/:pNumRetro/:pMagSrc" Method="GET" Call="LoadRetroDetail" Cors="true"/>
<Route Url="/saveretro/:pGlobal/:pLogin/:pE2" Method="POST" Call="SaveRetro" Cors="true"/>
<Route Url="/saveretrobug/:pGlobal/:pNumCMD/:pMagSrc/:pMagDest/:pLogin/:pE2" Method="GET" Call="SaveRetroBUG" Cors="true"/>
<Route Url="/PG/AjoutGUMVT/:pParamGlobal" Method="GET" Call="PGAjoutGUMVT" Cors="true"/>
<Route Url="/RapprochementManuel/:pMag/:sNumCmdBci" Method="GET" Call="RapprochementManuel" Cors="true"/>
<Route Url="/savecmdweb/:pNumCmd" Method="GET" Call="SaveCmdWeb" Cors="true"/>
<Route Url="/HistoCmdWeb/:pNumCmd" Method="GET" Call="HistoCmdWeb" Cors="true"/>
<Route Url="/correctMvtRetro/:pNumretro/:pMagasin" Method="GET" Call="CORRECTMVT" Cors="true"/>
<Route Url="/fabien/:pTest/:pDeltaDate" Method="GET" Call="FalControle" Cors="true"/>
<Route Url="/kmvt/:pDate" Method="GET" Call="kmvt" Cors="true"/>
<Route Url="/recup/:pTest" Method="GET" Call="RecupMouvement" Cors="true"/>
<Route Url="/CorrecBugHistoToutMag" Method="GET" Call="CorrecBugHistoToutMag" Cors="true"/>
<Route Url="/RecupPrix/:pPLU" Method="GET" Call="RecupPrix" Cors="true"/>
<Route Url="/ControleMagWebCMD" Method="GET" Call="ControleMagWebCMD" Cors="true"/>
<Route Url="/ControleRetro" Method="POST" Call="ControleRetro" Cors="true"/>
<Route Url="/MAJRetro" Method="POST" Call="MAJRetro" Cors="true"/>
<Route Url="/TestPOSTIRIS" Method="POST" Call="TestPOSTIRIS" Cors="true"/>
<Route Url="/GestDoubRetro" Method="POST" Call="GestDoubRetro" Cors="true"/>
<Route Url="/ExportGUMVT" Method="GET" Call="ExportGUMVT" Cors="true"/>
<Route Url="/ControleCmdWeb" Method="GET" Call="ControleCmdWeb" Cors="true"/>
</Routes>
}

ClassMethod RapprochementManuel(MagCapInfo, sNumCmdBCI) As %Status
{
	Set MagCapInfo=..getCodeMagCapInfo(MagCapInfo)

	If MagCapInfo = ""
	{
		Set valeur.ERR = "Magasin non converti : "_valeur.MAGDEST
	}
	Else
	{
		Set client=##class(ICashOrderWSservice.ICashOrderWSPort).%New()
		Set hResponse = client.AffectationE2ByCommande(MagCapInfo,sNumCmdBCI)
						
		If +hResponse.ErrorCode '= 0
		{
			If valeur.ERR '= "" Set valeur.ERR = ", "
			Set valeur.ERR = valeur.ERR_"Rapprochement E2 BCI("_sNumCmdBCI_"): "_hResponse.Error
		}					
	}
}

ClassMethod CorrecBugHistoToutMag() As %Status
{
	Set sc = $$$OK
	Set MAGWEBCMD = "^[""USER""]MAGWEBCMD"
	Set HISTOMAGWEBCMD = "^[""USER""]HISTOMAGWEBCMD"

	Set req = ##class(%Net.HttpRequest).%New()
	Set Cpt = ""
	Set CptAHisto = ""
	Kill ^tmpTMCptAHisto
	kill ^TestTMHisto
	kill ^MagWebBUTM
	Set NumCMD = ""
	Set NumCMD = $ORDER(@MAGWEBCMD@(NumCMD))
	While NumCMD '= ""
	{
		Do req.Get("http://10.10.1.14:57772/rest/webAtlas/EstArchive/"_NumCMD)

   		Set str = req.HttpResponse.Data.Read()

   		Set AArchiver = $PIECE(str,";",1)
		Set Type = $PIECE(str,";",2)
		set Date = $P(str,";",3)
		set Heure = $P(str,";",4)
		If Type = "" Set Type = "CmdWeb"

		If AArchiver > 0
		{
			Set ^tmpTMCptAHisto(NumCMD,Type) = Date_"\"_Heure
			s NumBL = $o(@MAGWEBCMD@(NumCMD,""))
			s DataMWC = $g(@MAGWEBCMD@(NumCMD,NumBL))
			s ^MagWebBUTM(NumCMD,NumBL) = DataMWC
			k:((NumCMD '="")&&(NumBL '="")) @MAGWEBCMD@(NumCMD,NumBL)
			s $p(DataMWC,"\",17) = $zd(Date,8)
			s $p(DataMWC,"\",18) = $replace($ztime(Heure,2),":","")
			set ^TestTMHisto(NumCMD,NumBL) = DataMWC
			set @HISTOMAGWEBCMD@(NumCMD,NumBL) = DataMWC
			Set CptAHisto = CptAHisto + 1
		}
		Set Cpt = Cpt + 1
		Set NumCMD = $ORDER(@MAGWEBCMD@(NumCMD))
	}
	Set ^tmpTMCptAHisto($HOROLOG) = CptAHisto_"\"_Cpt
	Write CptAHisto_"\"_Cpt
	Return sc
}

ClassMethod SaveCmdWeb(pNUMCMD As %String) As %String
{
	Set sc=$$$OK
	Set MAGWEBCMD="^[""USER""]MAGWEBCMD"
	
	Set response = {}
	Set response.ERR = ""
	Set resultStatut=[]
	
	Set LstCmd=pNUMCMD 
	Set iCmd=1
	While $PIECE(LstCmd,";",iCmd)'=""
	{
		Set bMODIF=0
		Set NUMCMDENCOURS=$PIECE(LstCmd,";",iCmd)
		If NUMCMDENCOURS '= ""
		{
			Set NUMCMDENCOURS2=""
			Set NUMCMDENCOURS2=$ORDER(@MAGWEBCMD@(NUMCMDENCOURS,NUMCMDENCOURS2))
			While NUMCMDENCOURS2'=""
			{
				Set bMODIF=1
				Set DATA=$GET(@MAGWEBCMD@(NUMCMDENCOURS,NUMCMDENCOURS2))
				Set $PIECE(DATA,"\",15)=$ZDATE(+$HOROLOG,8)
				Set $PIECE(DATA,"\",16)=$EXTRACT($REPLACE($ZTIME($PIECE($HOROLOG,",",2)),":",""),1,4)
				Set @MAGWEBCMD@(NUMCMDENCOURS,NUMCMDENCOURS2)=DATA
					
				Set NUMCMDENCOURS2=$ORDER(@MAGWEBCMD@(NUMCMDENCOURS,NUMCMDENCOURS2))
			}
			Do resultStatut.%Set(iCmd-1,{"NUMCMD":(NUMCMDENCOURS),"ETAT":(bMODIF)})
		}
		Set iCmd=iCmd+1
	}
	If resultStatut '=""
	{
		Set response.TblInfo = resultStatut
	}
	Else
	{
		Set response.ERR="Problème de réception de vôtre commande côté magasin. Veuillez prévenir le service informatique ."
	}
 	Write response.%ToJSON()
	Return sc
}

ClassMethod HistoCmdWeb(pNUMCMD As %String) As %String
{
	Set sc=$$$OK
	Set MAGWEBCMD="^[""USER""]MAGWEBCMD"
	Set HISTOMAGWEBCMD="^[""USER""]HISTOMAGWEBCMD"
	
	Set response = {}
	Set response.ERR = ""
	Set resultStatut=[]
	
	Set bMODIF = 0
	Set NUMCMDENCOURS2=""
	Set NUMCMDENCOURS2=$ORDER(@MAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2))
	While NUMCMDENCOURS2'=""
	{
		Set bMODIF=1
		Set DATA=$GET(@MAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2))
		Set $PIECE(DATA,"\",17)=$ZDATE(+$HOROLOG,8)
		Set $PIECE(DATA,"\",18)=$EXTRACT($REPLACE($ZTIME($PIECE($HOROLOG,",",2)),":",""),1,4)
		Set @HISTOMAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2)=DATA
		If +$DATA(@HISTOMAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2))>0 Kill @MAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2)
			
		Set NUMCMDENCOURS2=$ORDER(@MAGWEBCMD@(pNUMCMD,NUMCMDENCOURS2))
	}
	Do resultStatut.%Set(1,{"NUMCMD":(pNUMCMD),"ETAT":(bMODIF)})
	
	If resultStatut '=""
	{
		Set response.TblInfo = resultStatut
	}
	Else
	{
		Set response.ERR="Problème de retrait de votre commande côté magasin. Veuillez prévenir le service informatique ."
	}
 	Write response.%ToJSON()
	Return sc
}

ClassMethod testsoap() As %Status
{
	Set sc=$$$OK
	
	Set preprodFR = "http://10.10.1.209/CashOrderWS/CashOrderWS.exe/soap/ICashOrderWS"
	Set prodFR = "http://10.10.1.18:8080/CashOrderWS/CashOrderWS.exe/soap/ICashOrderWS"
	Set prodDE = "http://10.10.1.104/CashOrderWS/CashOrderWS.exe/soap/ICashOrderWS"
	
	Set wc = ##class(ICashOrderWSservice.ICashOrderWSPort).%New()
	Set result = ##class(ICashOrderWSservice.ResultGetStockSimple).%New()
	
	;s result = wc.GetStockSimple(2215, "1500")
	;I result.ErrorCode = 0 w "Stock="_+result.stock

	Set result = wc.AffectationE2ByCommande("2257","2820141061528")
	Write result.ErrorCode_" "
	If result.ErrorCode '= 0 Write !,result.Error
	
	Return sc
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

ClassMethod testserveur() As %Status
{
	Set sc=$$$OK
	
	Set resTestserveur={}
	Set resTestserveur.ERR=""
	Set resTestserveur.Valider=1

	Write resTestserveur.%ToJSON()
	Return sc
}

ClassMethod getIdMag() As %Status
{
	Set sc=$$$OK

	Set resMagasin={}
	Set resMagasin.ERR=""
	Set resMagasin.Valider=1
	Set resMagasin.CodeMag=$GET(^|"USER"|HWINFO("MAG"))
	
	If resMagasin.CodeMag="" 
	{
		Set resMagasin.ERR="Erreur récupération du code magasin"
		Set resMagasin.Valider=0
	}

	Write resMagasin.%ToJSON()
	Return sc
}

ClassMethod getCodeMagCapInfo(pMAGGMT As %String) As %String
{
	Set resCodeMagCapInfo=""
	
	Set LettreCodeMag=$EXTRACT(pMAGGMT,1,1)
	If LettreCodeMag="G" Set resCodeMagCapInfo="1"
	If LettreCodeMag="M" Set resCodeMagCapInfo="2"
	If LettreCodeMag="Q" Set resCodeMagCapInfo="3"
	If LettreCodeMag="C" Set resCodeMagCapInfo="4"
	If LettreCodeMag="F" Set resCodeMagCapInfo="5"
	If LettreCodeMag="V" Set resCodeMagCapInfo="6"
	If LettreCodeMag="D" Set resCodeMagCapInfo="7"
	If LettreCodeMag="B" Set resCodeMagCapInfo="8"
	If LettreCodeMag="X" Set resCodeMagCapInfo="9"
	
	If resCodeMagCapInfo'="" Set resCodeMagCapInfo=resCodeMagCapInfo_$EXTRACT(pMAGGMT,2,4)
		
	Return resCodeMagCapInfo
}

ClassMethod InfoArticle(pPLU As %String) As %Status
{
	Set sc=$$$OK
	Set GUSTOCK="^[""USER""]GUSTOCK"
	Set TKFINSERIE="^[""USER""]TKFINSERIE"

	Set resInfoArticle={}
	Set resInfoArticle.PLU=pPLU
	Set resInfoArticle.ERR=""
	Set resInfoArticle.Valider=1
	Set resInfoArticle.QTESTOCK=$PIECE($GET(@GUSTOCK@(pPLU)),"\",6)
	Set resInfoArticle.PROMO=$GET(@TKFINSERIE@(pPLU))

	Set REPPHOTOWEB="C:\gsiphotos\"
	Set NOMPHOTO=REPPHOTOWEB_pPLU_".jpg"
	If '##class(%Library.File).Exists(NOMPHOTO)
	{
		Set NOMPHOTO=REPPHOTOWEB_pPLU_".jpeg"
		If '##class(%Library.File).Exists(NOMPHOTO)
		{
			Set NOMPHOTO=REPPHOTOWEB_pPLU_".gif"
			If '##class(%Library.File).Exists(NOMPHOTO) {Set NOMPHOTO=""}
		}
	}
	Set resInfoArticle.PHOTO=$PIECE(NOMPHOTO,"\",3)
	
	/*
	I NOMPHOTO'=""
	{
		Set stream=##class(%Stream.FileBinary).%New()
		Set sc=stream.LinkToFile(NOMPHOTO)
		
		Set x1=stream.Read(25000,sc)
		Set x2=stream.Read(25000,sc)
		Set x3=stream.Read(25000,sc)
		Set x4=stream.Read(25000,sc)
		
		s hex=##class(%xsd.hexBinary).LogicalToXSD(x1_x2_x3_x4)
		s resInfoArticle.PHOTO=hex
		//s resInfoArticle.NOMPHOTO=hex
	}*/

	Write resInfoArticle.%ToJSON()
	Return sc
}

ClassMethod LoginFusion(pLogin As %String, pMdp As %String) As %Status
{
	Set sc=$$$OK
	
	Set UserIdentification={}
	Set UserIdentification.Valider=0
	Set UserIdentification.ERR=""
	Set UserIdentification.Prénom=""
	Set UserIdentification.Nom=""
	Set UserIdentification.Login=pLogin
	Set UserIdentification.Droit=""
				 	
	Set DATAUSER=$GET(^|"USER"|SIB("USER",pLogin))
	Set DROITS="^[""USER""]FUSIONDROITS"

	If (pLogin="ADMIN")&&(pMdp="ADMGMT01")
	{
		Set UserIdentification.Valider=1
		Set UserIdentification.ERR=""
		Set UserIdentification.Prénom="Administrateur"
		Set UserIdentification.Nom="ADMIN"
		Set UserIdentification.Droit="1;1;1;1;1;1;1;1;1"
	}
	Else
	{
		If DATAUSER="" {Set UserIdentification.ERR="Utilisateur inconnu"}
		Else
		{
			Set sMdp=$PIECE(DATAUSER,"\",4)
			If sMdp'=pMdp {Set UserIdentification.ERR="Mot de passe invalide"}
			Else
			{
				Set UserIdentification.Valider=1
				Set UserIdentification.Prénom=$PIECE(DATAUSER,"\",2)
				Set UserIdentification.Nom=$PIECE(DATAUSER,"\",1)
				Set UserIdentification.Login=pLogin
				Set bDROITINVTOURNANT = +$DATA(@DROITS@(pLogin,"INVTOURNANT"))
				Set bDROITRECEPTCOLIS = +$DATA(@DROITS@(pLogin,"RECEPLIVR"))
				Set UserIdentification.Droit = bDROITINVTOURNANT_";"_bDROITRECEPTCOLIS
			}
		}
	}

	Write UserIdentification.%ToJSON()
	
	Return sc
}

ClassMethod RechercheMultiCrit(pFindString As %String) As %Status
{
	Set sc=$$$OK
	
	Set sInfoRetour = $$MULTICRIT^|"USER"|SSMAG($REPLACE(pFindString,"_||_"," "))
	
	Set resInfoArticle={}
	Set resInfoArticle.ERR=""
	Set resInfoArticle.TblInfo=[]
	If +$PIECE(sInfoRetour,"\",1)=0
	{
		// On a une erreur => on 
		Set resInfoArticle.ERR=$PIECE(sInfoRetour,"\",2)
	}
	Else
	{
		Set SEPLIGNE="_||_"
		Set SEPENREG="$!!$"
		
		Set i=1
		Set sDataArticle=$PIECE(sInfoRetour,SEPENREG,i)
		While sDataArticle'=""
		{
			Set UnArticle={}
			Set UnArticle.PLU=$PIECE(sDataArticle,"\",1)
			Set sInfoComplementaire=$EXTRACT(sDataArticle,$LENGTH(UnArticle.PLU)+2,$LENGTH(sDataArticle))
			Set UnArticle.PHOTO=$PIECE(sInfoComplementaire,SEPLIGNE,1)
			Set UnArticle.CLEFART=$PIECE(sInfoComplementaire,SEPLIGNE,3)
			Set UnArticle.FOURNISSEUR=$PIECE(sInfoComplementaire,SEPLIGNE,4)
			Set UnArticle.DESIGNATION=$PIECE(sInfoComplementaire,SEPLIGNE,5)
			Set UnArticle.PV=$PIECE(sInfoComplementaire,SEPLIGNE,6)
			Set UnArticle.COMPOSITION=$PIECE(sInfoComplementaire,SEPLIGNE,7)
			Set UnArticle.ENTRETIEN=$PIECE(sInfoComplementaire,SEPLIGNE,8)
			Set UnArticle.UNITEEMB=$PIECE(sInfoComplementaire,SEPLIGNE,9)
			Set UnArticle.PHOTO64=$PIECE(sInfoComplementaire,SEPLIGNE,10)
			Set UnArticle.IDSTATUT=$PIECE(sInfoComplementaire,SEPLIGNE,11)
			Do resInfoArticle.TblInfo.%Set((i-1),UnArticle)

			Set i=i+1
			Set sDataArticle=$PIECE(sInfoRetour,SEPENREG,i)
		}
	}
	
	Write resInfoArticle.%ToJSON()
	
	Return sc
}

ClassMethod LoadRetro(pGLOBAL As %String, pMAGSRC As %String, pCALCUL As %Numeric) As %Status
{
	Set sc=$$$OK
	
	Set response = {}
	Set response.ERR = ""
	
	Set LstCommande=[]
	Set iCpt=0
	Set MAGRETRO="^[""USER""]"_pGLOBAL
	Set MAG=$GET(^|"USER"|HWINFO("MAG"))

	Set CPT=0 Set CPTOK=0
 	Set sNumRetro=""
 	Set sNumRetro=$ORDER(@MAGRETRO@("CMD",sNumRetro))
 	While sNumRetro'=""
 	{
	 	If (+$DATA(@MAGRETRO@("LIV",sNumRetro))=0)&&(+$DATA(@MAGRETRO@("FAX",sNumRetro))>0)
	 	{
			Set CPT=CPT+1
		 	Set sMagSrc=$EXTRACT(pMAGSRC,1,$LENGTH(pMAGSRC)-1) // Permet d'optimiser un peu le temps de parcours
		 	If pMAGSRC="ALL" Set sMagSrc=""
		 	Set sMagSrc=$ORDER(@MAGRETRO@("CMD",sNumRetro,sMagSrc))
		 	While sMagSrc'=""
		 	{
			 	Set CPTOK=CPTOK+1 
				If (sMagSrc=pMAGSRC)||(pMAGSRC="ALL")
			 	{
				 	// Signifie que l'on a une rétrocession non réceptionnée
				 	Set sData0=$GET(@MAGRETRO@("CMD",sNumRetro,sMagSrc,MAG,0))
				 	If sData0'=""
				 	{
					 	If pCALCUL=0
					 	{
						 	Set MaRetro={}
						 	Set MaRetro.NUMCMD=sNumRetro
						 	Set MaRetro.MAGSRC=sMagSrc
						 	Set MaRetro.MAGDEST=MAG
						 	Set MaRetro.DATA0=sData0
						 	Do LstCommande.%Set(iCpt,MaRetro)
					 	}
					 	
					 	Set iCpt=iCpt+1	
				 	}
			 	}
			
				Set sMagSrc=$ORDER(@MAGRETRO@("CMD",sNumRetro,sMagSrc)) 	
	 		}	 	
	 	}
	 	
		Set sNumRetro=$ORDER(@MAGRETRO@("CMD",sNumRetro))
	}
	
	If pCALCUL=1
	{
		Set MaRetro={}
		Set MaRetro.DATA0=iCpt
		Do LstCommande.%Set(0,MaRetro)
	}
	
	;w CPT_" "_CPTOK_" "
	Set response.TblRetro = LstCommande
	Write response.%ToJSON()
	
	Return sc
}

ClassMethod LoadRetroDetail(pGLOBAL As %String, pNUMRETRO As %String, pMAGSRC As %String) As %Status
{
	Set sc=$$$OK
	
	Set response={}
	Set response.ERR=""
	
	Set LstDetailPlu=[]
	Set MAGRETRO="^[""USER""]"_pGLOBAL
	Set MAG=$GET(^|"USER"|HWINFO("MAG"))
	
	Set iCpt=0
	Set CptEnt=0
 	Set NumLigne=""
 	Set NumLigne=$ORDER(@MAGRETRO@("CMD",pNUMRETRO,pMAGSRC,MAG,NumLigne))
 	While NumLigne'=""
 	{
	 	Set sData=$GET(@MAGRETRO@("CMD",pNUMRETRO,pMAGSRC,MAG,NumLigne))
	 	If CptEnt = 0
	 	{
		 	//Entete de la retro, detail general
		 	Set NbLigne=$PIECE(sData,"\",1)
		 	Set PrixAchatTotal=$PIECE(sData,"\",3)
		 	Set Commentaire=$PIECE(sData,"\",8)
		 	Set NumCmdSbm=$PIECE(sData,"\",9)
		 	Set CptEnt=CptEnt+1
	 	}
	 	Else
	 	{
		 	//Detail de la retro / plu
		 	Set RetroDetail={}
		 	Set RetroDetail.NumLigne=iCpt
		 	Set RetroDetail.CodePlu=$PIECE(sData,"\",1)
		 	Set RetroDetail.QteCmdDet=$PIECE(sData,"\",2)
		 	Set RetroDetail.PrixVentePlu=$PIECE(sData,"\",4)
		 	Set RetroDetail.Designation=$PIECE(sData,"\",8)
		 	Do LstDetailPlu.%Set(iCpt,RetroDetail)
		 	Set iCpt=iCpt+1
	 	}
		Set NumLigne=$ORDER(@MAGRETRO@("CMD",pNUMRETRO,pMAGSRC,MAG,NumLigne))		 	
	}
	Set response.TblRetro 		= LstDetailPlu
	Set response.NbLigne		= NbLigne
	Set response.PrixAchatTotal = PrixAchatTotal
	Set response.Commentaire	= Commentaire
	Set response.NumCmdSbm		= NumCmdSbm
	
	Write response.%ToJSON()
	
	Return sc
}

ClassMethod SaveRetro(pGLOBAL As %String, pLogin As %String, pE2 As %Boolean) As %Status
{
	Set sc=$$$OK

	Set MAGRETRO="^[""USER""]"_pGLOBAL
	Set MODMAGRETRO="^[""USER""]MOD"_pGLOBAL
	Set HWINFO="^[""USER""]HWINFO"
	Set MAGCMDEDI="^[""USER""]MAGCMDEDI"
	Set MODEDICMDSUIVI="^[""USER""]MODEDICMDSUIVI"
	Set MODMAGBCISTATUT="^[""USER""]MODMAGBCISTATUT"
	Set ST = "^[""USER""]ST"
 	Set bEstFranchise=+$GET(@HWINFO@("ESTFRANCHISE"))
	Set tmpTM = "^[""USER""]tmpTM"
	

	Set cstNumRecepRetro=13
	Set cstNumReceptRetroFranchise=13.5

	Set bufferEntrant = %request.Content
	Set responseSaveRetro = {}.%FromJSON(bufferEntrant)
	Set responseSaveRetro.ERR = ""
	Set responseSaveRetro.ListParamEtiq=""
	Set responseSaveRetro.ListPlu = ""
	Set responseSaveRetro.ListMetrage = ""

	ZA @MAGRETRO
	ZA @MODMAGRETRO
	
	Set ListCmdBCI = ""
	Set ListPLU = ""
	Set cpt=0
	Set iCpt=0
	Set sIterationLigne=responseSaveRetro.TblRetro.%GetIterator()
	While sIterationLigne.%GetNext(.cle,.valeur)
	{
		If valeur.NUMCMD'=""
		{
			// Permet de savoir si nous trouvons au moins une rétrocession => juste affiche sur smartphone
			Set cpt=cpt+1
			
			If +$DATA(@MAGRETRO@("LIV",valeur.NUMCMD))>0
			{
				If bEstFranchise=1 {Set valeur.ERR="Transfert vente déjà réceptionné sur un autre poste."}
				Else {Set valeur.ERR="Rétrocession déjà réceptionnée sur un autre poste."}
				
				Do responseSaveRetro.TblRetro.%Set(cle,valeur)
			}
			Else
			{
				Set strData = $GET(@MAGRETRO@("FAX",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,0))
				Set NbLigne = +$PIECE(strData,"\",1)
				Set TotalQte = $PIECE(strData,"\",2)
				Set Valorisation = $PIECE(strData,"\",3)
				Set CodeTransporteur = $PIECE(strData,"\",7)
				Set lRemarque = $PIECE(strData,"\",8)
				
				Set DateRetro = +$PIECE($HOROLOG,",",1)
				Set HeureRetro = +$PIECE($HOROLOG,",",2)
				Set sDataRetro = NbLigne_"\"_TotalQte_"\"_Valorisation_"\"_pLogin_"\"_$ZDATE(DateRetro,8)_"\"_$REPLACE($ZTIME(HeureRetro),":","")_"\"_CodeTransporteur_"\"_lRemarque
				
				//Enregistrement de l'entête de la commande
				Set @MAGRETRO@("LIV",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,0)=sDataRetro
				//La gestion des MOD est fait de telle sorte que le premier node doit toujours se référer au magasin source.
				Set @MODMAGRETRO@(valeur.MAGDEST,"LIV",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,0)=sDataRetro
				Set valeur.RETRO = 1
				
				Set sTypeMvt = cstNumRecepRetro
				If bEstFranchise = 1 Set sTypeMvt = cstNumReceptRetroFranchise
				
			 	// Gestion des commandes BCI pour les rétrocession de CONFECTION
			 	If pGLOBAL = "MAGRETROCONF"
			 	{
			 		If +$LENGTH($PIECE(strData,"\",11))=13 Set ListCmdBCI = ListCmdBCI_$PIECE(strData,"\",11)_";"
			 	}
		
				//Nous devons également créer les lignes de mouvements pour les lignes détails de rétrocessions concernées
				Set lIdLigne="0"
				Set iNbArticle=0
			 	Set lIdLigne=$ORDER(@MAGRETRO@("CMD",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,lIdLigne))
			 	While lIdLigne'=""
			 	{
				 	Set DataLigneRetro=$GET(@MAGRETRO@("CMD",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,lIdLigne))
				 	Set iNbArticle=iNbArticle+1
				 	
				 	Set Plu=$PIECE(DataLigneRetro,"\",1)
				 	Set QteCmd=$PIECE(DataLigneRetro,"\",2)
					//Récupération du métrage (Or confection)
					If pGLOBAL '= "MAGRETROCONF" && (valeur.MAGSRC = "X999")
					{
						Set ClefArt = $PIECE(DataLigneRetro,"\",8)
 						If (+$DATA(@ST@(ClefArt))>0) && (+$PIECE($GET(@ST@(ClefArt)),"\",23)<4)
   						{
    						Set responseSaveRetro.ListMetrage = ClefArt_"||"_QteCmd_";"_responseSaveRetro.ListMetrage //s Metrage = $p($g(@MAGRETRO@("CMD",sRetro,"X999",Mag,i)),"\",2)
   						}
					}
				 	If QteCmd'=0
				 	{
					 	Set CMDGSI=$PIECE(DataLigneRetro,"\",14)
					 	Set NUMCMD=$PIECE(DataLigneRetro,"\",5)
					 	Set EDTEDI=0
					 	If CMDGSI'="" Set EDTEDI=1
					 	
						Set sParam = valeur.MAGDEST_"_||_"_pLogin_"_||_"_Plu_"_||_"_Plu_"_||_"_sTypeMvt_"_||_"_QteCmd_"_||_"_lRemarque_"_||_"_valeur.MAGSRC_"_||_"_valeur.MAGDEST_"_||_"_valeur.NUMCMD
					 	Set @tmpTM@(sParam,"EntreMVT") = ""
						Set retErr = ..PGAjoutGUMVT(sParam, 0)
					 	If retErr '= ""
					 	{
						 	//Tracer les erreurs de mouvement 
						 	Set ^HISTOBUGMVTRETRO($ZDATE(+$HOROLOG,8),Plu)=valeur.MAGDEST_"/"_valeur.NUMCMD_"/"_valeur.ERR_"/"_retErr
						 	If valeur.ERR '= "" Set valeur.ERR = ", "
						 	Set valeur.ERR = valeur.ERR_retErr 
					 	}
					 	
						//Nous créons un enregistrement de retour pour les commandes venant du dépôt
						If NUMCMD'="" 
						{
							Set sNumLng = +$PIECE(DataLigneRetro,"\",7)
							If sNumLng = 0 Set sNumLng = 1
				
							Set sData="8"_"\"_pLogin
							Set @MODMAGBCISTATUT@(valeur.MAGDEST,NUMCMD,Plu,sNumLng)=sData
						}						
							
						If CMDGSI'=""
						{
							//Liste de commandes GSI pour l'EDI de @GP
							Set sListeCmdGSI = CMDGSI
							Set cptCmdGSi = 1
							Set sCmdGSIQTE = $PIECE(sListeCmdGSI,";",cptCmdGSi) //sous forme NUMCMD*QTEEXP;NUMCMD*QTEEXP;NUMCMD*QTEEXP;NUMCMD*QTEEXP;
							While sCmdGSIQTE'=""
							{								
								//Nous devons renvoyer un fichier de validation de réception
								Set sCmdGSI = $PIECE(sCmdGSIQTE,"*",1)
								Set sQTECMDGSI = +$PIECE(sCmdGSIQTE,"*",2)

								Set sData=sQTECMDGSI_"\"_pLogin_"\"_$ZDATE(+$HOROLOG,8)_"\"_$REPLACE($ZTIME($HOROLOG),":","")
								Set @MODEDICMDSUIVI@(valeur.MAGDEST,"LIV",sCmdGSI,Plu,valeur.NUMCMD)=sData		

								Set sDataMAGCMDEDI = $GET(@MAGCMDEDI@("CDE",sCmdGSI,Plu))
								Set rQteLivOld = +$PIECE(sDataMAGCMDEDI,"\",6)+sQTECMDGSI
								Set $PIECE(sDataMAGCMDEDI,"\",6) = rQteLivOld		//Quantité livrée
								Set $PIECE(sDataMAGCMDEDI,"\",7) = $ZDATE(+$HOROLOG,8) 	//Date de livraison
								Set $PIECE(sDataMAGCMDEDI,"\",8) = valeur.NUMCMD	//Numéro de rétrocession
								Set @MAGCMDEDI@("CDE",sCmdGSI,Plu)=sDataMAGCMDEDI

								Set cptCmdGSi=cptCmdGSi+1
								Set sCmdGSIQTE = $PIECE(sListeCmdGSI,";",cptCmdGSi)
							}		
						}
				 	}
				 	
				 	// Gestion des commandes BCI pour le S2W dans ^MAGRETROUCOUPE
				 	If pGLOBAL = "MAGRETROCOUPE"
				 	{
				 		If +$LENGTH($PIECE(DataLigneRetro,"\",5))=17 Set ListCmdBCI = ListCmdBCI_$EXTRACT($PIECE(DataLigneRetro,"\",5),5,17)_";"
				 	}
				 	
					Set lIdLigne=$ORDER(@MAGRETRO@("CMD",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,lIdLigne))
					
					//Récupération PLU pour impression étiquettes
					If ListPLU="" {Set ListPLU=Plu} Else {Set ListPLU=ListPLU_"_||_"_Plu}
				}
				Set valeur.NBART = iNbArticle
				
				// Appel du rapprochement automatique des E2 si paramètre pE2 = True
				If (+pE2 = 1) && (ListCmdBCI'="")
				{
					// récupération du code magasin de Cap'Info selon code GMT
					Set MagCapInfo=..getCodeMagCapInfo(valeur.MAGDEST)

					If MagCapInfo = ""
					{
						Set valeur.ERR = "Magasin non converti : "_valeur.MAGDEST
					}
					Else
					{
						// On parcourt le fichier des commandes BCI à rapprocher automatiquement
						Set cptCmdBCI = 1
						Set sNumCmdBCI = $PIECE(ListCmdBCI,";",cptCmdBCI) //sous forme N°CMDBCI;N°CMDBCI;N°CMDBCI;
						While sNumCmdBCI'=""
						{
							Set client=##class(ICashOrderWSservice.ICashOrderWSPort).%New()
		 					Set hResponse = client.AffectationE2ByCommande(MagCapInfo,sNumCmdBCI)
							Set req = ##class(%Net.HttpRequest).%New()
 							s h = $REPLACE($h,",","_")
 							s lien = "http://10.10.1.14:57772/rest/webAtlas/SMS/"_h_"/"_MagCapInfo_"/"_sNumCmdBCI
 							set response = req.Get(lien) 
						 
		 					
		 					If +hResponse.ErrorCode '= 0
		 					{
			 					If valeur.ERR '= "" Set valeur.ERR = ", "
								Set valeur.ERR = valeur.ERR_"Rapprochement E2 BCI("_sNumCmdBCI_"): "_hResponse.Error
		 					} 
							
							Set cptCmdBCI=cptCmdBCI+1
							Set sNumCmdBCI = $PIECE(ListCmdBCI,";",cptCmdBCI)
						}
					}

				}
				
				Do responseSaveRetro.TblRetro.%Set(cle,valeur)
			}
		}
	}
	
	//Déblocage du fichier
	ZD @MODMAGRETRO
	ZD @MAGRETRO
	
	If cpt=0 Set responseSaveRetro.ERR = "Aucune rétrocession trouvée"
	Set responseSaveRetro.ListParamEtiq=$GET(@HWINFO@("NB_PRINTER_ETIQUETTES"))
	Set responseSaveRetro.ListPlu = ListPLU
	Write responseSaveRetro.%ToJSON()
	Return sc
}

ClassMethod PGRenvoiPLURouleau(pROULEAU As %String) As %String
{
	//Nous devons renvoyer le PLU lié au rouleau
	Set sPLU=pROULEAU
	If (+$EXTRACT(sPLU,1)=2)&&($LENGTH(sPLU)=13) Set sPLU=+$EXTRACT(sPLU,2,6)
	Quit sPLU
}

ClassMethod PGGetPrix(pPrixMagasin As %String, pForce As %String = 0) As %Numeric
{

	Set strDateBascule = $PIECE(pPrixMagasin,"/",2)
	If strDateBascule="" Quit +pPrixMagasin
	
	If +pForce=1 Quit +$PIECE(pPrixMagasin,"/",3)
    
	Set sFinDateBascule = +$PIECE(pPrixMagasin,"/",4)
	If sFinDateBascule = 0 Set sFinDateBascule=999999
	
	Set valRetour=0
	If (+$HOROLOG>=strDateBascule)&&(+$HOROLOG<=sFinDateBascule) {Set valRetour=+$PIECE(pPrixMagasin,"/",3)}
	Else {Set valRetour=+$PIECE(pPrixMagasin,"/",1)}

	Quit valRetour
}

ClassMethod PGRenvoiNumMvt(pType As %Numeric) As %Numeric
{
	Set HWINFO="^[""USER""]HWINFO"
	Set cstcTypeMVTNumCoupon = 27
	Set lCompteurMouvement = 0

	//On bloque le fichier HWINFO
	ZA @HWINFO

	//On prélève le dernier numéro de mouvement: s'il n'existe pas alors on obtiendra 0 comme valeur
	Set lCompteurMouvement = +$GET(@HWINFO@("GUCOMPTEURMVT")) + 1
	If pType = cstcTypeMVTNumCoupon
	{
		//Dans le cas d'un coupon nous devons incrémenter de 2 le numéro de mouvement	
		Set lCompteurMouvement=lCompteurMouvement+1
		Set @HWINFO@("GUCOMPTEURMVT")=lCompteurMouvement
		Set lCompteurMouvement=lCompteurMouvement-1
	}
	Else
	{
		Set @HWINFO@("GUCOMPTEURMVT")=lCompteurMouvement
	}

	//On débloque le fichier HWINFO		
	ZD @HWINFO

	Quit lCompteurMouvement
}

ClassMethod PGAjoutSinistre(pDesSinistre As %String) As %Numeric
{
	Set GUSINISTRE="^[""USER""]GUSINISTRE"

	//On recherche le dernier code sinistre ($0-1) pour ensuite l'incrémenter de 1 et ajouter notre nouveau code
	Set lIdCodeSinistre = +$ORDER(@GUSINISTRE@(""))+1
	Set @GUSINISTRE@(lIdCodeSinistre)=pDesSinistre //On ajoute le nouveau sinitre

	Quit lIdCodeSinistre
}

ClassMethod PGRechercheCoupon(pPLU As %String, pPV As %Numeric, pSecteur As %Numeric) As %String
{
	Set GUCOUPON="^[""USER""]GUCOUPON"

	Set lCouponGU = ""
	If pSecteur '= ""
	{
		//Nous devons vérifier dans un premier temps que l'artuicle saisi n'ets pas déjà lui-même un coupon
		If +$DATA(@GUCOUPON@(pPLU))=0
		{
			//L'article n'est pas un coupon	
			Set lCoupon=""
		 	Set lCoupon=$ORDER(@GUCOUPON@(lCoupon))
		 	While lCoupon'=""
		 	{
			 	Set lCouponGU = lCoupon
			 	
			 	Set ldata = $GET(@GUCOUPON@(lCoupon))
			 	If ldata '= ""
			 	{
					Set lPVMini = +$PIECE(ldata,"\",2)
					Set lPVMaxi = +$PIECE(ldata,"\",3)
					If lPVMaxi = 0 Set lPVMaxi = 99999

					If (+$PIECE(ldata,"\",1) = +pSecteur) && (pPV >= lPVMini) && (pPV < lPVMaxi)
					{
						//On a trouvé le coupon correspondant, on ajoute donc le prix d'achat du coupon
						Set lCouponGU = lCouponGU _ "\\_||_//" _$PIECE(ldata,"\",4) _ "\\_||_//" _$PIECE(ldata,"\",5)
						Quit
					}
			 	}
			 	
				Set lCoupon=$ORDER(@GUCOUPON@(lCoupon))
			}
		}
	}
			
	Quit lCouponGU
}

ClassMethod PGAjoutGURECEPT(pNumCmd As %String, pClefArticle As %String, pQTE As %Numeric, pNUMBL As %String) As %String
{
	Set sRetour = $$RECEPTLIGNECOMMANDEPLUS^|"USER"|OPTIMISATIONFUSION(pNumCmd,pClefArticle,pQTE,pNUMBL)
	Set ValRetour=""
	If +$PIECE(sRetour,"\",1)=0 Set ValRetour=$PIECE(sRetour,"\",2)

	Quit ValRetour
}

ClassMethod PGEnleveGURECEPT(pNumCmd As %String, pClefArticle As %String, pQTE As %Numeric, pNUMBL As %String) As %String
{
	Set sRetour = $$RECEPTLIGNECOMMANDEMOINS^|"USER"|OPTIMISATIONFUSION(pNumCmd,pClefArticle,pQTE,pNUMBL)
	Set ValRetour=""
	If +$PIECE(sRetour,"\",1)=0 Set ValRetour=$PIECE(sRetour,"\",2)

	Quit ValRetour
}

ClassMethod PGModifGUSTOCK(pPLU As %String, pNUMCOL As %Numeric, pQTE As %Numeric, pData As %String, pSecteur As %String, pFamille As %String) As %String
{
	//================= Ligne de stock type ================
	// ^GUSTOCK(PLU) = QTEINVENTAIRE\QTEVENTE\QTERECEPT\QTETRANSFERT\QTEDEMARQUE\QTETOTAL\LASTUPDATE\MODIFY
	//Ces données sont mises à jour à chaque modification du stock du PLU concerné.
	//======================================================
	Set GUSTOCK="^[""USER""]GUSTOCK"
	Set GUSECTFAMPLU="^[""USER""]GUSECTFAMPLU"
	Set FILEPLU="^[""USER""]SP"
	Set FILEARTICLE="^[""USER""]ST"
	
	Set cstcTypeProduitIN = "IN"
	Set cstcTypeProduitSTOP = "STOP"
	Set cstcTypeProduitOUT = "OUT"
	
	//Dans le cas des ventes, ainsi que la démarque et les transferts, la quantité peut-être négative.
	Set lStockRetour = ""
	Set lerreur = ""
	Set lData = ""
	//On ne sait pas à l'avance quelle colonne est concernée, d'où la necessité d'utiliser ces 5 variables
	//for i=1:1:5 {s var="LQTE"_i s @var=0}
	Set LQTE1=0
	Set LQTE2=0
	Set LQTE3=0
	Set LQTE4=0
	Set LQTE5=0

	Set LPA=0 
	Set lQteTotal = 0
	//On utilise ce booleen pour savoir si nous devons ou non bloqué le fichier
	Set LCREATION = 0

	//====== Partie Vitrine ======
	//Variable permettant de connaitre la quantité à mettre à jour dans la vitrine si le stock est inférieur au stock vitrine
	//lQteVitrine is reel = 0
	Set lQteAMVT = 0

	If (pPLU = "") || (pNUMCOL <= 0) || (+pQTE = 0)
	{
		Set lStockRetour = "Impossible de modifier la ligne de stock de l'article : "_pPLU_" à la colonne "_pNUMCOL_" pour une quantité de "_pQTE
	}
	Else
	{
		If +$DATA(@GUSTOCK@(pPLU))=0
		{
			//s var="LQTE"_pNUMCOL
			//s @var=$Normalize(pQTE,5)
			If pNUMCOL=1 Set LQTE1=$NORMALIZE(pQTE,5)
			If pNUMCOL=2 Set LQTE2=$NORMALIZE(pQTE,5)
			If pNUMCOL=3 Set LQTE3=$NORMALIZE(pQTE,5)
			If pNUMCOL=4 Set LQTE4=$NORMALIZE(pQTE,5)
			If pNUMCOL=5 Set LQTE5=$NORMALIZE(pQTE,5)
		}
		Else
		{
			//On modifie la quantité concernée
			Set lData = $GET(@GUSTOCK@(pPLU))
			Set LQTE1 = +$NORMALIZE($PIECE(lData,"\",1),5) //Quantité de l'inventaire	
			Set LQTE2 = +$NORMALIZE($PIECE(lData,"\",2),5) //Quantité des Ventes
			Set LQTE3 = +$NORMALIZE($PIECE(lData,"\",3),5) //Quantité des réceptions
			Set LQTE4 = +$NORMALIZE($PIECE(lData,"\",4),5) //Quantité des transfert intersites
			Set LQTE5 = +$NORMALIZE($PIECE(lData,"\",5),5) //Quantité de la démarque
			
			// Le code ci-dessous ne fonctionne pas ; je ne me l'explique pas
			// Du coup je le fais à la bourrin sur 5 lignes
			;s var="LQTE"_pNUMCOL
			;s @var=+(@var)+$Normalize(pQTE,5)
			If pNUMCOL=1 Set LQTE1=+LQTE1+$NORMALIZE(pQTE,5)
			If pNUMCOL=2 Set LQTE2=+LQTE2+$NORMALIZE(pQTE,5)
			If pNUMCOL=3 Set LQTE3=+LQTE3+$NORMALIZE(pQTE,5)
			If pNUMCOL=4 Set LQTE4=+LQTE4+$NORMALIZE(pQTE,5)
			If pNUMCOL=5 Set LQTE5=+LQTE5+$NORMALIZE(pQTE,5)
						
			Set LCREATION = 0
		}
		
		//On calcul ensuite le total trouvé
		Set lQteTotal = LQTE1 + LQTE2 + LQTE3 + LQTE4 + LQTE5
		Set lQteTotal = $NORMALIZE(lQteTotal,5)

		//On bloque le fichier dans le cas d'une modification
		If LCREATION=0 ZA @GUSTOCK

		//On crée la ligne de stock
		Set lData = LQTE1_"\"_LQTE2_"\"_LQTE3_"\"_LQTE4_"\"_LQTE5_"\"_lQteTotal_"\"_$HOROLOG_"\"_"1"
		//On sauve la ligne de stock : s'il elle existe elle est écrasée sinon elle est créée
		Set @GUSTOCK@(pPLU)=lData
		
		//On débloque le fichier dans le cas d'une modification
		If LCREATION=0 ZD @GUSTOCK
		
		//De plus, comme nous venon de créer une nouvelle ligne de stock alors nous devons aussi ajouter la ligne d'index des secteur/famille
		If pSecteur = ""
		{
			//Nous devons rechercher le secteur et la famille du PLU concerné pour ajouter le nouvel enregistrement
			//Cas des coupons:
			Set lDesignation = $GET(@FILEPLU@(pPLU))
			If lDesignation'=""
			{
				//on recherche les données de cet article
				Set lDataPLU = $GET(@FILEARTICLE@(lDesignation))
				If lDataPLU'=""
				{
					//on peut prendre le secteur et la famille
					Set pSecteur = $PIECE(lDataPLU,"\",4)
					Set pFamille = $PIECE(lDataPLU,"\",7)
					/*
					IF :gcClassif THEN
						_Secteur = ExtractString(lDataPLU,23,::cstcSeparateurDonnees)
						_Famille = ExtractString(lDataPLU,24,::cstcSeparateurDonnees)
					ELSE
						_Secteur = ExtractString(lDataPLU,4,::cstcSeparateurDonnees)
						_Famille = ExtractString(lDataPLU,7,::cstcSeparateurDonnees)
					END		*/
						
					//Nous devons prendr eaussi en compte le statut de chaque article pour l'affichage
					//Date CACHE Hors Collection
					Set lDateHC = +$PIECE(lDataPLU,"\",5)
					//Date CACHE stop
					Set lDateSTOP = +$PIECE(lDataPLU,"\",3)
					Set lStatut = ""
					If lDateHC = 0
					{
						If lDateSTOP = 0 {Set lStatut = cstcTypeProduitIN}
						Else
						{
							//Si la date stop est égale au 31/12/2049 alors c'est un stop
							If lDateSTOP = 76336 {Set lStatut = cstcTypeProduitSTOP}
							Else {Set lStatut = cstcTypeProduitOUT}
						}
					}
					Else
					{
						Set lStatut = cstcTypeProduitOUT
					}
							
					//Ajout du prix d'achat dans la table d'index des secteurs/famille
					Set LPA = +$PIECE(lDataPLU,"\",13)
					Set lStatut = lStatut_"\"_LPA
					
					If (pSecteur'="")&&(pFamille'="") Set @GUSECTFAMPLU@(pSecteur,pFamille,pPLU)=lStatut
				}
			}
		}
	}

	Quit lStockRetour
}

ClassMethod PGConvMag(pCodeMag As %String) As %String
{
	Set HWCAPPOS="^[""USER""]HWCAPPOS"
	Set sNomMag = $GET(@HWCAPPOS@($EXTRACT(pCodeMag,1,1)))_$EXTRACT(pCodeMag,2,4)

	Quit sNomMag
}

ClassMethod PGModifGUVITRINE(pPLU As %String, pQTE As %Numeric, pPA As %Numeric, pPV As %Numeric, pREMARQUE As %String = "", pIDGRPVIT As %Numeric = 0) As %String
{
	//================= Ligne de stock type ================
	// ^GUVITRINE(PLU) = QTE\PA\PV\LASTUPDATE
	//Ces données sont mises à jour à chaque modification du stock du PLU concerné.
	//======================================================
	//On ajoute aussi un type de vitrine maintenant
	//======================================================
	// ^GUVITGRP(IdGroupe,libelle) = User/Date
	// ^GUVITGRPDETAIL(IdGroupe,PLU)=QTE
	//======================================================
	Set GUVITRINE="^[""USER""]GUVITRINE"
	Set GUVITGRP="^[""USER""]GUVITGRP"
	Set GUVITGRPDETAIL="^[""USER""]GUVITGRPDETAIL"

	//Dans le cas des ventes, ainsi que la démarque et les transferts, la quantité peut-être négative.
	Set ValRetour = 1

	Set lerreur = ""
	Set lData = ""
	//On ne sait pas à l'avance quelle colonne est concernée, d'où la necessité d'utiliser ces 5 variables
	Set lQteActuelle = 0
	Set LCREATION = 0

	If (pPLU="")||(+pQTE=0)
	{
		Set ValRetour = 0
	}
	Else
	{
		If +$DATA(@GUVITRINE@(pPLU))=0 {Set LCREATION=1}
		Else
		{
			Set lData = $GET(@GUVITRINE@(pPLU))
			Set lQteActuelle = $PIECE(lData,"\",1)
		}
		
		Set lQteActuelle = +lQteActuelle + pQTE
		
		
		If LCREATION = 0
		{
			//On bloque le fichier dans le cas d'une modification
			ZA @GUVITRINE@(pPLU)
		}
		
		If lQteActuelle <=0
		{
			Kill @GUVITRINE@(pPLU)
		}
		Else
		{
			//On crée ou on met à jour la ligne de stock
			Set lData = lQteActuelle_"\"_pPA_"\"_pPV_"\"_$HOROLOG_"\"_pREMARQUE
			Set @GUVITRINE@(pPLU)=lData
		}
			
		If LCREATION = 0
		{
			//On débloque le fichier dans le cas d'une modification
			ZD @GUVITRINE@(pPLU)
		}
		
		//Ensuite on traite le groupe de la vitrine
		If pIDGRPVIT > 0
		{
			Set lQteActuelle = 0
			If +$DATA(@GUVITGRPDETAIL@(pIDGRPVIT,pPLU))=0
			{
				//Nous devons ajouter une nouvelle ligne de stock Vitrine		
				Set LCREATION = Vrai
			}
			Else
			{
				//On modifie la quantité concernée
				Set LCREATION = 0
				Set lData = $GET(@GUVITGRPDETAIL@(pIDGRPVIT,pPLU))
				Set lQteActuelle = $PIECE(lData,"\",1)
			}
			
			Set lQteActuelle = +lQteActuelle + pQTE
			
			If LCREATION = 0
			{
				//On bloque le fichier dans le cas d'une modification
				ZA @GUVITGRPDETAIL@(pIDGRPVIT,pPLU)
			}
			
			If lQteActuelle <=0
			{
				Kill @GUVITGRPDETAIL@(pIDGRPVIT,pPLU)
			}
			Else
			{
				//On crée ou on met à jour la ligne de stock
				Set lData = lQteActuelle
				Set @GUVITGRPDETAIL@(pIDGRPVIT,pPLU)=lData
			}
			
			If LCREATION = 0
			{
				//On débloque le fichier dans le cas d'une modification
				ZD @GUVITGRPDETAIL@(pIDGRPVIT,pPLU)
			}
		}	
	}

	Quit ValRetour
}

ClassMethod PGAjoutGUMVT(pParamGlobal As %String, pVerbose As %Numeric = 1) As %String
{
	Set response = {}
	Set response.ERR = ""
	Set response.bERREUR = 0
	Set response.lMvtRetour = ""

	Set cstcTypeMVTNumRecPlus = 11
	Set cstcTypeMVTNumRecMoins = 12
	Set cstcTypeMVTNumCoupon = 27
	Set cstcTypeMVTNumRAZ = 30
	Set cstcTypeMVTNumVitRebus = 22
	Set cstcTypeMVTNumVitReal = 20
	Set cstcTypeMVTNumVitRet = 21
		
	;PROCÉDURE cProcAjoutGUMVT(
	;_CNSX, => REMPLACER PAR LE MAGASIN COURANT
	;_USER is string,
	;_PLU is string,
	;_TYPE is string,
	;_QTE is réel,
	;_REMARQUE"",
	;_MAGFROM"",
	;_MAGTO"",
	;_NUMDOC"",
	;_NATURESINISTRE"",
	;_DATESINITRE0,
	;_PV is réel = 0,
	;_PA is réel = 0,
	;_REMISE is réel = 1,
	;_DATEMVT,
	;_HEUREMVT,
	;_NUMBL"",
	;_IDGRP"",
	;_EMP is string ="",
	;_EMPORIGINE"")

	Set HWINFO="^[""USER""]HWINFO"
	Set FILEPLU="^[""USER""]SP"
	Set FILEARTICLE="^[""USER""]ST"
	Set GUMVTTYPE="^[""USER""]GUMVTTYPE"
	Set GUMVT="^[""USER""]GUMVT"
	Set MODGUMVT="^[""USER""]MODGUMVT"
	Set GUSTOCK="^[""USER""]GUSTOCK"
	Set GUSINISTRE="^[""USER""]GUSINISTRE"
	Set GULOG="^[""USER""]GULOG"
	Set MODGULOG="^[""USER""]MODGULOG"
	Set FABIEN="^[""USER""]FABIEN"
	Set tmpTM = "^[""USER""]tmpTM"
	Set ldata=""

	//Variables passées en paramètre
	Set param={}
	Set param.MAG = $PIECE(pParamGlobal,"_||_",1)
	Set param.USER = $PIECE(pParamGlobal,"_||_",2)
	Set param.PLU = ..PGRenvoiPLURouleau($PIECE(pParamGlobal,"_||_",3))
	Set param.PLURouleau = $PIECE(pParamGlobal,"_||_",4)
	Set param.TYPE = $PIECE(pParamGlobal,"_||_",5)
	Set param.QTE = $NORMALIZE($PIECE(pParamGlobal,"_||_",6),5)
	Set param.REMARQUE = $PIECE(pParamGlobal,"_||_",7)
	Set param.MAGFROM = $PIECE(pParamGlobal,"_||_",8)
	Set param.MAGTO = $PIECE(pParamGlobal,"_||_",9)
	Set param.NUMDOC = $PIECE(pParamGlobal,"_||_",10)
	Set param.NATURESINISTRE = $PIECE(pParamGlobal,"_||_",11)
	Set param.DATESINITRE = $PIECE(pParamGlobal,"_||_",12)
	//Ces 2 valeurs sont renseignées pour les articles génériques en caisse car on ne peut pas connaitre le prix à l'avance
	Set param.PV = +$PIECE(pParamGlobal,"_||_",13)
	Set param.PA = +$PIECE(pParamGlobal,"_||_",14)
	//Remise en caisse s'il y en une
	Set param.REMISE = +$PIECE(pParamGlobal,"_||_",15)
	Set param.DATEMVT = $PIECE(pParamGlobal,"_||_",16)
	Set param.HEUREMVT = $PIECE(pParamGlobal,"_||_",17)
	Set param.NUMBL = $PIECE(pParamGlobal,"_||_",18)
	//Groupe de vitrine
	Set param.IDGRP = $PIECE(pParamGlobal,"_||_",19)
	Set param.EMP = $PIECE(pParamGlobal,"_||_",20)			// NON UTILISE MAIS CONSERVE AU CAS OU
	Set param.EMPORIGINE = $PIECE(pParamGlobal,"_||_",21)		// NON UTILISE MAIS CONSERVE AU CAS OU
	
	// Exemple d'appel pour test
	//VENTE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||__||__||__||__||__||__||__||_
	//RECEPTION=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_11_||_0.8_||_Test Reception factice_||__||__||_85000_||__||__||__||__||__||__||__||_BL17_||__||_
	//RETRO=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_13_||_0.75_||_Test réception rétro_||_X999_||_M215_||_X999-RETRO-007_||__||__||__||__||__||__||__||__||__||_
	//SINISTRE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_26_||_1.1_||_Test sinistre_||__||__||__||_Incendie TEST_||_20200421_||__||__||__||__||__||__||__||_
	//VENTE GENERIQUE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||_9.45_||_2.21_||__||__||__||__||__||_
	//DATE MODIFIEE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||__||__||__||_65489_||_35000_||__||__||__||_
	//VITRINE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_20_||_0.2_||_Test vitrine_||__||__||__||__||__||__||__||__||__||__||__||_1_||__||_
	//INVENTAIRE TOURNANT+=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_33_||_0.65_||_Test mouvement inventaire tournant +_||__||__||__||__||__||__||__||__||__||__||__||__||_
	//w param.%ToJSON()_"    #######        "
	//Q sc

	//Données necessaires à l'enregistrement d'un mouvement
	Set lLibPLU = ""
	Set lDataPLU = ""
	//Prix d'achat du PLU
	Set lPA = ""
	//Prix de vente du PLU
	Set lPV = ""
	//Compteur de mouvement
	Set lCompteurMouvement = 0
	//Données du type de mouvements
	Set lDataMvt = ""
	//Sens de la transaction
	Set lSens = ""
	//Données du stock
	Set lDataStock = ""
	//Stock avant le mouvement
	Set lLastStock = 0
	//Date de mouvement
	Set lDateMVT = ""
	//Heure de mouvement
	Set lHeureMVT = ""
	//La colonne de quantité impactée par le type de mouvement
	Set lNumColonne = 0
	//Code du sinistre s'il y en a un
	Set lCodeSinitre = ""
	//Code coupon, son prix d'achat ainsi que son prix de vente utilisé dans le cas d'un mouvement coupon
	Set lCouponGU = ""
	Set lCouponPA = 0
	Set lCouponPV = 0
	Set lLastStockCoupon = 0

	//Quantité à mettre dans le mouvement
	Set lQuantite = 0
	//Secteur utilisé pour les coupons et si nous devons créer un nouvel enregistrement dans SECTFAMPLU
	Set lSecteur = ""
	//Familleutilisé pour la création d'un nouvel enregistrement dans SECTFAMPLU
	Set lFamille = ""

	//Nom du fichier
	Set lNomFicMVT = ""

	//Gestion des articles financiers
	Set bFinancier = 0

	//On vérifie que les données sont bien renseignées :
	If (param.PLU'="")&&(param.TYPE'="")
	{
		If +$DATA(@FILEPLU@(param.PLU))=0
		{
			//On recherche le PLU en question : 
			Set response.ERR = "Impossible d'ajouter le mouvement car le PLU : "_param.PLU_" n'existe pas."
			Set response.MVTRETOUR = "Le PLU "_param.PLU_" est inexistant dans le référentiel."
			Set response.bERREUR = 1
			Set @tmpTM@(pParamGlobal,"PLU inexistant") = ""
		}
		Else
		{
			//Le PLU existe bien dans la base de données
			//On prélève la désignatino du PLU
			Set llLibPLU = $GET(@FILEPLU@(param.PLU))
			Set lDataPLU = $GET(@FILEARTICLE@(llLibPLU))
			If lDataPLU = ""
			{
				Set response.ERR = "Impossible d'ajouter le mouvement car la désignation du PLU : "_param.PLU_" n'existe pas."
				Set response.MVTRETOUR = "La désignation du PLU "_param.PLU_" est inexistante."
				Set response.bERREUR = 1
				Set @tmpTM@(pParamGlobal,"Designation PLU inexistant") = ""
			}
			Else
			{
				If +$DATA(@FILEARTICLE@(llLibPLU,4))=0
				{
					//On test si l'article est géré en stock ou non
					Set response.ERR = "Impossible d'ajouter le mouvement car le PLU : "_param.PLU_" n'a pas de node 4 sur ^ST: on ne peut pas savoir si c'est une article financier."
					Set response.MVTRETOUR = "Le PLU "_param.PLU_" est inexistant dans le référentiel du node 4: On ne peut pas savoir si c'est un article financier."
					Set response.bERREUR = 1
					Set @tmpTM@(pParamGlobal,"Node4 inexistant") = ""
				}
				Else
				{
					If (+($PIECE($GET(@FILEARTICLE@(llLibPLU,4)),"\",6))=1) && (param.TYPE'=cstcTypeMVTNumRAZ)
					{
						//C'est un article financier et donc non géré en stock
						Set response.bERREUR = 1
						Set bFinancier = 1
						Set @tmpTM@(pParamGlobal,"Article financier") = ""
					}
					Else
					{
						//On extrait le prix d'achat et le prix de vente, ainsi que le secteur sauf dans le cas des articles génériques où le prix est fixé par la caissière lors de l'achat
						If param.PA'=0 {Set lPA = param.PA}
						Else {Set lPA=+..PGGetPrix($PIECE(lDataPLU,"\",13))}
						
						If param.PV'=0 {Set lPV = param.PV}
						Else {Set lPV=+..PGGetPrix($PIECE(lDataPLU,"\",22))}
						
						Set lSecteur = $PIECE(lDataPLU,"\",4)
						Set lFamille = $PIECE(lDataPLU,"\",7)
						
						/*
						IF :gcClassif THEN
							lSecteur = ExtractString(lDataPLU,23,::cstcSeparateurDonnees)
							lFamille = ExtractString(lDataPLU,24,::cstcSeparateurDonnees)	
						ELSE
							lSecteur = ExtractString(lDataPLU,4,::cstcSeparateurDonnees)
							lFamille = ExtractString(lDataPLU,7,::cstcSeparateurDonnees)
						END*/
					}
				}
			}
		}
		Set lQuantite = param.QTE

		//On recherche maintenant le sens du mouvement grace au code du type de mouvement
		Set lDataMvt = $GET(@GUMVTTYPE@(param.TYPE))
		If lDataMvt=""
		{
			Set response.ERR = "Impossible d'ajouter le mouvement car le type de mouvement "_param.TYPE_" n'existe pas dans le fichier "_GUMVTTYPE_" du magasin."
			Set response.MVTRETOUR = "Impossible d'ajouter le mouvement car le type de mouvement n'existe pas."
			Set response.bERREUR = 1
			Set @tmpTM@(pParamGlobal,"Mouvement inexistant") = ""
		}
		Else
		{
			Set lSens=+$PIECE(lDataMvt,"\",2)
			//Grace au sens, je met à jour la quantité en question
			If lSens'=0 Set param.QTE = +param.QTE * (+lSens)
			Set lNumColonne=$PIECE(lDataMvt,"\",1)
		}
		
		//Recherche du dernier stock
		Set lDataStock = $GET(@GUSTOCK@(param.PLU))
		If lDataStock'="" Set lLastStock = +($PIECE(lDataStock,"\",6))
					
		//Recherche si le sinistre en question existe bien
		If param.NATURESINISTRE '= ""
		{
			Set lCodeSinitre=""
		 	Set lCodeSinitre=$ORDER(@GUSINISTRE@(lCodeSinitre))
		 	While lCodeSinitre'=""
		 	{
			 	If $GET(@GUSINISTRE@(lCodeSinitre))=param.NATURESINISTRE Quit
			 	
				Set lCodeSinitre=$ORDER(@GUSINISTRE@(lCodeSinitre))
			}
			If lCodeSinitre="" Set lCodeSinitre = ..PGAjoutSinistre(param.NATURESINISTRE)
		}
		//============================================
		//================= COUPON ===================
		//Dans le cas des coupons, nous devons aussi réaliser l'entrée en stock du coupon en question
		If param.TYPE = cstcTypeMVTNumCoupon
		{
			Set lCouponGU = ..PGRechercheCoupon(param.PLU,lPV,lSecteur)
			If lCouponGU = ""
			{
				//Le coupon n'existe pas et c'est donc nous ne gérons pas l'erreur :
				Set response.ERR = "La transformation en coupon du PLU "_param.PLURouleau_" est impossible avec le prix de vente "_lPV_" car cet article n'est pas compatible."
				Set response.MVTRETOUR = "La transformation en coupon est impossible pour l'article "_param.PLURouleau_" car il est incompatible."
				Set response.bERREUR = 1
				Set @tmpTM@(pParamGlobal,"Coupon") = ""
			}
			Else
			{
				Set lCouponPA = $PIECE(lCouponGU,2,"\\_||_//")
				Set lCouponPV = $PIECE(lCouponGU,3,"\\_||_//")
				Set lCouponGU  = $PIECE(lCouponGU,1,"\\_||_//")
				//On recherche le dernier stock du coupon
				If +$DATA(@GUSTOCK@(lCouponGU))>0
				{
					Set lStockCoupon = $GET(@GUSTOCK@(lCouponGU))
					Set lLastStockCoupon = +$PIECE(lStockCoupon,"\",6)
				}
			}
		}
		//=============== Fin COUPON =================			
		//============================================			
			
		Set lDateMVT = $HOROLOG
		Set lHeureMVT = $PIECE(lDateMVT,",",2)
		Set lDateMVT = $PIECE(lDateMVT,",",1)
		If +param.DATEMVT > 0 Set lDateMVT = param.DATEMVT
		If +param.HEUREMVT > 0 Set lHeureMVT = param.HEUREMVT

		If response.bERREUR = 0
		{
			Set @tmpTM@(pParamGlobal,"PLU Pas d'erreur avt mvt") = ""
			//Nous sommes sûr de ne pas avoir d'erreur	
			//Ensuite, nous prélevons le prochain numéro d'incrémentation des mouvements que le mouvement
			Set lCompteurMouvement = +..PGRenvoiNumMvt(param.TYPE)
			
			//On construit la chaine
			Set ldata = lQuantite_"\"_	;1
						lPA_"\"_		;2	
						lPV_"\"_		;3
						lSens_"\"_		;4
						lLastStock_"\"_	;5
						param.MAGFROM_"\"_ ;6
						param.MAGTO_"\"_	;7
						param.NUMDOC_"\"_ ;8
						param.REMARQUE_"\"_ ;9
						lCodeSinitre_"\"_ ;10
						$ZDATEH(param.DATESINITRE,8,0,0,0,0,-1,-1,"")_"\"_ ;11
						param.USER_"\"_ ;12
						lHeureMVT_"\"_ ;13
						param.REMISE_"\"_ ;14
						param.EMP_"\"_ ;15
						param.EMPORIGINE ;16
		
			//Nous regardons si nous sommes ou non en mode cap cash ou non
			Set gcCapCash = +$GET(@HWINFO@("CAPCASH"))
						
			Set mercerie = 0
			If (+lSecteur=1)||(+lSecteur=2)||(+lSecteur=3)||(+lSecteur=5)||(+lSecteur=16) {Set mercerie = 0}
			Else {Set mercerie = 1}
			/*
			IF :gcClassif THEN
				IF Val(lSecteur) = 1 OR Val(lSecteur) = 2 OR Val(lSecteur) = 3 OR Val(lSecteur) = 5 OR Val(lSecteur) = 6 THEN
					mercerie = Faux
				ELSE
					mercerie = Vrai
				END
			ELSE
				IF Val(lSecteur) = 1 OR Val(lSecteur) = 2 OR Val(lSecteur) = 3 OR Val(lSecteur) = 5 OR Val(lSecteur) = 16 THEN
					mercerie = Faux
				ELSE
					mercerie = Vrai
				END
			END */

			//On crée le MODIO ou le MODIOTMP
			Set @tmpTM@(pParamGlobal,"génération mvt") = ldata
			If param.TYPE = cstcTypeMVTNumRecPlus 
			{						
				Set response.lMvtRetour = ..PGAjoutGURECEPT(param.NUMDOC,lLibPLU,lQuantite,param.NUMBL)			
			}
			If param.TYPE = cstcTypeMVTNumRecMoins
			{
				Set response.lMvtRetour = ..PGEnleveGURECEPT(param.NUMDOC,lLibPLU,lQuantite,param.NUMBL)						
			}
			If response.lMvtRetour '= "" Quit response.%ToJSON()
			Set @tmpTM@(pParamGlobal,"EcritureMvt")=""
			//On bloque le fichier de mouvements pour transfert: en effet, le logiciel POSCOMM risque de les supprimer sans les envoyer en .GSA sinon.
			ZA @MODGUMVT
			
			//On sauve la donnée
			Set @GUMVT@(lDateMVT,param.PLURouleau,param.TYPE,lCompteurMouvement)=ldata
		
		 	//si nous sommes en mode capcash alors nous devons également sauvegarder dans un fichier texte les mouvements
		 	Set bContinue = 0 // Sert plus bas pour la fermeture du fichier
			If gcCapCash = 1
			{
				//On récupère le dossier de mouvement
				Set gcsDossierInterfaceMVT = $GET(@HWINFO@("INT_MVTSTOCK"))
				
				Set bContinue = 1
				If gcsDossierInterfaceMVT="" Set bContinue = 0
				If param.TYPEMVT = 1 Set bContinue = 0
				If param.TYPEMVT = 2 Set bContinue = 0
				If param.TYPEMVT = 3 Set bContinue = 0
				If param.TYPEMVT = 4 Set bContinue = 0
				If param.TYPEMVT = 20 Set bContinue = 0
				If param.TYPEMVT = 21 Set bContinue = 0
				If param.TYPEMVT = 35 Set bContinue = 0
				If param.TYPEMVT = 36 Set bContinue = 0

				//Nous ne créons pas de fichier mouvement pour les ventes, retour marchandise, annulation ticket +et -, les mouvements de vitrine
				If bContinue = 1
				{
					Set sNomMag=..PGConvMag(param.MAG)
					Set lNomFicMVT = "MvtStock"_$ZDATE(+$HOROLOG,8)_$REPLACE($ZTIME($HOROLOG),":","")_"_"_sNomMag
					Set lNomFicMVTFinal = lNomFicMVT_".txt"
					
					If '##class(%Library.File).DirectoryExists(gcsDossierInterfaceMVT) Do ##class(%Library.File).CreateDirectory(gcsDossierInterfaceMVT)
					Set file=##class(%Library.File).%New(gcsDossierInterfaceMVT_"\"_lNomFicMVTFinal)
	 				Do file.Open("WSNK")
					Do file.WriteLine(sNomMag_"\"_param.PLU_"\"_param.QTE_"\")
					Do file.Close()	 
				}
			}
			//on crée le ^MODGUMVT		
			Set @tmpTM@(pParamGlobal,"CreationMODGUMVT")=""	
			//Le MODGUMVT diffère du GUMVT sur le type de sinistre car on met la description du sinistre et non son type
			If param.NATURESINISTRE '= "" 
			{
				Set $PIECE(ldata,"\",16) = param.NATURESINISTRE
			}
			Set @MODGUMVT@(param.MAG,lDateMVT,param.PLURouleau,param.TYPE,lCompteurMouvement)=ldata
			
			//Dans le cas Coupon on créé un autre mouvement mais positif pour le coupon en question mais seulement de 1 mètre car un coupon est calculé à l'unité et non au métrage
			If (param.TYPE = cstcTypeMVTNumCoupon) && (lCouponGU '= "")
			{
				Set ldata = "1"_"\"_lCouponPA_"\"_lCouponPV_"\"_"1"_"\"_lLastStockCoupon_"\"_param.MAGFROM_"\"_param.MAGTO_"\"_param.NUMDOC_"\"_param.REMARQUE_"\"_lCodeSinitre_"\"_$ZDATEH(param.DATESINITRE,8,0,0,0,0,-1,-1,"")_"\"_param.USER_"\"_lHeureMVT_"\"_param.REMISE_"\"_param.EMP_"\"_param.EMPORIGINE
			    Set lCompteurMouvement=lCompteurMouvement+1
			    Set @tmpTM@(pParamGlobal,"CreationGUMVT")=""
			    Set @GUMVT@(lDateMVT,lCouponGU,param.TYPE,lCompteurMouvement)=ldata
			    Set @MODGUMVT@(param.MAG,lDateMVT,lCouponGU,param.TYPE,lCompteurMouvement)=ldata
				
				If bContinue = 1 Do file.WriteLine(sNomMag_"\"_lCouponGU_"\1\")
			}
			If bContinue = 1 Do file.Close()
			
			//On débloque le fichier de mouvements pour transfert	
			ZD @MODGUMVT	
			
			
			//On met à jour ensuite le stock si ce n'est pas un mouvement nul (exemple: mise en vitrine)
			If +lSens '= 0
			{
				Set response.lMvtRetour = ..PGModifGUSTOCK(param.PLU,lNumColonne,param.QTE,ldata,lSecteur,lFamille)
				
				If (param.TYPE = cstcTypeMVTNumCoupon) && (response.lMvtRetour="")
				{
					//Dans le cas d'un coupon on met aussi à jour la quantité du stock du coupon en ajoutant 1
					Set param.QTE = 1
					Set response.lMvtRetour = ..PGModifGUSTOCK(lCouponGU,lNumColonne,param.QTE,ldata,"","")	
					If response.lMvtRetour = "" Set response.lMvtRetour = "COUPON:"+lCouponGU
				}
				If param.TYPE = cstcTypeMVTNumVitRebus
				{
					//Dans le cas du mouvement de rebus de la vitrine nous devons aussi enlever le stock vitrine
					Set lQuantite = ((+lQuantite)*-1)
					Do ..PGModifGUVITRINE(param.PLURouleau,lQuantite,lPA,lPV,"",param.IDGRP)	
				}
			}
			Else
			{
				//Dans le cas des vitrines alors on met à jour le stock correspondant :
				If param.TYPE = cstcTypeMVTNumVitReal
				{
					//dans le cas d'une réalisation de vitrine on doit ajouter du stock dans le stock vitrine
					Do ..PGModifGUVITRINE(param.PLURouleau,lQuantite,lPA,lPV,param.REMARQUE,param.IDGRP)		
				}
				If param.TYPE = cstcTypeMVTNumVitRet
				{
					Set lQuantite = (+lQuantite) * -1
					//dans le cas d'un retour en Vente de la vitrine au magasin on doit enlever du stock dans le stock vitrine
					Do ..PGModifGUVITRINE(param.PLURouleau,lQuantite,lPA,lPV,"",param.IDGRP)	
				}
			}								
		}
	}	
	Else
	{
		Set response.ERR = "Impossible d'ajouter le mouvement "_param.TYPE_" pour le PLU : "_param.PLURouleau_" et la quantité "_param.QTE_"."
		Set response.MVTRETOUR = response.ERR
		Set response.bERREUR = 1
	}		

	If (response.bERREUR = 1) && (bFinancier = 0)
	{
		Set lerreur2=""
		Set lerreur3=""
		Set lerreur4=""
		
		//============ GESTION DES ERREURS ===========
		Set lerreur2 = lerreur2_$CHAR(13,10)_"NODES : "_$CHAR(13,10)_$CHAR(9)_"- Date mvt = "_lDateMVT_$CHAR(13,10)_$CHAR(9)_"- PLU : "_param.PLURouleau_$CHAR(13,10)_$CHAR(9)_"- Type : "_param.TYPE_$CHAR(13,10)_$CHAR(9)_"- Numéro de mouvement : "_lCompteurMouvement_$CHAR(13,10)_$CHAR(13,10)_"DETAILS : "_$CHAR(13,10)_$CHAR(9)_"- Quantité : "_param.QTE_$CHAR(13,10)_$CHAR(9)_"- PA : "_lPA_$CHAR(13,10)_$CHAR(9)_"- PV : "_lPV
		Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Sens : "_lSens_$CHAR(13,10)_$CHAR(9)_"- Stock préced : "_lLastStock_$CHAR(13,10)_$CHAR(9)_"- Remise : "_param.REMISE
		If param.MAGFROM '= "" Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Origine : "_param.MAGFROM					
		If param.MAGTO '= "" Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Dest : "_param.MAGTO					
		If param.NUMDOC '= "" Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Doc : "_param.NUMDOC					
		If param.REMARQUE '= "" Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Rmq : "_param.REMARQUE				
		If param.NATURESINISTRE '= ""
		{
			Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Sinistre : "_param.NATURESINISTRE			
			If param.DATESINISTRE Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Date sinistre : "_param.DATESINISTRE
		}
		Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Utilisateur : "_param.USER			
		Set lerreur2 = lerreur2_$CHAR(13,10)_$CHAR(9)_"- Heure de mouvement : "_lHeureMVT				
		
		Set lerreur3 = $CHAR(13,10)_$CHAR(13,10)_"Les mouvements qui n'ont pas été ajoutés sont les suivants (attention ils comportent les erreurs vu ci-dessus, il faut donc les corriger) : "
		Set lerreur3 = lerreur3_$CHAR(13,10)_$CHAR(9)_"- MVT mag : " + "s "_GUMVT_"("_lDateMVT_","_param.PLURouleau_","_param.TYPE_","_lCompteurMouvement_")="_ldata
		If param.NATURESINISTRE '= "" Set ldata = lQuantite_"\"_lPA_"\"_lPV_"\"_lSens_"\"_lLastStock_"\"_param.MAGFROM_"\"_param.MAGTO_"\"_param.NUMDOC_"\"_param.REMARQUE_"\"_param.NATURESINISTRE_"\"_$ZDATEH(param.DATESINITRE,8,0,0,0,0,-1,-1,"")_"\"_param.USER_"\"_lHeureMVT_"\"_param.REMISE_"\"_param.EMPORIGINE
		Set lerreur3 = lerreur3_$CHAR(13,10)_$CHAR(9)_"- MVT centrale : "_"s "_MODGUMVT_"("_param.MAG_","_lDateMVT_","_param.PLURouleau_","_param.TYPE_","_lCompteurMouvement_")="_ldata
		
		Set lerreur4 = $CHAR(13,10)_$CHAR(13,10)_"ATTENTION : "_$CHAR(13,10)_$CHAR(9)_"Tous les mouvements qui sont créés par la CAISSE (vente ou avoir) ou POSBO (réception de commande ou annulation de ticket) sont à recréer en dur dans la base de données avec CACHE après résolution du problème."
		Set lerreur4 = lerreur4_$CHAR(13,10)_$CHAR(13,10)_$CHAR(9)_"Tous les mouvements qui sont créés par GEST peuvent être recréés dans le logiciel en question après résolution du problème."
		
		Set @GULOG@("IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=response.ERR
		Set @GULOG@(param.MAG,"IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=response.ERR
		
		If lerreur2'=""
		{
			Set @GULOG@("IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur2
			Set @GULOG@(param.MAG,"IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur2
		}
		If lerreur3'=""
		{
			Set @GULOG@("IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur3
			Set @GULOG@(param.MAG,"IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur3
		}
		If lerreur4'=""
		{
			Set @GULOG@("IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur4
			Set @GULOG@(param.MAG,"IRIS","RoutineAjoutGUMVT",$ZDATE(+$HOROLOG,8)_" "_$REPLACE($ZTIME($HOROLOG),":",""),1)=lerreur4
		}
		//============ FIN DE LA GESTION DES ERREURS ===========
	}
	
	If pVerbose=1 Write response.%ToJSON() 
	
	Return response.ERR
}

ClassMethod SaveRetroBUG(pGLOBAL As %String, NumCMD As %String, MagSrc As %String, MagDest As %String, pLogin As %String, pE2 As %Boolean) As %Status
{
	Set sc=$$$OK

	Set MAGRETRO="^[""USER""]"_pGLOBAL
	Set MODMAGRETRO="^[""USER""]MOD"_pGLOBAL
	Set HWINFO="^[""USER""]HWINFO"
	Set HWINFO="^[""USER""]HWINFO"
	Set MAGCMDEDI="^[""USER""]MAGCMDEDI"
	Set MODEDICMDSUIVI="^[""USER""]MODEDICMDSUIVI"
	Set MODMAGBCISTATUT="^[""USER""]MODMAGBCISTATUT"
	Set bEstFranchise=+$GET(@HWINFO@("ESTFRANCHISE"))
	Set RETROBUG="^[""USER""]RETROBUG"
	Set TMPTHEOKO="^[""USER""]TMPTHEOKO"
	
	Set cstNumRecepRetro=13
	Set cstNumReceptRetroFranchise=13.5
	
	Set responseSaveRetro = {}
	Set responseSaveRetro.ERR = ""

	ZA @MAGRETRO
	ZA @MODMAGRETRO
	
	Set ListCmdBCI = ""
	
	Set cpt=0
		
		If NumCMD '=""
		{
			// Permet de savoir si nous trouvons au moins une rétrocession => juste affiche sur smartphone
			Set cpt=cpt+1
			
			//I +$D(@MAGRETRO@("LIV",NumCMD))<=0
			//{
		//		I bEstFranchise=1 {s responseSaveRetro.ERR="Transfert vente déjà réceptionné sur un autre poste."}
	//			else {s responseSaveRetro.ERR="Rétrocession déjà réceptionnée sur un autre poste."}
	//		}
	//		else
		//	{
				Set @RETROBUG@("1")=NumCMD_"/*/"_MagSrc_"/*/"_MagDest
				Set strData = $GET(@MAGRETRO@("FAX",NumCMD,MagSrc,MagDest,0))
				Set NbLigne = +$PIECE(strData,"\",1)
				Set TotalQte = $PIECE(strData,"\",2)
				Set Valorisation = $PIECE(strData,"\",3)
				Set CodeTransporteur = $PIECE(strData,"\",7)
				Set lRemarque = $PIECE(strData,"\",8)
				
				Set DateRetro = +$PIECE($HOROLOG,",",1)
				Set HeureRetro = +$PIECE($HOROLOG,",",2)
				Set sDataRetro = NbLigne_"\"_TotalQte_"\"_Valorisation_"\"_pLogin_"\"_$ZDATE(DateRetro,8)_"\"_$REPLACE($ZTIME(HeureRetro),":","")_"\"_CodeTransporteur_"\"_lRemarque
				
				//Enregistrement de l'entête de la commande
				//s @MAGRETRO@("LIV",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,0)=sDataRetro
				//La gestion des MOD est fait de telle sorte que le premier node doit toujours se référer au magasin source.
				//s @MODMAGRETRO@(valeur.MAGDEST,"LIV",valeur.NUMCMD,valeur.MAGSRC,valeur.MAGDEST,0)=sDataRetro
				//s valeur.RETRO = 1
				
				Set sTypeMvt = cstNumRecepRetro
				If bEstFranchise = 1 Set sTypeMvt = cstNumReceptRetroFranchise
				
			 	// Gestion des commandes BCI pour les rétrocession de CONFECTION
			 	If pGLOBAL = "MAGRETROCONF"
			 	{
			 		If +$LENGTH($PIECE(strData,"\",11))=13 Set ListCmdBCI = ListCmdBCI_$PIECE(strData,"\",11)_";"
			 	}
		
				//Nous devons également créer les lignes de mouvements pour les lignes détails de rétrocessions concernées
				Set lIdLigne="0"
				Set iNbArticle=0
			 	Set lIdLigne=$ORDER(@MAGRETRO@("CMD",NumCMD,MagSrc,MagDest,lIdLigne))
			 	While lIdLigne'=""
			 	{
				 	Set DataLigneRetro=$GET(@MAGRETRO@("CMD",NumCMD,MagSrc,MagDest,lIdLigne))
				 	Set iNbArticle=iNbArticle+1
				 	
				 	Set Plu=$PIECE(DataLigneRetro,"\",1)
				 	Set @RETROBUG@("2")=Plu
				 	Set PLUBUG=""
				 	Set PLUBUG=+$DATA(@TMPTHEOKO@(Plu))
				 	If PLUBUG>0
				 	{
					 	Set @RETROBUG@(Plu)=""
					 	////////////////////////////////////
				 		Set QteCmd=$PIECE(DataLigneRetro,"\",2)
				 		If QteCmd'=0
				 		{
						 	Set CMDGSI=$PIECE(DataLigneRetro,"\",14)
					 		Set NUMCMD=$PIECE(DataLigneRetro,"\",5)
					 		Set EDTEDI=0
					 		If CMDGSI'="" Set EDTEDI=1
						 	
							Set sParam = MagDest_"_||_"_pLogin_"_||_"_Plu_"_||_"_Plu_"_||_"_sTypeMvt_"_||_"_QteCmd_"_||_"_lRemarque_"_||_"_MagSrc_"_||_"_MagDest_"_||_"_NumCMD
					 		Set retErr = ..PGAjoutGUMVTBUG(sParam, 0)
					 		If retErr '= ""
					 		{
							 	If responseSaveRetro.ERR '= "" Set responseSaveRetro.ERR = ", "
						 		Set responseSaveRetro.ERR = responseSaveRetro.ERR_retErr 
					 		}
				 		}
				 	}
				 	Set lIdLigne=$ORDER(@MAGRETRO@("CMD",NumCMD,MagSrc,MagDest,lIdLigne))
				}
			//}
		}
	
	//Déblocage du fichier
	ZD @MODMAGRETRO
	ZD @MAGRETRO
	
	If cpt'=0 Set responseSaveRetro.ERR = "OK c'est bon"

	Write responseSaveRetro.%ToJSON()
	Return sc
}

ClassMethod PGAjoutGUMVTBUG(pParamGlobal As %String, pVerbose As %Numeric = 1) As %String
{
	Set response = {}
	Set response.ERR = ""
	Set response.bERREUR = 0
	Set response.lMvtRetour = ""

	Set cstcTypeMVTNumRecPlus = 11
	Set cstcTypeMVTNumRecMoins = 12
	Set cstcTypeMVTNumCoupon = 27
	Set cstcTypeMVTNumRAZ = 30
	Set cstcTypeMVTNumVitRebus = 22
	Set cstcTypeMVTNumVitReal = 20
	Set cstcTypeMVTNumVitRet = 21
		
	;PROCÉDURE cProcAjoutGUMVT(
	;_CNSX, => REMPLACER PAR LE MAGASIN COURANT
	;_USER is string,
	;_PLU is string,
	;_TYPE is string,
	;_QTE is réel,
	;_REMARQUE"",
	;_MAGFROM"",
	;_MAGTO"",
	;_NUMDOC"",
	;_NATURESINISTRE"",
	;_DATESINITRE0,
	;_PV is réel = 0,
	;_PA is réel = 0,
	;_REMISE is réel = 1,
	;_DATEMVT,
	;_HEUREMVT,
	;_NUMBL"",
	;_IDGRP"",
	;_EMP is string ="",
	;_EMPORIGINE"")

	Set HWINFO="^[""USER""]HWINFO"
	Set FILEPLU="^[""USER""]SP"
	Set FILEARTICLE="^[""USER""]ST"
	Set GUMVTTYPE="^[""USER""]GUMVTTYPE"
	Set GUMVT="^[""USER""]GUMVT"
	Set MODGUMVT="^[""USER""]MODGUMVT"
	Set GUSTOCK="^[""USER""]GUSTOCK"
	Set GUSINISTRE="^[""USER""]GUSINISTRE"
	Set GULOG="^[""USER""]GULOG"
	Set MODGULOG="^[""USER""]MODGULOG"
	
	Set ldata=""

	//Variables passées en paramètre
	Set param={}
	Set param.MAG = $PIECE(pParamGlobal,"_||_",1)
	Set param.USER = $PIECE(pParamGlobal,"_||_",2)
	Set param.PLU = ..PGRenvoiPLURouleau($PIECE(pParamGlobal,"_||_",3))
	Set param.PLURouleau = $PIECE(pParamGlobal,"_||_",4)
	Set param.TYPE = $PIECE(pParamGlobal,"_||_",5)
	Set param.QTE = $NORMALIZE($PIECE(pParamGlobal,"_||_",6),5)
	Set param.REMARQUE = $PIECE(pParamGlobal,"_||_",7)
	Set param.MAGFROM = $PIECE(pParamGlobal,"_||_",8)
	Set param.MAGTO = $PIECE(pParamGlobal,"_||_",9)
	Set param.NUMDOC = $PIECE(pParamGlobal,"_||_",10)
	Set param.NATURESINISTRE = $PIECE(pParamGlobal,"_||_",11)
	Set param.DATESINITRE = $PIECE(pParamGlobal,"_||_",12)
	//Ces 2 valeurs sont renseignées pour les articles génériques en caisse car on ne peut pas connaitre le prix à l'avance
	Set param.PV = +$PIECE(pParamGlobal,"_||_",13)
	Set param.PA = +$PIECE(pParamGlobal,"_||_",14)
	//Remise en caisse s'il y en une
	Set param.REMISE = +$PIECE(pParamGlobal,"_||_",15)
	Set param.DATEMVT = $PIECE(pParamGlobal,"_||_",16)
	Set param.HEUREMVT = $PIECE(pParamGlobal,"_||_",17)
	Set param.NUMBL = $PIECE(pParamGlobal,"_||_",18)
	//Groupe de vitrine
	Set param.IDGRP = $PIECE(pParamGlobal,"_||_",19)
	Set param.EMP = $PIECE(pParamGlobal,"_||_",20)			// NON UTILISE MAIS CONSERVE AU CAS OU
	Set param.EMPORIGINE = $PIECE(pParamGlobal,"_||_",21)		// NON UTILISE MAIS CONSERVE AU CAS OU
	
	// Exemple d'appel pour test
	//VENTE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||__||__||__||__||__||__||__||_
	//RECEPTION=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_11_||_0.8_||_Test Reception factice_||__||__||_85000_||__||__||__||__||__||__||__||_BL17_||__||_
	//RETRO=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_13_||_0.75_||_Test réception rétro_||_X999_||_M215_||_X999-RETRO-007_||__||__||__||__||__||__||__||__||__||_
	//SINISTRE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_26_||_1.1_||_Test sinistre_||__||__||__||_Incendie TEST_||_20200421_||__||__||__||__||__||__||__||_
	//VENTE GENERIQUE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||_9.45_||_2.21_||__||__||__||__||__||_
	//DATE MODIFIEE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_1_||_0.2_||_Test mouvement_||__||__||__||__||__||__||__||__||_65489_||_35000_||__||__||__||_
	//VITRINE=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_20_||_0.2_||_Test vitrine_||__||__||__||__||__||__||__||__||__||__||__||_1_||__||_
	//INVENTAIRE TOURNANT+=http://192.168.1.100:57772/rest/FusionMobile/PG/AjoutGUMVT/M215_||_François_||_1500_||_1500_||_33_||_0.65_||_Test mouvement inventaire tournant +_||__||__||__||__||__||__||__||__||__||__||__||__||_
	//w param.%ToJSON()_"    #######        "
	//Q sc

	//Données necessaires à l'enregistrement d'un mouvement
	Set lLibPLU = ""
	Set lDataPLU = ""
	//Prix d'achat du PLU
	Set lPA = ""
	//Prix de vente du PLU
	Set lPV = ""
	//Compteur de mouvement
	Set lCompteurMouvement = 0
	//Données du type de mouvements
	Set lDataMvt = ""
	//Sens de la transaction
	Set lSens = ""
	//Données du stock
	Set lDataStock = ""
	//Stock avant le mouvement
	Set lLastStock = 0
	//Date de mouvement
	Set lDateMVT = ""
	//Heure de mouvement
	Set lHeureMVT = ""
	//La colonne de quantité impactée par le type de mouvement
	Set lNumColonne = 0
	//Code du sinistre s'il y en a un
	Set lCodeSinitre = ""
	//Code coupon, son prix d'achat ainsi que son prix de vente utilisé dans le cas d'un mouvement coupon
	Set lCouponGU = ""
	Set lCouponPA = 0
	Set lCouponPV = 0
	Set lLastStockCoupon = 0

	//Quantité à mettre dans le mouvement
	Set lQuantite = 0
	//Secteur utilisé pour les coupons et si nous devons créer un nouvel enregistrement dans SECTFAMPLU
	Set lSecteur = ""
	//Familleutilisé pour la création d'un nouvel enregistrement dans SECTFAMPLU
	Set lFamille = ""

	//Nom du fichier
	Set lNomFicMVT = ""

	//Gestion des articles financiers
	Set bFinancier = 0

	//On vérifie que les données sont bien renseignées :
	If (param.PLU'="")&&(param.TYPE'="")
	{
		If +$DATA(@FILEPLU@(param.PLU))=0
		{
			//On recherche le PLU en question : 
			Set response.ERR = "Impossible d'ajouter le mouvement car le PLU : "_param.PLU_" n'existe pas."
			Set response.MVTRETOUR = "Le PLU "_param.PLU_" est inexistant dans le référentiel."
			Set response.bERREUR = 1
		}
		Else
		{
			//Le PLU existe bien dans la base de données
			//On prélève la désignatino du PLU
			Set llLibPLU = $GET(@FILEPLU@(param.PLU))
			Set lDataPLU = $GET(@FILEARTICLE@(llLibPLU))
			If lDataPLU = ""
			{
				Set response.ERR = "Impossible d'ajouter le mouvement car la désignation du PLU : "_param.PLU_" n'existe pas."
				Set response.MVTRETOUR = "La désignation du PLU "_param.PLU_" est inexistante."
				Set response.bERREUR = 1
			}
			Else
			{
				If +$DATA(@FILEARTICLE@(llLibPLU,4))=0
				{
					//On test si l'article est géré en stock ou non
					Set response.ERR = "Impossible d'ajouter le mouvement car le PLU : "_param.PLU_" n'a pas de node 4 sur ^ST: on ne peut pas savoir si c'est une article financier."
					Set response.MVTRETOUR = "Le PLU "_param.PLU_" est inexistant dans le référentiel du node 4: On ne peut pas savoir si c'est un article financier."
					Set response.bERREUR = 1
				}
				Else
				{
					If (+($PIECE($GET(@FILEARTICLE@(llLibPLU,4)),"\",6))=1) && (param.TYPE'=cstcTypeMVTNumRAZ)
					{
						//C'est un article financier et donc non géré en stock
						Set response.bERREUR = 1
						Set bFinancier = 1
					}
					Else
					{
						//On extrait le prix d'achat et le prix de vente, ainsi que le secteur sauf dans le cas des articles génériques où le prix est fixé par la caissière lors de l'achat
						If param.PA'=0 {Set lPA = param.PA}
						Else {Set lPA=+..PGGetPrix($PIECE(lDataPLU,"\",13))}
						
						If param.PV'=0 {Set lPV = param.PV}
						Else {Set lPV=+..PGGetPrix($PIECE(lDataPLU,"\",22))}
						
						Set lSecteur = $PIECE(lDataPLU,"\",4)
						Set lFamille = $PIECE(lDataPLU,"\",7)
						
						/*
						IF :gcClassif THEN
							lSecteur = ExtractString(lDataPLU,23,::cstcSeparateurDonnees)
							lFamille = ExtractString(lDataPLU,24,::cstcSeparateurDonnees)	
						ELSE
							lSecteur = ExtractString(lDataPLU,4,::cstcSeparateurDonnees)
							lFamille = ExtractString(lDataPLU,7,::cstcSeparateurDonnees)
						END*/
					}
				}
			}
		}
		Set lQuantite = param.QTE

		//On recherche maintenant le sens du mouvement grace au code du type de mouvement
		Set lDataMvt = $GET(@GUMVTTYPE@(param.TYPE))
		If lDataMvt=""
		{
			Set response.ERR = "Impossible d'ajouter le mouvement car le type de mouvement "_param.TYPE_" n'existe pas dans le fichier "_GUMVTTYPE_" du magasin."
			Set response.MVTRETOUR = "Impossible d'ajouter le mouvement car le type de mouvement n'existe pas."
			Set response.bERREUR = 1
		}
		Else
		{
			Set lSens=+$PIECE(lDataMvt,"\",2)
			//Grace au sens, je met à jour la quantité en question
			If lSens'=0 Set param.QTE = +param.QTE * (+lSens)
			Set lNumColonne=$PIECE(lDataMvt,"\",1)
		}
		
		//Recherche du dernier stock
		Set lDataStock = $GET(@GUSTOCK@(param.PLU))
		If lDataStock'="" Set lLastStock = +($PIECE(lDataStock,"\",6))
					
		//Recherche si le sinistre en question existe bien
		If param.NATURESINISTRE '= ""
		{
			Set lCodeSinitre=""
		 	Set lCodeSinitre=$ORDER(@GUSINISTRE@(lCodeSinitre))
		 	While lCodeSinitre'=""
		 	{
			 	If $GET(@GUSINISTRE@(lCodeSinitre))=param.NATURESINISTRE Quit			 	
				Set lCodeSinitre=$ORDER(@GUSINISTRE@(lCodeSinitre))
			}
			//IF lCodeSinitre="" s lCodeSinitre = ..PGAjoutSinistre(param.NATURESINISTRE)
		}
		//============================================
		//================= COUPON ===================
		//Dans le cas des coupons, nous devons aussi réaliser l'entrée en stock du coupon en question
		If param.TYPE = cstcTypeMVTNumCoupon
		{
			Set lCouponGU = ..PGRechercheCoupon(param.PLU,lPV,lSecteur)
			If lCouponGU = ""
			{
				//Le coupon n'existe pas et c'est donc nous ne gérons pas l'erreur :
				Set response.ERR = "La transformation en coupon du PLU "_param.PLURouleau_" est impossible avec le prix de vente "_lPV_" car cet article n'est pas compatible."
				Set response.MVTRETOUR = "La transformation en coupon est impossible pour l'article "_param.PLURouleau_" car il est incompatible."
				Set response.bERREUR = 1
			}
			Else
			{
				Set lCouponPA = $PIECE(lCouponGU,2,"\\_||_//")
				Set lCouponPV = $PIECE(lCouponGU,3,"\\_||_//")
				Set lCouponGU  = $PIECE(lCouponGU,1,"\\_||_//")
				//On recherche le dernier stock du coupon
				If +$DATA(@GUSTOCK@(lCouponGU))>0
				{
					Set lStockCoupon = $GET(@GUSTOCK@(lCouponGU))
					Set lLastStockCoupon = +$PIECE(lStockCoupon,"\",6)
				}
			}
		}
		//=============== Fin COUPON =================			
		//============================================			
			
		Set lDateMVT = $HOROLOG
		Set lHeureMVT = $PIECE(lDateMVT,",",2)
		Set lDateMVT = $PIECE(lDateMVT,",",1)
		If +param.DATEMVT > 0 Set lDateMVT = param.DATEMVT
		If +param.HEUREMVT > 0 Set lHeureMVT = param.HEUREMVT

		If response.bERREUR = 0
		{
			//Nous sommes sûr de ne pas avoir d'erreur	
			//Ensuite, nous prélevons le prochain numéro d'incrémentation des mouvements que le mouvement
			Set lCompteurMouvement = 0
			
			//On construit la chaine
			Set ldata = lQuantite_"\"_lPA_"\"_lPV_"\"_lSens_"\"_lLastStock_"\"_param.MAGFROM_"\"_param.MAGTO_"\"_param.NUMDOC_"\"_param.REMARQUE_"\"_lCodeSinitre_"\"_$ZDATEH(param.DATESINITRE,8,0,0,0,0,-1,-1,"")_"\"_param.USER_"\"_lHeureMVT_"\"_param.REMISE_"\"_param.EMP_"\"_param.EMPORIGINE
		
			//Nous regardons si nous sommes ou non en mode cap cash ou non
			Set gcCapCash = +$GET(@HWINFO@("CAPCASH"))
						
			Set mercerie = 0
			If (+lSecteur=1)||(+lSecteur=2)||(+lSecteur=3)||(+lSecteur=5)||(+lSecteur=16) {Set mercerie = 0}
			Else {Set mercerie = 1}
			/*
			IF :gcClassif THEN
				IF Val(lSecteur) = 1 OR Val(lSecteur) = 2 OR Val(lSecteur) = 3 OR Val(lSecteur) = 5 OR Val(lSecteur) = 6 THEN
					mercerie = Faux
				ELSE
					mercerie = Vrai
				END
			ELSE
				IF Val(lSecteur) = 1 OR Val(lSecteur) = 2 OR Val(lSecteur) = 3 OR Val(lSecteur) = 5 OR Val(lSecteur) = 16 THEN
					mercerie = Faux
				ELSE
					mercerie = Vrai
				END
			END */

			//On crée le MODIO ou le MODIOTMP
			//IF param.TYPE = cstcTypeMVTNumRecPlus 
			//{						
			//	s response.lMvtRetour = ..PGAjoutGURECEPT(param.NUMDOC,lLibPLU,lQuantite,param.NUMBL)			
			//}
			//IF param.TYPE = cstcTypeMVTNumRecMoins
			//{
		//		s response.lMvtRetour = ..PGEnleveGURECEPT(param.NUMDOC,lLibPLU,lQuantite,param.NUMBL)						
		//	}
		//	IF response.lMvtRetour '= "" q response.%ToJSON()

			//On bloque le fichier de mouvements pour transfert: en effet, le logiciel POSCOMM risque de les supprimer sans les envoyer en .GSA sinon.
		//	ZA @MODGUMVT
			
			//On sauve la donnée
		//	s @GUMVT@(lDateMVT,param.PLURouleau,param.TYPE,lCompteurMouvement)=ldata
		
		 	//si nous sommes en mode capcash alors nous devons également sauvegarder dans un fichier texte les mouvements
		 	Set bContinue = 0 // Sert plus bas pour la fermeture du fichier
			If gcCapCash = 1
			{
				//On récupère le dossier de mouvement
				Set gcsDossierInterfaceMVT = $GET(@HWINFO@("INT_MVTSTOCK"))
				
				Set bContinue = 1
				If gcsDossierInterfaceMVT="" Set bContinue = 0
				If param.TYPEMVT = 1 Set bContinue = 0
				If param.TYPEMVT = 2 Set bContinue = 0
				If param.TYPEMVT = 3 Set bContinue = 0
				If param.TYPEMVT = 4 Set bContinue = 0
				If param.TYPEMVT = 20 Set bContinue = 0
				If param.TYPEMVT = 21 Set bContinue = 0
				If param.TYPEMVT = 35 Set bContinue = 0
				If param.TYPEMVT = 36 Set bContinue = 0

				//Nous ne créons pas de fichier mouvement pour les ventes, retour marchandise, annulation ticket +et -, les mouvements de vitrine
				If bContinue = 1
				{
					//s sNomMag=..PGConvMag(param.MAG)
					//s lNomFicMVT = "MvtStock"_$ZD(+$H,8)_$Replace($ZTIME($H),":","")_"_"_sNomMag
					//s lNomFicMVTFinal = lNomFicMVT_".txt"
					
					//I '##class(%Library.File).DirectoryExists(gcsDossierInterfaceMVT) d ##class(%Library.File).CreateDirectory(gcsDossierInterfaceMVT)
					//s file=##class(%Library.File).%New(gcsDossierInterfaceMVT_"\"_lNomFicMVTFinal)
	 				//d file.Open("WSNK")
					//d file.WriteLine(sNomMag_"\"_param.PLU_"\"_param.QTE_"\")
					//d file.Close()	 
				}
			}
			//on crée le ^MODGUMVT		
				
			//Le MODGUMVT diffère du GUMVT sur le type de sinistre car on met la description du sinistre et non son type
			If param.NATURESINISTRE '= "" 
			{
				Set $PIECE(ldata,"\",16) = param.NATURESINISTRE
			}
			//s @MODGUMVT@(param.MAG,lDateMVT,param.PLURouleau,param.TYPE,lCompteurMouvement)=ldata
			
			//Dans le cas Coupon on créé un autre mouvement mais positif pour le coupon en question mais seulement de 1 mètre car un coupon est calculé à l'unité et non au métrage
			If (param.TYPE = cstcTypeMVTNumCoupon) && (lCouponGU '= "")
			{
				Set ldata = "1"_"\"_lCouponPA_"\"_lCouponPV_"\"_"1"_"\"_lLastStockCoupon_"\"_param.MAGFROM_"\"_param.MAGTO_"\"_param.NUMDOC_"\"_param.REMARQUE_"\"_lCodeSinitre_"\"_$ZDATEH(param.DATESINITRE,8,0,0,0,0,-1,-1,"")_"\"_param.USER_"\"_lHeureMVT_"\"_param.REMISE_"\"_param.EMP_"\"_param.EMPORIGINE
			    Set lCompteurMouvement=lCompteurMouvement+1
			    
			   // s @GUMVT@(lDateMVT,lCouponGU,param.TYPE,lCompteurMouvement)=ldata
			    //s @MODGUMVT@(param.MAG,lDateMVT,lCouponGU,param.TYPE,lCompteurMouvement)=ldata
				
				//IF bContinue = 1 d file.WriteLine(sNomMag_"\"_lCouponGU_"\1\")
			}
			//IF bContinue = 1 d file.Close()
			
			//On débloque le fichier de mouvements pour transfert	
			//ZD @MODGUMVT	
			
			
			//On met à jour ensuite le stock si ce n'est pas un mouvement nul (exemple: mise en vitrine)
			If +lSens '= 0
			{
				Set response.lMvtRetour = ..PGModifGUSTOCK(param.PLU,lNumColonne,param.QTE,ldata,lSecteur,lFamille)
				
				If (param.TYPE = cstcTypeMVTNumCoupon) && (response.lMvtRetour="")
				{
					//Dans le cas d'un coupon on met aussi à jour la quantité du stock du coupon en ajoutant 1
					Set param.QTE = 1
					Set response.lMvtRetour = ..PGModifGUSTOCK(lCouponGU,lNumColonne,param.QTE,ldata,"","")	
					If response.lMvtRetour = "" Set response.lMvtRetour = "COUPON:"+lCouponGU
				}
			}							
		}
	}	
	
	If pVerbose=1 Write response.%ToJSON() 
	
	Return response.ERR
}

ClassMethod FalControle(pTest As %Numeric = 1, pDeltaDate As %Numeric = 30) As %Status
{
	Set pMagasin = ##class(%SYS.System).GetNodeName(1)
	Set pointercmd = 0
	Set cpt = 0
	Set MAGRETROCMD = $QUERY(^MAGRETRO)
	//S MAGRETROCMD = "^MAGRETRO"
	// 
	For {
		Set MAGRETROCMD=$QUERY(@MAGRETROCMD) 
	
		Set cpt=cpt+1
		Quit:MAGRETROCMD=""
		If $QSUBSCRIPT(MAGRETROCMD,1)'="CMD" 	{Continue}
		If $QSUBSCRIPT(MAGRETROCMD,3)'="X999" 	{Continue}
		If $QSUBSCRIPT(MAGRETROCMD,4)'=pMagasin 	{Continue}
		If $QSUBSCRIPT(MAGRETROCMD,5)'=0 		{Continue}

		Set sNumeroRetro = $QSUBSCRIPT(MAGRETROCMD,2)
		//S ^CORRECTMVT($QSUBSCRIPT(MAGRETROCMD,1),$QSUBSCRIPT(MAGRETROCMD,2),$QSUBSCRIPT(MAGRETROCMD,3),$QSUBSCRIPT(MAGRETROCMD,4))=@MAGRETROCMD
		//w !, sNumeroRetro
		

		Do ..CORRECTMVT(sNumeroRetro,pMagasin,pTest) 
		
	}
	Return $$$OK
}

ClassMethod CORRECTMVT(pNumRetro As %String, pMagasin As %String, pTest = 1, pDeltaDate As %Numeric = 30) As %Status
{
 Set NUMRETRO=pNumRetro
 //s NUMRETRO="X999-RETRO-155057"
 Set iCpt=0 Set iCptTrouve=0 Set iCptManque=0
 Set NUMLIGNE="0"
 

 Set COMMENTAIRE=$PIECE($GET(^MAGRETRO("CMD",NUMRETRO,"X999",pMagasin,NUMLIGNE)),"\",8)
 
 If +$DATA(^MAGRETRO("LIV",NUMRETRO,"X999",pMagasin,"0"))
 {
	 Set DATALIV=$GET(^MAGRETRO("LIV",NUMRETRO,"X999",pMagasin,"0"))
	 Set DATERECEP=$PIECE(DATALIV,"\",5)
	 Set dateAffiche = DATERECEP
	 Set deltaDate = $HOROLOG-$ZDATEH(DATERECEP,8)
	 Set DATERECEP= $ZDATEH(DATERECEP,8)
 }

 Else
 {
	
	 Write !, NUMRETRO_" Non réceptionné"
	 Return $$$OK
 }




 Set NUMLIGNE=$ORDER(^MAGRETRO("CMD",NUMRETRO,"X999",pMagasin,NUMLIGNE))
 While NUMLIGNE'=""
 {
	Set iCpt=iCpt+1
	
	Set DATARETRO=$GET(^MAGRETRO("CMD",NUMRETRO,"X999",pMagasin,NUMLIGNE))
	Set PLU=$PIECE(DATARETRO,"\",1)
	Set QTE=+$PIECE(DATARETRO,"\",2)
	Set CMDGSI=$PIECE(DATARETRO,"\",14)
	//i CMDGSI'="" {w !, "COUCOU"}
	Set bTrouve=0
	
	If +$DATA(^GUMVT(DATERECEP,PLU,13))>0
	{
		Set NUMMVT=""
		Set NUMMVT=$ORDER(^GUMVT(DATERECEP,PLU,13,NUMMVT))
		While NUMMVT'=""
		{
			Set DATAMVT=$GET(^GUMVT(DATERECEP,PLU,13,NUMMVT))
			
			If (COMMENTAIRE=$PIECE(DATAMVT,"\",9))&&(NUMRETRO=$PIECE(DATAMVT,"\",8))&&(QTE=+$PIECE(DATAMVT,"\",1))&&(bTrouve=0)
			{
				Set bTrouve=1
				Set iCptTrouve=iCptTrouve+1
				
			}
			
			Set NUMMVT=$ORDER(^GUMVT(DATERECEP,PLU,13,NUMMVT))	
		}
	}
	
	If (bTrouve=0)
	{
		Set iCptManque=iCptManque+1
		//W !, PLU
		//w !, DATARETRO
		Set MAGDEST=pMagasin
		Set TYPEMVT="13"
		Set MAGSRC="X999"
		Set Login="Correction Info"
		Set sParam = MAGDEST_"_||_"_
					Login_"_||_"_
					PLU_"_||_"_
					PLU_"_||_"_
					TYPEMVT_"_||_"_
					QTE_"_||_"_
					COMMENTAIRE_"_||_"_
					MAGSRC_"_||_"_
					MAGDEST_"_||_"_
					NUMRETRO_"_||_"
		
		//w !, sParam
		
		//w !,NUMRETRO_" "_iCptManque
		 If +deltaDate>pDeltaDate {
			//w !, "Date depasse pour le traitement"
			Return $$$OK
		}
		If pTest=0
		{
			Set retErr = ..PGAjoutGUMVT(sParam, 0)
			If retErr '= ""
			{
				//Tracer les erreurs de mouvement 
				Set ^HISTOBUGMVTRETRO($ZDATE(+$HOROLOG,8),PLU)=retErr.MAGDEST_"/"_retErr.NUMCMD_"/"_retErr.ERR_"/"_retErr
			 	If retErr.ERR '= "" Set retErr.ERR = ", "
			 	Set retErr.ERR = retErr.ERR_retErr 
			 	Write !, "PAS OK"
			}
			Else
			{
				Write !, "OK"
			}
		}
		
	}
	
	Set bTrouve=0
	
 	Set NUMLIGNE=$ORDER(^MAGRETRO("CMD",NUMRETRO,"X999",pMagasin,NUMLIGNE))
 }
 
 If ((pTest=1))
 {
 	Write !, pNumRetro_"=> "_ iCptTrouve_"/"_iCpt_"\"_iCptManque_" du "_dateAffiche_" "_DATERECEP_" "_QTE
 }
 
 Return $$$OK
}

/// Description
ClassMethod kmvt(pdate As %String) As %Status
{
	Set PLU = ""
	Set PLU = $ORDER(^GUMVT(pdate,PLU))

	While (PLU '= "") {
		Set noeud4 = ""
		Set noeud4 = $ORDER(^GUMVT(pdate,PLU,13,noeud4))
		While (noeud4 '= "") {
			If +$DATA(^GUMVT(pdate,PLU,13,noeud4))>0 {
				Set data =  $PIECE($GET(^GUMVT(pdate,PLU,13,noeud4)),"\",12)
				If data = "Correction Info" {
					Kill ^GUMVT(pdate,PLU,13,noeud4)
					Set ^CORRECTGUMVT(pdate,PLU,13,noeud4)=$GET(^GUMVT(pdate,PLU,13,noeud4))
				}
				 
			}
			
			Set noeud4 = $ORDER(^GUMVT(pdate,PLU,13,noeud4))
		}
		
		Set PLU = $ORDER(^GUMVT(pdate,PLU))
	}



	Return $$$OK
}

/// Description
ClassMethod RecupMouvement(pTest = 1) As %Status
{
	Set PLU = ""
	Set pdate = $GET(%request.Data("date",1),+$HOROLOG)
	Set pPLU = $GET(%request.Data("PLU",1))
	Set pNoeud4 = $GET(%request.Data("pNoeud4",1))
	Set pMagasin = ##class(%SYS.System).GetNodeName(1)


	Set CORRECTGUMVT = "^CORRECTGUMVT"
	For {
		Set CORRECTGUMVT = $QUERY(@CORRECTGUMVT)
		Quit:CORRECTGUMVT=""
		If ((pPLU'="")&&($QSUBSCRIPT(CORRECTGUMVT,2)'= pPLU)) {Continue}
		Write !, $QSUBSCRIPT(CORRECTGUMVT,4)
		If ((pNoeud4'="")&&($QSUBSCRIPT(CORRECTGUMVT,4)'= pNoeud4)) {Continue}

			Set PLU = $QSUBSCRIPT(CORRECTGUMVT,2)
			Set noeud4 = ""
			Set noeud4 = $ORDER(^GUMVT(pdate,PLU,13,noeud4))




			While (noeud4 '= "") { 

			If +$DATA(^GUMVT(pdate,PLU,13,noeud4))>0 {
				Set data =  $PIECE($GET(^GUMVT(pdate,PLU,13,noeud4)),"\",12)

				If data = "Correction Info" {
				Set QTE = $PIECE($GET(^GUMVT(pdate,PLU,13,noeud4)),"\",1)
				Set COMMENTAIRE = $PIECE($GET(^GUMVT(pdate,PLU,13,noeud4)),"\",9)
				Set NUMRETRO = $PIECE($GET(^GUMVT(pdate,PLU,13,noeud4)),"\",8)
				Set MAGDEST=pMagasin
				Set TYPEMVT="34"
				Set MAGSRC="X999"
				Set Login="Correction Info 2"
				Set sParam = MAGDEST_"_||_"_ 			;1
							Login_"_||_"_ 			;2 
							PLU_"_||_"_ 			;3
							PLU_"_||_"_ 			;4 
							TYPEMVT_"_||_"_ 		;5
							QTE_"_||_"_				;6
							COMMENTAIRE_"_||_"_ 	;7
							MAGSRC_"_||_"_ 			;8
							MAGDEST_"_||_"_ 		;9
							NUMRETRO 				;10
					Set ^CORRECTGUMVTFAL(pdate,PLU,13,noeud4)=$GET(^GUMVT(pdate,PLU,13,noeud4))
					Write !, sParam
					If pTest=0
					{
						Set retErr = ..PGAjoutGUMVT(sParam, 0)
						If retErr '= ""
						{
							//Tracer les erreurs de mouvement 
							Set ^HISTOBUGMVTRETRO($ZDATE(+$HOROLOG,8),PLU)=retErr.MAGDEST_"/"_retErr.NUMCMD_"/"_retErr.ERR_"/"_retErr
							If retErr.ERR '= "" Set retErr.ERR = ", "
							Set retErr.ERR = retErr.ERR_retErr 
							Write !, "PAS OK"
						}
						Else
						{
							Write !, "OK"
						}
					}
				}
				 
			}
			
			Set noeud4 = $ORDER(^GUMVT(pdate,PLU,13,noeud4))
			}


	}

	Return $$$OK
}

ClassMethod TestIris() As %Status
{
	Set sc = $$$OK
	Set tmpTM = "^[""USER""]tmpTM"

	Set @tmpTM@("TEST") = "OK"

	Return sc
}

ClassMethod RecupPrix(pPLU As %String) As %Status
{
	set sc = $$$OK
	s ST = "^[""USER""]ST"
	s SP = "^[""USER""]SP"

	S Res ={}
	s Res.PA = 0
	s Res.DE = ""
	s Res.PF = 0
	
	i $d(@SP@(pPLU)) > 0
	{
		s Data = $p($G(@ST@($G(@SP@(pPLU)))),"\",22)
		s Res.PA = $P(Data,"/",1)
		s:(+$P(Data,"/",2)>0)&&(+$P(Data,"/",2)>=+$h) Res.DE = $zd(+$P(Data,"/",2),4)
		s:(+$P(Data,"/",2)>0)&&(+$P(Data,"/",2)>=+$h) Res.PF = $P(Data,"/",3)
	}
	w Res.%ToJSON()
	return sc
}

ClassMethod ControleMagWebCMD() As %Status
{
	set sc = $$$OK
	Set MAGWEBCMD = "^[""USER""]MAGWEBCMD"

	s NumCmd = ""
	s NumBL = ""
	s CptCmd = 0
	s CptBL = 0

	s NumCmd = $O(@MAGWEBCMD@(""))
	while MAGWEBCMD '= ""
	{
		//w !,NumCmd
		s CptCmd = CptCmd + 1
		s NumBL = $O(@MAGWEBCMD@(NumCmd,""))
		while NumBL '= ""
		{
			s CptBL = CptBL + 1
			s NumBL = $O(@MAGWEBCMD@(NumCmd,NumBL))
		}
		s NumCmd = $O(@MAGWEBCMD@(NumCmd))
		w !,CptCmd_";"_CptBL
	}
	return sc
}

ClassMethod ControleRetro() As %Status
{
	SET sc = $$$OK
	SET Stream = ##class(%GlobalCharacterStream).%New()
	DO Stream.CopyFrom(%request.Content)
	SET RetroSiege = Stream.Read()
	SET RetroDetail = ""
	SET CPT = 1
	SET RenvoiSiege = ""
	//w !,"Avant While"
	While $PIECE( RetroSiege, "\\||//", CPT ) '= ""
	{
		SET RetroDetail = $PIECE( RetroSiege, "\\||//", CPT )
		//w !,RetroDetail
		SET NumRetro = $PIECE(RetroDetail,";",1)
		SET GlbSiege = $PIECE(RetroDetail,";",2)
		SET Statut   = $PIECE(RetroDetail,";",3)
		SET Dest     = $PIECE(RetroDetail,";",4)
	//	IF $LENGTH( Statut ) = 0
	//	{
	//		s Statut = "FAX"
	//	}
		Set Globale = $CASE(GlbSiege,1:"^[""USER""]MAGRETRO",2:"^[""USER""]MAGRETROCOUPE",3:"^[""USER""]MAGRETROCONF",:"Nope")
		//w !,CPT_":"_Glb,!
		i +$DATA( @Globale@( Statut, NumRetro )) '= 0
		{
			// SET RenvoiSiege = RenvoiSiege_NumRetro_";"_GlbSiege_";"_Statut_"\\||//"
			SET RenvoiSiege = RenvoiSiege_$GET( @Globale@( Statut, NumRetro, "X999", Dest, 0 ))_"\\||//"
		}
		SET CPT = CPT + 1
	}
	w RenvoiSiege
	return sc
}

ClassMethod TestPOSTIRIS() As %Status
{
	set sc = $$$OK
	s Test = ##class(%GlobalCharacterStream).%New()
	d Test.CopyFrom(%request.Content)
	/*write "Méthode : ", %request.Method,!
	write "Contenu : ", %request.Content,!*/
 //while 'Test.AtEnd {
    write Test.Read()
 //}
	
	return sc
}

ClassMethod MAJRetro() As %Status
{
	set sc = $$$OK
	s Stream = ##class(%GlobalCharacterStream).%New()
	d Stream.CopyFrom(%request.Content)
	s RetroAMAJ = Stream.Read()
	s RetroAMAJDetail = ""
	s CPT = 1
	//w !,"Avant While"
	While $p(RetroAMAJ,"\\||//",CPT) '= ""
	{
		s RetroAMAJDetail = $p(RetroAMAJ,"\\||//",CPT)
		s Node = $p(RetroAMAJDetail,"\;/",1)
		;w !,Node
		s Data = $p(RetroAMAJDetail,"\;/",2)
		;w !,Data
		//w !,RetroDetail
		s Glb		= $p(Node,",",1)
		;w !,Glb
		s Glb 		= $CASE(Glb,1:"^[""USER""]MAGRETRO",2:"^[""USER""]MAGRETROCOUPE",3:"^[""USER""]MAGRETROCONF",:"Nope")
		;w ":"_Glb
		s Statut	= $p(Node,",",2)
		;w !,Statut
		s Retro		= $p(Node,",",3)
		;w !,Retro
		s Exp		= $p(Node,",",4)
		;w !,Exp
		s Dest		= $p(Node,",",5)
		;w !,Dest
		s Ln		= $p(Node,",",6)
		/*w !,Ln
		w !,Glb_"("_Statut_","_Retro_","_Exp_","_Dest_","_Ln_") = "_Data*/
		s @Glb@(Statut,Retro,Exp,Dest,Ln) = Data
		s CPT = CPT + 1
		w !,Glb
	}
	
	return sc
}

ClassMethod GestDoubRetro(pMail = 0) As %Status
{
	set sc = $$$OK
	
	J ^GESTDOUBRETRO(pMail)
	
	return sc
}

ClassMethod ExportGUMVT() As %Status
{
	set sc = $$$OK
	
	J ..ExportGUMVTJob()
	
	
	return sc
}

ClassMethod ExportGUMVTJob() As %Status
{
	set sc = $$$OK

	Set DateDujour  = +$HOROLOG-1
	
	Set ^DateExportGUMVT  = $GET(^DateExportGUMVT, "")
	if ^DateExportGUMVT="" {
			Set ^DateExportGUMVT = $zdh(20230101,8)
			Set ^DateExportGUMVT(^DateExportGUMVT )=1
	}


	For DateEnCour=^DateExportGUMVT:1:DateDujour {
			Set sc = ##class(map.MAGGUMVT).CreateSubGlobalByDate(DateEnCour)
			Set ^DateExportGUMVT($INCREMENT(^DateExportGUMVT))=sc
			Set ^DateExportGUMVT(^DateExportGUMVT,"GlobalExport")=""
	}
	Set ftpSession = ##Class(%Net.FtpSession).%New()

	Set ftpSession = ##class(%Net.FtpSession).%New() 
	Set ftpServer = "10.10.1.200"
	Set ftpPort = 21 
	Set ftpUsername  = "anonymous"
	Set ftpPassword = "flemelle@mondialtissus.com"
	Set ftpPath = "/OBJ/ALL/"
	Set sc = ftpSession.Connect(ftpServer, ftpUsername,ftpPassword, ftpPort)
	
	If 'sc {
			Do ftpSession.Logout()
			Quit sc
	}
	Set ftpPath = "/OBJ/"_##Class(%Function).HostName()_"/"

	If 'ftpSession.SetDirectory(ftpPath) {
			Do ftpSession.MakeDirectory(ftpPath)
	} 

	Set file=$ZSEARCH("c:/temp/*.xml") 
	For {
			Set file=$ZSEARCH("")
			Quit:file=""
			Set filestream = ##class(%Stream.FileBinary).%New()
			Do filestream.LinkToFile(file)
			set tmpPath = ftpPath_$Extract(file,$Length("c:/temp/")+1,$Length(file))
			Set sc=ftpSession.Store(tmpPath,filestream)
			if sc {
					do ##Class(%File).Delete(file)
			}
			Do filestream.%Delete()
	}
	Do ftpSession.Logout()
	
	
	return sc
}

ClassMethod ControleCmdWeb() As %Status
{
	set sc = $$$OK
	s MAGWEBCMD = "^[""USER""]MAGWEBCMD"

	s NUMCMD = $o(@MAGWEBCMD@(""))
	s Tab = []
	s Cpt = 0
	
	while NUMCMD '= ""
	{
		Set reqCtrl = ##class(%Net.HttpRequest).%New()
        //w "Envoi Controle Mag:"_$H,!
        Do reqCtrl.Get("http://10.10.1.14:57772/rest/webAtlas/ControleCmdWeb/"_NUMCMD)
        s Data = reqCtrl.HttpResponse.Data.Read()
		s Struc = {}
		s Struc.Cmd = NUMCMD
		s Struc.EC = Data
		i Data = 0
		{
			s RetHisto = ..HistoCmdWeb(NUMCMD)
			//i RetHisto.ERR
		}
		//d Tab.%Set(Cpt,Struc)
		//s Cpt = Cpt+1
		s NUMCMD = $o(@MAGWEBCMD@(NUMCMD))
	}
	write Tab.%ToJSON()
	return sc
}

// fin WS

}

Class ICashOrderWSservice.ICashOrderWSPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

// Parameter LOCATION = "http://10.10.1.209/CashOrderWS/CashOrderWS.exe/soap/ICashOrderWS";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.10.1.18:8080/CashOrderWS/CashOrderWS.exe/soap/ICashOrderWS";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// This is the name of the Service
Parameter SERVICENAME = "ICashOrderWSservice";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "urn:CashOrderWSIntf";

Method AcompteBonDeCommande(pMag As %xsd.int, pNumBon As %String, pMtt As %xsd.double, pGetTicket As %Boolean) As ICashOrderWSservice.ResultAcompteBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("AcompteBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#AcompteBonDeCommande",.pMag,.pNumBon,.pMtt,.pGetTicket)
}

Method AffectationE2ByCommande(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("AffectationE2ByCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#AffectationE2ByCommande",.pMag,.pNumBon)
}

Method AffectationE2BySupport(pMag As %xsd.int, pSupport As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("AffectationE2BySupport").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#AffectationE2BySupport",.pMag,.pSupport)
}

Method BloquerStock(pBloquerStock As ICashOrderWSservice.ClassBloquerStock) As ICashOrderWSservice.ClassBloquerStock(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("BloquerStock").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#BloquerStock",.pBloquerStock)
}

Method CheckUser(pMag As %xsd.int, pUser As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CheckUser").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CheckUser",.pMag,.pUser)
}

Method CheckUserByCodeInterne(pIdinstint As %xsd.int, pCiint As %xsd.int) As ICashOrderWSservice.ResultLogin(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CheckUserByCodeInterne").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CheckUserByCodeInterne",.pIdinstint,.pCiint)
}

Method CheckUserV2(pMag As %xsd.int, pUser As %String) As ICashOrderWSservice.ResultLogin(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CheckUserV2").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CheckUserV2",.pMag,.pUser)
}

Method CreerBonDeCommande(pPanier As ICashOrderWSservice.ClassPanier, pCanal As %xsd.int, pMttPreVerse As %xsd.double) As ICashOrderWSservice.ResultCreerBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CreerBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CreerBonDeCommande",.pPanier,.pCanal,.pMttPreVerse)
}

Method CreerBonDeVente(pPanier As ICashOrderWSservice.ClassPanier, pCanal As %xsd.int) As ICashOrderWSservice.ResultCreerBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CreerBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CreerBonDeVente",.pPanier,.pCanal)
}

Method CreerDevis(pPanier As ICashOrderWSservice.ClassPanier) As ICashOrderWSservice.ResultCreerDevis(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CreerDevis").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CreerDevis",.pPanier)
}

Method CreerTicket(pPanier As ICashOrderWSservice.ClassPanier) As ICashOrderWSservice.ResultCreerTicket(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CreerTicket").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CreerTicket",.pPanier)
}

Method CreerTicketFlottant(pPanier As ICashOrderWSservice.ClassPanier, pNomFichier As %String) As ICashOrderWSservice.ResultCreerTicket(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("CreerTicketFlottant").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#CreerTicketFlottant",.pPanier,.pNomFichier)
}

Method FlotterBonDeCommande(pMag As %xsd.int, pNumBon As %String, pExtension As %String) As ICashOrderWSservice.ResultFlotterBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("FlotterBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#FlotterBonDeCommande",.pMag,.pNumBon,.pExtension)
}

Method GetAcompte(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultGetAcompte(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetAcompte").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetAcompte",.pMag,.pNumBon)
}

Method GetBDVEntete(pMag As %xsd.int, pCriteres As %String) As ICashOrderWSservice.ResultGetBDVEntete(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetBDVEntete").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetBDVEntete",.pMag,.pCriteres)
}

Method GetBonDeCommande(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultGetBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetBonDeCommande",.pMag,.pNumBon)
}

Method GetBonDeVente(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultGetBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetBonDeVente",.pMag,.pNumBon)
}

Method GetCA(pMag As %xsd.int, pDate As %TimeStamp, pPerimetre As %xsd.int) As ICashOrderWSservice.ResultCA(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetCA").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetCA",.pMag,.pDate,.pPerimetre)
}

Method GetCommandeDetail(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultGetCommandeDetail(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetCommandeDetail").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetCommandeDetail",.pMag,.pNumBon)
}

Method GetCommandeEntete(pMag As %xsd.int, pCriteres As %String) As ICashOrderWSservice.ResultGetCommandeEntete(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetCommandeEntete").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetCommandeEntete",.pMag,.pCriteres)
}

Method GetStock(pMag As %xsd.int, pCdart As %String) As ICashOrderWSservice.ResultGetStock(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetStock").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetStock",.pMag,.pCdart)
}

Method GetStockDetail(pMag As %String, pCdart As %String, pDetail As %Boolean) As ICashOrderWSservice.ResultGetStockDetail(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetStockDetail").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetStockDetail",.pMag,.pCdart,.pDetail)
}

Method GetStockSimple(pMag As %xsd.int, pCdart As %String) As ICashOrderWSservice.ResultGetStockSimple(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetStockSimple").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetStockSimple",.pMag,.pCdart)
}

Method GetTicketFlottant(pNomFichier As %String) As ICashOrderWSservice.ResultGetTicketFlottant(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("GetTicketFlottant").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#GetTicketFlottant",.pNomFichier)
}

Method ImprimerBonDeCommande(pMag As %xsd.int, pNumBon As %String, pImprimante As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ImprimerBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ImprimerBonDeCommande",.pMag,.pNumBon,.pImprimante)
}

Method ImprimerBonDeVente(pMag As %xsd.int, pNumBon As %String, pImprimante As %String) As ICashOrderWSservice.ResultImprimerBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ImprimerBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ImprimerBonDeVente",.pMag,.pNumBon,.pImprimante)
}

Method ListerTicketsFlottants(pMag As %xsd.int) As ICashOrderWSservice.ResultListerTicketsFlottants(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ListerTicketsFlottants").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ListerTicketsFlottants",.pMag)
}

Method Login(pMag As %xsd.int, pUser As %String, pPwd As %String) As ICashOrderWSservice.ResultLogin(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("Login").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#Login",.pMag,.pUser,.pPwd)
}

Method ModifierBonDeCommande(pMag As %xsd.int, pNumBon As %String, pPanier As ICashOrderWSservice.ClassPanier, pMotif As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ModifierBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ModifierBonDeCommande",.pMag,.pNumBon,.pPanier,.pMotif)
}

Method ModifierBonDeVente(pMag As %xsd.int, pNumBon As %String, pPanier As ICashOrderWSservice.ClassPanier) As ICashOrderWSservice.ResultCreerBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ModifierBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ModifierBonDeVente",.pMag,.pNumBon,.pPanier)
}

Method ModifierMagasinBonDeCommande(pMagOri As %xsd.int, pMagDest As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ModifierMagasinBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ModifierMagasinBonDeCommande",.pMagOri,.pMagDest,.pNumBon)
}

Method MouvementerStock(pMouvementerStock As ICashOrderWSservice.ClassMouvementerStock) As ICashOrderWSservice.ClassMouvementerStock(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("MouvementerStock").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#MouvementerStock",.pMouvementerStock)
}

Method PayerBonDeCommande(pMag As %xsd.int, pNumBon As %String, pMtt As %xsd.double, pGetTicket As %Boolean) As ICashOrderWSservice.ResultPayerBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("PayerBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#PayerBonDeCommande",.pMag,.pNumBon,.pMtt,.pGetTicket)
}

Method ProgressCA() As ICashOrderWSservice.ResultProgressCA(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ProgressCA").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ProgressCA")
}

Method RechercherBonDeCommande(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultRechercherBon(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("RechercherBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#RechercherBonDeCommande",.pMag,.pNumBon)
}

Method RechercherBonDeVente(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultRechercherBon(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("RechercherBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#RechercherBonDeVente",.pMag,.pNumBon)
}

Method RechercherBonsDeCommande(pMag As %xsd.int, pNumfid As %String, pNom As %String, pPrenom As %String, pCodpos As %String, pMin As %xsd.double, pMax As %xsd.double, pDtCreMin As %TimeStamp, pDtCreMax As %TimeStamp, pDtEchMin As %TimeStamp, pDtEchMax As %TimeStamp, pArt As %String, pCanal As %String, pNumExterne As %String, pEtat As %xsd.int, pNiv1 As %xsd.int, pRetrait1H As %Boolean) As ICashOrderWSservice.ResultRechercherBons(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("RechercherBonsDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#RechercherBonsDeCommande",.pMag,.pNumfid,.pNom,.pPrenom,.pCodpos,.pMin,.pMax,.pDtCreMin,.pDtCreMax,.pDtEchMin,.pDtEchMax,.pArt,.pCanal,.pNumExterne,.pEtat,.pNiv1,.pRetrait1H)
}

Method RechercherBonsDeVente(pMag As %xsd.int, pNumfid As %String, pNom As %String, pPrenom As %String, pCodpos As %String, pMin As %xsd.double, pMax As %xsd.double, pDtCreMin As %TimeStamp, pDtCreMax As %TimeStamp, pDtEchMin As %TimeStamp, pDtEchMax As %TimeStamp, pArt As %String, pCanal As %String, pNumExterne As %String, pNiv1 As %xsd.int, pRetrait1H As %Boolean) As ICashOrderWSservice.ResultRechercherBons(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("RechercherBonsDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#RechercherBonsDeVente",.pMag,.pNumfid,.pNom,.pPrenom,.pCodpos,.pMin,.pMax,.pDtCreMin,.pDtCreMax,.pDtEchMin,.pDtEchMax,.pArt,.pCanal,.pNumExterne,.pNiv1,.pRetrait1H)
}

Method SupprimerBonDeCommande(pMag As %xsd.int, pNumBon As %String, pMotif As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("SupprimerBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#SupprimerBonDeCommande",.pMag,.pNumBon,.pMotif)
}

Method SupprimerBonDeVente(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultSupprimerBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("SupprimerBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#SupprimerBonDeVente",.pMag,.pNumBon)
}

Method SupprimerLigneBonDeCommande(pMag As %xsd.int, pNumBon As %String, pCdart As %String, pMotif As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("SupprimerLigneBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#SupprimerLigneBonDeCommande",.pMag,.pNumBon,.pCdart,.pMotif)
}

Method SupprimerTicketFlottant(pNomFichier As %String) As ICashOrderWSservice.ResultStandard(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("SupprimerTicketFlottant").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#SupprimerTicketFlottant",.pNomFichier)
}

Method TipperBonDeCommande(pMag As %xsd.int, pNumBon As %String, pClientDemat As ICashOrderWSservice.ClassClientDemat) As ICashOrderWSservice.ResultTipperBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("TipperBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#TipperBonDeCommande",.pMag,.pNumBon,.pClientDemat)
}

Method TipperPartielBonDeCommande(pMag As %xsd.int, pNumBon As %String, pPanier As ICashOrderWSservice.ClassPanier, pClientDemat As ICashOrderWSservice.ClassClientDemat) As ICashOrderWSservice.ResultTipperBonDeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("TipperPartielBonDeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#TipperPartielBonDeCommande",.pMag,.pNumBon,.pPanier,.pClientDemat)
}

Method TransformeCommande(pFichier As %String) As ICashOrderWSservice.ResultTransformeCommande(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("TransformeCommande").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#TransformeCommande",.pFichier)
}

Method ValiderBonDeVente(pFichier As %String) As ICashOrderWSservice.ResultValiderBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ValiderBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ValiderBonDeVente",.pFichier)
}

Method ValiderStdBonDeVente(pMag As %xsd.int, pNumBon As %String) As ICashOrderWSservice.ResultValiderStdBonDeVente(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = encoded, SoapNameSpace = "urn:CashOrderWSIntf-ICashOrderWS", WebMethod ]
{
 Quit ..WebMethod("ValiderStdBonDeVente").Invoke($this,"urn:CashOrderWSIntf-ICashOrderWS#ValiderStdBonDeVente",.pMag,.pNumBon)
}

}

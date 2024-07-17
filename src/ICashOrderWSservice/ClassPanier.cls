/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassPanier Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassPanier";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property client As ICashOrderWSservice.ClassClient(XMLNAME = "client") [ Required ];

Property clientlivre As ICashOrderWSservice.ClassClient(XMLNAME = "clientlivre") [ Required ];

Property clientfacture As ICashOrderWSservice.ClassClient(XMLNAME = "clientfacture") [ Required ];

Property numfid As %String(MAXLEN = "", XMLNAME = "numfid") [ Required ];

Property articles As list Of ICashOrderWSservice.ClassArticle(XMLNAME = "articles", XMLPROJECTION = "COLLECTION") [ Required ];

Property comm As %String(MAXLEN = "", XMLNAME = "comm") [ Required ];

Property idinstuser As %xsd.int(XMLNAME = "idinstuser") [ Required ];

Property iduser As %xsd.int(XMLNAME = "iduser") [ Required ];

Property userexterne As %String(MAXLEN = "", XMLNAME = "userexterne") [ Required ];

Property dtliv As %TimeStamp(XMLNAME = "dtliv") [ Required ];

Property dtlivsouhait As %TimeStamp(XMLNAME = "dtlivsouhait") [ Required ];

Property livjour As %String(MAXLEN = "", XMLNAME = "livjour") [ Required ];

Property livconfirm As %Boolean(XMLNAME = "livconfirm") [ Required ];

Property livinfo1 As %String(MAXLEN = "", XMLNAME = "livinfo1") [ Required ];

Property livinfo2 As %String(MAXLEN = "", XMLNAME = "livinfo2") [ Required ];

Property livdeport As %Boolean(XMLNAME = "livdeport") [ Required ];

Property livdirect As %Boolean(XMLNAME = "livdirect") [ Required ];

Property transporteur As %String(MAXLEN = "", XMLNAME = "transporteur") [ Required ];

Property numexterne As %String(MAXLEN = "", XMLNAME = "numexterne") [ Required ];

Property remtot As %xsd.double(XMLNAME = "remtot") [ Required ];

Property datafid As %String(MAXLEN = "", XMLNAME = "datafid") [ Required ];

Property datafidaco As %String(MAXLEN = "", XMLNAME = "datafidaco") [ Required ];

Property dataopeco As %String(MAXLEN = "", XMLNAME = "dataopeco") [ Required ];

Property datarem As %String(MAXLEN = "", XMLNAME = "datarem") [ Required ];

Property vteemp As %xsd.int(XMLNAME = "vteemp") [ Required ];

Property pseudo As %String(MAXLEN = "", XMLNAME = "pseudo") [ Required ];

Property place As %String(MAXLEN = "", XMLNAME = "place") [ Required ];

Property infocde As %String(MAXLEN = "", XMLNAME = "infocde") [ Required ];

Property numcourt As %String(MAXLEN = "", XMLNAME = "numcourt") [ Required ];

Property statut As %xsd.int(XMLNAME = "statut") [ Required ];

Property dtsaisie As %TimeStamp(XMLNAME = "dtsaisie") [ Required ];

Property dtmaj As %TimeStamp(XMLNAME = "dtmaj") [ Required ];

Property dtech As %TimeStamp(XMLNAME = "dtech") [ Required ];

Property dtrel As %TimeStamp(XMLNAME = "dtrel") [ Required ];

Property dtpromesse As %TimeStamp(XMLNAME = "dtpromesse") [ Required ];

Property ecartpromesse As %String(MAXLEN = "", XMLNAME = "ecartpromesse") [ Required ];

Property canal As %xsd.int(XMLNAME = "canal") [ Required ];

Property montant As %xsd.double(XMLNAME = "montant") [ Required ];

Property montantrestant As %xsd.double(XMLNAME = "montantrestant") [ Required ];

Property paiements As list Of ICashOrderWSservice.ClassPaiement(XMLNAME = "paiements", XMLPROJECTION = "COLLECTION") [ Required ];

}

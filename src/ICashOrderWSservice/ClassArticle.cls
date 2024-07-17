/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassArticle Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassArticle";

Parameter XMLSEQUENCE = 1;

Property cdart As %String(MAXLEN = "", XMLNAME = "cdart") [ Required ];

Property quantite As %xsd.double(XMLNAME = "quantite") [ Required ];

Property prix As %xsd.double(XMLNAME = "prix") [ Required ];

Property prixforce As %Boolean(XMLNAME = "prixforce") [ Required ];

Property motifprixforce As %String(MAXLEN = "", XMLNAME = "motifprixforce") [ Required ];

Property commlig1 As %String(MAXLEN = "", XMLNAME = "commlig1") [ Required ];

Property commlig2 As %String(MAXLEN = "", XMLNAME = "commlig2") [ Required ];

Property prixachatHT As %xsd.double(XMLNAME = "prixachatHT") [ Required ];

Property prixachatTTC As %xsd.double(XMLNAME = "prixachatTTC") [ Required ];

Property tauxTVA As %xsd.double(XMLNAME = "tauxTVA") [ Required ];

Property typecde As %String(MAXLEN = "", XMLNAME = "typecde") [ Required ];

Property remlig As %xsd.double(XMLNAME = "remlig") [ Required ];

Property remtot As %xsd.double(XMLNAME = "remtot") [ Required ];

Property datafid As %String(MAXLEN = "", XMLNAME = "datafid") [ Required ];

Property datafidaco As %String(MAXLEN = "", XMLNAME = "datafidaco") [ Required ];

Property dataopeco As %String(MAXLEN = "", XMLNAME = "dataopeco") [ Required ];

Property datarem As %String(MAXLEN = "", XMLNAME = "datarem") [ Required ];

Property okdiff As %Boolean(XMLNAME = "okdiff") [ Required ];

Property bundle As %xsd.int(XMLNAME = "bundle") [ Required ];

Property opt As %xsd.int(XMLNAME = "opt") [ Required ];

Property lib As %String(MAXLEN = "", XMLNAME = "lib") [ Required ];

Property idinstuser As %xsd.int(XMLNAME = "idinstuser") [ Required ];

Property iduser As %xsd.int(XMLNAME = "iduser") [ Required ];

Property dtpromesse As %TimeStamp(XMLNAME = "dtpromesse") [ Required ];

Property expo As %Boolean(XMLNAME = "expo") [ Required ];

Property motifcde As %String(MAXLEN = "", XMLNAME = "motifcde") [ Required ];

Property numcde As %String(MAXLEN = "", XMLNAME = "numcde") [ Required ];

Property prixupv As %xsd.double(XMLNAME = "prixupv") [ Required ];

Property montant As %xsd.double(XMLNAME = "montant") [ Required ];

Property remise As %xsd.double(XMLNAME = "remise") [ Required ];

Property emplacement As %String(MAXLEN = "", XMLNAME = "emplacement") [ Required ];

Property statut As %xsd.int(XMLNAME = "statut") [ Required ];

}

/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassBon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassBon";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property numbon As %String(MAXLEN = "", XMLNAME = "numbon") [ Required ];

Property numexterne As %String(MAXLEN = "", XMLNAME = "numexterne") [ Required ];

Property montant As %xsd.double(XMLNAME = "montant") [ Required ];

Property nom As %String(MAXLEN = "", XMLNAME = "nom") [ Required ];

Property prenom As %String(MAXLEN = "", XMLNAME = "prenom") [ Required ];

Property dtsaisie As %TimeStamp(XMLNAME = "dtsaisie") [ Required ];

Property dtmaj As %TimeStamp(XMLNAME = "dtmaj") [ Required ];

Property statut As %xsd.int(XMLNAME = "statut") [ Required ];

Property canal As %xsd.int(XMLNAME = "canal") [ Required ];

Property dtech As %TimeStamp(XMLNAME = "dtech") [ Required ];

Property dtpromesse As %TimeStamp(XMLNAME = "dtpromesse") [ Required ];

Property ecartpromesse As %String(MAXLEN = "", XMLNAME = "ecartpromesse") [ Required ];

}

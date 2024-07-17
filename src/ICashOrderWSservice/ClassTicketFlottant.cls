/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassTicketFlottant Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassTicketFlottant";

Parameter XMLSEQUENCE = 1;

Property Pseudo As %String(MAXLEN = "", XMLNAME = "Pseudo") [ Required ];

Property NomFichier As %String(MAXLEN = "", XMLNAME = "NomFichier") [ Required ];

Property MntTtc As %xsd.double(XMLNAME = "MntTtc") [ Required ];

Property DateTick As %TimeStamp(XMLNAME = "DateTick") [ Required ];

}

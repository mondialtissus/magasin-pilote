/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultAcompteBonDeCommande Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultAcompteBonDeCommande";

Parameter XMLSEQUENCE = 1;

Property NumTick As %String(MAXLEN = "", XMLNAME = "NumTick") [ Required ];

Property Fichier As %String(MAXLEN = "", XMLNAME = "Fichier") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

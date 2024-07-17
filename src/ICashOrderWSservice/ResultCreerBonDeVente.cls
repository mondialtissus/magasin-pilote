/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultCreerBonDeVente Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultCreerBonDeVente";

Parameter XMLSEQUENCE = 1;

Property NumBon As %String(MAXLEN = "", XMLNAME = "NumBon") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

Property Panier As ICashOrderWSservice.ClassPanier(XMLNAME = "Panier") [ Required ];

}

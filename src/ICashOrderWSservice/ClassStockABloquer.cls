/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassStockABloquer Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassStockABloquer";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property cdart As %String(MAXLEN = "", XMLNAME = "cdart") [ Required ];

Property idmotif As %xsd.int(XMLNAME = "idmotif") [ Required ];

Property qte As %xsd.double(XMLNAME = "qte") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

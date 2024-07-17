/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassStockAMouvementer Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassStockAMouvementer";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property cdart As %String(MAXLEN = "", XMLNAME = "cdart") [ Required ];

Property typemvt As %String(MAXLEN = "", XMLNAME = "typemvt") [ Required ];

Property qte As %xsd.double(XMLNAME = "qte") [ Required ];

Property origine As %String(MAXLEN = "", XMLNAME = "origine") [ Required ];

Property numserie As %String(MAXLEN = "", XMLNAME = "numserie") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

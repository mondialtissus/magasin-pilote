/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassMouvementerStock Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassMouvementerStock";

Parameter XMLSEQUENCE = 1;

Property StocksAMouvementer As list Of ICashOrderWSservice.ClassStockAMouvementer(XMLNAME = "StocksAMouvementer", XMLPROJECTION = "COLLECTION") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

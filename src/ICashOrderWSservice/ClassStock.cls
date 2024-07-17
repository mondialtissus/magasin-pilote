/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassStock Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassStock";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property cdart As %String(MAXLEN = "", XMLNAME = "cdart") [ Required ];

Property stockdispo As %xsd.double(XMLNAME = "stockdispo") [ Required ];

Property stockbloque As %xsd.double(XMLNAME = "stockbloque") [ Required ];

Property StocksBloques As list Of ICashOrderWSservice.ClassStockBloque(XMLNAME = "StocksBloques", XMLPROJECTION = "COLLECTION") [ Required ];

}

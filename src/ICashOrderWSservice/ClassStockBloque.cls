/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassStockBloque Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassStockBloque";

Parameter XMLSEQUENCE = 1;

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

Property cdart As %String(MAXLEN = "", XMLNAME = "cdart") [ Required ];

Property idmotif As %xsd.int(XMLNAME = "idmotif") [ Required ];

Property motif As %String(MAXLEN = "", XMLNAME = "motif") [ Required ];

Property qte As %xsd.double(XMLNAME = "qte") [ Required ];

}

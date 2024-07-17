/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultLogin Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultLogin";

Parameter XMLSEQUENCE = 1;

Property ciint As %xsd.int(XMLNAME = "ciint") [ Required ];

Property idinstint As %xsd.int(XMLNAME = "idinstint") [ Required ];

Property Code As %String(MAXLEN = "", XMLNAME = "Code") [ Required ];

Property Nom As %String(MAXLEN = "", XMLNAME = "Nom") [ Required ];

Property Prenom As %String(MAXLEN = "", XMLNAME = "Prenom") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

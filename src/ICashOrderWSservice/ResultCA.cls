/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultCA Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultCA";

Parameter XMLSEQUENCE = 1;

Property ca As %xsd.double(XMLNAME = "ca") [ Required ];

Property obj As %xsd.double(XMLNAME = "obj") [ Required ];

Property can1 As %xsd.double(XMLNAME = "can1") [ Required ];

Property paniermoyen As %xsd.double(XMLNAME = "paniermoyen") [ Required ];

Property cible As %String(MAXLEN = "", XMLNAME = "cible") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

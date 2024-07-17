/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassAcompte Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassAcompte";

Parameter XMLSEQUENCE = 1;

Property NumMag As %xsd.int(XMLNAME = "NumMag") [ Required ];

Property NumTick As %String(MAXLEN = "", XMLNAME = "NumTick") [ Required ];

Property MntTtc As %xsd.double(XMLNAME = "MntTtc") [ Required ];

Property DateTick As %TimeStamp(XMLNAME = "DateTick") [ Required ];

}

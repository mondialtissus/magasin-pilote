/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassCAMag Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassCAMag";

Parameter XMLSEQUENCE = 1;

Property numreg As %xsd.int(XMLNAME = "numreg") [ Required ];

Property nummag As %xsd.int(XMLNAME = "nummag") [ Required ];

Property libmag As %String(MAXLEN = "", XMLNAME = "libmag") [ Required ];

Property catot As %xsd.double(XMLNAME = "catot") [ Required ];

Property caprevu As %xsd.double(XMLNAME = "caprevu") [ Required ];

Property caN1 As %xsd.double(XMLNAME = "caN1") [ Required ];

Property caCnC As %xsd.double(XMLNAME = "caCnC") [ Required ];

}

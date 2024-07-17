/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultProgressCA Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultProgressCA";

Parameter XMLSEQUENCE = 1;

Property dtmaj As %TimeStamp(XMLNAME = "dtmaj") [ Required ];

Property catot As %xsd.double(XMLNAME = "catot") [ Required ];

Property caprevu As %xsd.double(XMLNAME = "caprevu") [ Required ];

Property caN1 As %xsd.double(XMLNAME = "caN1") [ Required ];

Property caCnC As %xsd.double(XMLNAME = "caCnC") [ Required ];

Property CAReg As list Of ICashOrderWSservice.ClassCAReg(XMLNAME = "CAReg", XMLPROJECTION = "COLLECTION") [ Required ];

Property CAMag As list Of ICashOrderWSservice.ClassCAMag(XMLNAME = "CAMag", XMLPROJECTION = "COLLECTION") [ Required ];

Property CACat As list Of ICashOrderWSservice.ClassCACat(XMLNAME = "CACat", XMLPROJECTION = "COLLECTION") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

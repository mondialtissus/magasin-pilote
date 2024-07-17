/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassCAReg Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassCAReg";

Parameter XMLSEQUENCE = 1;

Property numreg As %xsd.int(XMLNAME = "numreg") [ Required ];

Property libreg As %String(MAXLEN = "", XMLNAME = "libreg") [ Required ];

}

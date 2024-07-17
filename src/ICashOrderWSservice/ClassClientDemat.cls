/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassClientDemat Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassClientDemat";

Parameter XMLSEQUENCE = 1;

Property nom As %String(MAXLEN = "", XMLNAME = "nom") [ Required ];

Property prenom As %String(MAXLEN = "", XMLNAME = "prenom") [ Required ];

Property email As %String(MAXLEN = "", XMLNAME = "email") [ Required ];

}

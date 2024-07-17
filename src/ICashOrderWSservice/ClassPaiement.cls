/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassPaiement Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassPaiement";

Parameter XMLSEQUENCE = 1;

Property cdpaiement As %String(MAXLEN = "", XMLNAME = "cdpaiement") [ Required ];

Property mtt As %xsd.double(XMLNAME = "mtt") [ Required ];

Property numtransac As %String(MAXLEN = "", XMLNAME = "numtransac") [ Required ];

Property infotransac As %String(MAXLEN = "", XMLNAME = "infotransac") [ Required ];

}

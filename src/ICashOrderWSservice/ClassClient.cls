/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassClient Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassClient";

Parameter XMLSEQUENCE = 1;

Property civil As %xsd.int(XMLNAME = "civil") [ Required ];

Property nom As %String(MAXLEN = "", XMLNAME = "nom") [ Required ];

Property prenom As %String(MAXLEN = "", XMLNAME = "prenom") [ Required ];

Property adr1 As %String(MAXLEN = "", XMLNAME = "adr1") [ Required ];

Property adr2 As %String(MAXLEN = "", XMLNAME = "adr2") [ Required ];

Property adr3 As %String(MAXLEN = "", XMLNAME = "adr3") [ Required ];

Property adr4 As %String(MAXLEN = "", XMLNAME = "adr4") [ Required ];

Property codpos As %String(MAXLEN = "", XMLNAME = "codpos") [ Required ];

Property ville As %String(MAXLEN = "", XMLNAME = "ville") [ Required ];

Property pays As %String(MAXLEN = "", XMLNAME = "pays") [ Required ];

Property tel As %String(MAXLEN = "", XMLNAME = "tel") [ Required ];

Property fax As %String(MAXLEN = "", XMLNAME = "fax") [ Required ];

Property gsm As %String(MAXLEN = "", XMLNAME = "gsm") [ Required ];

Property email As %String(MAXLEN = "", XMLNAME = "email") [ Required ];

Property idinstcli As %xsd.int(XMLNAME = "idinstcli") [ Required ];

Property idcli As %xsd.int(XMLNAME = "idcli") [ Required ];

Property mag As %xsd.int(XMLNAME = "mag") [ Required ];

}

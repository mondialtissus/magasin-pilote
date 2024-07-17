/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ClassCACat Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ClassCACat";

Parameter XMLSEQUENCE = 1;

Property nummag As %xsd.int(XMLNAME = "nummag") [ Required ];

Property numcat As %xsd.int(XMLNAME = "numcat") [ Required ];

Property libcat As %String(MAXLEN = "", XMLNAME = "libcat") [ Required ];

Property catot As %xsd.double(XMLNAME = "catot") [ Required ];

Property caprevu As %xsd.double(XMLNAME = "caprevu") [ Required ];

Property caN1 As %xsd.double(XMLNAME = "caN1") [ Required ];

Property caCnC As %xsd.double(XMLNAME = "caCnC") [ Required ];

Property numcatparent As %xsd.int(XMLNAME = "numcatparent") [ Required ];

}

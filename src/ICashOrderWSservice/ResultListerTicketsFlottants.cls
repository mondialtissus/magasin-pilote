/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ResultListerTicketsFlottants Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ResultListerTicketsFlottants";

Parameter XMLSEQUENCE = 1;

Property TicketsFlottants As list Of ICashOrderWSservice.ClassTicketFlottant(XMLNAME = "TicketsFlottants", XMLPROJECTION = "COLLECTION") [ Required ];

Property Error As %String(MAXLEN = "", XMLNAME = "Error") [ Required ];

Property ErrorCode As %xsd.int(XMLNAME = "ErrorCode") [ Required ];

}

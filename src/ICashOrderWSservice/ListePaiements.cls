/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ListePaiements Extends %ListOfObjects [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter ELEMENTTYPE = "ICashOrderWSservice.ClassPaiement";

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ListePaiements";

Parameter XMLSEQUENCE = 1;

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}

/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ListeCACat Extends %ListOfObjects [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter ELEMENTTYPE = "ICashOrderWSservice.ClassCACat";

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ListeCACat";

Parameter XMLSEQUENCE = 1;

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}

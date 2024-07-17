/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ListeStocksBloques Extends %ListOfObjects [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter ELEMENTTYPE = "ICashOrderWSservice.ClassStockBloque";

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ListeStocksBloques";

Parameter XMLSEQUENCE = 1;

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}

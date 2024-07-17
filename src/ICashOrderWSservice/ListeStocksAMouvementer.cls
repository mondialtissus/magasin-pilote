/// Created from: http://10.10.1.209/CashOrderWS/CashOrderWS.exe/wsdl/ICashOrderWS?wsdl
Class ICashOrderWSservice.ListeStocksAMouvementer Extends %ListOfObjects [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter ELEMENTTYPE = "ICashOrderWSservice.ClassStockAMouvementer";

Parameter NAMESPACE = "urn:CashOrderWSIntf";

Parameter XMLNAME = "ListeStocksAMouvementer";

Parameter XMLSEQUENCE = 1;

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}

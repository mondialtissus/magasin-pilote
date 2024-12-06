Class Global.Interface.StringToDate Extends %RegisteredObject
{

/// <EXAMPLE>
/// Set MaDateAConvertir = "20240314113335"
/// Set MaDateConvertie = ##class(Global.Interface.StringToDate).Convertie(MaDateAConvertir)
/// </EXAMPLE>
ClassMethod Convertie(sData As %String) As %Date
{
    Return:sData="" ""
    set StringPartieDate = $EXTRACT(sData,1,8)
    return $zdh(StringPartieDate,8)
}

}

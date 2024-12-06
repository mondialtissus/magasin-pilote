Class Global.Components.RETRO.CMD.CONFECTIONDETAIL Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Property LIGNE As %Integer;

Property DONNEES As %String;

Property PLU As %String;

Property QTEEXP As %Numeric;

Property NUMSMP As %String;

Property CODEROULEAU As %String;

Query QteExpedie(pNumCmd As %String, pMagDestination As %String, pMagSource As %String, pPLU As %String) As %SQLQuery [ SqlProc ]
{
    SELECT sum(QTEEXP) as QTE 
    FROM 
        Global_Components_RETRO_CMD.CONFECTIONDETAIL 
    WHERE 
        REFCMDENTETE->NUMRETRO = :pNumCmd
        AND REFCMDENTETE->MAGDEST = :pMagDestination
        AND REFCMDENTETE->MAGSRC = :pMagSource
        AND PLU = :pPLU
}

ClassMethod QteExpedie(pNumCmd As %String, pMagDestination As %String, pMagSource As %String, pPLU As %String, ByRef Qte As %Float = 0) As %Status
{
    Set sc = $$$OK
    set stmt = ##class(%SQL.Statement).%New()
    set sc = stmt.%PrepareClassQuery("Global.Components.RETRO.CMD.CONFECTIONDETAIL", "QteExpedie")
    if $$$ISERR(sc) {
        do $system.Status.DisplayError(sc)
        Quit sc
    }
    set rs = stmt.%Execute(pNumCmd, pMagDestination, pMagSource, pPLU)
    while rs.%Next() {
        set Qte = rs.%Get("QTE")
    }

    Return sc
}

Property RETROFORTELAMON As %String [ Calculated, SqlComputeCode = {
        set {RETROFORTELAMON} = $replace($P({REFCMDENTETE},"||",1),"-RETRO-","-R-")
     }, SqlComputed ];

/// Description
Index Master On (REFCMDENTETE, LIGNE) [ IdKey ];

Relationship REFCMDENTETE As Global.Components.RETRO.CMD.CONFECTION [ Cardinality = parent, Inverse = REFCMDDETAIL ];

Storage SQL
{
<SQLMap name="Map1">
<Data name="CODEROULEAU">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DONNEES"/>
<Data name="NUMSMP">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PLU">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTEEXP">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^["USER"]MAGRETROCONF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CMD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Global_Components_RETRO_CMD.CONFECTION.NUMRETRO}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Global_Components_RETRO_CMD.CONFECTION.MAGSRC}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Global_Components_RETRO_CMD.CONFECTION.MAGDEST}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIGNE}</Expression>
<Invalidcondition name="1">
<Expression>{L5}=0</Expression>
</Invalidcondition>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^Global.Components.RETRO.CMD.CONFECTIONDETAIL</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

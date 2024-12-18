Class Global.Components.RETRO.LIV.CONFECTION Extends (%Persistent, Global.Models.RETRO, Global.Interface.StringToDate, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Property DATESYS As %Date [ Calculated, SqlComputeCode = {
    Set {DATESYS}= ..Convertie({DATESYSRAW})
}, SqlComputed ];

Property RETROGSI As Global.Components.RETRO.LIV.GSI [ Calculated, SqlComputeCode = {
    Set id = {ID}
    if ##Class(Global.Components.RETRO.LIV.GSI).%ExistsId(id)=0
    {
        set {RETROGSI} = ""
        return
    }
    set {RETROGSI} = id
     }, SqlComputed ];

Index Master On (NUMRETRO, MAGSRC, MAGDEST) [ IdKey ];

Storage SQL
{
<SQLMap name="Map1">
<Data name="DATESYSRAW">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HEURESYS">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LIBRE">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NUMCMD">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NUMCPT">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTETOT">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REMARQUE">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="USERRETRO">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VALOTOT">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^["DEPOT"]MAGRETROCONF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NUMRETRO}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MAGSRC}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MAGDEST}</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^Global.Components.RETRO.LIV.CONFECTION</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class Global.Components.RETRO.CMD.INTERSITE Extends (%Persistent, Global.Models.RETRO, Global.Interface.StringToDate, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Property DATESYS As %Date [ Calculated, SqlComputeCode = {
    if {DATESYSRAW}=""
    {
        set {DATESYS}= ""
        return 
    }
  
    Set {DATESYS}= $zdh({DATESYSRAW},8)
}, SqlComputed ];

Property asLIV As %Boolean [ Calculated, SqlComputeCode = {
    Set magRetro = "^[""USER""]MAGRETRO"
    Set {asLIV} = ($Data(@magRetro@("LIV",{NUMRETRO}))>0)
}, SqlComputed ];

Index Master On (NUMRETRO, MAGSRC, MAGDEST) [ IdKey ];

/// Description
Method CreateMod() As %Status
{
    Set sc = $$$OK
    Set magretro = "^[""USER""]MAGRETRO"
    Set ^|"USER"|MODMAGRETRO(..MAGSRC, "CMD", ..NUMRETRO, ..MAGDEST,"SRC", 0) = @magretro@("CMD", ..NUMRETRO, ..MAGSRC,..MAGDEST,0)

    // do something
    Return sc
}

Method CreateModDetail() As %Status
{
    Set sc = $$$OK
    Set magretro = "^[""USER""]MAGRETRO"
    set nbRetro = ..REFCMDDETAIL.Count()
    for i=1:1:nbRetro {
        Set retroDetail = ..REFCMDDETAIL.GetAt(i)
        Set ^|"USER"|MODMAGRETRO(..MAGSRC, "CMD", ..NUMRETRO, ..MAGDEST,"SRC", retroDetail.LIGNE) = @magretro@("CMD", ..NUMRETRO, ..MAGSRC,..MAGDEST,retroDetail.LIGNE)
    }

    // do something
    Return sc
}

Relationship REFCMDDETAIL As Global.Components.RETRO.CMD.INTERSITEDETAIL [ Cardinality = children, Inverse = REFCMDENTETE ];

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
<Global>^["USER"]MAGRETRO</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CMD"</Expression>
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
<StreamLocation>^Global.Components.RETRO.CMD.USER</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

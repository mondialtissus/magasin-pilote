Class Global.Services.RETRO.CMD Extends %RegisteredObject
{

Property RETROs As list Of Global.Models.RETRO [ Private ];

Method GenerateModLiv(retro As Global.Models.RETRO) As %Status
{
    Set mod = ..GetRetroModGlobal(retro)

    Set DataEntete = ""

    Set $Piece(DataEntete, "\", 1) = retro.NUMCPT
    Set $Piece(DataEntete, "\", 2) = retro.QTETOT
    Set $Piece(DataEntete, "\", 3) = retro.VALOTOT
    Set $Piece(DataEntete, "\", 4) = retro.USERRETRO
    Set $Piece(DataEntete, "\", 5) = retro.DATESYSRAW
    Set $Piece(DataEntete, "\", 6) = retro.HEURESYS
    Set $Piece(DataEntete, "\", 7) = retro.LIBRE
    Set $Piece(DataEntete, "\", 8) = retro.REMARQUE
    Set $Piece(DataEntete, "\", 9) = retro.NUMCMD

    Set @mod@(retro.MAGDEST, "LIV", retro.NUMRETRO, retro.MAGSRC, "DEST", 0) = DataEntete
}

Method GenerateModCmd(retro As Global.Models.RETRO) As %Status
{
    Set mod = ..GetRetroModGlobal(retro)

    Set DataEntete = ""

    Set $Piece(DataEntete, "\", 1) = retro.NUMCPT
    Set $Piece(DataEntete, "\", 2) = retro.QTETOT
    Set $Piece(DataEntete, "\", 3) = retro.VALOTOT
    Set $Piece(DataEntete, "\", 4) = retro.USERRETRO
    Set $Piece(DataEntete, "\", 5) = retro.DATESYSRAW
    Set $Piece(DataEntete, "\", 6) = retro.HEURESYS
    Set $Piece(DataEntete, "\", 7) = retro.LIBRE
    Set $Piece(DataEntete, "\", 8) = retro.REMARQUE
    Set $Piece(DataEntete, "\", 9) = retro.NUMCMD

    Set @mod@(retro.MAGSRC, "CMD", retro.NUMRETRO, retro.MAGDEST, "SRC", 0) = DataEntete
    set sc = ..GenerateModCmdDetail(retro)
}

Method GenerateModCmdDetail(retro As Global.Models.RETRO) As %Status [ Private ]
{
    Set sc = $$$OK
    Set mod = ..GetRetroModGlobal(retro)

    for i=1:1:retro.REFCMDDETAIL.Count() {
        Set retroDetail = retro.REFCMDDETAIL.GetAt(i)
        Set DataDetail = ""

        Set @mod@(retro.MAGSRC, "CMD", retro.NUMRETRO, retro.MAGDEST, "SRC", retroDetail.LIGNE) = retroDetail.DONNEES
    }

    // do something
    Return sc
}

/// Description
Method addRetro(retro As Global.Models.RETRO) As %Status
{
    Set sc = $$$OK
    set sc = ..RETROs.Insert(retro)

    // do something
    Return sc
}

/// Description
Method boucleRetro() As %Status
{
    Set sc = $$$OK
    
    for i=1:1:..RETROs.Count() {
        Set retro = ..RETROs.GetAt(i)
        w ..GetRetroModGlobal(retro)
    }
    Return sc
}

/// Description
ClassMethod GetRetroModGlobal(retro As Global.Models.RETRO) As %String
{
    Return $CASE(retro.%ClassName(),
        "COUPE":"^[""USER""]MODMAGRETROCOUPE",
        "CONFECTION":"^[""USER""]MODMAGRETROCONF",
        "INTERSITE":"^[""USER""]MODMAGRETRO",
        :""
    )
}

}

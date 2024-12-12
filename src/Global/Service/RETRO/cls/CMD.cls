Class Global.Service.RETRO.cls.CMD Extends %RegisteredObject
{

Property RETROs As list Of Global.Models.RETRO [ Private ];

Method GenerateMod() As %Status
{
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
        "COUPE":"^[""DBMETIER""]MODRETROCOUPE",
        "CONFECTION":"^[""DBMETIER""]MODRETROCONF",
        "INTERSITE":"^[""DBMETIER""]MODRETRO",
        :""
    )
}

}

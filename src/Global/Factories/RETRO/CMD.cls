Class Global.Factories.RETRO.CMD Extends %RegisteredObject
{

/// Description
Parameter EMPLACEMENT = "Global.Components.RETRO.CMD.";

/// Description
Query SearchByRetro(NUMRETRO) As %SQLQuery [ SqlProc ]
{
        SELECT 
        ID, TYPAGE
        FROM Global_Vue_RETRO_CMD.EnTete
        WHERE NUMRETRO = :NUMRETRO
}

ClassMethod SearchByRetro(NUMRETRO As %String) As Global.Models.RETRO
{
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%PrepareClassQuery("Global.Factories.RETRO.CMD", "SearchByRetro")
    If $$$ISERR(sc) {
        Quit ""
    }
    Set rset = stmt.%Execute(NUMRETRO)
    Set result = ""
    While rset.%Next() {
        Set ID =  rset.%Get("ID")
        Set TYPAGE =  rset.%Get("TYPAGE")
        set result = ..OpenRetroWithTypage(ID, TYPAGE)
    }
    return result
}

ClassMethod OpenRetro(ID) As Global.Models.RETRO
{

    Set RETRO = ""
    If ##Class(Global.Components.RETRO.CMD.INTERSITE).%ExistsId(ID)=1{
        Set RETRO = ##Class(Global.Components.RETRO.CMD.INTERSITE).%OpenId(ID)
    }
    If ##Class(Global.Components.RETRO.CMD.COUPE).%ExistsId(ID)=1{
        Set RETRO = ##Class(Global.Components.RETRO.CMD.COUPE).%OpenId(ID)
    }
    If ##Class(Global.Components.RETRO.CMD.CONFECTION).%ExistsId(ID)=1{
        Set RETROD = ##Class(Global.Components.RETRO.CMD.CONFECTION).%OpenId(ID)
    }
   
    Return RETRO
}

ClassMethod OpenRetroWithTypage(ID, TYPAGE) As Global.Models.RETRO
{
    return:($CLASSMETHOD(..#EMPLACEMENT_TYPAGE,"%ExistsId",ID)=0) ""
    Return $CLASSMETHOD(..#EMPLACEMENT_TYPAGE,"%OpenId",ID)
}

/// Description
ClassMethod IDConstruction(ID As %String) As %String
{
    Set sc = $$$OK
    Set NUMRETRO = $piece(ID,"||",1)
    Set MAGSRC = $piece(ID,"||",2)
    Set MAGDEST = $piece(ID,"||",3)

    // do something
    Return sc
}

}

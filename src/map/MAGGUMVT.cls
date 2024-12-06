Class map.MAGGUMVT Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Parameter LastDateDefaut = 20230814;

Property POSNUM As %String [ Calculated, SqlComputeCode = {
    Set {POSNUM}=##class(%Function).HostName()
}, SqlComputed ];

Property DATEMVT As %Date;

Property ROULEAU As %Integer [ Calculated, SqlComputeCode = { 
    Set {ROULEAU}=##Class(map.MAGGUMVT).GetROULEAU({ROULEAUORPLU})
}, SqlComputed ];

/// ClassMethod pour récupérer le ROULEAU a partir du ROULEAUORPLU
ClassMethod GetROULEAU(pROULEAUORPLU As %Integer) As %Integer
{
    Return:$LENGTH(pROULEAUORPLU)=13 pROULEAUORPLU
    Return ""
}

Property ROULEAUORPLU As %Integer;

Property IDTYPE As %Numeric;

Property NUMMVT As %Integer;

Property QTE As %Float;

Property QTE2 As %String;

Property PA As %Float;

Property PV As %Float;

Property SENS As %Integer;

Property LASTSTOCK As %Numeric;

Property MAGFROM As %String;

Property MAGTO As %String;

Property NUMDOC As %String;

Property REMARQUE As %String;

Property SINISTRE As %String;

Property DATESINISTRE As %Date;

Property USERMVT As %String;

Property HEURE As %Integer;

Property REMISE As %Numeric;

Property EMPSRC As %String;

Property EMPDEST As %String;

Property QTEROULEAU As %Integer;

Property LASTSTOCKROULEAU As %Numeric;

Property ESTSURMANDRIN As %Integer;

Property MAGFRANCHISE As %String;

Property PLU As %String [ Calculated, SqlComputeCode = { 
    Set {PLU}=##Class(map.MAGGUMVT).GetPLU({ROULEAUORPLU},{POSNUM})
}, SqlComputed ];

/// Retourne Le PLU du mouvement
/// Exemple d'appel : do ##class(map.MAGGUMVT).GetPLU({ROULEAU})
ClassMethod GetPLU(pROULEAU As %String, pPOSNUM As %String) As %String
{
    If pPOSNUM="X999" If $LENGTH(pROULEAU)=13 {Return +$EXTRACT(pROULEAU,2,7) }
	If pPOSNUM="X900" If $LENGTH(pROULEAU)=13 {Return +$EXTRACT(pROULEAU,2,7) }
    Return pROULEAU
}

Property Correctif As %Integer [ Calculated, SqlComputeCode = { 
    Set {Correctif}=1
}, SqlComputed ];

/// Query Renvoi la liste des mouvements d'un magasin pour une période donnée
Query GetMovementsForStoreAndPeriod(pMAGASIN As %String, pDateDebut As %Date, pDateFin As %Date) As %SQLQuery [ SqlProc ]
{
    SELECT 
        *
    FROM 
        MAGGUMVT
    WHERE 
        POSNUM = :pMAGASIN
        AND DATEMVT BETWEEN :pDateDebut AND :pDateFin
}

/// Renvoi la liste des mouvements pour un magasin pour une période donnée
/// Exemple d'appel : do ##class(map.MAGGUMVT).GetMovementsForStoreAndPeriod("M207", "20230814", "20230814", .MAGGUMVTS)
ClassMethod GetMovementsForStoreAndPeriod(pMAGASIN As %String, pDateDebut As %Date, pDateFin As %Date, ByRef MAGGUMVTS As %ListOfObjects) As %Status
{
    Set pDateDebut = $ZDATEH(pDateDebut, 8)
    Set pDateFin = $ZDATEH(pDateFin, 8)
    Set MAGGUMVTS = ##class(%ListOfObjects).%New()


    // Création de la requête
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%PrepareClassQuery("map.MAGGUMVT", "GetMovementsForStoreAndPeriod")
    If $$$ISERR(sc) Do $SYSTEM.Status.DisplayError(sc) Quit sc
    // Exécution de la requête
    Set rs = stmt.%Execute(pMAGASIN, pDateDebut, pDateFin)
    // Affichage des résultats
    While rs.%Next() {
        Set MAGGUMVT = ##class(map.MAGGUMVT).%OpenId(rs.%Get("ID"))
        Do MAGGUMVTS.Insert(MAGGUMVT)
    }
    Quit $$$OK
}

/// Merge une global depuis une liste d'objets MAGGUMVT
/// Exemple d'appel : do ##class(map.MAGGUMVT).MergeFromListOfObjects(MAGGUMVTS)
ClassMethod MergeFromListOfObjects(pMAGGUMVTS As %ListOfObjects, pGlobal As %String = "^|USER|TEST") As %Status [ Deprecated ]
{

    Set sc = $$$OK

    Set MAGGUMVT = ""
    For i=1:1:pMAGGUMVTS.Count() {
        Set MAGGUMVT = pMAGGUMVTS.GetAt(i)
        Write MAGGUMVT.%Id(),!
    }
  
    Quit sc
}

/// Renvoi la liste des mouvements pour un magasin pour une période donnée sous forme de JSON
/// Exemple d'appel : do ##class(map.MAGGUMVT).GetMovementsForStoreAndPeriodJSON("M205", "20230814", "20230814", .json)
ClassMethod GetMovementsForStoreAndPeriodJSON(pMAGASIN As %String = "", pDateDebut As %Date, pDateFin As %Date, ByRef ArrayJson As %DynamicArray) As %Status
{
    Set:pMAGASIN="" pMAGASIN=##class(%Function).HostName()

    Do ##Class(map.MAGGUMVT).GetMovementsForStoreAndPeriod(pMAGASIN, pDateDebut, pDateFin, .MAGGUMVTS)

    Set ArrayJson = []
    Set sc = $$$OK

    For i=1:1:MAGGUMVTS.Count() {
        Set MAGGUMVT = MAGGUMVTS.GetAt(i)
        Do MAGGUMVT.%JSONExport(.Json)
        Do ArrayJson.%Push(Json)
    }
    
    Return sc
}

/// Export le tableau json en fichier .json dans le dossier C:\Temp le nom correspond au timestamp de l'export au format YYYYMMDDHHMMSS_{POSNUM}_GUMVT.json
/// Exemple d'appel : do ##class(map.MAGGUMVT).ExportJsonToFile(, obj)
/// Description 
/// 
/// Description
ClassMethod ExportJsonToFile(pFileName = "C:/temps/json/MAGGUMVT.json", ByRef obj As %DynamicAbstractObject) As %Status
{
    Set stream = ##class(%Stream.FileBinary).%New()
    Set sc = stream.LinkToFile(pFileName)
    If 'sc {Write !,"Error opening file: ",$SYSTEM.Status.GetErrorText(sc),! Quit sc}
    Try {
        Do obj.%FromJSON(stream)
    }
    Catch ex {
        Write "Error. Unable to parse file "_pFileName,!
        Write "Error type   "_ex.Name,!
        Write "Error code   "_ex.Code,!
        Write "Error location "_ex.Location,!
        Set obj = ""
    }
    Quit obj
}

/// Creation de sous global GUMVT par date
/// Exemple d'appel : do ##class(map.MAGGUMVT).CreateSubGlobalByDate("20230814")
ClassMethod CreateSubGlobalByDate(pDate As %Integer, ByRef FileGlobalXml As %String) As %Status
{


    Set host = ##class(%Function).HostName()
    Set DateCache = pDate
    Set MAGGUMVT = "^GUMVT"_pDate_host
    Set GUMVT = "^GUMVT"

    
    Quit:(+$DATA(@GUMVT@(DateCache))'>0 ) 0

    Merge @MAGGUMVT@(host, DateCache) = @GUMVT@(DateCache)

    Set FileGlobal = MAGGUMVT_".GBL"
    set nameGloval = $Extract(GUMVT, 2, $Length(GUMVT))
    Set FileGlobalXml = "C:\temp\"_host_"-"_nameGloval_"-"_pDate_".xml"

    Set sc = $SYSTEM.OBJ.Export(.FileGlobal,.FileGlobalXml,,.errorLog,)
    If 'sc{
        Write "Error: "_$SYSTEM.Status.GetErrorText(sc),!
        Quit sc
    }
    Kill @MAGGUMVT@(host, DateCache)

    Quit sc
}

/// Creation de sous global GUMVT par date
/// Exemple d'appel : do ##class(map.MAGGUMVT).CreateSubGlobalByDates("20230814", "20230815")
ClassMethod CreateSubGlobalByDates(pDate...) [ Deprecated ]
{
  
    Set queue = $SYSTEM.WorkMgr.%New() If $$$ISERR(queue) Do $SYSTEM.Status.DisplayError(queue) Quit
    
    For i=1:1:pDate {
        Set sc = queue.Queue("##class(map.MAGGUMVT).CreateSubGlobalByDate",pDate(i)) If 'sc Do $SYSTEM.Status.DisplayError(sc) Quit
    }
    
    Set sc=queue.WaitForComplete() If 'sc Do $SYSTEM.Status.DisplayError(sc) Quit

    Do queue.%Close()
}

Index Master On (DATEMVT, ROULEAUORPLU, IDTYPE, NUMMVT) [ IdKey, PrimaryKey, Unique ];

Storage SQL
{
<SQLMap name="Map1">
<Data name="DATESINISTRE">
<Delimiter>"\"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EMPDEST">
<Delimiter>"\"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EMPSRC">
<Delimiter>"\"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ESTSURMANDRIN">
<Delimiter>"\"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HEURE">
<Delimiter>"\"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LASTSTOCK">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LASTSTOCKROULEAU">
<Delimiter>"\"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MAGFRANCHISE">
<Delimiter>"\"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MAGFROM">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MAGTO">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NUMDOC">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PA">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PV">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QTE">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTE2">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTEROULEAU">
<Delimiter>"\"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="REMARQUE">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REMISE">
<Delimiter>"\"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SENS">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SINISTRE">
<Delimiter>"\"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="USERMVT">
<Delimiter>"\"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^["USER"]GUMVT</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DATEMVT}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ROULEAUORPLU}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IDTYPE}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NUMMVT}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.MAGGUMVT</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

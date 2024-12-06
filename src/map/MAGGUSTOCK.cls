Class map.MAGGUSTOCK Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property PLU As %String;

Property PA As %Library.Float;

Property PV As %Library.Float;

Property QTEINVENTAIRE As %Library.Float;

Property QTERECEPTION As %Library.Float;

Property QTETRANSFERTINTERSITE As %Library.Float;

Property QTEDEMARQUE As %Library.Float;

Property QTEVENTE As %Library.Float;

Property QTETOT As %Library.Float;

Property LASTUPD As %String;

Index Master On PLU [ IdKey, PrimaryKey, Unique ];

/// Exemple: do ##class(map.MAGGUSTOCK).MAGGUSTOCKToGuStockALL("20230101",20230831)
ClassMethod MAGGUSTOCKToGuStockALL(pDateDebut As %Date = {$ZDATE($HOROLOG,8)}, pDateFin As %Date = {$ZDATE($HOROLOG,8)}) As %Status
{
    Set POSNUM=""

    Set nb = 0
    For {
        Set POSNUM = $ORDER(^MAGGUSTOCK(POSNUM))
        Quit:POSNUM=""
        Write "Traitement du magasin "_POSNUM,!,"..."
        Set nb = nb + 1
        Do ..MAGGUSTOCKToGuStockParMagasin(POSNUM,pDateDebut,pDateFin)
    }
}

ClassMethod MAGGUSTOCKToGuStockParMagasin(pPOSNUM As %String, pDateDebut As %Date, pDateFin As %Date = {$ZDATE($HOROLOG,8)}) As %Status
{
    Set DateDebut = $ZDATEH(pDateDebut,8)
    Set DateFin = $ZDATEH(pDateFin,8)

    For dateEnCours = DateDebut:1:DateFin {
        Write "Traitement du magasin "_pPOSNUM_" pour la date "_dateEnCours,!,"..."
        Do SQLCOPIEDATESTOCK^GUconvSTOCK(pPOSNUM,"^MAGGUSTOCK",dateEnCours)
    }
}

/// Exemple: do ##class(map.MAGGUSTOCK).MagasinStockDateSamediFinDeMoisVide("20230101",20230831)    
ClassMethod MagasinStockDateSamediFinDeMoisVide(pDebut As %Date = {$ZDATE($HOROLOG,8)}, pFin As %Date = {$ZDATE($HOROLOG,8)}) As %Status
{
    Set DateDebut = $ZDATEH(pDebut,8)
    Set DateFin = $ZDATEH(pFin,8)
    For DateEnCours=DateDebut:1:DateFin {
        continue:'(
            (+$EXTRACT($ZDATE(+DateEnCours+1,8),7,8)=1)
            || (+$ZDATE(+DateEnCours,10)=6)
        )
        set query = 4
        set query(1) = "SELECT POSNUM,count(*) AS nb "
        set query(2) = "FROM SQLUser.GuStock  "
        set query(3) = "WHERE DATESTOCK =? "
        set query(4) = "GROUP by POSNUM "

        set stmt = ##class(%SQL.Statement).%New()
        set sc = stmt.%Prepare(.query)
        if $$$ISERR(sc) {
            do $system.Status.DisplayError(sc)
            quit
        }

        set rs = stmt.%Execute(DateEnCours)
        while rs.%Next() {
            set POSNUM = rs.%Get("POSNUM")
            set nb = rs.%Get("nb")

            if nb=0 {
                Write "Le magasin "_POSNUM_" n'a pas de stock pour la date "_$ZDATE(DateEnCours,8),!
            }
        }

        
    }
}

/// Cette méthode permet d'effectuer des insertions (SQL) depuis la table SQLUser.GuStock vers la table map.MAGGUSTOCK
/// @Param pPOSNUM : Le numéro du magasin
/// @Param pDate : La date
/// <EXAMPLE>
/// set pMagasin = "M205"
/// set pDate = "20231028"
/// Do ##class(map.MAGGUSTOCK).InsertGuStockToMAGGUSTOCK(pMagasin,pDate)
/// </EXAMPLE>
ClassMethod InsertGuStockToMAGGUSTOCK(pDate As %Date, pMagasin As %String)
{
    set sc = $$$OK
    set sql = "INSERT INTO map.MAGGUSTOCK SELECT * FROM SQLUser.GuStock WHERE POSNUM = ? AND DATESTOCK = ?"
    set stmt = ##class(%SQL.Statement).%New()
    set sc = stmt.%Prepare(sql)
    if $$$ISERR(sc) {
        // Gérer les erreurs de préparation
        do $system.OBJ.DisplayError(sc)
        return sc
    }

    // Exécuter la requête SQL avec les paramètres pMagasin et pDate
    set rs = stmt.%Execute(pMagasin, pDate)
    if $$$ISERR(rs) {
        // Gérer les erreurs d'exécution
        do $system.OBJ.DisplayError(rs)
        return rs
    }

    return sc
}

/// Description
Storage SQLmap
{
<Description>
<![CDATA[Description]]></Description>
<SQLMap name="Map2">
<Data name="LASTUPD">
<Delimiter>"\"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PA">
<Delimiter>"\"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PV">
<Delimiter>"\"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QTEDEMARQUE">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QTEINVENTAIRE">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTERECEPTION">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QTETOT">
<Delimiter>"\"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QTETRANSFERTINTERSITE">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QTEVENTE">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^["USER"]GUSTOCK</Global>
<Subscript name="1">
<Expression>{PLU}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.GUSTOCK</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

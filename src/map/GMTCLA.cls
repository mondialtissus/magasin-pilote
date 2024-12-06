Class map.GMTCLA Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property SECTEUR As %String;

Property DONNEES As %String;

Property LIBELLE As %String;

Index Master On SECTEUR [ IdKey, PrimaryKey, Unique ];

/// Description
Storage SQLmap
{
<Description>
<![CDATA[Description]]></Description>
<SQLMap name="Map1">
<Data name="DONNEES"/>
<Data name="LIBELLE">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^["USER"]GMTCLA</Global>
<Subscript name="1">
<Expression>{SECTEUR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.GMTCLA</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

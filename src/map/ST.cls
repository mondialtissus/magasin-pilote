Class map.ST Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property CLEART As %String;

Property DONNEES As %String;

Property SECTEUR As %String;

Index Master On CLEART [ IdKey, PrimaryKey, Unique ];

/// Description
Storage SQLmap
{
<Description>
<![CDATA[Description]]></Description>
<SQLMap name="Map1">
<Data name="DONNEES"/>
<Data name="SECTEUR">
<Delimiter>"\"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^["USER"]ST</Global>
<Subscript name="1">
<Expression>{CLEART}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.ST</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

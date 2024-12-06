Class map.INVARTICLEME Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Property CODEMAG As %String;

Property REFERENCE As %String;

Property FOURNISSEUR As %String;

Property CLE As %String;

Property LIGNE As %Integer;

Property DONNEES As %String;

Property ZONE As %String;

Index Master On (CODEMAG, REFERENCE, FOURNISSEUR, CLE, LIGNE) [ IdKey ];

Storage SQL
{
<SQLMap name="Map1">
<Data name="DONNEES"/>
<Data name="ZONE">
<Delimiter>"\"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^["USER"]INVARTICLEME</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CODEMAG}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REFERENCE}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FOURNISSEUR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIGNE}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.INVARTICLEME</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

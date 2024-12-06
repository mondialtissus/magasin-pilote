Class map.HWARTFAMPA Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQL ]
{

Property PLU As %String;

Property PA As %Numeric;

Index Master On PLU [ IdKey, PrimaryKey, Unique ];

Storage SQL
{
<SQLMap name="Map1">
<Data name="PA">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^["USER"]HWARTFAMPA</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PLU}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.HWARTFAMPA</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

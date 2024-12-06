Class map.SP Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property PLU As %String;

Property CLEART As %String;

Index Master On PLU [ IdKey, PrimaryKey, Unique ];

/// Description
Storage SQLmap
{
<Description>
<![CDATA[Description]]></Description>
<SQLMap name="Map1">
<Data name="CLEART"/>
<Global>^["USER"]SP</Global>
<Subscript name="1">
<Expression>{PLU}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^map.SP</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

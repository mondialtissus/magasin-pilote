Class Global.Components.PARAM.HWINFO2 Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property N1 As %String;

Property N2 As %String;

Property VALEUR As %String;

Index Master On (N1, N2) [ IdKey, PrimaryKey, Unique ];

/// Description
Storage SQLmap
{
<Description>
<![CDATA[Description]]></Description>
<SQLMap name="Map1">
<Data name="VALEUR"/>
<Global>^["USER"]HWINFO</Global>
<Subscript name="1">
<Expression>{N1}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{N2}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^Global.Components.PARAM.HWINFO2</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

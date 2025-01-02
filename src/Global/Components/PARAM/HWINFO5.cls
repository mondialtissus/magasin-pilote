Class Global.Components.PARAM.HWINFO5 Extends (%Persistent, %JSON.Adaptor) [ StorageStrategy = SQLmap ]
{

Property N1 As %String;

Property N2 As %String;

Property N3 As %String;

Property N4 As %String;

Property N5 As %String;

Property VALEUR As %String;

Index Master On (N1, N2, N3, N4, N5) [ IdKey, PrimaryKey, Unique ];

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
<Subscript name="3">
<Expression>{N3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{N4}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{N5}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^Global.Components.PARAM.HWINFO5</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

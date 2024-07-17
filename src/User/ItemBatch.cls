Class User.ItemBatch Extends (%Persistent, %JSON.Adaptor)
{

Index DateHeureNdx On DateHeure;

Index OrigineNdx On Origine;

Property DateHeure As %String [ Required ];

Property RequeteREST As %String(MAXLEN = 1000) [ Required ];

Property Parametres As %String(MAXLEN = 1000) [ Required ];

Property Origine As %String(MAXLEN = 1000) [ Required ];

Storage Default
{
<Data name="ItemBatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateHeure</Value>
</Value>
<Value name="3">
<Value>RequeteREST</Value>
</Value>
<Value name="4">
<Value>Parametres</Value>
</Value>
<Value name="5">
<Value>Origine</Value>
</Value>
</Data>
<DataLocation>^User.ItemBatchD</DataLocation>
<DefaultData>ItemBatchDefaultData</DefaultData>
<IdLocation>^User.ItemBatchD</IdLocation>
<IndexLocation>^User.ItemBatchI</IndexLocation>
<StreamLocation>^User.ItemBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

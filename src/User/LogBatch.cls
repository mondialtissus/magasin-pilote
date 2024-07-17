Class User.LogBatch Extends %Persistent
{

Property DateHeure As %String [ Required ];

Property RequeteREST As %String(MAXLEN = 1000) [ Required ];

Property Parametres As %String(MAXLEN = 1000) [ Required ];

Property Origine As %String(MAXLEN = 1000) [ Required ];

Property Synchro As %Boolean [ Required ];

Property DateHeureSynchro As %String;

Property ExecutionReussie As %Boolean [ Required ];

Storage Default
{
<Data name="LogBatchDefaultData">
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
<Value name="6">
<Value>ExecutionReussie</Value>
</Value>
<Value name="7">
<Value>Synchro</Value>
</Value>
<Value name="8">
<Value>DateHaureSynchro</Value>
</Value>
<Value name="9">
<Value>DateHeureSynchro</Value>
</Value>
</Data>
<DataLocation>^User.LogBatchD</DataLocation>
<DefaultData>LogBatchDefaultData</DefaultData>
<IdLocation>^User.LogBatchD</IdLocation>
<IndexLocation>^User.LogBatchI</IndexLocation>
<StreamLocation>^User.LogBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

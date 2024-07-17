/// 
Class User.webSIGNATURE Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = webSIGNATURE, StorageStrategy = Default ]
{

Property CMDNUM As %Library.String(MAXLEN = 16) [ Required, SqlColumnNumber = 2 ];

Property SIGNATURE As %Stream.GlobalBinary [ SqlColumnNumber = 3 ];

/// DDL Primary Key Specification
Index CMDNUMPK On CMDNUM [ PrimaryKey, Type = index, Unique ];

Storage Default
{
<Data name="webSIGNATUREDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMDNUM</Value>
</Value>
<Value name="3">
<Value>SIGNATURE</Value>
</Value>
</Data>
<DataLocation>^User.webSIGNATURED</DataLocation>
<DefaultData>webSIGNATUREDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.webSIGNATURED</IdLocation>
<IndexLocation>^User.webSIGNATUREI</IndexLocation>
<StreamLocation>^User.webSIGNATURES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

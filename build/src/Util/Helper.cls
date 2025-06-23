Class Util.Helper Extends %RegisteredObject
{

ClassMethod AddResultSet(rs)
{
	; instance of %Library.ProcedureContext
	do %sqlcontext.AddResultSet(rs)
}

}

Class Rest.Common
{

ClassMethod GetRequestContent() As %String
{
	#; 文字列化。<MAXSTRING>に留意。
	Return %request.Content.Read(%request.Content.Size)
}

ClassMethod Test() As %String
{
	#; 文字列化。<MAXSTRING>に留意。
	Set req={"name":"あいうえお"}.%ToJSON()
	Return req
}

}

Class Test.Debug Extends %RegisteredObject
{

ClassMethod Test1py() As %Numeric [ Language = python ]
{
    import iris
    breakpoint()
    foo = iris.gref("^Test")
    return foo.get()==42
}

ClassMethod Test1os() As %Numeric
{
    
    Set foo = $G(^Test)
    return foo=42
}

}

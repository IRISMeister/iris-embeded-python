Class Test.SQLStoredProc Extends %RegisteredObject
{

/// Example of how to make SQL calls from Python
ClassMethod run() As %Status
{
    Set rs=$system.SQL.Execute("call Simple_OS_Proc()")
    d rs.%Display()

    Set rs=$system.SQL.Execute("call Simple_Python_Proc()")
    d rs.%Display()
}

}

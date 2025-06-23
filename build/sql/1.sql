/* call Simple_OS_Proc() */
CREATE PROCEDURE Simple_OS_Proc() RESULT SETS
RETURNS INTEGER
LANGUAGE OBJECTSCRIPT
{
    Set rs=$system.SQL.Execute("select top 20 ID,Salary s1 ,Salary*2 s2 from Sample.Employee")
    do %sqlcontext.AddResultSet(rs)
    return 1
}
GO
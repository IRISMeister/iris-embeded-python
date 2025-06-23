/* call Simple_Python_Proc() まだ動作しない */
CREATE PROCEDURE Simple_Python_Proc() RESULT SETS
RETURNS INTEGER
LANGUAGE Python
{
    import iris 

    # Execute SQL query 
    stmt = iris.sql.prepare("select top 20 ID,Salary s1 ,Salary*2 s2 from Sample.Employee")
    rs = stmt.execute()

    # Add result set to the context 
    iris.Util.Helper.AddResultSet(rs.ResultSet)
    return 1
}
GO
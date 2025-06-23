import pandas
import iris

def run():
    rs = iris.sql.exec('select top 20 ID,Salary s1 ,Salary*2 s2 from Sample.Employee')
    for row in rs:  
        print(row)

    df = iris.sql.exec('select top 20 ID,Salary s1 ,Salary*2 s2 from Sample.Employee').dataframe()
    print(df)

Class Test.Python2
{

/// コミュニティ提供のSQLAlchemy及びDB-APIを使用しています。
/// pip install sqlalchemy-iris https://github.com/intersystems-community/intersystems-irispython/releases/download/3.6.0/intersystems_iris-3.6.0-py3-none-any.whl
ClassMethod test1() As %Status [ Language = python ]
{
import pandas as pd
import numpy as np

# コミュニティ提供のsqlalchemyを使用
from sqlalchemy import create_engine
import intersystems_iris.dbapi._DBAPI as dbapi
engine = create_engine('iris+emb:///USER')

# SQLAlchemy + 埋め込みPython
df = pd.read_sql('select top 5 ID,Salary p1 ,Salary+10 p2 from Sample.Employee', engine)
print(type(df))
print(df)

# DataFrameをnumpy.ndarrayに変換
array1=df[['p1','p2']].to_numpy()
print(type(array1))
print(array1.dtype)
print(array1)

# array単位での演算。
array2=array1/2

# numpy.ndarrayをDataFrameに変換
columns = ['p1', 'p2']
df2 = pd.DataFrame(data=array2,columns=columns)

# テーブルのプライマリキーを再生
np_ids=df["ID"].to_numpy() # "ID"が大文字化されているので注意
df2["id"] = np_ids
print(df2)

# DB-API + 埋め込みPython
config = {
    'embedded': True,
  }
with dbapi.connect(**config) as connection:
  with connection.cursor() as cursor:
    sql = "UPDATE Sample.Employee Set Salary=? WHERE ID=?"
    ## with the cursor, execute the SQL statement
    for row in df2.itertuples():
        try: 
            cursor.execute(sql,(str(int(row.p1)),row.id))
        except Exception as ex:
            print ('ERROR!!', repr(ex))
}

}

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
df = pd.read_sql('select ID id,Price p1 ,Price*2 p2 from HoleFoods.Product', engine)
print(type(df))
print(df)
# DataFrameをnumpy.ndarrayに変換
array1=df[['p1','p2']].to_numpy()
print(type(array1))
print(array1.dtype)
print(array1)
# 演算
array2=array1*2
# numpy.ndarrayをDataFrameに変換
columns = ['p1', 'p2']
df2 = pd.DataFrame(data=array2,columns=columns)
# テーブルのプライマリキーを再生
np_ids=df["id"].to_numpy()
df2["id"] = np_ids
print(df2)

# DB-API + 埋め込みPython
config = {
    'embedded': True,
  }
with dbapi.connect(**config) as connection:
  with connection.cursor() as cursor:
    sql = "UPDATE HoleFoods.Product Set Price=? WHERE ID=?"
    ## with the cursor, execute the SQL statement
    for row in df2.itertuples():
        try: 
            cursor.execute(sql,(str(row.p1),row.id))
        except Exception as ex:
            print ('ERROR!!', repr(ex))
}

}

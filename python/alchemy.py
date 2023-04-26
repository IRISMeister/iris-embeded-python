# コミュニティ提供のSQLAlchemy及びDB-APIを使用しています。
# pip install sqlalchemy-iris https://github.com/intersystems-community/intersystems-irispython/releases/download/3.6.0/intersystems_iris-3.6.0-py3-none-any.whl

import pandas as pd

from sqlalchemy import create_engine
import intersystems_iris.dbapi._DBAPI as dbapi

# create fake dataframes with a bunch of columns types
# and a bunch of rows
# columns types are: int, float, string, datetime, bool
df = pd.DataFrame({
    'int': [1, 2, 3, 4, 5],
    'float': [1.1, 2.2, 3.3, 4.4, 5.5],
    'string': ['a', 'b', 'c', 'd', 'e'],
    'datetime': pd.date_range('20130101', periods=5),
    'bool': [True, False, True, False, True]
})

sql='select ID id,Price p1 ,Price*2 p2 from HoleFoods.Product'

# 埋め込みPython
engine2 = create_engine('iris+emb:///USER')
with engine2.connect() as conn:
    rs = conn.execute(sql)
    for row in rs:
        print(row)

df = pd.read_sql(sql, engine)
print(df)

# <UNIMPLEMENTED>
# create a table in IRIS
#df.to_sql('iris_table', engine2, if_exists='replace', schema='sqlalchemy')

# <UNIMPLEMENTED>
# read the table back from IRIS 
#df2 = pd.read_sql('select * from sqlalchemy.iris_table', engine2)

# print the dataframe
#print(df2)

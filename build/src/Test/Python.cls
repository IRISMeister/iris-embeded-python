Class Test.Python
{

ClassMethod test1() [ Language = python ]
{
#import sys
#sys.path += ['/home/irisowner/venv/lib/python3.12/site-packages']

import iris
import pandas as pd
import numpy as np

#df = iris.sql.exec('select ID,Price p1 ,Price*2 p2 from HoleFoods.Product').dataframe()
df = iris.sql.exec('select ID,Salary p1 ,Salary+10 p2 from Sample.Employee').dataframe()
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
np_ids=df["id"].to_numpy()
df2["id"] = np_ids
print(df2)

sql = "UPDATE Sample.Employee Set Salary=? WHERE ID=?"
stmt = iris.sql.prepare(sql)

# 更新を実行 
for row in df2.itertuples():
	try: 
		rs=stmt.execute(str(int(row.p1)),row.id)
	except Exception as ex:
		if ex.sqlcode == 100:
			print ('The record dosen\'t exist anymore. ID=',row.id)
		if ex.sqlcode != 100:
			print ('SQL error', ex.message, ex.sqlcode, ex.statement)
}

}

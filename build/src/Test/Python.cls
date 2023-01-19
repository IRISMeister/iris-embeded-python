Class Test.Python
{

ClassMethod test1() [ Language = python ]
{
 import iris
 import pandas as pd
 import numpy as np

 df = iris.sql.exec('select ID,Price p1 ,Price*2 p2 from HoleFoods.Product').dataframe()
 print(type(df))
 print(df)

 # DataFrameをnumpy.ndarrayに変換
 a_df=df[['p1','p2']].to_numpy()
 print(type(a_df))
 print(a_df.dtype)
 print(a_df)
 
 # numpy.ndarrayをDataFrameに変換
 columns = ['p1', 'p2']
 df2 = pd.DataFrame(data=a_df,columns=columns)

 # テーブルのプライマリキーを再生
 np_ids=df["id"].to_numpy()
 df2["id"] = np_ids
 print(df2)
 
 # 更新を実行 
 for row in df2.itertuples():
 	print(row.id, row.p1 ,row.p2)
 	sql="update HoleFoods.Product Set Price="+str(row.p1*2) +" where ID='"+row.id+"'"
 	iris.sql.exec(sql)
}

}
